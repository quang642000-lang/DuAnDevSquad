package model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class DonHang {
    private String maDH;
    private Date thoiGianTao;
    private Date thoiGianThanhToan;
    private int tongTienHang;
    private int tienGiamGia;
    private int tongTienTra;
    private int soTienKhachDua;
    private String trangThai; // "Đang xử lý", "Hoàn thành", "Đã hủy"

    // --- CÁC MỐI QUAN HỆ (KHÓA NGOẠI TỪ BẢNG KHÁC) ---
    private NhanVien nhanVien;
    private KhachHang khachHang; // Có thể là khách vãng lai
    private KhuyenMai khuyenMai; // Có thể null nếu không dùng mã
    private PhuongThucThanhToan phuongThucThanhToan;

    // --- DANH SÁCH CON: MỘT ĐƠN HÀNG CÓ NHIỀU CHI TIẾT ---
    private List<ChiTietDonHang> danhSachChiTiet = new ArrayList<>();

    public DonHang() {
    }

    public DonHang(String maDH, Date thoiGianTao, Date thoiGianThanhToan, int tongTienHang, int tienGiamGia, int tongTienTra, int soTienKhachDua, String trangThai, NhanVien nhanVien, KhachHang khachHang, KhuyenMai khuyenMai, PhuongThucThanhToan phuongThucThanhToan) {
        this.maDH = maDH;
        this.thoiGianTao = thoiGianTao;
        this.thoiGianThanhToan = thoiGianThanhToan;
        this.tongTienHang = tongTienHang;
        this.tienGiamGia = tienGiamGia;
        this.tongTienTra = tongTienTra;
        this.soTienKhachDua = soTienKhachDua;
        this.trangThai = trangThai;
        this.nhanVien = nhanVien;
        this.khachHang = khachHang;
        this.khuyenMai = khuyenMai;
        this.phuongThucThanhToan = phuongThucThanhToan;
    }

    // Getters and Setters
    public String getMaDH() { return maDH; }
    public void setMaDH(String maDH) { this.maDH = maDH; }

    public Date getThoiGianTao() { return thoiGianTao; }
    public void setThoiGianTao(Date thoiGianTao) { this.thoiGianTao = thoiGianTao; }

    public Date getThoiGianThanhToan() { return thoiGianThanhToan; }
    public void setThoiGianThanhToan(Date thoiGianThanhToan) { this.thoiGianThanhToan = thoiGianThanhToan; }

    public int getTongTienHang() { return tongTienHang; }
    public void setTongTienHang(int tongTienHang) { this.tongTienHang = tongTienHang; }

    public int getTienGiamGia() { return tienGiamGia; }
    public void setTienGiamGia(int tienGiamGia) { this.tienGiamGia = tienGiamGia; }

    public int getTongTienTra() { return tongTienTra; }
    public void setTongTienTra(int tongTienTra) { this.tongTienTra = tongTienTra; }

    public int getSoTienKhachDua() { return soTienKhachDua; }
    public void setSoTienKhachDua(int soTienKhachDua) { this.soTienKhachDua = soTienKhachDua; }

    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }

    public NhanVien getNhanVien() { return nhanVien; }
    public void setNhanVien(NhanVien nhanVien) { this.nhanVien = nhanVien; }

    public KhachHang getKhachHang() { return khachHang; }
    public void setKhachHang(KhachHang khachHang) { this.khachHang = khachHang; }

    public KhuyenMai getKhuyenMai() { return khuyenMai; }
    public void setKhuyenMai(KhuyenMai khuyenMai) { this.khuyenMai = khuyenMai; }

    public PhuongThucThanhToan getPhuongThucThanhToan() { return phuongThucThanhToan; }
    public void setPhuongThucThanhToan(PhuongThucThanhToan phuongThucThanhToan) { this.phuongThucThanhToan = phuongThucThanhToan; }

    public List<ChiTietDonHang> getDanhSachChiTiet() { return danhSachChiTiet; }
    public void setDanhSachChiTiet(List<ChiTietDonHang> danhSachChiTiet) { this.danhSachChiTiet = danhSachChiTiet; }
}