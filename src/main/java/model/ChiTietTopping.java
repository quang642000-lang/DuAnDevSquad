package model;

public class ChiTietTopping {
    private String maChiTietTopping;
    private int soLuongTopping;
    private int giaChot;

    // --- CÁC MỐI QUAN HỆ ---
    private ChiTietDonHang chiTietDonHang; // Liên kết ngược lại ly nước chứa nó
    private Topping topping; // Loại Topping được thêm vào

    public ChiTietTopping() {
    }

    public ChiTietTopping(String maChiTietTopping, int soLuongTopping, int giaChot, ChiTietDonHang chiTietDonHang, Topping topping) {
        this.maChiTietTopping = maChiTietTopping;
        this.soLuongTopping = soLuongTopping;
        this.giaChot = giaChot;
        this.chiTietDonHang = chiTietDonHang;
        this.topping = topping;
    }

    public String getMaChiTietTopping() { return maChiTietTopping; }
    public void setMaChiTietTopping(String maChiTietTopping) { this.maChiTietTopping = maChiTietTopping; }

    public int getSoLuongTopping() { return soLuongTopping; }
    public void setSoLuongTopping(int soLuongTopping) { this.soLuongTopping = soLuongTopping; }

    public int getGiaChot() { return giaChot; }
    public void setGiaChot(int giaChot) { this.giaChot = giaChot; }

    public ChiTietDonHang getChiTietDonHang() { return chiTietDonHang; }
    public void setChiTietDonHang(ChiTietDonHang chiTietDonHang) { this.chiTietDonHang = chiTietDonHang; }

    public Topping getTopping() { return topping; }
    public void setTopping(Topping topping) { this.topping = topping; }
}