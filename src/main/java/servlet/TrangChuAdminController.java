package servlet;

import service.ThongKeService;
import model.ThongKe;
import model.DonHangDashboard;
import model.TopSanPham;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "TrangChuAdminController", value = "/admin")
public class TrangChuAdminController extends HttpServlet {

    private ThongKeService thongKeService = new ThongKeService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. Lấy ngày được chọn từ giao diện (Bộ lọc)
        String filterDate = request.getParameter("dateFilter");

        // 2. Lấy 4 chỉ số tổng quan
        ThongKe tk = thongKeService.getThongKeTongQuan(filterDate);
        request.setAttribute("thongKe", tk);

        // 3. Lấy Danh sách Đơn Hàng trong ngày
        List<DonHangDashboard> listDonHang = thongKeService.getDonHangTheoNgay(filterDate);
        request.setAttribute("listDonHang", listDonHang);

        // 4. Lấy Top 5 Sản phẩm bán chạy
        List<TopSanPham> topSanPham = thongKeService.getTopSanPham(filterDate);
        request.setAttribute("topSanPham", topSanPham);

        // 5. Trả ngày về lại JSP để đổ vào ô <input type="date">
        request.setAttribute("selectedDate", filterDate);

        request.getRequestDispatcher("/views/admin_dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}