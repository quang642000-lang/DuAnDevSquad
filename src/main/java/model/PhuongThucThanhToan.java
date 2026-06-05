package model;

public class PhuongThucThanhToan {
    private String maPTTT;
    private String tenPhuongThuc;
    private int trangThai;

    public PhuongThucThanhToan() {
    }

    public PhuongThucThanhToan(String maPTTT, String tenPhuongThuc, int trangThai) {
        this.maPTTT = maPTTT;
        this.tenPhuongThuc = tenPhuongThuc;
        this.trangThai = trangThai;
    }

    public String getMaPTTT() {
        return maPTTT;
    }

    public void setMaPTTT(String maPTTT) {
        this.maPTTT = maPTTT;
    }

    public String getTenPhuongThuc() {
        return tenPhuongThuc;
    }

    public void setTenPhuongThuc(String tenPhuongThuc) {
        this.tenPhuongThuc = tenPhuongThuc;
    }

    public int getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(int trangThai) {
        this.trangThai = trangThai;
    }
}
