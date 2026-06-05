package model;

public class SanPham {
    private String maSP; // ĐÃ CHUẨN HÓA THÀNH P HOA
    private String tenSanPham; // ĐÃ CHUẨN HÓA
    private int trangThai;
    private String hinhAnh;
    private DanhMuc danhMuc;

    public SanPham() {
    }

    public SanPham(String maSP, String tenSanPham, int trangThai, String hinhAnh, DanhMuc danhMuc) {
        this.maSP = maSP;
        this.tenSanPham = tenSanPham;
        this.trangThai = trangThai;
        this.hinhAnh = hinhAnh;
        this.danhMuc = danhMuc;
    }

    public String getMaSP() { return maSP; }
    public void setMaSP(String maSP) { this.maSP = maSP; }

    public String getTenSanPham() { return tenSanPham; }
    public void setTenSanPham(String tenSanPham) { this.tenSanPham = tenSanPham; }

    public int getTrangThai() { return trangThai; }
    public void setTrangThai(int trangThai) { this.trangThai = trangThai; }

    public String getHinhAnh() { return hinhAnh; }
    public void setHinhAnh(String hinhAnh) { this.hinhAnh = hinhAnh; }

    public DanhMuc getDanhMuc() { return danhMuc; }
    public void setDanhMuc(DanhMuc danhMuc) { this.danhMuc = danhMuc; }
}