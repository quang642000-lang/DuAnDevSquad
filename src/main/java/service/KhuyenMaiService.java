package service;

import model.KhuyenMai;
import repository.KhuyenMaiRepository;
import java.time.LocalDate;
import java.util.List;

public class KhuyenMaiService {

    private KhuyenMaiRepository khuyenMaiRepo = new KhuyenMaiRepository();

    public List<KhuyenMai> getAll() {
        return khuyenMaiRepo.getAll();
    }

    public String add(KhuyenMai km) {
        if (km.getTenKM() == null || km.getTenKM().trim().isEmpty()) return "Lỗi: Tên CTKM không được để trống!";
        if (km.getSoLuong() < 1) return "Lỗi: Số lượng phát hành phải lớn hơn 0!";
        if (km.getNgayBatDau().after(km.getNgayKetThuc())) return "Lỗi: Ngày kết thúc không được nhỏ hơn ngày bắt đầu!";

        km.setTrangThai(1);
        return khuyenMaiRepo.add(km) ? "Thêm khuyến mãi thành công!" : "Lỗi khi thêm khuyến mãi!";
    }

    public String update(KhuyenMai km) {
        if (km.getMaKM() == null || km.getMaKM().trim().isEmpty()) return "Mã KM không hợp lệ!";
        if (km.getTenKM() == null || km.getTenKM().trim().isEmpty()) return "Tên CTKM không được trống!";
        if (km.getSoLuong() < 0) return "Lỗi: Số lượng không hợp lệ!";
        if (km.getNgayBatDau().after(km.getNgayKetThuc())) return "Lỗi: Ngày kết thúc không hợp lệ!";

        KhuyenMai oldKm = khuyenMaiRepo.getById(km.getMaKM());
        if (oldKm == null) return "Lỗi: Không tìm thấy chương trình khuyến mãi!";
        int daDung = oldKm.getSoLuongDaDung();

        if (km.getSoLuong() < daDung) {
            return "Lỗi: Đã có " + daDung + " khách sử dụng mã này. Bạn chỉ có thể sửa Tổng Số Lượng >= " + daDung + "!";
        }

        if (daDung > 0) {
            km.setLoaiGiamGia(oldKm.getLoaiGiamGia());
            km.setGiaTriGiam(oldKm.getGiaTriGiam()); // ĐÃ SỬA
            km.setDieuKienToiThieu(oldKm.getDieuKienToiThieu());
        }

        LocalDate today = LocalDate.now();
        java.sql.Date sqlToday = java.sql.Date.valueOf(today);

        if (km.getNgayKetThuc().getTime() != oldKm.getNgayKetThuc().getTime() && km.getNgayKetThuc().before(sqlToday)) {
            return "Lỗi: Không thể sửa ngày kết thúc về một ngày trong quá khứ!";
        }

        return khuyenMaiRepo.update(km) ? "Cập nhật thành công!" : "Lỗi khi cập nhật!";
    }

    public String updateTrangThai(String maKM, int trangThai) {
        if (maKM == null || maKM.isEmpty()) return "Mã không hợp lệ!";
        return khuyenMaiRepo.updateTrangThai(maKM, trangThai) ? "Cập nhật trạng thái thành công!" : "Lỗi hệ thống!";
    }

    public String delete(String maKM) {
        if (maKM == null || maKM.isEmpty()) return "Mã không hợp lệ!";
        return khuyenMaiRepo.delete(maKM) ? "Đã xóa vĩnh viễn chương trình khuyến mãi!" : "Không thể xóa do mã này đã được sử dụng trong Hóa đơn!";
    }

    public List<KhuyenMai> search(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) return khuyenMaiRepo.getAll();
        return khuyenMaiRepo.search(keyword);
    }
}