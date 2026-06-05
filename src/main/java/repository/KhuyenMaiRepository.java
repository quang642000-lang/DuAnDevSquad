package repository;

import model.KhuyenMai;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class KhuyenMaiRepository {

    // --- BỔ SUNG HÀM LẤY 1 KHUYẾN MÃI THEO MÃ (DÙNG ĐỂ CHECK LỊCH SỬ) ---
    public KhuyenMai getById(String maKM) {
        String sql = "SELECT *, (SELECT COUNT(*) FROM DON_HANG WHERE ma_km = CHUONG_TRINH_KHUYEN_MAI.ma_km) AS so_luong_da_dung FROM CHUONG_TRINH_KHUYEN_MAI WHERE ma_km = ?";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, maKM);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    KhuyenMai km = new KhuyenMai();
                    km.setMaKM(rs.getString("ma_km"));
                    km.setTenKM(rs.getString("ten_km"));
                    km.setLoaiGiamGia(rs.getString("loai_giam_gia"));
                    km.setGiaTrịGiam(rs.getInt("gia_tri_giam"));
                    km.setDieuKienToiThieu(rs.getInt("dieu_kien_toi_thieu"));
                    km.setSoLuong(rs.getInt("so_luong"));
                    km.setSoLuongDaDung(rs.getInt("so_luong_da_dung"));
                    km.setTrangThai(rs.getInt("trang_thai"));
                    km.setMaCode(rs.getString("ma_code"));
                    km.setNgayBatDau(rs.getDate("ngay_bat_dau"));
                    km.setNgayKetThuc(rs.getDate("ngay_ket_thuc"));
                    return km;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 1. Tìm mã Code hợp lệ (Đã kiểm tra so_luong còn dư hay không)
    public KhuyenMai getKhuyenMaiHopLe(String maCode) {
        String sql = "SELECT * FROM (" +
                "  SELECT *, (SELECT COUNT(*) FROM DON_HANG WHERE ma_km = CHUONG_TRINH_KHUYEN_MAI.ma_km) AS so_luong_da_dung " +
                "  FROM CHUONG_TRINH_KHUYEN_MAI " +
                "  WHERE ma_code = ? AND trang_thai = 1 AND CAST(GETDATE() AS DATE) BETWEEN ngay_bat_dau AND ngay_ket_thuc" +
                ") AS T WHERE T.so_luong > T.so_luong_da_dung";

        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, maCode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    KhuyenMai km = new KhuyenMai();
                    km.setMaKM(rs.getString("ma_km"));
                    km.setTenKM(rs.getString("ten_km"));
                    km.setLoaiGiamGia(rs.getString("loai_giam_gia"));
                    km.setGiaTrịGiam(rs.getInt("gia_tri_giam"));
                    km.setDieuKienToiThieu(rs.getInt("dieu_kien_toi_thieu"));
                    km.setSoLuong(rs.getInt("so_luong"));
                    km.setSoLuongDaDung(rs.getInt("so_luong_da_dung"));
                    km.setTrangThai(rs.getInt("trang_thai"));
                    km.setMaCode(rs.getString("ma_code"));
                    km.setNgayBatDau(rs.getDate("ngay_bat_dau"));
                    km.setNgayKetThuc(rs.getDate("ngay_ket_thuc"));
                    return km;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lấy số lượng thực tế đã dùng của 1 mã (Dùng để check điều kiện Sửa)
    public int getSoLuongDaDung(String maKM) {
        String sql = "SELECT COUNT(*) FROM DON_HANG WHERE ma_km = ?";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, maKM);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 2. Lấy toàn bộ (Có đếm số lượng đã dùng)
    public List<KhuyenMai> getAll() {
        List<KhuyenMai> list = new ArrayList<>();
        String sql = "SELECT *, (SELECT COUNT(*) FROM DON_HANG WHERE ma_km = CHUONG_TRINH_KHUYEN_MAI.ma_km) AS so_luong_da_dung FROM CHUONG_TRINH_KHUYEN_MAI";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                KhuyenMai km = new KhuyenMai();
                km.setMaKM(rs.getString("ma_km"));
                km.setTenKM(rs.getString("ten_km"));
                km.setLoaiGiamGia(rs.getString("loai_giam_gia"));
                km.setGiaTrịGiam(rs.getInt("gia_tri_giam"));
                km.setDieuKienToiThieu(rs.getInt("dieu_kien_toi_thieu"));
                km.setSoLuong(rs.getInt("so_luong"));
                km.setSoLuongDaDung(rs.getInt("so_luong_da_dung"));
                km.setTrangThai(rs.getInt("trang_thai"));
                km.setMaCode(rs.getString("ma_code"));
                km.setNgayBatDau(rs.getDate("ngay_bat_dau"));
                km.setNgayKetThuc(rs.getDate("ngay_ket_thuc"));
                list.add(km);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3. Thêm mới
    public boolean add(KhuyenMai km) {
        String sql = "INSERT INTO CHUONG_TRINH_KHUYEN_MAI (ten_km, loai_giam_gia, gia_tri_giam, dieu_kien_toi_thieu, so_luong, trang_thai, ma_code, ngay_bat_dau, ngay_ket_thuc) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, km.getTenKM());
            ps.setString(2, km.getLoaiGiamGia());
            ps.setInt(3, km.getGiaTrịGiam());
            ps.setInt(4, km.getDieuKienToiThieu());
            ps.setInt(5, km.getSoLuong());
            ps.setInt(6, km.getTrangThai());
            ps.setString(7, km.getMaCode());
            ps.setDate(8, new java.sql.Date(km.getNgayBatDau().getTime()));
            ps.setDate(9, new java.sql.Date(km.getNgayKetThuc().getTime()));

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 4. Cập nhật
    public boolean update(KhuyenMai km) {
        String sql = "UPDATE CHUONG_TRINH_KHUYEN_MAI SET ten_km = ?, loai_giam_gia = ?, gia_tri_giam = ?, dieu_kien_toi_thieu = ?, so_luong = ?, ma_code = ?, ngay_bat_dau = ?, ngay_ket_thuc = ? WHERE ma_km = ?";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, km.getTenKM());
            ps.setString(2, km.getLoaiGiamGia());
            ps.setInt(3, km.getGiaTrịGiam());
            ps.setInt(4, km.getDieuKienToiThieu());
            ps.setInt(5, km.getSoLuong());
            ps.setString(6, km.getMaCode());
            ps.setDate(7, new java.sql.Date(km.getNgayBatDau().getTime()));
            ps.setDate(8, new java.sql.Date(km.getNgayKetThuc().getTime()));
            ps.setString(9, km.getMaKM());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 5. Cập nhật trạng thái
    public boolean updateTrangThai(String maKM, int trangThai) {
        String sql = "UPDATE CHUONG_TRINH_KHUYEN_MAI SET trang_thai = ? WHERE ma_km = ?";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, trangThai);
            ps.setString(2, maKM);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 6. Xóa vĩnh viễn
    public boolean delete(String maKM) {
        String sql = "DELETE FROM CHUONG_TRINH_KHUYEN_MAI WHERE ma_km = ?";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, maKM);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 7. Tìm kiếm theo tên hoặc mã code
    public List<KhuyenMai> search(String keyword) {
        List<KhuyenMai> list = new ArrayList<>();
        String sql = "SELECT *, (SELECT COUNT(*) FROM DON_HANG WHERE ma_km = CHUONG_TRINH_KHUYEN_MAI.ma_km) AS so_luong_da_dung FROM CHUONG_TRINH_KHUYEN_MAI WHERE ten_km LIKE ? OR ma_code LIKE ?";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            String searchPattern = "%" + keyword.trim() + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    KhuyenMai km = new KhuyenMai();
                    km.setMaKM(rs.getString("ma_km"));
                    km.setTenKM(rs.getString("ten_km"));
                    km.setLoaiGiamGia(rs.getString("loai_giam_gia"));
                    km.setGiaTrịGiam(rs.getInt("gia_tri_giam"));
                    km.setDieuKienToiThieu(rs.getInt("dieu_kien_toi_thieu"));
                    km.setSoLuong(rs.getInt("so_luong"));
                    km.setSoLuongDaDung(rs.getInt("so_luong_da_dung"));
                    km.setTrangThai(rs.getInt("trang_thai"));
                    km.setMaCode(rs.getString("ma_code"));
                    km.setNgayBatDau(rs.getDate("ngay_bat_dau"));
                    km.setNgayKetThuc(rs.getDate("ngay_ket_thuc"));
                    list.add(km);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}