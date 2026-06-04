package model;

public class KhachHang {
    private String maKH;
    private String tenKH;
    private String SDT;
    private int diemTichLuy;

    public KhachHang() {
    }

    public KhachHang(String maKH, String tenKH, String SDT, int diemTichLuy) {
        this.maKH = maKH;
        this.tenKH = tenKH;
        this.SDT = SDT;
        this.diemTichLuy = diemTichLuy;
    }

    public String getMaKH() {
        return maKH;
    }

    public void setMaKH(String maKH) {
        this.maKH = maKH;
    }

    public String getTenKH() {
        return tenKH;
    }

    public void setTenKH(String tenKH) {
        this.tenKH = tenKH;
    }

    public String getSDT() {
        return SDT;
    }

    public void setSDT(String SDT) {
        this.SDT = SDT;
    }

    public int getDiemTichLuy() {
        return diemTichLuy;
    }

    public void setDiemTichLuy(int diemTichLuy) {
        this.diemTichLuy = diemTichLuy;
    }
}
