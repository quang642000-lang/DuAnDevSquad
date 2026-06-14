package service;

import model.BienTheSanPham;
import repository.BienTheSanPhamRepository;
import repository.DBConnect;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

public class BienTheSanPhamService {
    private BienTheSanPhamRepository bienTheRepo = new BienTheSanPhamRepository();
    private final int LIMIT = 5;

    public List<BienTheSanPham> getAll() {
        return bienTheRepo.getAll();
    }

    public List<BienTheSanPham> getAllByPage(int page) {
        int offset = (page - 1) * LIMIT;
        return bienTheRepo.getAll(offset, LIMIT);
    }

    public int getTotalPages() {
        int totalRecords = bienTheRepo.getTotalCount();
        return (int) Math.ceil((double) totalRecords / LIMIT);
    }

    public String add(BienTheSanPham bt) {
        if (bt.getKichCo() == null || bt.getKichCo().trim().isEmpty()) {
            return "Lỗi: Kích cỡ không được để trống!";
        }
        if (bt.getGiaBan() < 0) {
            return "Lỗi: Giá bán không được là số âm!";
        }
        if (bt.getSanPham() == null || bt.getSanPham().getMaSP() == null || bt.getSanPham().getMaSP().isEmpty()) {
            return "Lỗi: Vui lòng chọn sản phẩm!";
        }

        bt.setTrangThai(1);
        return bienTheRepo.add(bt) ? "Thêm kích cỡ thành công!" : "Lỗi hệ thống khi thêm!";
    }

    public String update(BienTheSanPham bt) {
        if (bt.getMaBienThe() == null || bt.getMaBienThe().isEmpty()) return "Lỗi: Mã không hợp lệ!";
        if (bt.getKichCo() == null || bt.getKichCo().trim().isEmpty()) return "Lỗi: Kích cỡ không được trống!";

        return bienTheRepo.update(bt) ? "Cập nhật thành công!" : "Lỗi hệ thống khi cập nhật!";
    }

    public String updateTrangThai(String maBienThe, int trangThai) {
        if (maBienThe == null || maBienThe.isEmpty()) return "Lỗi: Mã không hợp lệ!";

        // Kiểm tra sản phẩm mẹ trước khi bật trạng thái
        if (trangThai == 1) {
            String sql = "SELECT sp.trang_thai FROM SAN_PHAM sp INNER JOIN BIEN_THE_SAN_PHAM bt ON sp.ma_sp = bt.ma_sp WHERE bt.ma_bien_the = ?";
            try (Connection con = DBConnect.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, maBienThe);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        int spTrangThai = rs.getInt("trang_thai");
                        if (spTrangThai == 0) {
                            return "Không thể bật! Sản phẩm mẹ đang ngừng bán. Vui lòng sang trang Quản Lý Sản Phẩm để bật hoạt động trước.";
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                return "Lỗi hệ thống khi kiểm tra trạng thái sản phẩm mẹ!";
            }
        }

        return bienTheRepo.updateTrangThai(maBienThe, trangThai) ? "Cập nhật trạng thái thành công!" : "Lỗi khi cập nhật trạng thái!";
    }

    public String delete(String maBienThe) {
        if (maBienThe == null || maBienThe.isEmpty()) return "Lỗi: Mã không hợp lệ!";
        return bienTheRepo.delete(maBienThe) ? "Đã xóa kích cỡ!" : "Lỗi: Không thể xóa vì kích cỡ này đã phát sinh trong đơn hàng!";
    }

    public List<BienTheSanPham> search(String keyword, String maSp) {
        return bienTheRepo.search(keyword, maSp);
    }
}
