package service;

import model.Topping;
import repository.ToppingRepository;
import java.util.List;

public class ToppingService {

    private ToppingRepository toppingRepo = new ToppingRepository();

    public List<Topping> getAll() {
        return toppingRepo.getAll();
    }

    public String add(Topping tp) {
        if (tp.getTenTopping() == null || tp.getTenTopping().trim().isEmpty()) {
            return "Lỗi: Tên Topping không được để trống!";
        }
        if (tp.getGiaBan() < 0) {
            return "Lỗi: Giá bán không được là số âm!";
        }

        tp.setTrangThai(1); // Mặc định Đang bán khi thêm mới

        // Không cần tự sinh mã ở đây nữa, DB sẽ lo việc đó
        boolean success = toppingRepo.add(tp);
        return success ? "Thêm Topping thành công!" : "Thêm thất bại. Vui lòng kiểm tra lại!";
    }

    public String update(Topping tp) {
        if (tp.getMaTopping() == null || tp.getMaTopping().trim().isEmpty()) {
            return "Lỗi: Mã Topping không hợp lệ!";
        }
        if (tp.getTenTopping() == null || tp.getTenTopping().trim().isEmpty()) {
            return "Lỗi: Tên Topping không được để trống!";
        }

        boolean success = toppingRepo.update(tp);
        return success ? "Cập nhật thành công!" : "Cập nhật thất bại!";
    }

    public String updateTrangThai(String maTopping, int trangThai) {
        if (maTopping == null || maTopping.isEmpty()) return "Mã không hợp lệ!";
        return toppingRepo.updateTrangThai(maTopping, trangThai) ? "Cập nhật trạng thái thành công!" : "Lỗi!";
    }

    public String delete(String maTopping) {
        if (maTopping == null || maTopping.isEmpty()) return "Mã không hợp lệ!";
        boolean success = toppingRepo.delete(maTopping);
        return success ? "Xóa vĩnh viễn Topping thành công!" : "Lỗi: Không thể xóa vì Topping này đã từng được đặt hàng!";
    }

    public List<Topping> search(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return toppingRepo.getAll();
        }
        return toppingRepo.search(keyword);
    }
}