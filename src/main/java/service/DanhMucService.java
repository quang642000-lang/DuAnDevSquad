package service;

import model.DanhMuc;
import repository.DanhMucRepository;
import java.util.List;

public class DanhMucService {

    private DanhMucRepository danhMucRepo = new DanhMucRepository();
    private final int LIMIT = 5;

    public List<DanhMuc> getAll() {
        return danhMucRepo.getAll();
    }

    public List<DanhMuc> getAllByPage(int page) {
        int offset = (page - 1) * LIMIT;
        return danhMucRepo.getAll(offset, LIMIT);
    }

    public int getTotalPages() {
        int totalRecords = danhMucRepo.getTotalCount();
        return (int) Math.ceil((double) totalRecords / LIMIT);
    }

    public String add(DanhMuc dm) {
        if (dm.getTenDanhMuc() == null || dm.getTenDanhMuc().trim().isEmpty()) {
            return "Tên danh mục không được để trống!";
        }
        boolean success = danhMucRepo.add(dm);
        return success ? "Thêm danh mục thành công!" : "Thêm thất bại. Vui lòng thử lại!";
    }

    public String update(DanhMuc dm) {
        if (dm.getTenDanhMuc() == null || dm.getTenDanhMuc().trim().isEmpty()) {
            return "Tên danh mục không được để trống!";
        }
        if (dm.getMaDanhMuc() == null || dm.getMaDanhMuc().trim().isEmpty()) {
            return "Mã danh mục không hợp lệ!";
        }

        boolean success = danhMucRepo.update(dm);
        return success ? "Cập nhật danh mục thành công!" : "Cập nhật thất bại!";
    }

    public String delete(String maDanhMuc) {
        if (maDanhMuc == null || maDanhMuc.trim().isEmpty()) {
            return "Mã danh mục không hợp lệ!";
        }
        boolean success = danhMucRepo.delete(maDanhMuc);
        return success ? "Đã xóa danh mục thành công!" : "Không thể xóa! Danh mục này đang chứa sản phẩm.";
    }
}
