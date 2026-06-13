package repository;

import model.ThongKe;
import model.DonHangDashboard;
import model.TopSanPham;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.LinkedHashMap;

public class ThongKeRepository {

    private String[] getDefaultDates(String tuNgay, String denNgay) {
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
        String today = sdf.format(new Date());
        if ((tuNgay == null || tuNgay.isEmpty()) && (denNgay == null || denNgay.isEmpty())) {
            tuNgay = today;
            denNgay = today;
        }
        if (tuNgay == null || tuNgay.isEmpty()) tuNgay = "2000-01-01";
        if (denNgay == null || denNgay.isEmpty()) denNgay = "2099-12-31";
        return new String[]{tuNgay, denNgay};
    }

    public int getTotalDonHang(String tuNgay, String denNgay, String maNV) {
        String[] dates = getDefaultDates(tuNgay, denNgay);
        String nvCondition = (maNV != null && !maNV.isEmpty()) ? " AND ma_nv = ? " : "";
        String sql = "SELECT COUNT(*) FROM DON_HANG WHERE CAST(thoi_gian_tao AS DATE) >= ? AND CAST(thoi_gian_tao AS DATE) <= ? " + nvCondition;
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            int paramIndex = 1;
            ps.setString(paramIndex++, dates[0]);
            ps.setString(paramIndex++, dates[1]);
            if (maNV != null && !maNV.isEmpty()) ps.setString(paramIndex++, maNV);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public List<DonHangDashboard> getDonHangTheoNgay(String tuNgay, String denNgay, String maNV, int offset, int limit) {
        List<DonHangDashboard> list = new ArrayList<>();
        String[] dates = getDefaultDates(tuNgay, denNgay);
        String nvCondition = (maNV != null && !maNV.isEmpty()) ? " AND dh.ma_nv = ? " : "";
        String sql = "SELECT dh.ma_dh, dh.thoi_gian_tao, dh.tong_phai_tra, dh.trang_thai_don, nv.ho_ten " +
                "FROM DON_HANG dh JOIN NHAN_VIEN nv ON dh.ma_nv = nv.ma_nv " +
                "WHERE CAST(dh.thoi_gian_tao AS DATE) >= ? AND CAST(dh.thoi_gian_tao AS DATE) <= ? " + nvCondition +
                "ORDER BY dh.thoi_gian_tao DESC " +
                "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            int paramIndex = 1;
            ps.setString(paramIndex++, dates[0]);
            ps.setString(paramIndex++, dates[1]);
            if (maNV != null && !maNV.isEmpty()) ps.setString(paramIndex++, maNV);
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex++, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DonHangDashboard dh = new DonHangDashboard();
                    dh.setMaDH(rs.getString("ma_dh"));
                    dh.setThoiGian(rs.getTimestamp("thoi_gian_tao"));
                    dh.setTongTien(rs.getInt("tong_phai_tra"));
                    dh.setTrangThai(rs.getString("trang_thai_don"));
                    dh.setTenNhanVien(rs.getString("ho_ten"));
                    list.add(dh);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public ThongKe getThongKeTongQuan(String tuNgay, String denNgay, String maNV) {
        ThongKe tk = new ThongKe();
        String[] dates = getDefaultDates(tuNgay, denNgay);
        String sql = "WITH Params AS (SELECT CAST(? AS DATE) as StartDate, CAST(? AS DATE) as EndDate, CAST(? AS VARCHAR(20)) as MaNV) " +
                "SELECT " +
                "(SELECT ISNULL(SUM(tong_phai_tra), 0) FROM DON_HANG CROSS JOIN Params WHERE CAST(thoi_gian_tao AS DATE) BETWEEN StartDate AND EndDate AND trang_thai_don = N'Hoàn thành' AND (MaNV IS NULL OR ma_nv = MaNV)) AS doanh_thu, " +
                "(SELECT ISNULL(SUM(tong_phai_tra), 0) FROM DON_HANG CROSS JOIN Params WHERE MONTH(thoi_gian_tao) = MONTH(GETDATE()) AND YEAR(thoi_gian_tao) = YEAR(GETDATE()) AND trang_thai_don = N'Hoàn thành' AND (MaNV IS NULL OR ma_nv = MaNV)) AS doanh_thu_thang, " +
                "(SELECT COUNT(*) FROM DON_HANG CROSS JOIN Params WHERE CAST(thoi_gian_tao AS DATE) BETWEEN StartDate AND EndDate AND (MaNV IS NULL OR ma_nv = MaNV)) AS don_hang_moi, " +
                "(SELECT COUNT(*) FROM SAN_PHAM WHERE trang_thai = 1) AS tong_san_pham, " +
                "(SELECT COUNT(*) FROM KHACH_HANG) AS tong_khach_hang";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, dates[0]);
            ps.setString(2, dates[1]);
            if (maNV == null || maNV.isEmpty()) ps.setNull(3, java.sql.Types.VARCHAR);
            else ps.setString(3, maNV);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    tk.setDoanhThuHomNay(rs.getInt("doanh_thu"));
                    tk.setDoanhThuThangNay(rs.getInt("doanh_thu_thang"));
                    tk.setDonHangMoi(rs.getInt("don_hang_moi"));
                    tk.setTongSanPham(rs.getInt("tong_san_pham"));
                    tk.setTongKhachHang(rs.getInt("tong_khach_hang"));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return tk;
    }

    public List<DonHangDashboard> getDonHangTheoNgay(String tuNgay, String denNgay, String maNV) {
        List<DonHangDashboard> list = new ArrayList<>();
        String[] dates = getDefaultDates(tuNgay, denNgay);
        String nvCondition = (maNV != null && !maNV.isEmpty()) ? " AND dh.ma_nv = ? " : "";
        String sql = "SELECT dh.ma_dh, dh.thoi_gian_tao, dh.tong_phai_tra, dh.trang_thai_don, nv.ho_ten " +
                "FROM DON_HANG dh JOIN NHAN_VIEN nv ON dh.ma_nv = nv.ma_nv " +
                "WHERE CAST(dh.thoi_gian_tao AS DATE) >= ? AND CAST(dh.thoi_gian_tao AS DATE) <= ? " + nvCondition +
                "ORDER BY dh.thoi_gian_tao DESC";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            int paramIndex = 1;
            ps.setString(paramIndex++, dates[0]);
            ps.setString(paramIndex++, dates[1]);
            if (maNV != null && !maNV.isEmpty()) ps.setString(paramIndex++, maNV);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DonHangDashboard dh = new DonHangDashboard();
                    dh.setMaDH(rs.getString("ma_dh"));
                    dh.setThoiGian(rs.getTimestamp("thoi_gian_tao"));
                    dh.setTongTien(rs.getInt("tong_phai_tra"));
                    dh.setTrangThai(rs.getString("trang_thai_don"));
                    dh.setTenNhanVien(rs.getString("ho_ten"));
                    list.add(dh);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<TopSanPham> getTopSanPham(String tuNgay, String denNgay, String maNV) {
        List<TopSanPham> list = new ArrayList<>();
        String[] dates = getDefaultDates(tuNgay, denNgay);
        String nvCondition = (maNV != null && !maNV.isEmpty()) ? " AND dh.ma_nv = ? " : "";
        String sql = "SELECT TOP 5 sp.ten_san_pham, SUM(ct.so_luong) as tong_so_luong " +
                "FROM CHI_TIET_DON_HANG ct JOIN BIEN_THE_SAN_PHAM bt ON ct.ma_bien_the = bt.ma_bien_the " +
                "JOIN SAN_PHAM sp ON bt.ma_sp = sp.ma_sp JOIN DON_HANG dh ON ct.ma_dh = dh.ma_dh " +
                "WHERE CAST(dh.thoi_gian_tao AS DATE) >= ? AND CAST(dh.thoi_gian_tao AS DATE) <= ? AND dh.trang_thai_don != N'Đã hủy' " + nvCondition +
                "GROUP BY sp.ten_san_pham ORDER BY tong_so_luong DESC";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            int paramIndex = 1;
            ps.setString(paramIndex++, dates[0]);
            ps.setString(paramIndex++, dates[1]);
            if (maNV != null && !maNV.isEmpty()) ps.setString(paramIndex++, maNV);
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

    public Map<String, Integer> getDoanhThu7NgayQua(String tuNgay, String denNgay, String maNV) {
        Map<String, Integer> chartData = new LinkedHashMap<>();
        String[] dates = getDefaultDates(tuNgay, denNgay);
        String nvCondition = (maNV != null && !maNV.isEmpty()) ? " AND ma_nv = ? " : "";
        String sql = "SELECT TOP 14 FORMAT(thoi_gian_tao, 'dd/MM') as ngay, SUM(tong_phai_tra) as tong_doanh_thu " +
                "FROM DON_HANG WHERE CAST(thoi_gian_tao AS DATE) >= ? AND CAST(thoi_gian_tao AS DATE) <= ? AND trang_thai_don = N'Hoàn thành' " + nvCondition +
                "GROUP BY FORMAT(thoi_gian_tao, 'dd/MM'), CAST(thoi_gian_tao AS DATE) ORDER BY CAST(thoi_gian_tao AS DATE) ASC";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            int paramIndex = 1;
            ps.setString(paramIndex++, dates[0]);
            ps.setString(paramIndex++, dates[1]);
            if (maNV != null && !maNV.isEmpty()) ps.setString(paramIndex++, maNV);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) chartData.put(rs.getString("ngay"), rs.getInt("tong_doanh_thu"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return chartData;
    }

    public Map<String, Object> getReceiptData(String maDH) {
        Map<String, Object> receipt = new LinkedHashMap<>();
        String sqlDH = "SELECT dh.ma_dh, dh.thoi_gian_tao, dh.tong_tien_hang, dh.tien_giam_gia, dh.tong_phai_tra, dh.so_tien_khach_dua, " +
                "nv.ho_ten AS ten_nv, kh.ten_khach_hang AS ten_kh, pt.ten_phuong_thuc " +
                "FROM DON_HANG dh LEFT JOIN NHAN_VIEN nv ON dh.ma_nv = nv.ma_nv " +
                "LEFT JOIN KHACH_HANG kh ON dh.ma_kh = kh.ma_kh " +
                "LEFT JOIN PHUONG_THUC_THANH_TOAN pt ON dh.ma_pttt = pt.ma_pttt WHERE dh.ma_dh = ?";

        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sqlDH)) {
            ps.setString(1, maDH);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    receipt.put("maDH", rs.getString("ma_dh"));
                    receipt.put("nhanVien", rs.getString("ten_nv"));

                    // CHỈ LẤY DỮ LIỆU THÔ, NHƯỜNG PHẦN FORMAT CHO SERVICE
                    receipt.put("thoi_gian_tho", rs.getTimestamp("thoi_gian_tao"));
                    receipt.put("ten_kh_tho", rs.getString("ten_kh"));
                    receipt.put("ten_pttt_tho", rs.getString("ten_phuong_thuc"));

                    receipt.put("tongTienHang", rs.getInt("tong_tien_hang"));
                    receipt.put("tienGiamGia", rs.getInt("tien_giam_gia"));
                    receipt.put("tongPhaiTra", rs.getInt("tong_phai_tra"));
                    receipt.put("tienKhachDua", rs.getInt("so_tien_khach_dua"));

                    List<Map<String, Object>> items = new ArrayList<>();
                    String sqlCT = "SELECT ct.ma_chi_tiet, ct.so_luong, ct.gia_chot_mon, ct.muc_da, ct.muc_duong, sp.ten_san_pham, bt.kich_co " +
                            "FROM CHI_TIET_DON_HANG ct JOIN BIEN_THE_SAN_PHAM bt ON ct.ma_bien_the = bt.ma_bien_the " +
                            "JOIN SAN_PHAM sp ON bt.ma_sp = sp.ma_sp WHERE ct.ma_dh = ?";

                    try (PreparedStatement psCT = con.prepareStatement(sqlCT)) {
                        psCT.setString(1, maDH);
                        try (ResultSet rsCT = psCT.executeQuery()) {
                            while (rsCT.next()) {
                                Map<String, Object> item = new LinkedHashMap<>();
                                String maChiTiet = rsCT.getString("ma_chi_tiet");
                                item.put("tenMon", rsCT.getString("ten_san_pham"));
                                // Bổ sung rào chắn NULL để tránh lỗi 'Size |'
                                item.put("size", rsCT.getString("kich_co") != null ? rsCT.getString("kich_co") : "");
                                item.put("da", rsCT.getString("muc_da") != null ? rsCT.getString("muc_da") : "100%");
                                item.put("duong", rsCT.getString("muc_duong") != null ? rsCT.getString("muc_duong") : "100%");
                                item.put("soLuong", rsCT.getInt("so_luong"));
                                item.put("giaChot", rsCT.getInt("gia_chot_mon"));

                                List<Map<String, Object>> toppings = new ArrayList<>();

                                // ĐÃ CẬP NHẬT: Lấy thêm ctt.gia_chot_topping
                                String sqlTP = "SELECT tp.ten_topping, ctt.so_luong_topping, ctt.gia_chot_topping " +
                                        "FROM CHI_TIET_TOPPING ctt JOIN TOPPING tp ON ctt.ma_topping = tp.ma_topping " +
                                        "WHERE ctt.ma_chi_tiet = ?";

                                try (PreparedStatement psTP = con.prepareStatement(sqlTP)) {
                                    psTP.setString(1, maChiTiet);
                                    try (ResultSet rsTP = psTP.executeQuery()) {
                                        while (rsTP.next()) {
                                            Map<String, Object> topping = new LinkedHashMap<>();
                                            topping.put("ten", rsTP.getString("ten_topping"));
                                            topping.put("sl", rsTP.getInt("so_luong_topping"));
                                            topping.put("gia", rsTP.getInt("gia_chot_topping")); // BỔ SUNG DÒNG NÀY ĐỂ HIỂN THỊ GIÁ TRÊN JSP
                                            toppings.add(topping);
                                        }
                                    }
                                }
                                item.put("toppings", toppings);
                                items.add(item);
                            }
                        }
                    }
                    receipt.put("items", items);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return receipt;
    }
}