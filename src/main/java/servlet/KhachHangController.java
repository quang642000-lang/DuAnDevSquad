package servlet;

import model.KhachHang;
import service.KhachHangService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "KhachHangController", value = "/khach-hang")
public class KhachHangController extends HttpServlet {

    private KhachHangService khachHangService = new KhachHangService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "delete":
                // CHỨC NĂNG XÓA
                String maKHDelete = request.getParameter("maKH");
                String tbXoa = khachHangService.delete(maKHDelete);
                // Gửi thông báo (thành công/thất bại) sang JSP
                request.getSession().setAttribute("message", tbXoa);
                response.sendRedirect(request.getContextPath() + "/khach-hang?action=list");
                break;
            case "search":
                // CHỨC NĂNG TÌM KIẾM
                String sdt = request.getParameter("sdt");
                KhachHang kh = khachHangService.timKiemTheoSdt(sdt);
                if (kh != null) {
                    List<KhachHang> listSearch = new java.util.ArrayList<>();
                    listSearch.add(kh);
                    request.setAttribute("danhSach", listSearch);
                }
                request.setAttribute("currentPage", 1);
                request.setAttribute("totalPages", 1); // Ẩn thanh phân trang khi đang tìm kiếm
                request.getRequestDispatcher("/views/khach_hang.jsp").forward(request, response);
                break;

            case "list":
            default:
                // HIỂN THỊ DANH SÁCH CÓ PHÂN TRANG
                int page = 1;
                String pageParam = request.getParameter("page");
                if (pageParam != null && !pageParam.isEmpty()) {
                    try { page = Integer.parseInt(pageParam); } catch (Exception e) {}
                }
                request.setAttribute("danhSach", khachHangService.getAllByPage(page));
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", khachHangService.getTotalPages());

                request.getRequestDispatcher("/views/khach_hang.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            // CHỨC NĂNG THÊM
            KhachHang kh = new KhachHang();
            kh.setTenKH(request.getParameter("tenKhachHang"));
            kh.setSDT(request.getParameter("soDienThoai"));

            String thongBao = khachHangService.add(kh);
            request.getSession().setAttribute("message", thongBao);

        } else if ("update".equals(action)) {
            // CHỨC NĂNG CẬP NHẬT
            KhachHang kh = new KhachHang();
            // Bắt buộc phải lấy maKH từ thẻ hidden form để biết đang sửa ai
            kh.setMaKH(request.getParameter("maKH"));
            kh.setTenKH(request.getParameter("tenKhachHang"));
            kh.setSDT(request.getParameter("soDienThoai"));

            String thongBao = khachHangService.update(kh);
            request.getSession().setAttribute("message", thongBao);
        }

        response.sendRedirect(request.getContextPath() + "/khach-hang?action=list");
    }
}