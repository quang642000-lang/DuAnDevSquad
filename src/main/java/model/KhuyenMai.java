package model;

import java.util.Date;

public class KhuyenMai {
    private String maKM;
    private String tenKM;
    private String loaiGiamGia;
    private String maCode;
    private int giaTriGiam; // ĐÃ SỬA: Bỏ dấu nặng
    private int dieuKienToiThieu;
    private int soLuong;
    private int soLuongDaDung;
    private int trangThai;
    private Date ngayBatDau;
    private Date ngayKetThuc;

    public KhuyenMai() {
    }

    public KhuyenMai(String maKM, String tenKM, String loaiGiamGia, String maCode, int giaTriGiam, int dieuKienToiThieu, int soLuong, int soLuongDaDung, int trangThai, Date ngayBatDau, Date ngayKetThuc) {
        this.maKM = maKM;
        this.tenKM = tenKM;
        this.loaiGiamGia = loaiGiamGia;
        this.maCode = maCode;
        this.giaTriGiam = giaTriGiam; // ĐÃ SỬA
        this.dieuKienToiThieu = dieuKienToiThieu;
        this.soLuong = soLuong;
        this.soLuongDaDung = soLuongDaDung;
        this.trangThai = trangThai;
        this.ngayBatDau = ngayBatDau;
        this.ngayKetThuc = ngayKetThuc;
    }

    public String getMaKM() { return maKM; }
    public void setMaKM(String maKM) { this.maKM = maKM; }

    public String getTenKM() { return tenKM; }
    public void setTenKM(String tenKM) { this.tenKM = tenKM; }

    public String getLoaiGiamGia() { return loaiGiamGia; }
    public void setLoaiGiamGia(String loaiGiamGia) { this.loaiGiamGia = loaiGiamGia; }

    public String getMaCode() { return maCode; }
    public void setMaCode(String maCode) { this.maCode = maCode; }

    public int getGiaTriGiam() { return giaTriGiam; } // ĐÃ SỬA
    public void setGiaTriGiam(int giaTriGiam) { this.giaTriGiam = giaTriGiam; } // ĐÃ SỬA

    public int getDieuKienToiThieu() { return dieuKienToiThieu; }
    public void setDieuKienToiThieu(int dieuKienToiThieu) { this.dieuKienToiThieu = dieuKienToiThieu; }

    public int getSoLuong() { return soLuong; }
    public void setSoLuong(int soLuong) { this.soLuong = soLuong; }

    public int getSoLuongDaDung() { return soLuongDaDung; }
    public void setSoLuongDaDung(int soLuongDaDung) { this.soLuongDaDung = soLuongDaDung; }

    public int getTrangThai() { return trangThai; }
    public void setTrangThai(int trangThai) { this.trangThai = trangThai; }

    public Date getNgayBatDau() { return ngayBatDau; }
    public void setNgayBatDau(Date ngayBatDau) { this.ngayBatDau = ngayBatDau; }

    public Date getNgayKetThuc() { return ngayKetThuc; }
    public void setNgayKetThuc(Date ngayKetThuc) { this.ngayKetThuc = ngayKetThuc; }
}