package servlet;

import model.DanhMuc;
import service.DanhMucService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "DanhMucController", value = "/danh-muc")
public class DanhMucController extends HttpServlet {

    private DanhMucService danhMucService = new DanhMucService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        if ("delete".equals(action)) {
            // Xử lý Xóa
            try {
                String maDanhMuc = request.getParameter("id");
                String thongBao = danhMucService.delete(maDanhMuc);
                request.getSession().setAttribute("message", thongBao);
            } catch (Exception e) {
                request.getSession().setAttribute("message", "Lỗi: ID không hợp lệ!");
            }
            response.sendRedirect(request.getContextPath() + "/danh-muc?action=list");

        } else {
            // Xử lý Hiển thị danh sách có phân trang
            int page = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try { page = Integer.parseInt(pageParam); } catch (Exception e) {}
            }

            List<DanhMuc> listDM = danhMucService.getAllByPage(page);
            int totalPages = danhMucService.getTotalPages();

            request.setAttribute("danhSach", listDM);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);

            request.getRequestDispatcher("/views/danh_muc.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            // Xử lý Thêm Mới
            String ten = request.getParameter("tenDanhMuc");
            DanhMuc dm = new DanhMuc();
            dm.setTenDanhMuc(ten);

            String thongBao = danhMucService.add(dm);
            request.getSession().setAttribute("message", thongBao);

        } else if ("update".equals(action)) {
            // Xử lý Cập Nhật
            try {
                String id = request.getParameter("maDanhMuc"); // Lấy ID ẩn từ form cập nhật
                String ten = request.getParameter("tenDanhMuc");

                DanhMuc dm = new DanhMuc(id, ten);
                String thongBao = danhMucService.update(dm);
                request.getSession().setAttribute("message", thongBao);

            } catch (NumberFormatException e) {
                request.getSession().setAttribute("message", "Lỗi định dạng mã danh mục!");
            }
        }

        response.sendRedirect(request.getContextPath() + "/danh-muc?action=list");
    }
}