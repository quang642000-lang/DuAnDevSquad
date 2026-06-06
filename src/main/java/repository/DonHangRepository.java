package repository;

import model.ChiTietDonHang;
import model.ChiTietTopping;
import model.DonHang;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DonHangRepository {

    public boolean taoDonHang(DonHang dh) {
        Connection con = null;
        try {
            con = DBConnect.getConnection();
            con.setAutoCommit(false); // Bật Transaction (Nếu lỗi sẽ Rollback hoàn tác)

            String maDHMoi = "";

            // 1. LƯU BẢNG ĐƠN HÀNG (Lấy mã vừa sinh ra)
            String sqlDH = "INSERT INTO DON_HANG (thoi_gian_tao, tong_tien_hang, tien_giam_gia, trang_thai_don, tong_phai_tra, thoi_gian_thanh_toan, so_tien_khach_dua, ma_nv, ma_kh, ma_km, ma_pttt) " +
                    "OUTPUT INSERTED.ma_dh " +
                    "VALUES (GETDATE(), ?, ?, N'Hoàn thành', ?, GETDATE(), ?, ?, ?, ?, ?)";

            try (PreparedStatement psDH = con.prepareStatement(sqlDH)) {
                psDH.setInt(1, dh.getTongTienHang());
                psDH.setInt(2, dh.getTienGiamGia());
                psDH.setInt(3, dh.getTongTienTra());
                psDH.setInt(4, dh.getSoTienKhachDua());
                psDH.setString(5, dh.getNhanVien().getMaNV());

                // Khách hàng chắc chắn không bị NULL nhờ xử lý ở DonHangService
                psDH.setString(6, dh.getKhachHang().getMaKH());

                // Khuyến mãi có thể NULL
                if (dh.getKhuyenMai() != null && dh.getKhuyenMai().getMaKM() != null && !dh.getKhuyenMai().getMaKM().isEmpty()) {
                    psDH.setString(7, dh.getKhuyenMai().getMaKM());
                } else {
                    psDH.setNull(7, java.sql.Types.VARCHAR);
                }

                psDH.setString(8, dh.getPhuongThucThanhToan().getMaPTTT());

                try (ResultSet rsDH = psDH.executeQuery()) {
                    if (rsDH.next()) {
                        maDHMoi = rsDH.getString("ma_dh");
                        dh.setMaDH(maDHMoi); // <-- BỔ SUNG: Gắn mã tự động sinh vào Object để đem đi in Bill
                    }
                }
            }

            if (maDHMoi == null || maDHMoi.isEmpty()) throw new Exception("SQL Server không tạo được mã đơn hàng!");

            // 2. LƯU BẢNG CHI TIẾT
            String sqlCT = "INSERT INTO CHI_TIET_DON_HANG (so_luong, muc_duong, muc_da, ghi_chu, gia_chot_mon, ma_dh, ma_bien_the) OUTPUT INSERTED.ma_chi_tiet VALUES (?, ?, ?, ?, ?, ?, ?)";
            String sqlTopping = "INSERT INTO CHI_TIET_TOPPING (so_luong_topping, gia_chot_topping, ma_chi_tiet, ma_topping) VALUES (?, ?, ?, ?)";

            try (PreparedStatement psCT = con.prepareStatement(sqlCT);
                 PreparedStatement psTopping = con.prepareStatement(sqlTopping)) {

                for (ChiTietDonHang ct : dh.getDanhSachChiTiet()) {
                    psCT.setInt(1, ct.getSoLuong());
                    psCT.setString(2, ct.getMucDuong());
                    psCT.setString(3, ct.getMucDa());
                    psCT.setString(4, ct.getGhiChu());
                    psCT.setInt(5, ct.getGiaChot());
                    psCT.setString(6, maDHMoi);
                    psCT.setString(7, ct.getBienThe().getMaBienThe());

                    String maCTMoi = "";
                    try (ResultSet rsCT = psCT.executeQuery()) {
                        if (rsCT.next()) maCTMoi = rsCT.getString("ma_chi_tiet");
                    }

                    // 3. LƯU BẢNG TOPPING TƯƠNG ỨNG
                    for (ChiTietTopping ctt : ct.getDanhSachTopping()) {
                        psTopping.setInt(1, ctt.getSoLuongTopping());
                        psTopping.setInt(2, ctt.getGiaChot());
                        psTopping.setString(3, maCTMoi);
                        psTopping.setString(4, ctt.getTopping().getMaTopping());
                        psTopping.executeUpdate();
                    }
                }
            }

            // Chốt lưu vào Database
            con.commit();
            return true;

        } catch (Exception e) {
            System.err.println("==> LỖI LƯU ĐƠN HÀNG: " + e.getMessage());
            e.printStackTrace();
            try { if (con != null) con.rollback(); } catch (Exception re) { re.printStackTrace(); }
        } finally {
            try { if (con != null) con.setAutoCommit(true); } catch (Exception ex) { ex.printStackTrace(); }
        }
        return false;
    }
}