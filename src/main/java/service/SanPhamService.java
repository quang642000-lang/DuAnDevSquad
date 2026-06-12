package service;

import model.SanPham;
import repository.DBConnect;
import repository.SanPhamRepository;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.List;

public class SanPhamService {
    private SanPhamRepository sanPhamRepo = new SanPhamRepository();
    private final int LIMIT = 5;

    public List<SanPham> getAll() {
        return sanPhamRepo.getAll();
    }
    public List<SanPham> getAllByPage(int page) {
        int offset = (page - 1) * LIMIT;
        return sanPhamRepo.getAll(offset, LIMIT);
    }
    public int getTotalPages() {
        int totalRecords = sanPhamRepo.getTotalCount();
        return (int) Math.ceil((double) totalRecords / LIMIT);
    }

    public String add(SanPham sp) {
        if (sp.getTenSanPham() == null || sp.getTenSanPham().trim().isEmpty()) {
            return "Tên sản phẩm không được để trống!";
        }
        if (sp.getDanhMuc() == null || sp.getDanhMuc().getMaDanhMuc() == null || sp.getDanhMuc().getMaDanhMuc().isEmpty()) {
            return "Vui lòng chọn danh mục cho sản phẩm!";
        }
        sp.setTrangThai(1);
        return sanPhamRepo.add(sp) ? "Thêm sản phẩm thành công!" : "Lỗi khi thêm sản phẩm!";
    }

    public String update(SanPham sp) {
        if (sp.getMaSP() == null || sp.getMaSP().isEmpty()) return "Mã sản phẩm không hợp lệ!";
        if (sp.getTenSanPham() == null || sp.getTenSanPham().trim().isEmpty()) return "Tên sản phẩm không được trống!";
        return sanPhamRepo.update(sp) ? "Cập nhật sản phẩm thành công!" : "Lỗi khi cập nhật!";
    }

    // ĐÃ TỐI ƯU: Sử dụng Transaction gộp cả cập nhật Sản Phẩm và Biến Thể chung 1 luồng
    public String updateTrangThai(String maSP, int trangThai) {
        if (maSP == null || maSP.isEmpty()) return "Mã sản phẩm không hợp lệ!";

        String sqlSP = "UPDATE SAN_PHAM SET trang_thai = ? WHERE ma_sp = ?";
        String sqlBT = "UPDATE BIEN_THE_SAN_PHAM SET trang_thai = ? WHERE ma_sp = ?";

        try (Connection con = DBConnect.getConnection()) {
            con.setAutoCommit(false); // Bắt đầu Transaction

            try (PreparedStatement ps1 = con.prepareStatement(sqlSP);
                 PreparedStatement ps2 = con.prepareStatement(sqlBT)) {

                // 1. Cập nhật trạng thái Sản phẩm mẹ
                ps1.setInt(1, trangThai);
                ps1.setString(2, maSP);
                int spUpdated = ps1.executeUpdate();

                // 2. Cập nhật đồng loạt các Biến thể (Kích cỡ) con
                if (spUpdated > 0) {
                    ps2.setInt(1, trangThai);
                    ps2.setString(2, maSP);
                    ps2.executeUpdate();
                } else {
                    con.rollback();
                    return "Lỗi: Không tìm thấy sản phẩm cần cập nhật!";
                }

                con.commit(); // Thành công -> Lưu vào Database
                return "Cập nhật trạng thái thành công!";

            } catch (Exception e) {
                con.rollback(); // Bị lỗi -> Hoàn tác mọi thứ về ban đầu
                e.printStackTrace();
                return "Lỗi khi cập nhật trạng thái!";
            } finally {
                con.setAutoCommit(true);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "Lỗi kết nối cơ sở dữ liệu!";
        }
    }

    public String delete(String maSP) {
        if (maSP == null || maSP.isEmpty()) return "Mã không hợp lệ!";
        return sanPhamRepo.delete(maSP) ? "Đã xóa sản phẩm thành công!" : "Lỗi: Sản phẩm đang tồn tại trong hóa đơn!";
    }

    public List<SanPham> search(String keyword, String maDanhMuc) {
        return sanPhamRepo.search(keyword, maDanhMuc);
    }
}