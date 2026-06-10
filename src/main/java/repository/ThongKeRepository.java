package repository;

import model.ThongKe;
import model.DonHangDashboard;
import model.TopSanPham;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.LinkedHashMap;
import java.util.Map;

public class ThongKeRepository {

    private String[] getDefaultDates(String tuNgay, String denNgay) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String today = sdf.format(new Date());

        if ((tuNgay == null || tuNgay.isEmpty()) && (denNgay == null || denNgay.isEmpty())) {
            tuNgay = today;
            denNgay = today;
        }
        if (tuNgay == null || tuNgay.isEmpty()) tuNgay = "2000-01-01";
        if (denNgay == null || denNgay.isEmpty()) denNgay = "2099-12-31";

        return new String[]{tuNgay, denNgay};
    }

    public ThongKe getThongKeTongQuan(String tuNgay, String denNgay, String maNV) {
        ThongKe tk = new ThongKe();
        String[] dates = getDefaultDates(tuNgay, denNgay);
        tuNgay = dates[0];
        denNgay = dates[1];

        String nvCondition = (maNV != null && !maNV.isEmpty()) ? " AND ma_nv = ? " : "";

        String sql = "SELECT " +
                "(SELECT ISNULL(SUM(tong_phai_tra), 0) FROM DON_HANG WHERE CAST(thoi_gian_tao AS DATE) >= ? AND CAST(thoi_gian_tao AS DATE) <= ? AND trang_thai_don = N'Hoàn thành' " + nvCondition + ") AS doanh_thu, " +
                "(SELECT COUNT(*) FROM DON_HANG WHERE CAST(thoi_gian_tao AS DATE) >= ? AND CAST(thoi_gian_tao AS DATE) <= ? " + nvCondition + ") AS don_hang_moi, " +
                "(SELECT COUNT(*) FROM SAN_PHAM WHERE trang_thai = 1) AS tong_san_pham, " +
                "(SELECT COUNT(*) FROM KHACH_HANG) AS tong_khach_hang, " +
                "(SELECT ISNULL(SUM(tong_phai_tra), 0) FROM DON_HANG WHERE MONTH(thoi_gian_tao) = MONTH(GETDATE()) AND YEAR(thoi_gian_tao) = YEAR(GETDATE()) AND trang_thai_don = N'Hoàn thành' " + nvCondition + ") AS doanh_thu_thang_nay";

        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            int paramIndex = 1;
            ps.setString(paramIndex++, tuNgay);
            ps.setString(paramIndex++, denNgay);
            if (maNV != null && !maNV.isEmpty()) ps.setString(paramIndex++, maNV);

            ps.setString(paramIndex++, tuNgay);
            ps.setString(paramIndex++, denNgay);
            if (maNV != null && !maNV.isEmpty()) ps.setString(paramIndex++, maNV);

            if (maNV != null && !maNV.isEmpty()) ps.setString(paramIndex++, maNV);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    tk.setDoanhThuHomNay(rs.getInt("doanh_thu"));
                    tk.setDonHangMoi(rs.getInt("don_hang_moi"));
                    tk.setTongSanPham(rs.getInt("tong_san_pham"));
                    tk.setTongKhachHang(rs.getInt("tong_khach_hang"));
                    tk.setDoanhThuThangNay(rs.getInt("doanh_thu_thang_nay"));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return tk;
    }

    public List<DonHangDashboard> getDonHangTheoNgay(String tuNgay, String denNgay, String maNV) {
        List<DonHangDashboard> list = new ArrayList<>();
        String[] dates = getDefaultDates(tuNgay, denNgay);
        tuNgay = dates[0];
        denNgay = dates[1];

        String nvCondition = (maNV != null && !maNV.isEmpty()) ? " AND dh.ma_nv = ? " : "";

        String sql = "SELECT dh.ma_dh, dh.thoi_gian_tao, dh.tong_phai_tra, dh.trang_thai_don, nv.ho_ten " +
                "FROM DON_HANG dh " +
                "JOIN NHAN_VIEN nv ON dh.ma_nv = nv.ma_nv " +
                "WHERE CAST(dh.thoi_gian_tao AS DATE) >= ? AND CAST(dh.thoi_gian_tao AS DATE) <= ? " + nvCondition +
                "ORDER BY dh.thoi_gian_tao DESC";

        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            int paramIndex = 1;
            ps.setString(paramIndex++, tuNgay);
            ps.setString(paramIndex++, denNgay);
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
        tuNgay = dates[0];
        denNgay = dates[1];

        String nvCondition = (maNV != null && !maNV.isEmpty()) ? " AND dh.ma_nv = ? " : "";

        String sql = "SELECT TOP 5 sp.ten_san_pham, SUM(ct.so_luong) as tong_so_luong " +
                "FROM CHI_TIET_DON_HANG ct " +
                "JOIN BIEN_THE_SAN_PHAM bt ON ct.ma_bien_the = bt.ma_bien_the " +
                "JOIN SAN_PHAM sp ON bt.ma_sp = sp.ma_sp " +
                "JOIN DON_HANG dh ON ct.ma_dh = dh.ma_dh " +
                "WHERE CAST(dh.thoi_gian_tao AS DATE) >= ? AND CAST(dh.thoi_gian_tao AS DATE) <= ? AND dh.trang_thai_don != N'Đã hủy' " + nvCondition +
                "GROUP BY sp.ten_san_pham " +
                "ORDER BY tong_so_luong DESC";

        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            int paramIndex = 1;
            ps.setString(paramIndex++, tuNgay);
            ps.setString(paramIndex++, denNgay);
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
        tuNgay = dates[0];
        denNgay = dates[1];

        String nvCondition = (maNV != null && !maNV.isEmpty()) ? " AND ma_nv = ? " : "";

        String sql = "SELECT TOP 14 FORMAT(thoi_gian_tao, 'dd/MM') as ngay, SUM(tong_phai_tra) as tong_doanh_thu " +
                "FROM DON_HANG " +
                "WHERE CAST(thoi_gian_tao AS DATE) >= ? AND CAST(thoi_gian_tao AS DATE) <= ? AND trang_thai_don = N'Hoàn thành' " + nvCondition +
                "GROUP BY FORMAT(thoi_gian_tao, 'dd/MM'), CAST(thoi_gian_tao AS DATE) " +
                "ORDER BY CAST(thoi_gian_tao AS DATE) ASC";

        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            int paramIndex = 1;
            ps.setString(paramIndex++, tuNgay);
            ps.setString(paramIndex++, denNgay);
            if (maNV != null && !maNV.isEmpty()) ps.setString(paramIndex++, maNV);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    chartData.put(rs.getString("ngay"), rs.getInt("tong_doanh_thu"));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return chartData;
    }

    // =========================================================================
    // HÀM MỚI TỐI ƯU HÓA: Chống lỗi MARS của SQL Server và Lỗi JSON Parse
    // =========================================================================
    public String getReceiptJson(String maDH) {
        StringBuilder json = new StringBuilder("{");

        String sqlDH = "SELECT dh.ma_dh, dh.thoi_gian_tao, dh.tong_tien_hang, dh.tien_giam_gia, dh.tong_phai_tra, dh.so_tien_khach_dua, " +
                "nv.ho_ten AS ten_nv, kh.ten_khach_hang AS ten_kh, pt.ten_phuong_thuc " +
                "FROM DON_HANG dh " +
                "LEFT JOIN NHAN_VIEN nv ON dh.ma_nv = nv.ma_nv " +
                "LEFT JOIN KHACH_HANG kh ON dh.ma_kh = kh.ma_kh " +
                "LEFT JOIN PHUONG_THUC_THANH_TOAN pt ON dh.ma_pttt = pt.ma_pttt " +
                "WHERE dh.ma_dh = ?";

        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sqlDH)) {
            ps.setString(1, maDH);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
                    json.append("\"maDH\":\"").append(escapeJson(rs.getString("ma_dh"))).append("\",");
                    json.append("\"ngay\":\"").append(sdf.format(rs.getTimestamp("thoi_gian_tao"))).append("\",");
                    json.append("\"nhanVien\":\"").append(escapeJson(rs.getString("ten_nv"))).append("\",");
                    json.append("\"khachHang\":\"").append(escapeJson(rs.getString("ten_kh") != null ? rs.getString("ten_kh") : "Khách vãng lai")).append("\",");
                    json.append("\"phuongThuc\":\"").append(escapeJson(rs.getString("ten_phuong_thuc") != null ? rs.getString("ten_phuong_thuc") : "Tiền mặt")).append("\",");
                    json.append("\"tongTienHang\":").append(rs.getInt("tong_tien_hang")).append(",");
                    json.append("\"tienGiamGia\":").append(rs.getInt("tien_giam_gia")).append(",");
                    json.append("\"tongPhaiTra\":").append(rs.getInt("tong_phai_tra")).append(",");
                    json.append("\"tienKhachDua\":").append(rs.getInt("so_tien_khach_dua")).append(",");

                    json.append("\"items\":[");

                    // 1. Tạo mảng trung gian để tránh lỗi MultipleActiveResultSets
                    List<String[]> listItems = new ArrayList<>();

                    String sqlCT = "SELECT ct.ma_chi_tiet, ct.so_luong, ct.gia_chot_mon, ct.muc_da, ct.muc_duong, sp.ten_san_pham, bt.kich_co " +
                            "FROM CHI_TIET_DON_HANG ct " +
                            "JOIN BIEN_THE_SAN_PHAM bt ON ct.ma_bien_the = bt.ma_bien_the " +
                            "JOIN SAN_PHAM sp ON bt.ma_sp = sp.ma_sp " +
                            "WHERE ct.ma_dh = ?";
                    try (PreparedStatement psCT = con.prepareStatement(sqlCT)) {
                        psCT.setString(1, maDH);
                        try (ResultSet rsCT = psCT.executeQuery()) {
                            while (rsCT.next()) {
                                listItems.add(new String[]{
                                        rsCT.getString("ma_chi_tiet"),
                                        rsCT.getString("ten_san_pham"),
                                        rsCT.getString("kich_co"),
                                        rsCT.getString("muc_da") != null ? rsCT.getString("muc_da") : "100%",
                                        rsCT.getString("muc_duong") != null ? rsCT.getString("muc_duong") : "100%",
                                        String.valueOf(rsCT.getInt("so_luong")),
                                        String.valueOf(rsCT.getInt("gia_chot_mon"))
                                });
                            }
                        }
                    } // rsCT và psCT được đóng tại đây

                    // 2. Vòng lặp lấy Topping từ List an toàn
                    boolean firstItem = true;
                    for (String[] it : listItems) {
                        if (!firstItem) json.append(",");
                        json.append("{");
                        json.append("\"tenMon\":\"").append(escapeJson(it[1])).append("\",");
                        json.append("\"size\":\"").append(escapeJson(it[2])).append("\",");
                        json.append("\"da\":\"").append(escapeJson(it[3])).append("\",");
                        json.append("\"duong\":\"").append(escapeJson(it[4])).append("\",");
                        json.append("\"soLuong\":").append(it[5]).append(",");
                        json.append("\"giaChot\":").append(it[6]).append(",");

                        json.append("\"toppings\":[");
                        String sqlTP = "SELECT tp.ten_topping, ctt.so_luong_topping " +
                                "FROM CHI_TIET_TOPPING ctt " +
                                "JOIN TOPPING tp ON ctt.ma_topping = tp.ma_topping " +
                                "WHERE ctt.ma_chi_tiet = ?";
                        try (PreparedStatement psTP = con.prepareStatement(sqlTP)) {
                            psTP.setString(1, it[0]);
                            try (ResultSet rsTP = psTP.executeQuery()) {
                                boolean firstTp = true;
                                while(rsTP.next()){
                                    if (!firstTp) json.append(",");
                                    json.append("{\"ten\":\"").append(escapeJson(rsTP.getString("ten_topping"))).append("\",");
                                    json.append("\"sl\":").append(rsTP.getInt("so_luong_topping")).append("}");
                                    firstTp = false;
                                }
                            }
                        } catch (Exception ignored) { }
                        json.append("]"); // đóng mảng toppings

                        json.append("}"); // đóng object item
                        firstItem = false;
                    }

                    json.append("]"); // đóng mảng items
                } else {
                    return "{\"error\":\"Không tìm thấy đơn hàng trong Database.\"}";
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Lỗi SQL khi lấy JSON: " + e.getMessage());
            return "{\"error\":\"Lỗi SQL: " + escapeJson(e.getMessage()) + "\"}";
        }
        json.append("}");
        return json.toString();
    }

    // Hàm hỗ trợ lọc chuỗi giúp trình duyệt không bị sập hàm JSON.parse()
    private String escapeJson(String data) {
        if (data == null) return "";
        return data.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\b", "\\b")
                .replace("\f", "\\f")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}