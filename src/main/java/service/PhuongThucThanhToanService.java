package service;

import model.PhuongThucThanhToan;
import repository.PhuongThucThanhToanRepository;
import java.util.List;

public class PhuongThucThanhToanService {

    private PhuongThucThanhToanRepository repo = new PhuongThucThanhToanRepository();
    private final int LIMIT = 5;

    public List<PhuongThucThanhToan> getAll() {
        return repo.getAll();
    }

    public List<PhuongThucThanhToan> getAllByPage(int page) {
        int offset = (page - 1) * LIMIT;
        return repo.getAll(offset, LIMIT);
    }

    public int getTotalPages() {
        int totalRecords = repo.getTotalCount();
        return (int) Math.ceil((double) totalRecords / LIMIT);
    }

    public String add(PhuongThucThanhToan pt) {
        if (pt.getTenPhuongThuc() == null || pt.getTenPhuongThuc().trim().isEmpty()) {
            return "Lỗi: Tên phương thức không được để trống!";
        }

        pt.setTrangThai(1);
        return repo.add(pt) ? "Thêm phương thức thanh toán thành công!" : "Lỗi hệ thống khi thêm!";
    }

    public String update(PhuongThucThanhToan pt) {
        if (pt.getMaPTTT() == null || pt.getMaPTTT().trim().isEmpty()) return "Lỗi: Mã không hợp lệ!";
        if (pt.getTenPhuongThuc() == null || pt.getTenPhuongThuc().trim().isEmpty()) return "Lỗi: Tên không được trống!";

        return repo.update(pt) ? "Cập nhật thành công!" : "Lỗi hệ thống khi cập nhật!";
    }

    public String updateTrangThai(String maPTTT, int trangThai) {
        if (maPTTT == null || maPTTT.trim().isEmpty()) return "Lỗi: Mã không hợp lệ!";
        return repo.updateTrangThai(maPTTT, trangThai) ? "Cập nhật trạng thái thành công!" : "Lỗi hệ thống!";
    }

    public String delete(String maPTTT) {
        if (maPTTT == null || maPTTT.trim().isEmpty()) return "Lỗi: Mã không hợp lệ!";
        return repo.delete(maPTTT) ? "Đã xóa phương thức thanh toán!" : "Không thể xóa do đã phát sinh giao dịch thanh toán!";
    }

    public List<PhuongThucThanhToan> search(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) return repo.getAll();
        return repo.search(keyword);
    }
}
