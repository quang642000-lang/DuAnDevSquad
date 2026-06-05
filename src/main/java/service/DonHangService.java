package service;

import model.ChiTietDonHang;
import model.ChiTietTopping;
import model.DonHang;
import model.KhachHang;
import model.KhuyenMai;
import model.BienTheSanPham;
import model.Topping;
import repository.DBConnect;
import repository.DonHangRepository;
import repository.KhachHangRepository;
import repository.KhuyenMaiRepository;
import repository.BienTheSanPhamRepository;
import repository.ToppingRepository;

import java.sql.Connection;
import java.sql.PreparedStatement;
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

            // =========================================================
            // 2. KIỂM TRA LẠI KHUYẾN MÃI
            // =========================================================
            int tienGiamVoucher = 0;
            if (dh.getKhuyenMai() != null && dh.getKhuyenMai().getMaKM() != null && !dh.getKhuyenMai().getMaKM().isEmpty()) {
                KhuyenMai km = khuyenMaiRepo.getById(dh.getKhuyenMai().getMaKM());
                if (km != null && tongTienHang >= km.getDieuKienToiThieu()) {
                    if ("Phần Trăm".equalsIgnoreCase(km.getLoaiGiamGia())) {
                        tienGiamVoucher = (tongTienHang * km.getGiaTriGiam()) / 100; // ĐÃ SỬA
                    } else {
                        tienGiamVoucher = km.getGiaTriGiam(); // ĐÃ SỬA
                    }
                    if (tienGiamVoucher > tongTienHang) tienGiamVoucher = tongTienHang;
                } else {
                    dh.setKhuyenMai(null);
                }
            }

            String sdt = (sdtKhachHang != null && !sdtKhachHang.trim().isEmpty()) ? sdtKhachHang.trim() : "0000000000";
            String ten = (tenKhachHang != null && !tenKhachHang.trim().isEmpty()) ? tenKhachHang.trim() : "Khách vãng lai";

            KhachHang kh = khachHangRepo.timKiemTheoSdt(sdt);
            int diemGiamGia = 0;

            if (kh == null) {
                kh = new KhachHang();
                kh.setSDT(sdt);
                kh.setTenKH(ten);
                kh.setDiemTichLuy(0);
                khachHangRepo.add(kh);
                kh = khachHangRepo.timKiemTheoSdt(sdt);
                diemSuDung = 0;
            } else {
                if (diemSuDung > kh.getDiemTichLuy()) diemSuDung = kh.getDiemTichLuy();

                int tienSauVoucher = tongTienHang - tienGiamVoucher;
                int diemToiDaChoPhep = tienSauVoucher / 1000;

                if (diemSuDung > diemToiDaChoPhep) {
                    diemSuDung = diemToiDaChoPhep;
                }
                diemGiamGia = diemSuDung * 1000;
            }
            dh.setKhachHang(kh);

            int tongPhaiTra = tongTienHang - tienGiamVoucher - diemGiamGia;
            if (tongPhaiTra < 0) tongPhaiTra = 0;

            dh.setTienGiamGia(tienGiamVoucher + diemGiamGia);
            dh.setTongTienTra(tongPhaiTra);
            dh.setThoiGianTao(new Date());

            if (dh.getSoTienKhachDua() < dh.getTongTienTra()) return "Lỗi: Số tiền khách đưa không đủ!";
            if (dh.getDanhSachChiTiet() == null || dh.getDanhSachChiTiet().isEmpty()) return "Lỗi: Giỏ hàng trống!";

            boolean success = donHangRepo.taoDonHang(dh);

            if (success) {
                int diemCongThem = tongPhaiTra / 10000;
                if (!sdt.equals("0000000000")) {
                    String sqlDiem = "UPDATE KHACH_HANG SET diem_tich_luy = diem_tich_luy - ? + ? WHERE ma_kh = ?";
                    try (Connection con = DBConnect.getConnection();
                         PreparedStatement ps = con.prepareStatement(sqlDiem)) {
                        ps.setInt(1, diemSuDung);
                        ps.setInt(2, diemCongThem);
                        ps.setString(3, kh.getMaKH());
                        ps.executeUpdate();
                    } catch (Exception ignored) { }
                }
            }

            return success ? "Thanh toán thành công! Đã in hóa đơn." : "Lỗi SQL: Không thể lưu đơn hàng!";

        } catch (Exception e) {
            e.printStackTrace();
            return "Lỗi hệ thống: " + e.getMessage();
        }
    }
}