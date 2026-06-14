package service;

import model.NhanVien;
import repository.NhanVienRepository;
import Util.SecurityUtil;
import java.util.List;

public class NhanVienService {
    private NhanVienRepository nhanVienRepo = new NhanVienRepository();
    private final int LIMIT = 5;

    public NhanVien login(String tenDangNhap, String matKhau) {
        if (tenDangNhap == null || matKhau == null) return null;
        return nhanVienRepo.login(tenDangNhap, matKhau);
    }

    public List<NhanVien> getAll() {
        return nhanVienRepo.getAll();
    }

    public List<NhanVien> getAllByPage(int page) {
        int offset = (page - 1) * LIMIT;
        return nhanVienRepo.getAll(offset, LIMIT);
    }

    public int getTotalPages() {
        int totalRecords = nhanVienRepo.getTotalCount();
        return (int) Math.ceil((double) totalRecords / LIMIT);
    }

    public String add(NhanVien nv) {
        if (nv.getTenDangNhap() == null || nv.getMatKhau() == null || nv.getHoTen() == null || nv.getEmail() == null) {
            return "Lỗi: Dữ liệu không được để trống!";
        }

        String hashedMatKhau = SecurityUtil.hashPassword(nv.getMatKhau());
        nv.setMatKhau(hashedMatKhau);
        nv.setTrangThai(1);
        return nhanVienRepo.add(nv) ? "Thêm nhân viên thành công!" : "Lỗi hệ thống khi thêm!";
    }

    public String update(NhanVien nv) {
        if (nv.getMaNV() == null || nv.getMaNV().isEmpty()) return "Lỗi: Mã nhân viên không hợp lệ!";
        return nhanVienRepo.update(nv) ? "Cập nhật thành công!" : "Lỗi hệ thống khi cập nhật!";
    }

    public String updateTrangThai(String maNV, int trangThaiMoi) {
        return nhanVienRepo.updateTrangThai(maNV, trangThaiMoi) ? "Cập nhật trạng thái thành công!" : "Lỗi!";
    }

    public String delete(String maNV) {
        if (maNV == null || maNV.isEmpty()) return "Lỗi: Mã nhân viên không hợp lệ!";
        boolean isDeleted = nhanVienRepo.delete(maNV);
        return isDeleted ? "Đã xóa nhân viên thành công!" : "Lỗi: Không thể xóa vì nhân viên này đã từng lập hóa đơn bán hàng!";
    }

    public String resetPassword(String maNV, String matKhauMoi) {
        if (maNV == null || maNV.isEmpty()) return "Lỗi: Mã nhân viên không hợp lệ!";
        if (matKhauMoi == null || matKhauMoi.trim().isEmpty()) return "Lỗi: Mật khẩu mới không được để trống!";

        String hashedMatKhauMoi = SecurityUtil.hashPassword(matKhauMoi);
        return nhanVienRepo.resetPassword(maNV, hashedMatKhauMoi) ? "Khôi phục mật khẩu thành công!" : "Lỗi khi đổi mật khẩu!";
    }
}