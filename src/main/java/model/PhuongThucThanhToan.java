package model;

public class PhuongThucThanhToan {
    private String maPTTT;
    private String tenPhuongThuc;
    private String trangThai;

    public PhuongThucThanhToan() {
    }

    public PhuongThucThanhToan(String maPTTT, String tenPhuongThuc, String trangThai) {
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

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }
}
