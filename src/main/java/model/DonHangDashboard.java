package model;

import java.util.Date;

public class DonHangDashboard {
    private String maDH;
    private Date thoiGian;
    private String tenNhanVien;
    private String chiTietMon; // Chuỗi gộp các món ăn
    private int tongTien;
    private String trangThai;

    public DonHangDashboard() {
    }

    public DonHangDashboard(String maDH, Date thoiGian, String tenNhanVien, String chiTietMon, int tongTien, String trangThai) {
        this.maDH = maDH;
        this.thoiGian = thoiGian;
        this.tenNhanVien = tenNhanVien;
        this.chiTietMon = chiTietMon;
        this.tongTien = tongTien;
        this.trangThai = trangThai;
    }

    public String getMaDH() { return maDH; }
    public void setMaDH(String maDH) { this.maDH = maDH; }

    public Date getThoiGian() { return thoiGian; }
    public void setThoiGian(Date thoiGian) { this.thoiGian = thoiGian; }

    public String getTenNhanVien() { return tenNhanVien; }
    public void setTenNhanVien(String tenNhanVien) { this.tenNhanVien = tenNhanVien; }

    public String getChiTietMon() { return chiTietMon; }
    public void setChiTietMon(String chiTietMon) { this.chiTietMon = chiTietMon; }

    public int getTongTien() { return tongTien; }
    public void setTongTien(int tongTien) { this.tongTien = tongTien; }

    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }
}