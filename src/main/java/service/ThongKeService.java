package service;

import model.ThongKe;
import model.DonHangDashboard;
import model.TopSanPham;
import repository.ThongKeRepository;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

public class ThongKeService {

    private ThongKeRepository repo = new ThongKeRepository();

    // Hàm lấy chuỗi ngày tháng chuẩn YYYY-MM-DD. Nếu trống thì tự lấy ngày hôm nay.
    private String getFormattedDate(String inputDate) {
        if (inputDate == null || inputDate.trim().isEmpty()) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            return sdf.format(new Date());
        }
        return inputDate;
    }

    public ThongKe getThongKeTongQuan(String dateString) {
        return repo.getThongKeTongQuan(getFormattedDate(dateString));
    }

    public List<DonHangDashboard> getDonHangTheoNgay(String dateString) {
        return repo.getDonHangTheoNgay(getFormattedDate(dateString));
    }

    public List<TopSanPham> getTopSanPham(String dateString) {
        return repo.getTopSanPham(getFormattedDate(dateString));
    }
}