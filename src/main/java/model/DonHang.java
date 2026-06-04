package model;

import java.util.Date;

public class DonHang {
    private String maDH;
    private Date thoiGianTao;
    private Date thoiGianThanhToan;
    private int tongTienHang;
    private int tienGiamGia;
    private int tongTienTra;
    private int soTienKhachDua;
    private String trangThai;

    public DonHang() {
    }

    public DonHang(String maDH, Date thoiGianTao, Date thoiGianThanhToan, int tongTienHang, int tienGiamGia, int tongTienTra, int soTienKhachDua, String trangThai) {
        this.maDH = maDH;
        this.thoiGianTao = thoiGianTao;
        this.thoiGianThanhToan = thoiGianThanhToan;
        this.tongTienHang = tongTienHang;
        this.tienGiamGia = tienGiamGia;
        this.tongTienTra = tongTienTra;
        this.soTienKhachDua = soTienKhachDua;
        this.trangThai = trangThai;
    }

    public String getMaDH() {
        return maDH;
    }

    public void setMaDH(String maDH) {
        this.maDH = maDH;
    }

    public Date getThoiGianTao() {
        return thoiGianTao;
    }

    public void setThoiGianTao(Date thoiGianTao) {
        this.thoiGianTao = thoiGianTao;
    }

    public Date getThoiGianThanhToan() {
        return thoiGianThanhToan;
    }

    public void setThoiGianThanhToan(Date thoiGianThanhToan) {
        this.thoiGianThanhToan = thoiGianThanhToan;
    }

    public int getTongTienHang() {
        return tongTienHang;
    }

    public void setTongTienHang(int tongTienHang) {
        this.tongTienHang = tongTienHang;
    }

    public int getTienGiamGia() {
        return tienGiamGia;
    }

    public void setTienGiamGia(int tienGiamGia) {
        this.tienGiamGia = tienGiamGia;
    }

    public int getTongTienTra() {
        return tongTienTra;
    }

    public void setTongTienTra(int tongTienTra) {
        this.tongTienTra = tongTienTra;
    }

    public int getSoTienKhachDua() {
        return soTienKhachDua;
    }

    public void setSoTienKhachDua(int soTienKhachDua) {
        this.soTienKhachDua = soTienKhachDua;
    }

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }
}
