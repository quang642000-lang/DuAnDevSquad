package servlet;

import model.KhuyenMai;
import service.KhuyenMaiService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "KhuyenMaiController", value = "/khuyen-mai")
public class KhuyenMaiController extends HttpServlet {

    private KhuyenMaiService khuyenMaiService = new KhuyenMaiService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "delete":
                String maKmDel = request.getParameter("id");
                request.getSession().setAttribute("message", khuyenMaiService.delete(maKmDel));
                response.sendRedirect(request.getContextPath() + "/khuyen-mai?action=list");
                break;

            case "toggle-status":
                String maKmToggle = request.getParameter("id");
                int status = Integer.parseInt(request.getParameter("status"));
                request.getSession().setAttribute("message", khuyenMaiService.updateTrangThai(maKmToggle, status));
                response.sendRedirect(request.getContextPath() + "/khuyen-mai?action=list");
                break;

            case "search":
                String keyword = request.getParameter("keyword");
                request.setAttribute("danhSach", khuyenMaiService.search(keyword));
                request.setAttribute("selectedKeyword", keyword);
                request.getRequestDispatcher("/views/khuyen_mai.jsp").forward(request, response);
                break;

            case "list":
            default:
                request.setAttribute("danhSach", khuyenMaiService.getAll());
                request.getRequestDispatcher("/views/khuyen_mai.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            KhuyenMai km = new KhuyenMai();
            km.setTenKM(request.getParameter("tenKm"));
            km.setMaCode(request.getParameter("maCode").toUpperCase());
            km.setLoaiGiamGia(request.getParameter("loaiGiamGia"));

            km.setGiaTrịGiam(Integer.parseInt(request.getParameter("giaTriGiam")));
            km.setDieuKienToiThieu(Integer.parseInt(request.getParameter("dieuKienToiThieu")));
            km.setSoLuong(Integer.parseInt(request.getParameter("soLuong"))); // Lấy số lượng từ Form

            km.setNgayBatDau(java.sql.Date.valueOf(request.getParameter("ngayBatDau")));
            km.setNgayKetThuc(java.sql.Date.valueOf(request.getParameter("ngayKetThuc")));

            if ("add".equals(action)) {
                request.getSession().setAttribute("message", khuyenMaiService.add(km));
            } else if ("update".equals(action)) {
                km.setMaKM(request.getParameter("maKm"));
                request.getSession().setAttribute("message", khuyenMaiService.update(km));
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("message", "Lỗi dữ liệu đầu vào (Vui lòng kiểm tra lại định dạng số/ngày)!");
        }

        response.sendRedirect(request.getContextPath() + "/khuyen-mai?action=list");
    }
}