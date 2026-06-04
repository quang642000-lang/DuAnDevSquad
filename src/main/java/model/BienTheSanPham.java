package model;

public class BienTheSanPham {
    private String maBienThe;
    private int giaBan;
    private String kichCo;
    private int trangThai; // Bắt buộc phải có vì CSDL SQL có cột này
    private SanPham sanPham;

    public BienTheSanPham() {
    }

    public BienTheSanPham(String maBienThe, int giaBan, String kichCo, int trangThai, SanPham sanPham) {
        this.maBienThe = maBienThe;
        this.giaBan = giaBan;
        this.kichCo = kichCo;
        this.trangThai = trangThai;
        this.sanPham = sanPham;
    }

    public String getMaBienThe() {
        return maBienThe;
    }

    public void setMaBienThe(String maBienThe) {
        this.maBienThe = maBienThe;
    }

    public int getGiaBan() {
        return giaBan;
    }

    public void setGiaBan(int giaBan) {
        this.giaBan = giaBan;
    }

    public String getKichCo() {
        return kichCo;
    }

    public void setKichCo(String kichCo) {
        this.kichCo = kichCo;
    }

    public int getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(int trangThai) {
        this.trangThai = trangThai;
    }

    public SanPham getSanPham() {
        return sanPham;
    }

    public void setSanPham(SanPham sanPham) {
        this.sanPham = sanPham;
    }
}