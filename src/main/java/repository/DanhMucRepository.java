package repository;

import model.DanhMuc;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class DanhMucRepository {

    public List<DanhMuc> getAll() {
        List<DanhMuc> list = new ArrayList<>();
        String sql = "SELECT ma_danh_muc, ten_danh_muc FROM DANH_MUC";

        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                DanhMuc dm = new DanhMuc();
                dm.setMaDanhMuc(rs.getString("ma_danh_muc"));
                dm.setTenDanhMuc(rs.getString("ten_danh_muc"));
                list.add(dm);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<DanhMuc> getAll(int offset, int limit) {
        List<DanhMuc> list = new ArrayList<>();
        String sql = "SELECT ma_danh_muc, ten_danh_muc FROM DANH_MUC " +
                "ORDER BY ma_danh_muc DESC " +
                "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DanhMuc dm = new DanhMuc();
                    dm.setMaDanhMuc(rs.getString("ma_danh_muc"));
                    dm.setTenDanhMuc(rs.getString("ten_danh_muc"));
                    list.add(dm);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public int getTotalCount() {
        String sql = "SELECT COUNT(*) FROM DANH_MUC";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public boolean add(DanhMuc dm) {
        String sql = "INSERT INTO DANH_MUC (ten_danh_muc) VALUES (?)";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, dm.getTenDanhMuc());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("LỖI THÊM DANH MỤC: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(DanhMuc dm) {
        String sql = "UPDATE DANH_MUC SET ten_danh_muc = ? WHERE ma_danh_muc = ?";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, dm.getTenDanhMuc());
            ps.setString(2, dm.getMaDanhMuc());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(String maDanhMuc) {
        String sql = "DELETE FROM DANH_MUC WHERE ma_danh_muc = ?";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, maDanhMuc);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Lỗi xóa: Danh mục này có thể đang chứa sản phẩm!");
            e.printStackTrace();
        }
        return false;
    }
}
