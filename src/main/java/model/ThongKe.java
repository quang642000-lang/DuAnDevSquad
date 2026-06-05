package model;

public class ThongKe {
    private long doanhThuHomNay;
    private int donHangMoi;
    private int tongSanPham;
    private int tongKhachHang;

    public ThongKe() {
    }

    public ThongKe(long doanhThuHomNay, int donHangMoi, int tongSanPham, int tongKhachHang) {
        this.doanhThuHomNay = doanhThuHomNay;
        this.donHangMoi = donHangMoi;
        this.tongSanPham = tongSanPham;
        this.tongKhachHang = tongKhachHang;
    }

    public long getDoanhThuHomNay() { return doanhThuHomNay; }
    public void setDoanhThuHomNay(long doanhThuHomNay) { this.doanhThuHomNay = doanhThuHomNay; }

    public int getDonHangMoi() { return donHangMoi; }
    public void setDonHangMoi(int donHangMoi) { this.donHangMoi = donHangMoi; }

    public int getTongSanPham() { return tongSanPham; }
    public void setTongSanPham(int tongSanPham) { this.tongSanPham = tongSanPham; }

    public int getTongKhachHang() { return tongKhachHang; }
    public void setTongKhachHang(int tongKhachHang) { this.tongKhachHang = tongKhachHang; }
}