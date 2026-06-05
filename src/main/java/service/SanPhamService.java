package service;

import model.SanPham;
import repository.SanPhamRepository;
import java.util.List;

public class SanPhamService {
    private SanPhamRepository sanPhamRepo = new SanPhamRepository();
    private repository.BienTheSanPhamRepository bienTheRepo = new repository.BienTheSanPhamRepository();

    public List<SanPham> getAll() {
        return sanPhamRepo.getAll();
    }

    public String add(SanPham sp) {
        if (sp.getTenSanPham() == null || sp.getTenSanPham().trim().isEmpty()) { // ĐÃ CHUẨN HÓA
            return "Tên sản phẩm không được để trống!";
        }
        if (sp.getDanhMuc() == null || sp.getDanhMuc().getMaDanhMuc() == null || sp.getDanhMuc().getMaDanhMuc().isEmpty()) {
            return "Vui lòng chọn danh mục cho sản phẩm!";
        }

        sp.setTrangThai(1);

        return sanPhamRepo.add(sp) ? "Thêm sản phẩm thành công!" : "Lỗi khi thêm sản phẩm!";
    }

    public String update(SanPham sp) {
        if (sp.getMaSP() == null || sp.getMaSP().isEmpty()) return "Mã sản phẩm không hợp lệ!"; // ĐÃ CHUẨN HÓA
        if (sp.getTenSanPham() == null || sp.getTenSanPham().trim().isEmpty()) return "Tên sản phẩm không được trống!"; // ĐÃ CHUẨN HÓA
        return sanPhamRepo.update(sp) ? "Cập nhật sản phẩm thành công!" : "Lỗi khi cập nhật!";
    }

    public String updateTrangThai(String maSP, int trangThai) { // ĐÃ CHUẨN HÓA
        if (maSP == null || maSP.isEmpty()) return "Mã sản phẩm không hợp lệ!";

        boolean success = sanPhamRepo.updateTrangThai(maSP, trangThai);
        if (success) {
            bienTheRepo.updateTrangThaiBySanPham(maSP, trangThai);
            return "Cập nhật trạng thái thành công!";
        }
        return "Lỗi khi cập nhật trạng thái!";
    }

    public String delete(String maSP) { // ĐÃ CHUẨN HÓA
        if (maSP == null || maSP.isEmpty()) return "Mã không hợp lệ!";
        return sanPhamRepo.delete(maSP) ? "Đã xóa sản phẩm thành công!" : "Lỗi: Sản phẩm đang tồn tại trong hóa đơn!";
    }

    public List<SanPham> search(String keyword, String maDanhMuc) {
        return sanPhamRepo.search(keyword, maDanhMuc);
    }
}