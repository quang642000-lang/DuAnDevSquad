package repository;

import model.ThongKe;
import model.DonHangDashboard;
import model.TopSanPham;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;
import java.util.LinkedHashMap;

public class ThongKeRepository {

    // 1. LẤY 4 CHỈ SỐ TỔNG QUAN
    public ThongKe getThongKeTongQuan(String dateString) {
        ThongKe tk = new ThongKe();
        String sql = "SELECT " +
                "(SELECT ISNULL(SUM(tong_phai_tra), 0) FROM DON_HANG WHERE CAST(thoi_gian_tao AS DATE) = ?) AS doanh_thu, " +
                "(SELECT COUNT(*) FROM DON_HANG WHERE CAST(thoi_gian_tao AS DATE) = ?) AS don_hang_moi, " +
                "(SELECT COUNT(*) FROM SAN_PHAM WHERE trang_thai = 1) AS tong_san_pham, " +
                "(SELECT COUNT(*) FROM KHACH_HANG) AS tong_khach_hang";

        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, dateString);
            ps.setString(2, dateString);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    tk.setDoanhThuHomNay(rs.getInt("doanh_thu"));
                    tk.setDonHangMoi(rs.getInt("don_hang_moi"));
                    tk.setTongSanPham(rs.getInt("tong_san_pham"));
                    tk.setTongKhachHang(rs.getInt("tong_khach_hang"));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return tk;
    }

    // 2. LẤY DANH SÁCH ĐƠN HÀNG TRONG NGÀY
    public List<DonHangDashboard> getDonHangTheoNgay(String dateString) {
        List<DonHangDashboard> list = new ArrayList<>();
        String sql = "SELECT dh.ma_dh, dh.thoi_gian_tao, dh.tong_phai_tra, dh.trang_thai_don, nv.ho_ten, " +
                "STUFF((SELECT ' | ' + sp.ten_san_pham + ' (Size ' + bt.kich_co + ') x' + CAST(ct.so_luong AS VARCHAR) " +
                "       FROM CHI_TIET_DON_HANG ct " +
                "       JOIN BIEN_THE_SAN_PHAM bt ON ct.ma_bien_the = bt.ma_bien_the " +
                "       JOIN SAN_PHAM sp ON bt.ma_sp = sp.ma_sp " +
                "       WHERE ct.ma_dh = dh.ma_dh " +
                "       FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 3, '') AS chi_tiet_mon " +
                "FROM DON_HANG dh " +
                "JOIN NHAN_VIEN nv ON dh.ma_nv = nv.ma_nv " +
                "WHERE CAST(dh.thoi_gian_tao AS DATE) = ? " +
                "ORDER BY dh.thoi_gian_tao DESC";

        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, dateString);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DonHangDashboard dh = new DonHangDashboard();
                    dh.setMaDH(rs.getString("ma_dh"));
                    dh.setThoiGian(rs.getTimestamp("thoi_gian_tao"));
                    dh.setTongTien(rs.getInt("tong_phai_tra"));
                    dh.setTrangThai(rs.getString("trang_thai_don"));
                    dh.setTenNhanVien(rs.getString("ho_ten"));
                    dh.setChiTietMon(rs.getString("chi_tiet_mon"));

                    if (dh.getChiTietMon() == null) dh.setChiTietMon("Không có thông tin món");
                    list.add(dh);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 3. LẤY TOP 5 SẢN PHẨM BÁN CHẠY NHẤT TRONG NGÀY
    public List<TopSanPham> getTopSanPham(String dateString) {
        List<TopSanPham> list = new ArrayList<>();
        String sql = "SELECT TOP 5 sp.ten_san_pham, SUM(ct.so_luong) as tong_so_luong " +
                "FROM CHI_TIET_DON_HANG ct " +
                "JOIN BIEN_THE_SAN_PHAM bt ON ct.ma_bien_the = bt.ma_bien_the " +
                "JOIN SAN_PHAM sp ON bt.ma_sp = sp.ma_sp " +
                "JOIN DON_HANG dh ON ct.ma_dh = dh.ma_dh " +
                "WHERE CAST(dh.thoi_gian_tao AS DATE) = ? AND dh.trang_thai_don != N'Đã hủy' " +
                "GROUP BY sp.ten_san_pham " +
                "ORDER BY tong_so_luong DESC";

        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, dateString);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TopSanPham top = new TopSanPham();
                    top.setTenSanPham(rs.getString("ten_san_pham"));
                    top.setSoLuongBan(rs.getInt("tong_so_luong"));
                    list.add(top);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 4. HÀM MỚI: LẤY DOANH THU 7 NGÀY GẦN NHẤT ĐỂ VẼ BIỂU ĐỒ (Dùng LinkedHashMap để giữ thứ tự)
    public Map<String, Integer> getDoanhThu7NgayQua(String dateString) {
        Map<String, Integer> chartData = new LinkedHashMap<>();
        // Truy vấn doanh thu theo từng ngày, gom nhóm 7 ngày tính từ ngày đang lọc trở về trước
        String sql = "SELECT TOP 7 FORMAT(thoi_gian_tao, 'dd/MM') as ngay, SUM(tong_phai_tra) as tong_doanh_thu " +
                "FROM DON_HANG " +
                "WHERE CAST(thoi_gian_tao AS DATE) <= ? AND trang_thai_don = N'Hoàn thành' " +
                "GROUP BY FORMAT(thoi_gian_tao, 'dd/MM'), CAST(thoi_gian_tao AS DATE) " +
                "ORDER BY CAST(thoi_gian_tao AS DATE) ASC";

        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, dateString);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    chartData.put(rs.getString("ngay"), rs.getInt("tong_doanh_thu"));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return chartData;
    }
}