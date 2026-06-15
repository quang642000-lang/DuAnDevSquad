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
import java.sql.SQLException;
import java.util.Date;

public class DonHangService {
    private DonHangRepository donHangRepo = new DonHangRepository();
    private KhachHangRepository khachHangRepo = new KhachHangRepository();
    private KhuyenMaiRepository khuyenMaiRepo = new KhuyenMaiRepository();
    private BienTheSanPhamRepository bienTheRepo = new BienTheSanPhamRepository();
    private ToppingRepository toppingRepo = new ToppingRepository();

    public String taoDonHangThanhToan(DonHang dh, String sdtKhachHang, String tenKhachHang, int diemSuDung) {
        try {
            int tongTienHang = 0;
            for (ChiTietDonHang ct : dh.getDanhSachChiTiet()) {
                BienTheSanPham btDb = bienTheRepo.findById(ct.getBienThe().getMaBienThe());
                if (btDb == null) return "Lỗi: Có món ăn không tồn tại trong hệ thống!";
                int giaLy = btDb.getGiaBan();
                ct.setGiaChot(giaLy);
                int tongTienTopping = 0;
                for (ChiTietTopping ctt : ct.getDanhSachTopping()) {
                    Topping tpDb = toppingRepo.findById(ctt.getTopping().getMaTopping());
                    if (tpDb == null) return "Lỗi: Topping không tồn tại!";
                    ctt.setGiaChot(tpDb.getGiaBan());
                    tongTienTopping += tpDb.getGiaBan() * ctt.getSoLuongTopping();
                }
                tongTienHang += (giaLy * ct.getSoLuong()) + tongTienTopping;
            }
            dh.setTongTienHang(tongTienHang);

            int tienGiamVoucher = 0;
            Date now = new Date(); // Lấy thời gian hiện tại lúc tạo đơn

            if (dh.getKhuyenMai() != null && dh.getKhuyenMai().getMaKM() != null && !dh.getKhuyenMai().getMaKM().isEmpty()) {
                KhuyenMai km = khuyenMaiRepo.getById(dh.getKhuyenMai().getMaKM());

                if (km != null) {
                    // KIỂM TRA ĐIỀU KIỆN 1: Ngày tháng hiệu lực của Voucher
                    if (km.getNgayBatDau() != null && now.before(km.getNgayBatDau())) {
                        return "Lỗi: Mã giảm giá này chưa đến ngày bắt đầu sử dụng!";
                    }
                    if (km.getNgayKetThuc() != null && now.getTime() > (km.getNgayKetThuc().getTime() + 86399000)) {
                        return "Lỗi: Mã giảm giá này đã hết hạn sử dụng!";
                    }

                    // Bỏ qua kiểm tra số lượng ở Service vì Repository đã chặn bằng Transaction Lock rất chặt chẽ.

                    // KIỂM TRA ĐIỀU KIỆN 2: Đơn tối thiểu
                    if (tongTienHang >= km.getDieuKienToiThieu()) {
                        if ("Phần Trăm".equalsIgnoreCase(km.getLoaiGiamGia())) {
                            tienGiamVoucher = (tongTienHang * km.getGiaTriGiam()) / 100;
                        } else {
                            tienGiamVoucher = km.getGiaTriGiam();
                        }
                        if (tienGiamVoucher > tongTienHang) tienGiamVoucher = tongTienHang;
                    } else {
                        return "Lỗi: Đơn hàng chưa đạt mức tối thiểu " + km.getDieuKienToiThieu() + "đ để dùng mã này!";
                    }
                } else {
                    dh.setKhuyenMai(null);
                }
            }

            // Xử lý Khách Hàng (Tránh gán cứng 0000000000, hỗ trợ NULL ở Database)
            KhachHang kh = null;
            int diemGiamGia = 0;
            int diemCongThem = 0;

            if (sdtKhachHang != null && !sdtKhachHang.trim().isEmpty()) {
                kh = khachHangRepo.timKiemTheoSdt(sdtKhachHang.trim());
                if (kh == null) {
                    kh = new KhachHang();
                    kh.setSDT(sdtKhachHang.trim());
                    kh.setTenKH(tenKhachHang != null && !tenKhachHang.isEmpty() ? tenKhachHang.trim() : "Khách hàng mới");
                    kh.setDiemTichLuy(0);
                    khachHangRepo.add(kh);
                    kh = khachHangRepo.timKiemTheoSdt(sdtKhachHang.trim());

                    if (kh == null) {
                        return "Lỗi: Không thể tự động tạo thẻ khách hàng mới do lỗi CSDL. Vui lòng thử lại!";
                    }
                }
                if (diemSuDung > kh.getDiemTichLuy()) diemSuDung = kh.getDiemTichLuy();
                int tienSauVoucher = tongTienHang - tienGiamVoucher;
                int diemToiDa = tienSauVoucher / 1000;
                if (diemSuDung > diemToiDa) diemSuDung = diemToiDa;
                diemGiamGia = diemSuDung * 1000;
            } else {
                diemSuDung = 0; // Khách vãng lai không dùng điểm
            }
            dh.setKhachHang(kh);

            int tongPhaiTra = Math.max(tongTienHang - tienGiamVoucher - diemGiamGia, 0);
            dh.setTienGiamGia(tienGiamVoucher + diemGiamGia);
            dh.setTongTienTra(tongPhaiTra);
            dh.setThoiGianTao(now); // Đã lấy ở trên

            if (dh.getSoTienKhachDua() < dh.getTongTienTra()) return "Lỗi: Số tiền khách đưa không đủ!";
            if (dh.getDanhSachChiTiet() == null || dh.getDanhSachChiTiet().isEmpty()) return "Lỗi: Giỏ hàng trống!";

            diemCongThem = tongPhaiTra / 10000;

            // Đẩy tất cả thông số xuống Transaction ở Repository
            donHangRepo.taoDonHang(dh, diemSuDung, diemCongThem);
            return "Thanh toán thành công! Đã in hóa đơn.";

        } catch (SQLException e) {
            e.printStackTrace();
            return "Lỗi giao dịch: " + e.getMessage();
        } catch (Exception e) {
            e.printStackTrace();
            return "Lỗi hệ thống: " + e.getMessage();
        }
    }
}