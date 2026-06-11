package servlet;

import model.KhuyenMai;
import service.KhuyenMaiService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Date;

@MultipartConfig // QUAN TRỌNG: Giúp form gửi được mọi dữ liệu, khắc phục lỗi null
@WebServlet(name = "KhuyenMaiController", value = "/khuyen-mai")
public class KhuyenMaiController extends HttpServlet {

    private KhuyenMaiService khuyenMaiService = new KhuyenMaiService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "delete":
                String maKmDel = request.getParameter("id");
                request.getSession().setAttribute("message", khuyenMaiService.delete(maKmDel));
                response.sendRedirect(request.getContextPath() + "/khuyen-mai");
                break;
            case "toggle-status":
                String maKmToggle = request.getParameter("id");
                int status = Integer.parseInt(request.getParameter("status"));
                request.getSession().setAttribute("message", khuyenMaiService.updateTrangThai(maKmToggle, status));
                response.sendRedirect(request.getContextPath() + "/khuyen-mai");
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

            // 1. Xử lý Tên Khuyến Mãi (Tự động bắt cả 2 kiểu đặt tên form)
            String ten = request.getParameter("tenKm");
            if (ten == null || ten.trim().isEmpty()) {
                ten = request.getParameter("tenKhuyenMai");
            }
            km.setTenKM(ten);

            // 2. Lấy Mã Code và Loại giảm giá
            String maCode = request.getParameter("maCode");
            km.setMaCode(maCode != null ? maCode.trim().toUpperCase() : "");
            km.setLoaiGiamGia(request.getParameter("loaiGiamGia"));

            // 3. Parse dữ liệu số nguyên an toàn
            String giaTriGiamStr = request.getParameter("giaTriGiam");
            String dieuKienStr = request.getParameter("dieuKienToiThieu");
            String soLuongStr = request.getParameter("soLuong");

            km.setGiaTriGiam(giaTriGiamStr != null && !giaTriGiamStr.isEmpty() ? Integer.parseInt(giaTriGiamStr) : 0);
            km.setDieuKienToiThieu(dieuKienStr != null && !dieuKienStr.isEmpty() ? Integer.parseInt(dieuKienStr) : 0);
            km.setSoLuong(soLuongStr != null && !soLuongStr.isEmpty() ? Integer.parseInt(soLuongStr) : 0);

            // 4. Parse dữ liệu Ngày tháng an toàn
            String ngayBatDauStr = request.getParameter("ngayBatDau");
            String ngayKetThucStr = request.getParameter("ngayKetThuc");

            if (ngayBatDauStr != null && !ngayBatDauStr.isEmpty()) {
                km.setNgayBatDau(Date.valueOf(ngayBatDauStr));
            }
            if (ngayKetThucStr != null && !ngayKetThucStr.isEmpty()) {
                km.setNgayKetThuc(Date.valueOf(ngayKetThucStr));
            }

            // 5. Điều hướng Service
            if ("add".equals(action)) {
                request.getSession().setAttribute("message", khuyenMaiService.add(km));
            } else if ("update".equals(action)) {
                String idUpdate = request.getParameter("maKm");
                if (idUpdate == null || idUpdate.isEmpty()) {
                    idUpdate = request.getParameter("id");
                }
                km.setMaKM(idUpdate);
                request.getSession().setAttribute("message", khuyenMaiService.update(km));
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.getSession().setAttribute("message", "Lỗi: Số lượng, Giá trị giảm hoặc Điều kiện tối thiểu phải là số hợp lệ!");
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
            request.getSession().setAttribute("message", "Lỗi: Vui lòng nhập đúng định dạng Ngày bắt đầu và Ngày kết thúc!");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("message", "Lỗi hệ thống: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/khuyen-mai");
    }
}