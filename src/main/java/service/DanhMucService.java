package service;

import model.DanhMuc;
import repository.DanhMucRepository;
import java.util.List;

public class DanhMucService {

    private DanhMucRepository danhMucRepo = new DanhMucRepository();

    public List<DanhMuc> getAll() {
        return danhMucRepo.getAll();
    }

    public String add(DanhMuc dm) {
        if (dm.getTenDanhMuc() == null || dm.getTenDanhMuc().trim().isEmpty()) {
            return "Tên danh mục không được để trống!";
        }

        // Đã xóa gọi hàm tự sinh mã trong java, nhường việc cho SQL Server
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