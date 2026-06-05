package model;

import java.util.ArrayList;
import java.util.List;

public class ChiTietDonHang {
    private String maChiTiet; // Sửa tên biến cho giống ma_chi_tiet trong DB
    private int soLuong;
    private String mucDa;
    private String mucDuong;
    private String ghiChu;
    private int giaChot;

    // --- CÁC MỐI QUAN HỆ ---
    private DonHang donHang; // Liên kết ngược lại Đơn hàng cha
    private BienTheSanPham bienThe; // Món nước được đặt (Đã bao gồm tên SP và Kích cỡ)

    // --- DANH SÁCH CON: MỘT LY NƯỚC CÓ THỂ CÓ NHIỀU TOPPING ---
    private List<ChiTietTopping> danhSachTopping = new ArrayList<>();

    public ChiTietDonHang() {
    }

    public ChiTietDonHang(String maChiTiet, int soLuong, String mucDa, String mucDuong, String ghiChu, int giaChot, DonHang donHang, BienTheSanPham bienThe) {
        this.maChiTiet = maChiTiet;
        this.soLuong = soLuong;
        this.mucDa = mucDa;
        this.mucDuong = mucDuong;
        this.ghiChu = ghiChu;
        this.giaChot = giaChot;
        this.donHang = donHang;
        this.bienThe = bienThe;
    }

    public String getMaChiTiet() { return maChiTiet; }
    public void setMaChiTiet(String maChiTiet) { this.maChiTiet = maChiTiet; }

    public int getSoLuong() { return soLuong; }
    public void setSoLuong(int soLuong) { this.soLuong = soLuong; }

    public String getMucDa() { return mucDa; }
    public void setMucDa(String mucDa) { this.mucDa = mucDa; }

    public String getMucDuong() { return mucDuong; }
    public void setMucDuong(String mucDuong) { this.mucDuong = mucDuong; }

    public String getGhiChu() { return ghiChu; }
    public void setGhiChu(String ghiChu) { this.ghiChu = ghiChu; }

    public int getGiaChot() { return giaChot; }
    public void setGiaChot(int giaChot) { this.giaChot = giaChot; }

    public DonHang getDonHang() { return donHang; }
    public void setDonHang(DonHang donHang) { this.donHang = donHang; }

    public BienTheSanPham getBienThe() { return bienThe; }
    public void setBienThe(BienTheSanPham bienThe) { this.bienThe = bienThe; }

    public List<ChiTietTopping> getDanhSachTopping() { return danhSachTopping; }
    public void setDanhSachTopping(List<ChiTietTopping> danhSachTopping) { this.danhSachTopping = danhSachTopping; }
}