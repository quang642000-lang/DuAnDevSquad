package servlet;

import model.DanhMuc;
import model.SanPham;
import service.SanPhamService;
import service.DanhMucService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "SanPhamController", value = "/san-pham")
public class SanPhamController extends HttpServlet {

    private SanPhamService sanPhamService = new SanPhamService();
    private DanhMucService danhMucService = new DanhMucService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "toggle-status":
                String maSpToggle = request.getParameter("id");
                int trangThaiMoi = Integer.parseInt(request.getParameter("status"));
                String tbToggle = sanPhamService.updateTrangThai(maSpToggle, trangThaiMoi);
                request.getSession().setAttribute("message", tbToggle);
                response.sendRedirect(request.getContextPath() + "/san-pham?action=list");
                break;

            case "delete":
                String maSpDel = request.getParameter("id");
                String tbDel = sanPhamService.delete(maSpDel);
                request.getSession().setAttribute("message", tbDel);
                response.sendRedirect(request.getContextPath() + "/san-pham?action=list");
                break;

            case "search":
                // Lấy các tham số tìm kiếm
                String keyword = request.getParameter("keyword");
                String filterDanhMuc = request.getParameter("filterDanhMuc");

                // Gọi Service tìm kiếm
                List<SanPham> listSpFiltered = sanPhamService.search(keyword, filterDanhMuc);
                request.setAttribute("danhSachSP", listSpFiltered);

                // Luôn cần danh sách Danh Mục để nạp vào form và dropdown lọc
                List<DanhMuc> listDmForSearch = danhMucService.getAll();
                request.setAttribute("danhSachDM", listDmForSearch);

                // Gửi ngược lại từ khóa cũ lên JSP để điền lại vào ô nhập
                request.setAttribute("selectedKeyword", keyword);
                request.setAttribute("selectedDanhMuc", filterDanhMuc);

                request.getRequestDispatcher("/views/san_pham.jsp").forward(request, response);
                break;

            case "list":
            default:
                List<SanPham> listSP = sanPhamService.getAll();
                request.setAttribute("danhSachSP", listSP);

                List<DanhMuc> listDM = danhMucService.getAll();
                request.setAttribute("danhSachDM", listDM);

                request.getRequestDispatcher("/views/san_pham.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            SanPham sp = new SanPham();
            sp.setTenSP(request.getParameter("tenSanPham"));
            sp.setHinhAnh(request.getParameter("hinhAnh"));

            DanhMuc dm = new DanhMuc();
            dm.setMaDanhMuc(request.getParameter("maDanhMuc"));
            sp.setDanhMuc(dm);

            String thongBao = sanPhamService.add(sp);
            request.getSession().setAttribute("message", thongBao);

        } else if ("update".equals(action)) {
            SanPham sp = new SanPham();
            sp.setMaSP(request.getParameter("maSP"));
            sp.setTenSP(request.getParameter("tenSanPham"));
            sp.setHinhAnh(request.getParameter("hinhAnh"));

            DanhMuc dm = new DanhMuc();
            dm.setMaDanhMuc(request.getParameter("maDanhMuc"));
            sp.setDanhMuc(dm);

            String thongBao = sanPhamService.update(sp);
            request.getSession().setAttribute("message", thongBao);
        }
        response.sendRedirect(request.getContextPath() + "/san-pham?action=list");
    }
}