package repository;

import model.ChiTietDonHang;
import model.ChiTietTopping;
import model.DonHang;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DonHangRepository {
    public boolean taoDonHang(DonHang dh, int diemSuDung, int diemCongThem) throws SQLException {
        String maDHMoi = "";
        String checkKhuyenMai = "SELECT so_luong, (SELECT COUNT(*) FROM DON_HANG WHERE ma_km = ?) as so_luong_da_dung FROM CHUONG_TRINH_KHUYEN_MAI WITH (UPDLOCK, ROWLOCK) WHERE ma_km = ?";
        String sqlDH = "INSERT INTO DON_HANG (thoi_gian_tao, tong_tien_hang, tien_giam_gia, trang_thai_don, tong_phai_tra, thoi_gian_thanh_toan, so_tien_khach_dua, ma_nv, ma_kh, ma_km, ma_pttt) OUTPUT INSERTED.ma_dh VALUES (GETDATE(), ?, ?, N'Hoàn thành', ?, GETDATE(), ?, ?, ?, ?, ?)";
        String sqlCT = "INSERT INTO CHI_TIET_DON_HANG (so_luong, muc_duong, muc_da, ghi_chu, gia_chot_mon, ma_dh, ma_bien_the) OUTPUT INSERTED.ma_chi_tiet VALUES (?, ?, ?, ?, ?, ?, ?)";
        String sqlTopping = "INSERT INTO CHI_TIET_TOPPING (so_luong_topping, gia_chot_topping, ma_chi_tiet, ma_topping) VALUES (?, ?, ?, ?)";
        String updateDiem = "UPDATE KHACH_HANG SET diem_tich_luy = diem_tich_luy - ? + ? WHERE ma_kh = ?";

        try (Connection con = DBConnect.getConnection()) {
            con.setAutoCommit(false);
            try {
                // 1. CHỐNG RACE CONDITION
                if (dh.getKhuyenMai() != null && dh.getKhuyenMai().getMaKM() != null && !dh.getKhuyenMai().getMaKM().isEmpty()) {
                    try (PreparedStatement psCheck = con.prepareStatement(checkKhuyenMai)) {
                        psCheck.setString(1, dh.getKhuyenMai().getMaKM());
                        psCheck.setString(2, dh.getKhuyenMai().getMaKM());
                        try (ResultSet rs = psCheck.executeQuery()) {
                            if (rs.next()) {
                                if (rs.getInt("so_luong_da_dung") >= rs.getInt("so_luong")) {
                                    throw new SQLException("Mã khuyến mãi đã hết lượt sử dụng trong tích tắc!");
                                }
                            }
                        }
                    }
                }

                // 2. TẠO ĐƠN HÀNG
                try (PreparedStatement psDH = con.prepareStatement(sqlDH)) {
                    psDH.setInt(1, dh.getTongTienHang());
                    psDH.setInt(2, dh.getTienGiamGia());
                    psDH.setInt(3, dh.getTongTienTra());
                    psDH.setInt(4, dh.getSoTienKhachDua());
                    psDH.setString(5, dh.getNhanVien().getMaNV());
                    if (dh.getKhachHang() != null && dh.getKhachHang().getMaKH() != null) {
                        psDH.setString(6, dh.getKhachHang().getMaKH());
                    } else {
                        psDH.setNull(6, java.sql.Types.VARCHAR);
                    }
                    if (dh.getKhuyenMai() != null && dh.getKhuyenMai().getMaKM() != null && !dh.getKhuyenMai().getMaKM().isEmpty()) {
                        psDH.setString(7, dh.getKhuyenMai().getMaKM());
                    } else {
                        psDH.setNull(7, java.sql.Types.VARCHAR);
                    }
                    psDH.setString(8, dh.getPhuongThucThanhToan().getMaPTTT());
                    try (ResultSet rsDH = psDH.executeQuery()) {
                        if (rsDH.next()) {
                            maDHMoi = rsDH.getString("ma_dh");
                            dh.setMaDH(maDHMoi);
                        }
                    }
                }

                if (maDHMoi == null || maDHMoi.isEmpty()) throw new SQLException("Lỗi sinh mã hóa đơn!");

                // 3. TẠO CHI TIẾT VÀ TOPPING
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
                        for (ChiTietTopping ctt : ct.getDanhSachTopping()) {
                            psTopping.setInt(1, ctt.getSoLuongTopping());
                            psTopping.setInt(2, ctt.getGiaChot());
                            psTopping.setString(3, maCTMoi);
                            psTopping.setString(4, ctt.getTopping().getMaTopping());
                            psTopping.executeUpdate();
                        }
                    }
                }

                // 4. TRỪ/CỘNG ĐIỂM
                if (dh.getKhachHang() != null && dh.getKhachHang().getMaKH() != null) {
                    try (PreparedStatement psDiem = con.prepareStatement(updateDiem)) {
                        psDiem.setInt(1, diemSuDung);
                        psDiem.setInt(2, diemCongThem);
                        psDiem.setString(3, dh.getKhachHang().getMaKH());
                        psDiem.executeUpdate();
                    }
                }

                con.commit();
                return true;
            } catch (SQLException e) {
                con.rollback();
                throw e;
            }
        }
    }
}