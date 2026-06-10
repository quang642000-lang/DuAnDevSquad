package service;

import model.ThongKe;
import model.DonHangDashboard;
import model.TopSanPham;
import repository.ThongKeRepository;

import java.util.List;
import java.util.Map;

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

    public String getReceiptJson(String maDH) {
        return repo.getReceiptJson(maDH);
    }
}