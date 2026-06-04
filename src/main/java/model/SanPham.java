package model;

public class SanPham {
    private String maSP;
    private String tenSP;
    private int trangThai;
    private String hinhAnh;
    private DanhMuc danhMuc;
    public SanPham() {
    }

    public SanPham(String maSP, String tenSP, int trangThai, String hinhAnh) {
        this.maSP = maSP;
        this.tenSP = tenSP;
        this.trangThai = trangThai;
        this.hinhAnh = hinhAnh;
    }

    public String getMaSP() {
        return maSP;
    }

    public void setMaSP(String maSP) {
        this.maSP = maSP;
    }

    public String getTenSP() {
        return tenSP;
    }

    public void setTenSP(String tenSP) {
        this.tenSP = tenSP;
    }

    public int getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(int trangThai) {
        this.trangThai = trangThai;
    }

    public String getHinhAnh() {
        return hinhAnh;
    }

    public void setHinhAnh(String hinhAnh) {
        this.hinhAnh = hinhAnh;
    }
    public DanhMuc getDanhMuc() {
        return danhMuc;
    }

    public void setDanhMuc(DanhMuc danhMuc) {
        this.danhMuc = danhMuc;
    }
}
