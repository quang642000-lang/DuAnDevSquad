package service;

import model.KhachHang;
import repository.KhachHangRepository;
import java.util.List;

public class KhachHangService {
    private KhachHangRepository khachHangRepo = new KhachHangRepository();
    private final int LIMIT = 5;

    public List<KhachHang> getAll() {
        return khachHangRepo.getAll();
    }

    public List<KhachHang> getAllByPage(int page) {
        int offset = (page - 1) * LIMIT;
        return khachHangRepo.getAll(offset, LIMIT);
    }

    public int getTotalPages() {
        int totalRecords = khachHangRepo.getTotalCount();
        return (int) Math.ceil((double) totalRecords / LIMIT);
    }

    public KhachHang timKiemTheoSdt(String sdt) {
        if (sdt == null || sdt.trim().isEmpty()) return null;
        return khachHangRepo.timKiemTheoSdt(sdt.trim());
    }

    public String add(KhachHang kh) {
        if (kh.getTenKH() == null || kh.getTenKH().trim().isEmpty()) {
            return "Tên khách hàng không được để trống!";
        }
        if (kh.getSDT() == null || !kh.getSDT().matches("\\d{10}")) {
            return "Số điện thoại không hợp lệ (phải đủ 10 chữ số)!";
        }
        kh.setDiemTichLuy(0);
        return khachHangRepo.add(kh) ? "Thêm khách hàng thành công!" : "Lỗi hệ thống!";
    }

    public String update(KhachHang kh) {
        if (kh.getTenKH() == null || kh.getTenKH().trim().isEmpty()) {
            return "Tên khách hàng không được để trống!";
        }
        if (kh.getSDT() == null || !kh.getSDT().matches("\\d{10}")) {
            return "Số điện thoại không hợp lệ (phải đủ 10 chữ số)!";
        }
        return khachHangRepo.update(kh) ? "Cập nhật thành công!" : "Cập nhật thất bại!";
    }

    public String delete(String maKH) {
        if (maKH == null || maKH.isEmpty()) return "Mã khách hàng không hợp lệ!";
        boolean isDeleted = khachHangRepo.delete(maKH);
        return isDeleted ? "Đã xóa khách hàng thành công!" : "Không thể xóa! Khách hàng này có thể đã phát sinh đơn hàng.";
    }

    public boolean congDiemTichLuy(String maKh, int diemCongThem) {
        if (maKh == null || diemCongThem <= 0) return false;
        return khachHangRepo.congDiemTichLuy(maKh, diemCongThem);
    }
}