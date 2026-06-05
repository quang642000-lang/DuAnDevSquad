package servlet;

import model.PhuongThucThanhToan;
import service.PhuongThucThanhToanService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "PhuongThucThanhToanController", value = "/phuong-thuc")
public class PhuongThucThanhToanController extends HttpServlet {

    private PhuongThucThanhToanService ptService = new PhuongThucThanhToanService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "delete":
                String idDel = request.getParameter("id");
                request.getSession().setAttribute("message", ptService.delete(idDel));
                response.sendRedirect(request.getContextPath() + "/phuong-thuc?action=list");
                break;

            case "toggle-status":
                String idToggle = request.getParameter("id");
                int status = Integer.parseInt(request.getParameter("status"));
                request.getSession().setAttribute("message", ptService.updateTrangThai(idToggle, status));
                response.sendRedirect(request.getContextPath() + "/phuong-thuc?action=list");
                break;

            case "search":
                String keyword = request.getParameter("keyword");
                request.setAttribute("danhSach", ptService.search(keyword));
                request.setAttribute("selectedKeyword", keyword);
                request.getRequestDispatcher("/views/phuong_thuc.jsp").forward(request, response);
                break;

            case "list":
            default:
                request.setAttribute("danhSach", ptService.getAll());
                request.getRequestDispatcher("/views/phuong_thuc.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            PhuongThucThanhToan pt = new PhuongThucThanhToan();
            pt.setTenPhuongThuc(request.getParameter("tenPhuongThuc"));
            request.getSession().setAttribute("message", ptService.add(pt));

        } else if ("update".equals(action)) {
            PhuongThucThanhToan pt = new PhuongThucThanhToan();
            pt.setMaPTTT(request.getParameter("maPTTT"));
            pt.setTenPhuongThuc(request.getParameter("tenPhuongThuc"));
            request.getSession().setAttribute("message", ptService.update(pt));
        }

        response.sendRedirect(request.getContextPath() + "/phuong-thuc?action=list");
    }
}