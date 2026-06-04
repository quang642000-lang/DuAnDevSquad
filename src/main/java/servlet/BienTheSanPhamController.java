package servlet;

import model.BienTheSanPham;
import model.SanPham;
import service.BienTheSanPhamService;
import service.SanPhamService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "BienTheSanPhamController", value = "/bien-the")
public class BienTheSanPhamController extends HttpServlet {

    private BienTheSanPhamService bienTheService = new BienTheSanPhamService();
    // Khởi tạo Service của Sản Phẩm để lấy dữ liệu
    private SanPhamService sanPhamService = new SanPhamService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "delete":
                String idDel = request.getParameter("id");
                request.getSession().setAttribute("message", bienTheService.delete(idDel));
                response.sendRedirect(request.getContextPath() + "/bien-the?action=list");
                break;

            case "toggle-status":
                String idToggle = request.getParameter("id");
                int status = Integer.parseInt(request.getParameter("status"));
                request.getSession().setAttribute("message", bienTheService.updateTrangThai(idToggle, status));
                response.sendRedirect(request.getContextPath() + "/bien-the?action=list");
                break;

            case "list":
            default:
                // 1. Lấy danh sách Biến thể nạp vào bảng
                request.setAttribute("danhSach", bienTheService.getAll());

                // 2. Lấy danh sách Sản phẩm nạp vào thẻ <select>
                request.setAttribute("danhSachSp", sanPhamService.getAll());

                request.getRequestDispatcher("/views/bien_the.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            BienTheSanPham bt = new BienTheSanPham();
            bt.setKichCo(request.getParameter("kichCo"));

            try {
                bt.setGiaBan(Integer.parseInt(request.getParameter("giaBan")));
            } catch (Exception e) {
                bt.setGiaBan(0);
            }

            SanPham sp = new SanPham();
            sp.setMaSP(request.getParameter("maSp"));
            bt.setSanPham(sp);

            request.getSession().setAttribute("message", bienTheService.add(bt));

        } else if ("update".equals(action)) {
            BienTheSanPham bt = new BienTheSanPham();
            bt.setMaBienThe(request.getParameter("maBienThe"));
            bt.setKichCo(request.getParameter("kichCo"));

            try {
                bt.setGiaBan(Integer.parseInt(request.getParameter("giaBan")));
            } catch (Exception e) {
                bt.setGiaBan(0);
            }

            SanPham sp = new SanPham();
            sp.setMaSP(request.getParameter("maSp"));
            bt.setSanPham(sp);

            request.getSession().setAttribute("message", bienTheService.update(bt));
        }

        response.sendRedirect(request.getContextPath() + "/bien-the?action=list");
    }
}