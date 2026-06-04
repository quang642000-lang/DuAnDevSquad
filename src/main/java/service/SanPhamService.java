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

    public List<SanPham> getSanPhamByDanhMuc(String maDanhMuc) {
        if (maDanhMuc == null || maDanhMuc.trim().isEmpty()) return null;
        return sanPhamRepo.getSanPhamByDanhMuc(maDanhMuc);
    }

    public String add(SanPham sp) {
        if (sp.getTenSP() == null || sp.getTenSP().trim().isEmpty()) {
            return "Tên sản phẩm không được để trống!";
        }
        if (sp.getDanhMuc() == null || sp.getDanhMuc().getMaDanhMuc() == null || sp.getDanhMuc().getMaDanhMuc().isEmpty()) {
            return "Vui lòng chọn danh mục cho sản phẩm!";
        }

        sp.setTrangThai(1);

        return sanPhamRepo.add(sp) ? "Thêm sản phẩm thành công!" : "Lỗi khi thêm sản phẩm!";
    }

    public String update(SanPham sp) {
        if (sp.getMaSP() == null || sp.getMaSP().isEmpty()) {
            return "Mã sản phẩm không hợp lệ!";
        }
        if (sp.getTenSP() == null || sp.getTenSP().trim().isEmpty()) {
            return "Tên sản phẩm không được để trống!";
        }
        if (sp.getDanhMuc() == null || sp.getDanhMuc().getMaDanhMuc() == null || sp.getDanhMuc().getMaDanhMuc().isEmpty()) {
            return "Vui lòng chọn danh mục!";
        }
        return sanPhamRepo.update(sp) ? "Cập nhật sản phẩm thành công!" : "Lỗi khi cập nhật!";
    }

// Nhớ import thêm BienTheSanPhamRepository ở đầu file nếu chưa có nhé:
    // import repository.BienTheSanPhamRepository;



    public String updateTrangThai(String maSp, int trangThai) {
        if (maSp == null || maSp.isEmpty()) return "Mã sản phẩm không hợp lệ!";

        // 1. Cập nhật trạng thái của Sản phẩm mẹ
        boolean success = sanPhamRepo.updateTrangThai(maSp, trangThai);

        if (success) {
            // 2. Cập nhật dây chuyền: Đổi luôn trạng thái của tất cả Biến thể con (Kích cỡ)
            bienTheRepo.updateTrangThaiBySanPham(maSp, trangThai);
            return "Cập nhật trạng thái thành công!";
        }

        return "Lỗi khi cập nhật trạng thái!";
    }

    public String delete(String maSp) {
        if (maSp == null || maSp.isEmpty()) return "Mã không hợp lệ!";
        boolean success = sanPhamRepo.delete(maSp);
        return success ? "Đã xóa sản phẩm thành công!" : "Không thể xóa! Sản phẩm này đã tồn tại trong hóa đơn.";
    }

    // --- THÊM HÀM GỌI TÌM KIẾM ---
    public List<SanPham> search(String keyword, String maDanhMuc) {
        return sanPhamRepo.search(keyword, maDanhMuc);
    }
}