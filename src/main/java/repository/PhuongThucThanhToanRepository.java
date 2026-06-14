package repository;

import model.PhuongThucThanhToan;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class PhuongThucThanhToanRepository {

    public List<PhuongThucThanhToan> getAll() {
        List<PhuongThucThanhToan> list = new ArrayList<>();
        String sql = "SELECT * FROM PHUONG_THUC_THANH_TOAN";

        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                PhuongThucThanhToan pt = new PhuongThucThanhToan();
                pt.setMaPTTT(rs.getString("ma_pttt"));
                pt.setTenPhuongThuc(rs.getString("ten_phuong_thuc"));
                pt.setTrangThai(rs.getInt("trang_thai"));
                list.add(pt);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<PhuongThucThanhToan> getAll(int offset, int limit) {
        List<PhuongThucThanhToan> list = new ArrayList<>();
        String sql = "SELECT * FROM PHUONG_THUC_THANH_TOAN ORDER BY ma_pttt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PhuongThucThanhToan pt = new PhuongThucThanhToan();
                    pt.setMaPTTT(rs.getString("ma_pttt"));
                    pt.setTenPhuongThuc(rs.getString("ten_phuong_thuc"));
                    pt.setTrangThai(rs.getInt("trang_thai"));
                    list.add(pt);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public int getTotalCount() {
        String sql = "SELECT COUNT(*) FROM PHUONG_THUC_THANH_TOAN";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public boolean add(PhuongThucThanhToan pt) {
        String sql = "INSERT INTO PHUONG_THUC_THANH_TOAN (ten_phuong_thuc, trang_thai) VALUES (?, ?)";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, pt.getTenPhuongThuc());
            ps.setInt(2, pt.getTrangThai());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(PhuongThucThanhToan pt) {
        String sql = "UPDATE PHUONG_THUC_THANH_TOAN SET ten_phuong_thuc = ? WHERE ma_pttt = ?";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, pt.getTenPhuongThuc());
            ps.setString(2, pt.getMaPTTT());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateTrangThai(String maPTTT, int trangThai) {
        String sql = "UPDATE PHUONG_THUC_THANH_TOAN SET trang_thai = ? WHERE ma_pttt = ?";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, trangThai);
            ps.setString(2, maPTTT);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(String maPTTT) {
        String sql = "DELETE FROM PHUONG_THUC_THANH_TOAN WHERE ma_pttt = ?";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, maPTTT);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Lỗi Xóa: PTTT này đã có trong Hóa Đơn!");
        }
        return false;
    }

    public List<PhuongThucThanhToan> search(String keyword) {
        List<PhuongThucThanhToan> list = new ArrayList<>();
        String sql = "SELECT * FROM PHUONG_THUC_THANH_TOAN WHERE ten_phuong_thuc LIKE ? OR ma_pttt LIKE ?";

        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            String searchPattern = "%" + keyword.trim() + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PhuongThucThanhToan pt = new PhuongThucThanhToan();
                    pt.setMaPTTT(rs.getString("ma_pttt"));
                    pt.setTenPhuongThuc(rs.getString("ten_phuong_thuc"));
                    pt.setTrangThai(rs.getInt("trang_thai"));
                    list.add(pt);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}