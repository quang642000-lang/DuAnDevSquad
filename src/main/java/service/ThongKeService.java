package service;

import model.ThongKe;
import model.DonHangDashboard;
import model.TopSanPham;
import repository.ThongKeRepository;
import java.util.List;
import java.util.Map;
import com.google.gson.Gson;

public class ThongKeService {
    private ThongKeRepository repo = new ThongKeRepository();

    public ThongKe getThongKeTongQuan(String tuNgay, String denNgay, String maNV) {
        return repo.getThongKeTongQuan(tuNgay, denNgay, maNV);
    }

    public List<DonHangDashboard> getDonHangTheoNgay(String tuNgay, String denNgay, String maNV) {
        return repo.getDonHangTheoNgay(tuNgay, denNgay, maNV);
    }

    public List<TopSanPham> getTopSanPham(String tuNgay, String denNgay, String maNV) {
        return repo.getTopSanPham(tuNgay, denNgay, maNV);
    }

    public Map<String, Integer> getDoanhThu7NgayQua(String tuNgay, String denNgay, String maNV) {
        return repo.getDoanhThu7NgayQua(tuNgay, denNgay, maNV);
    }

    // Xử lý JSON ở tầng Service thay vì Repository
    public String getReceiptJson(String maDH) {
        Map<String, Object> data = repo.getReceiptData(maDH);
        if (data == null || data.isEmpty()) {
            return "{\"error\":\"Không tìm thấy đơn hàng trong Database.\"}";
        }
        return new Gson().toJson(data);
    }
}