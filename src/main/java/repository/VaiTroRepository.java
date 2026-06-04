package repository;

import model.VaiTro;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class VaiTroRepository {

    public List<VaiTro> findAll() {
        List<VaiTro> list = new ArrayList<>();
        String sql = "SELECT * FROM VAI_TRO";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                VaiTro obj = new VaiTro();
                obj.setMaVaiTro(rs.getInt("ma_vai_tro"));
                obj.setTenVaiTro(rs.getString("ten_vai_tro"));
                obj.setMoTa(rs.getString("mo_ta"));
                list.add(obj);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public VaiTro findById(int id) {
        String sql = "SELECT * FROM VAI_TRO WHERE ma_vai_tro = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    VaiTro obj = new VaiTro();
                    obj.setMaVaiTro(rs.getInt("ma_vai_tro"));
                    obj.setTenVaiTro(rs.getString("ten_vai_tro"));
                    obj.setMoTa(rs.getString("mo_ta"));
                    return obj;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean insert(VaiTro obj) {
        String sql = "INSERT INTO VAI_TRO (ten_vai_tro, mo_ta) VALUES (?, ?)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, obj.getTenVaiTro());
            ps.setString(2, obj.getMoTa());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean update(VaiTro obj) {
        String sql = "UPDATE VAI_TRO SET ten_vai_tro = ?, mo_ta = ? WHERE ma_vai_tro = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, obj.getTenVaiTro());
            ps.setString(2, obj.getMoTa());
            ps.setInt(3, obj.getMaVaiTro());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM VAI_TRO WHERE ma_vai_tro = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}