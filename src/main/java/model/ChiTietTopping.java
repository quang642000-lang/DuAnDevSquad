package model;

public class ChiTietTopping {
    private String maChiTietTopping;
    private int soLuongTopping;
    private int giaChot;

    public ChiTietTopping() {
    }

    public ChiTietTopping(String maChiTietTopping, int soLuongTopping, int giaChot) {
        this.maChiTietTopping = maChiTietTopping;
        this.soLuongTopping = soLuongTopping;
        this.giaChot = giaChot;
    }

    public String getMaChiTietTopping() {
        return maChiTietTopping;
    }

    public void setMaChiTietTopping(String maChiTietTopping) {
        this.maChiTietTopping = maChiTietTopping;
    }

    public int getSoLuongTopping() {
        return soLuongTopping;
    }

    public void setSoLuongTopping(int soLuongTopping) {
        this.soLuongTopping = soLuongTopping;
    }

    public int getGiaChot() {
        return giaChot;
    }

    public void setGiaChot(int giaChot) {
        this.giaChot = giaChot;
    }
}
