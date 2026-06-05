package service;

import model.ChiTietDonHang;
import model.ChiTietTopping;
import model.DonHang;
import model.KhachHang;
import model.KhuyenMai;
import model.BienTheSanPham;
import model.Topping;
import repository.DonHangRepository;
import repository.KhachHangRepository;
import repository.KhuyenMaiRepository;
import repository.BienTheSanPhamRepository;
import repository.ToppingRepository;

public class DonHangService {

    private DonHangRepository donHangRepo = new DonHangRepository();
    private KhachHangRepository khachHangRepo = new KhachHangRepository();
    private KhuyenMaiRepository khuyenMaiRepo = new KhuyenMaiRepository();
    private BienTheSanPhamRepository bienTheRepo = new BienTheSanPhamRepository();
    private ToppingRepository toppingRepo = new ToppingRepository();

    public String taoDonHangThanhToan(DonHang dh, String sdtKhachHang, String tenKhachHang) {

        // 1. TÍNH LẠI TOÀN BỘ GIÁ TIỀN TỪ DATABASE (Bảo mật)
        int tongTienHang = 0;

        for (ChiTietDonHang ct : dh.getDanhSachChiTiet()) {
            // Lấy giá chuẩn của ly nước
            BienTheSanPham btDb = bienTheRepo.findById(ct.getBienThe().getMaBienThe());
            if (btDb == null) return "Lỗi: Có món ăn không tồn tại trong hệ thống!";
            int giaLy = btDb.getGiaBan();
            ct.setGiaChot(giaLy);

            // Tính tiền topping
            int tongTienTopping = 0;
            for (ChiTietTopping ctt : ct.getDanhSachTopping()) {
                Topping tpDb = toppingRepo.findById(ctt.getTopping().getMaTopping());
                if (tpDb == null) return "Lỗi: Topping không tồn tại!";
                ctt.setGiaChot(tpDb.getGiaBan()); // Lưu lại giá lịch sử
                tongTienTopping += tpDb.getGiaBan() * ctt.getSoLuongTopping();
            }

            tongTienHang += (giaLy * ct.getSoLuong()) + tongTienTopping;
        }

        dh.setTongTienHang(tongTienHang);

        // 2. TÍNH LẠI KHUYẾN MÃI
        int tienGiamGia = 0;
        if (dh.getKhuyenMai() != null && dh.getKhuyenMai().getMaKM() != null) {
            KhuyenMai km = khuyenMaiRepo.getById(dh.getKhuyenMai().getMaKM());
            if (km != null && tongTienHang >= km.getDieuKienToiThieu()) {
                if ("Phần Trăm".equalsIgnoreCase(km.getLoaiGiamGia())) {
                    tienGiamGia = (tongTienHang * km.getGiaTrịGiam()) / 100;
                } else {
                    tienGiamGia = km.getGiaTrịGiam();
                }
                if (tienGiamGia > tongTienHang) tienGiamGia = tongTienHang;
            } else {
                dh.setKhuyenMai(null); // Hủy áp mã nếu không đạt điều kiện
            }
        }
        dh.setTienGiamGia(tienGiamGia);

        int tongPhaiTra = tongTienHang - tienGiamGia;
        dh.setTongTienTra(tongPhaiTra);

        // 3. Validate
        if (tongPhaiTra < 0) return "Lỗi: Tổng tiền không hợp lệ!";
        if (dh.getSoTienKhachDua() < tongPhaiTra) return "Lỗi: Số tiền khách đưa không đủ!";
        if (dh.getDanhSachChiTiet() == null || dh.getDanhSachChiTiet().isEmpty()) return "Lỗi: Giỏ hàng trống!";

        // 4. Xử lý thông tin Khách Hàng
        if (sdtKhachHang != null && !sdtKhachHang.trim().isEmpty()) {
            KhachHang kh = khachHangRepo.timKiemTheoSdt(sdtKhachHang.trim());
            if (kh == null) {
                kh = new KhachHang();
                kh.setSDT(sdtKhachHang.trim());
                kh.setTenKH((tenKhachHang != null && !tenKhachHang.trim().isEmpty()) ? tenKhachHang.trim() : "Khách vãng lai");
                kh.setDiemTichLuy(0);
                khachHangRepo.add(kh);
                kh = khachHangRepo.timKiemTheoSdt(sdtKhachHang.trim());
            }
            dh.setKhachHang(kh);
        }

        // 5. Tiến hành lưu Database
        boolean success = donHangRepo.taoDonHang(dh);

        if (success && dh.getKhachHang() != null) {
            int diemCongThem = tongPhaiTra / 10000;
            if (diemCongThem > 0) {
                khachHangRepo.congDiemTichLuy(dh.getKhachHang().getMaKH(), diemCongThem);
            }
        }

        return success ? "Thanh toán thành công! Đã lưu Đơn Hàng." : "Lỗi hệ thống khi tạo đơn hàng!";
    }
}