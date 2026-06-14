package repository;

import model.Topping;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ToppingRepository {

    public List<Topping> getAll() {
        List<Topping> list = new ArrayList<>();
        String sql = "SELECT * FROM TOPPING";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Topping tp = new Topping();
                tp.setMaTopping(rs.getString("ma_topping"));
                tp.setTenTopping(rs.getString("ten_topping"));
                tp.setGiaBan(rs.getInt("gia_ban"));
                tp.setHinhAnh(rs.getString("hinh_anh"));
                tp.setTrangThai(rs.getInt("trang_thai"));
                list.add(tp);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Topping> getAll(int offset, int limit) {
        List<Topping> list = new ArrayList<>();
        String sql = "SELECT * FROM TOPPING ORDER BY ma_topping DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Topping tp = new Topping();
                    tp.setMaTopping(rs.getString("ma_topping"));
                    tp.setTenTopping(rs.getString("ten_topping"));
                    tp.setGiaBan(rs.getInt("gia_ban"));
                    tp.setHinhAnh(rs.getString("hinh_anh"));
                    tp.setTrangThai(rs.getInt("trang_thai"));
                    list.add(tp);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public int getTotalCount() {
        String sql = "SELECT COUNT(*) FROM TOPPING";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public boolean add(Topping tp) {
        String sql = "INSERT INTO TOPPING (ten_topping, gia_ban, hinh_anh, trang_thai) VALUES (?, ?, ?, ?)";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, tp.getTenTopping());
            ps.setInt(2, tp.getGiaBan());
            ps.setString(3, tp.getHinhAnh());
            ps.setInt(4, tp.getTrangThai());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Topping tp) {
        String sql = "UPDATE TOPPING SET ten_topping = ?, gia_ban = ?, hinh_anh = ? WHERE ma_topping = ?";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, tp.getTenTopping());
            ps.setInt(2, tp.getGiaBan());
            ps.setString(3, tp.getHinhAnh());
            ps.setString(4, tp.getMaTopping());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateTrangThai(String maTopping, int trangThai) {
        String sql = "UPDATE TOPPING SET trang_thai = ? WHERE ma_topping = ?";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, trangThai);
            ps.setString(2, maTopping);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(String maTopping) {
        String sql = "DELETE FROM TOPPING WHERE ma_topping = ?";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, maTopping);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Lỗi Xóa Topping: Có thể đã dính khóa ngoại (Đang nằm trong đơn hàng).");
        }
        return false;
    }

    public List<Topping> search(String keyword) {
        List<Topping> list = new ArrayList<>();
        String sql = "SELECT * FROM TOPPING WHERE ten_topping LIKE ? OR ma_topping LIKE ?";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            String searchPattern = "%" + keyword.trim() + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Topping tp = new Topping();
                    tp.setMaTopping(rs.getString("ma_topping"));
                    tp.setTenTopping(rs.getString("ten_topping"));
                    tp.setGiaBan(rs.getInt("gia_ban"));
                    tp.setHinhAnh(rs.getString("hinh_anh"));
                    tp.setTrangThai(rs.getInt("trang_thai"));
                    list.add(tp);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Topping findById(String maTopping) {
        String sql = "SELECT * FROM TOPPING WHERE ma_topping = ?";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, maTopping);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Topping tp = new Topping();
                    tp.setMaTopping(rs.getString("ma_topping"));
                    tp.setTenTopping(rs.getString("ten_topping"));
                    tp.setGiaBan(rs.getInt("gia_ban"));
                    tp.setHinhAnh(rs.getString("hinh_anh"));
                    tp.setTrangThai(rs.getInt("trang_thai"));
                    return tp;
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }
}