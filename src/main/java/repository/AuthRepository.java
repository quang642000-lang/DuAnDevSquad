package repository;

import model.NhanVien;
import model.VaiTro;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AuthRepository {

    // Đăng nhập thông minh: Nhận diện cả pass cũ (chưa mã hóa) và pass mới (đã mã hóa)
    public NhanVien login(String tenDangNhap, String matKhauPlain, String hashedMatKhau) {
        String sql = "SELECT nv.*, vt.ten_vai_tro FROM NHAN_VIEN nv " +
                "LEFT JOIN VAI_TRO vt ON nv.ma_vai_tro = vt.ma_vai_tro " +
                "WHERE nv.ten_dang_nhap = ? AND nv.trang_thai = 1";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, tenDangNhap);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String dbPassword = rs.getString("mat_khau");
                    boolean isValid = false;

                    // 1. Kiểm tra nếu DB đang lưu pass đã mã hóa
                    if (dbPassword.equals(hashedMatKhau)) {
                        isValid = true;
                    }
                    // 2. Kiểm tra nếu DB vẫn đang lưu pass dạng chữ thường (VD: '123456')
                    else if (dbPassword.equals(matKhauPlain)) {
                        isValid = true;
                        // Tự động chuyển đổi sang mã hóa trong CSDL để bảo mật cho các lần sau
                        updatePassword(tenDangNhap, hashedMatKhau);
                    }

                    if (isValid) {
                        NhanVien nv = new NhanVien();
                        nv.setMaNV(rs.getString("ma_nv"));
                        nv.setTenDangNhap(rs.getString("ten_dang_nhap"));
                        nv.setMatKhau(rs.getString("mat_khau"));
                        nv.setHoTen(rs.getString("ho_ten"));
                        nv.setSDT(rs.getString("so_dien_thoai"));
                        nv.setEmail(rs.getString("email")); // THÊM EMAIL
                        nv.setTrangThai(rs.getInt("trang_thai"));

                        VaiTro vt = new VaiTro();
                        vt.setMaVaiTro(rs.getInt("ma_vai_tro"));
                        vt.setTenVaiTro(rs.getString("ten_vai_tro"));
                        nv.setVaiTro(vt);

                        return nv;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ĐÃ THAY ĐỔI: Tìm Tên đăng nhập dựa trên Email
    public String findUsernameByEmail(String email) {
        String sql = "SELECT ten_dang_nhap FROM NHAN_VIEN WHERE email = ? AND trang_thai = 1";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("ten_dang_nhap");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lưu mật khẩu mới vào DB
    public boolean updatePassword(String tenDangNhap, String hashedMatKhauMoi) {
        String sql = "UPDATE NHAN_VIEN SET mat_khau = ? WHERE ten_dang_nhap = ?";
        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, hashedMatKhauMoi);
            ps.setString(2, tenDangNhap);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}