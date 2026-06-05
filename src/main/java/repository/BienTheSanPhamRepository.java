package repository;

import model.BienTheSanPham;
import model.SanPham;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class BienTheSanPhamRepository {

    public List<BienTheSanPham> getAll() {
        List<BienTheSanPham> list = new ArrayList<>();
        String sql = "SELECT bt.ma_bien_the, bt.gia_ban, bt.kich_co, bt.trang_thai, bt.ma_sp, sp.ten_san_pham " +
                "FROM BIEN_THE_SAN_PHAM bt " +
                "LEFT JOIN SAN_PHAM sp ON bt.ma_sp = sp.ma_sp";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                BienTheSanPham bt = new BienTheSanPham();
                bt.setMaBienThe(rs.getString("ma_bien_the"));
                bt.setGiaBan(rs.getInt("gia_ban"));
                bt.setKichCo(rs.getString("kich_co"));
                bt.setTrangThai(rs.getInt("trang_thai"));

                SanPham sp = new SanPham();
                sp.setMaSP(rs.getString("ma_sp"));
                // ĐÃ SỬA LỖI BUILD: Gọi đúng hàm setTenSanPham
                sp.setTenSanPham(rs.getString("ten_san_pham"));
                bt.setSanPham(sp);

                list.add(bt);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean add(BienTheSanPham bt) {
        String sql = "INSERT INTO BIEN_THE_SAN_PHAM (gia_ban, kich_co, trang_thai, ma_sp) VALUES (?, ?, ?, ?)";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, bt.getGiaBan());
            ps.setString(2, bt.getKichCo());
            ps.setInt(3, bt.getTrangThai());
            ps.setString(4, bt.getSanPham().getMaSP());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(BienTheSanPham bt) {
        String sql = "UPDATE BIEN_THE_SAN_PHAM SET gia_ban = ?, kich_co = ?, ma_sp = ? WHERE ma_bien_the = ?";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, bt.getGiaBan());
            ps.setString(2, bt.getKichCo());
            ps.setString(3, bt.getSanPham().getMaSP());
            ps.setString(4, bt.getMaBienThe());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateTrangThai(String maBienThe, int trangThai) {
        String sql = "UPDATE BIEN_THE_SAN_PHAM SET trang_thai = ? WHERE ma_bien_the = ?";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, trangThai);
            ps.setString(2, maBienThe);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(String maBienThe) {
        String sql = "DELETE FROM BIEN_THE_SAN_PHAM WHERE ma_bien_the = ?";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, maBienThe);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Lỗi xóa: " + e.getMessage());
        }
        return false;
    }

    public boolean updateTrangThaiBySanPham(String maSp, int trangThai) {
        String sql = "UPDATE BIEN_THE_SAN_PHAM SET trang_thai = ? WHERE ma_sp = ?";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, trangThai);
            ps.setString(2, maSp);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<BienTheSanPham> search(String keyword, String maSp) {
        List<BienTheSanPham> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT bt.ma_bien_the, bt.gia_ban, bt.kich_co, bt.trang_thai, bt.ma_sp, sp.ten_san_pham " +
                        "FROM BIEN_THE_SAN_PHAM bt " +
                        "LEFT JOIN SAN_PHAM sp ON bt.ma_sp = sp.ma_sp " +
                        "WHERE 1=1 "
        );

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (sp.ten_san_pham LIKE ? OR bt.kich_co LIKE ? OR bt.ma_bien_the LIKE ?) ");
        }
        if (maSp != null && !maSp.trim().isEmpty() && !maSp.equals("all")) {
            sql.append("AND bt.ma_sp = ? ");
        }

        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int index = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String likeValue = "%" + keyword.trim() + "%";
                ps.setString(index++, likeValue);
                ps.setString(index++, likeValue);
                ps.setString(index++, likeValue);
            }
            if (maSp != null && !maSp.trim().isEmpty() && !maSp.equals("all")) {
                ps.setString(index++, maSp);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BienTheSanPham bt = new BienTheSanPham();
                    bt.setMaBienThe(rs.getString("ma_bien_the"));
                    bt.setGiaBan(rs.getInt("gia_ban"));
                    bt.setKichCo(rs.getString("kich_co"));
                    bt.setTrangThai(rs.getInt("trang_thai"));

                    SanPham sp = new SanPham();
                    sp.setMaSP(rs.getString("ma_sp"));
                    // ĐÃ SỬA LỖI BUILD: Gọi đúng hàm setTenSanPham
                    sp.setTenSanPham(rs.getString("ten_san_pham"));
                    bt.setSanPham(sp);

                    list.add(bt);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public BienTheSanPham findById(String maBienThe) {
        String sql = "SELECT bt.ma_bien_the, bt.gia_ban, bt.kich_co, bt.trang_thai, bt.ma_sp, sp.ten_san_pham " +
                "FROM BIEN_THE_SAN_PHAM bt " +
                "LEFT JOIN SAN_PHAM sp ON bt.ma_sp = sp.ma_sp " +
                "WHERE bt.ma_bien_the = ?";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, maBienThe);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    BienTheSanPham bt = new BienTheSanPham();
                    bt.setMaBienThe(rs.getString("ma_bien_the"));
                    bt.setGiaBan(rs.getInt("gia_ban"));
                    bt.setKichCo(rs.getString("kich_co"));
                    bt.setTrangThai(rs.getInt("trang_thai"));

                    SanPham sp = new SanPham();
                    sp.setMaSP(rs.getString("ma_sp"));
                    // ĐÃ SỬA LỖI BUILD: Gọi đúng hàm setTenSanPham
                    sp.setTenSanPham(rs.getString("ten_san_pham"));
                    bt.setSanPham(sp);
                    return bt;
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }
}