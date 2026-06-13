package service;

import model.KhuyenMai;
import repository.KhuyenMaiRepository;
import java.util.List;

public class KhuyenMaiService {
    private KhuyenMaiRepository repo = new KhuyenMaiRepository();

    public List<KhuyenMai> getAll() {
        return repo.getAll();
    }

    public KhuyenMai getById(String maKM) {
        return repo.getById(maKM);
    }

    public String add(KhuyenMai km) {
        // Sửa Lỗi Bảo mật: Chặn nhập mức giảm phần trăm vượt quá 100%
        if ("Phần Trăm".equals(km.getLoaiGiamGia()) && km.getGiaTriGiam() > 100) {
            return "Lỗi: Mức giảm phần trăm không được vượt quá 100%!";
        }

        if (repo.add(km)) {
            return "Thêm chương trình khuyến mãi thành công!";
        }
        return "Thêm thất bại!";
    }

    public String update(KhuyenMai km) {
        // Sửa Lỗi Bảo mật: Chặn nhập mức giảm phần trăm vượt quá 100%
        if ("Phần Trăm".equals(km.getLoaiGiamGia()) && km.getGiaTriGiam() > 100) {
            return "Lỗi: Mức giảm phần trăm không được vượt quá 100%!";
        }

        // --- KIỂM TRA BẢO MẬT BACKEND CHỐNG GIAN LẬN F12 ---
        KhuyenMai kmCu = repo.getById(km.getMaKM());
        if (kmCu != null && km.getSoLuong() < kmCu.getSoLuongDaDung()) {
            return "Lỗi: Số lượng tổng không được nhỏ hơn số lượng mã đã phát hành (" + kmCu.getSoLuongDaDung() + ")!";
        }
        // ---------------------------------------------------

        if (repo.update(km)) {
            return "Cập nhật chương trình khuyến mãi thành công!";
        }
        return "Cập nhật thất bại!";
    }

    public String delete(String maKM) {
        if (repo.delete(maKM)) {
            return "Xóa chương trình khuyến mãi thành công!";
        }
        return "Xóa thất bại!";
    }

    public List<KhuyenMai> search(String keyword) {
        return repo.search(keyword);
    }

    public String updateTrangThai(String maKM, int trangThai) {
        if (repo.updateTrangThai(maKM, trangThai)) {
            return "Cập nhật trạng thái thành công!";
        }
        return "Lỗi: Không thể cập nhật trạng thái!";
    }
}