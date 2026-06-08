package controller;

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
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet(name = "TrangChuAdminController", value = "/admin")
public class TrangChuAdminController extends HttpServlet {

    private ThongKeService thongKeService = new ThongKeService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String filterDate = request.getParameter("dateFilter");

        ThongKe tk = thongKeService.getThongKeTongQuan(filterDate);
        request.setAttribute("thongKe", tk);

        List<DonHangDashboard> listDonHang = thongKeService.getDonHangTheoNgay(filterDate);
        request.setAttribute("listDonHang", listDonHang);

        List<TopSanPham> topSanPham = thongKeService.getTopSanPham(filterDate);
        request.setAttribute("topSanPham", topSanPham);

        // --- XỬ LÝ DỮ LIỆU BIỂU ĐỒ (CHART.JS) ---
        Map<String, Integer> chartData = thongKeService.getDoanhThu7NgayQua(filterDate);
        // Biến Map thành chuỗi JSON thô: ["01/06", "02/06"] và [150000, 200000]
        String chartLabels = "[]";
        String chartValues = "[]";

        if (!chartData.isEmpty()) {
            chartLabels = "[\"" + String.join("\",\"", chartData.keySet()) + "\"]";
            chartValues = "[" + chartData.values().stream().map(String::valueOf).collect(Collectors.joining(",")) + "]";
        }

        request.setAttribute("chartLabels", chartLabels);
        request.setAttribute("chartValues", chartValues);
        // ----------------------------------------

        request.setAttribute("selectedDate", filterDate);

        request.getRequestDispatcher("/views/admin_dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}