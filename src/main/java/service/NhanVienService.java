package service;

import model.NhanVien;
import repository.NhanVienRepository;
import java.util.List;

public class NhanVienService {
    private NhanVienRepository nhanVienRepo = new NhanVienRepository();

    public NhanVien login(String tenDangNhap, String matKhau) {
        if (tenDangNhap == null || matKhau == null) return null;
        return nhanVienRepo.login(tenDangNhap, matKhau);
    }

    public List<NhanVien> getAll() { return nhanVienRepo.getAll(); }

    public String add(NhanVien nv) {
        if (nv.getTenDangNhap() == null || nv.getMatKhau() == null || nv.getHoTen() == null) {
            return "Lỗi: Dữ liệu không được để trống!";
        }

        nv.setTrangThai(1); // Mặc định Hoạt động khi mới tạo
        return nhanVienRepo.add(nv) ? "Thêm nhân viên thành công!" : "Lỗi hệ thống khi thêm!";
    }

    public String update(NhanVien nv) {
        if (nv.getMaNV() == null || nv.getMaNV().isEmpty()) return "Lỗi: Mã nhân viên không hợp lệ!";
        return nhanVienRepo.update(nv) ? "Cập nhật thành công!" : "Lỗi hệ thống khi cập nhật!";
    }

    public String updateTrangThai(String maNv, int trangThaiMoi) {
        return nhanVienRepo.updateTrangThai(maNv, trangThaiMoi) ? "Cập nhật trạng thái thành công!" : "Lỗi!";
    }
}