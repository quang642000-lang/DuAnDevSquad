package service;

import model.NhanVien;
import repository.AuthRepository;
import Util.SecurityUtil;

public class AuthService {
    private AuthRepository authRepo = new AuthRepository();

    // Xử lý Đăng nhập
    public NhanVien login(String tenDangNhap, String matKhauPlain) {
        if (tenDangNhap == null || matKhauPlain == null) return null;

        // Băm mật khẩu người dùng nhập vào
        String hashedMatKhau = SecurityUtil.hashPassword(matKhauPlain);

        // Truyền cả 2 loại pass xuống DB để kiểm tra
        return authRepo.login(tenDangNhap, matKhauPlain, hashedMatKhau);
    }

    // Xác minh SĐT để khôi phục mật khẩu
    public boolean verifyPhone(String tenDangNhap, String sdt) {
        if (tenDangNhap == null || sdt == null) return false;
        return authRepo.verifyUserAndPhone(tenDangNhap, sdt);
    }

    // Xử lý đặt lại mật khẩu mới
    public boolean resetPassword(String tenDangNhap, String matKhauMoi) {
        if (tenDangNhap == null || matKhauMoi == null || matKhauMoi.trim().isEmpty()) return false;

        // Băm mật khẩu mới trước khi lưu
        String hashedMatKhauMoi = SecurityUtil.hashPassword(matKhauMoi);
        return authRepo.updatePassword(tenDangNhap, hashedMatKhauMoi);
    }
}