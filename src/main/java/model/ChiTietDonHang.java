package model;

public class ChiTietDonHang {
    private String maChiTietDonHang;
    private int soLuong;
    private String mucDa;
    private String mucDuong;
    private String ghiChu;
    private int giaChot;

    public ChiTietDonHang() {
    }

    public ChiTietDonHang(String maChiTietDonHang, int soLuong, String mucDa, String mucDuong, String ghiChu, int giaChot) {
        this.maChiTietDonHang = maChiTietDonHang;
        this.soLuong = soLuong;
        this.mucDa = mucDa;
        this.mucDuong = mucDuong;
        this.ghiChu = ghiChu;
        this.giaChot = giaChot;
    }

    public String getMaChiTietDonHang() {
        return maChiTietDonHang;
    }

    public void setMaChiTietDonHang(String maChiTietDonHang) {
        this.maChiTietDonHang = maChiTietDonHang;
    }

    public int getSoLuong() {
        return soLuong;
    }

    public void setSoLuong(int soLuong) {
        this.soLuong = soLuong;
    }

    public String getMucDa() {
        return mucDa;
    }

    public void setMucDa(String mucDa) {
        this.mucDa = mucDa;
    }

    public String getMucDuong() {
        return mucDuong;
    }

    public void setMucDuong(String mucDuong) {
        this.mucDuong = mucDuong;
    }

    public String getGhiChu() {
        return ghiChu;
    }

    public void setGhiChu(String ghiChu) {
        this.ghiChu = ghiChu;
    }

    public int getGiaChot() {
        return giaChot;
    }

    public void setGiaChot(int giaChot) {
        this.giaChot = giaChot;
    }
}
