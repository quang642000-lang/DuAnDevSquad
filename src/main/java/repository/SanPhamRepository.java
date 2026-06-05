package repository;

import model.DanhMuc;
import model.SanPham;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class SanPhamRepository {

    // 1. Lấy tất cả sản phẩm
    public List<SanPham> getAll() {
        List<SanPham> list = new ArrayList<>();
        String sql = "SELECT sp.ma_sp, sp.ten_san_pham, sp.trang_thai, sp.hinh_anh, sp.ma_danh_muc, dm.ten_danh_muc " +
                "FROM SAN_PHAM sp LEFT JOIN DANH_MUC dm ON sp.ma_danh_muc = dm.ma_danh_muc";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                SanPham sp = new SanPham();
                sp.setMaSP(rs.getString("ma_sp")); // ĐÃ CHUẨN HÓA
                sp.setTenSanPham(rs.getString("ten_san_pham")); // ĐÃ CHUẨN HÓA
                sp.setHinhAnh(rs.getString("hinh_anh"));
                sp.setTrangThai(rs.getInt("trang_thai"));

                DanhMuc dm = new DanhMuc();
                dm.setMaDanhMuc(rs.getString("ma_danh_muc"));
                dm.setTenDanhMuc(rs.getString("ten_danh_muc"));
                sp.setDanhMuc(dm);

                list.add(sp);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Lấy sản phẩm theo mã Danh Mục (ĐÃ KHÔI PHỤC HÀM NÀY)
    public List<SanPham> getSanPhamByDanhMuc(String maDanhMuc) {
        List<SanPham> list = new ArrayList<>();
        String sql = "SELECT sp.ma_sp, sp.ten_san_pham, sp.trang_thai, sp.hinh_anh, " +
                "sp.ma_danh_muc, dm.ten_danh_muc " +
                "FROM SAN_PHAM sp " +
                "LEFT JOIN DANH_MUC dm ON sp.ma_danh_muc = dm.ma_danh_muc " +
                "WHERE sp.ma_danh_muc = ? AND sp.trang_thai = 1";

        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, maDanhMuc);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SanPham sp = new SanPham();
                    sp.setMaSP(rs.getString("ma_sp")); // ĐÃ CHUẨN HÓA
                    sp.setTenSanPham(rs.getString("ten_san_pham")); // ĐÃ CHUẨN HÓA
                    sp.setHinhAnh(rs.getString("hinh_anh"));
                    sp.setTrangThai(rs.getInt("trang_thai"));

                    DanhMuc dm = new DanhMuc();
                    dm.setMaDanhMuc(rs.getString("ma_danh_muc"));
                    dm.setTenDanhMuc(rs.getString("ten_danh_muc"));
                    sp.setDanhMuc(dm);

                    list.add(sp);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3. Thêm mới Sản phẩm
    public boolean add(SanPham sp) {
        String sql = "INSERT INTO SAN_PHAM (ten_san_pham, trang_thai, hinh_anh, ma_danh_muc) VALUES (?, ?, ?, ?)";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, sp.getTenSanPham()); // ĐÃ CHUẨN HÓA
            ps.setInt(2, sp.getTrangThai());
            ps.setString(3, sp.getHinhAnh());
            ps.setString(4, sp.getDanhMuc().getMaDanhMuc());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 4. Cập nhật Sản phẩm
    public boolean update(SanPham sp) {
        String sql = "UPDATE SAN_PHAM SET ten_san_pham = ?, hinh_anh = ?, ma_danh_muc = ? WHERE ma_sp = ?";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, sp.getTenSanPham()); // ĐÃ CHUẨN HÓA
            ps.setString(2, sp.getHinhAnh());
            ps.setString(3, sp.getDanhMuc().getMaDanhMuc());
            ps.setString(4, sp.getMaSP()); // ĐÃ CHUẨN HÓA
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 5. Cập nhật trạng thái
    public boolean updateTrangThai(String maSP, int trangThaiMoi) {
        String sql = "UPDATE SAN_PHAM SET trang_thai = ? WHERE ma_sp = ?";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, trangThaiMoi);
            ps.setString(2, maSP);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 6. Xóa sản phẩm
    public boolean delete(String maSP) {
        String sql = "DELETE FROM SAN_PHAM WHERE ma_sp = ?";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, maSP);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 7. Tìm kiếm sản phẩm
    public List<SanPham> search(String keyword, String maDanhMuc) {
        List<SanPham> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT sp.ma_sp, sp.ten_san_pham, sp.trang_thai, sp.hinh_anh, sp.ma_danh_muc, dm.ten_danh_muc " +
                        "FROM SAN_PHAM sp " +
                        "LEFT JOIN DANH_MUC dm ON sp.ma_danh_muc = dm.ma_danh_muc " +
                        "WHERE 1=1 "
        );

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (sp.ten_san_pham LIKE ? OR sp.ma_sp LIKE ?) ");
        }
        if (maDanhMuc != null && !maDanhMuc.trim().isEmpty() && !maDanhMuc.equals("all")) {
            sql.append("AND sp.ma_danh_muc = ? ");
        }

        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int index = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String likeValue = "%" + keyword.trim() + "%";
                ps.setString(index++, likeValue);
                ps.setString(index++, likeValue);
            }
            if (maDanhMuc != null && !maDanhMuc.trim().isEmpty() && !maDanhMuc.equals("all")) {
                ps.setString(index++, maDanhMuc);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SanPham sp = new SanPham();
                    sp.setMaSP(rs.getString("ma_sp")); // ĐÃ CHUẨN HÓA
                    sp.setTenSanPham(rs.getString("ten_san_pham")); // ĐÃ CHUẨN HÓA
                    sp.setHinhAnh(rs.getString("hinh_anh"));
                    sp.setTrangThai(rs.getInt("trang_thai"));

                    DanhMuc dm = new DanhMuc();
                    dm.setMaDanhMuc(rs.getString("ma_danh_muc"));
                    dm.setTenDanhMuc(rs.getString("ten_danh_muc"));
                    sp.setDanhMuc(dm);

                    list.add(sp);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}