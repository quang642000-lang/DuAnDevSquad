package model;

public class NhanVien {
    private String maNV;
    private String tenDangNhap;
    private String matKhau;
    private String hoTen;
    private String SDT;
    private String email; // ĐÃ THÊM EMAIL
    private int trangThai;
    private VaiTro vaiTro;

    public NhanVien() {
    }

    // ĐÃ CẬP NHẬT CONSTRUCTOR CHỨA EMAIL
    public NhanVien(String maNV, String tenDangNhap, String matKhau, String hoTen, String SDT, String email, int trangThai, VaiTro vaiTro) {
        this.maNV = maNV;
        this.tenDangNhap = tenDangNhap;
        this.matKhau = matKhau;
        this.hoTen = hoTen;
        this.SDT = SDT;
        this.email = email;
        this.trangThai = trangThai;
        this.vaiTro = vaiTro;
    }

    public String getMaNV() {
        return maNV;
    }

    public void setMaNV(String maNV) {
        this.maNV = maNV;
    }

    public String getTenDangNhap() {
        return tenDangNhap;
    }

    public void setTenDangNhap(String tenDangNhap) {
        this.tenDangNhap = tenDangNhap;
    }

    public String getMatKhau() {
        return matKhau;
    }

    public void setMatKhau(String matKhau) {
        this.matKhau = matKhau;
    }

    public String getHoTen() {
        return hoTen;
    }

    public void setHoTen(String hoTen) {
        this.hoTen = hoTen;
    }

    public String getSDT() {
        return SDT;
    }

    public void setSDT(String SDT) {
        this.SDT = SDT;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(int trangThai) {
        this.trangThai = trangThai;
    }

    public VaiTro getVaiTro() {
        return vaiTro;
    }

    public void setVaiTro(VaiTro vaiTro) {
        this.vaiTro = vaiTro;
    }
}