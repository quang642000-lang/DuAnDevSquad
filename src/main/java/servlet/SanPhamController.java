package servlet;

import model.DanhMuc;
import model.SanPham;
import service.SanPhamService;
import service.DanhMucService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.List;

// THÊM ANNOTATION NÀY ĐỂ BẬT TÍNH NĂNG UPLOAD FILE (Tối đa 5MB)
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 10)
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
                String keyword = request.getParameter("keyword");
                String filterDanhMuc = request.getParameter("filterDanhMuc");

                List<SanPham> listSpFiltered = sanPhamService.search(keyword, filterDanhMuc);
                request.setAttribute("danhSachSp", listSpFiltered);

                List<DanhMuc> listDmForSearch = danhMucService.getAll();
                request.setAttribute("danhSachDm", listDmForSearch);

                request.setAttribute("selectedKeyword", keyword);
                request.setAttribute("selectedDanhMuc", filterDanhMuc);

                request.getRequestDispatcher("/views/san_pham.jsp").forward(request, response);
                break;

            case "list":
            default:
                List<SanPham> listSp = sanPhamService.getAll();
                request.setAttribute("danhSachSp", listSp);

                List<DanhMuc> listDm = danhMucService.getAll();
                request.setAttribute("danhSachDm", listDm);

                request.getRequestDispatcher("/views/san_pham.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        // ĐƯỜNG DẪN LƯU ẢNH TRÊN SERVER (Thư mục assets/img)
        String uploadPath = getServletContext().getRealPath("") + File.separator + "assets" + File.separator + "img";
        File uploadDir = new File(uploadPath);

        // ĐÃ SỬA: Dùng mkdirs() thay vì mkdir() để tạo cả thư mục cha nếu chưa có
        if (!uploadDir.exists()) uploadDir.mkdirs();

        if ("add".equals(action)) {
            SanPham sp = new SanPham();
            sp.setTenSanPham(request.getParameter("tenSanPham"));

            // XỬ LÝ LƯU FILE ẢNH
            Part filePart = request.getPart("hinhAnhFile");
            String fileName = filePart.getSubmittedFileName();
            if (fileName != null && !fileName.isEmpty()) {
                filePart.write(uploadPath + File.separator + fileName);
                sp.setHinhAnh(fileName);
            } else {
                sp.setHinhAnh("default.png"); // Nếu không chọn ảnh thì gán mặc định
            }

            DanhMuc dm = new DanhMuc();
            dm.setMaDanhMuc(request.getParameter("maDanhMuc"));
            sp.setDanhMuc(dm);

            String thongBao = sanPhamService.add(sp);
            request.getSession().setAttribute("message", thongBao);

        } else if ("update".equals(action)) {
            SanPham sp = new SanPham();
            sp.setMaSP(request.getParameter("maSP"));
            sp.setTenSanPham(request.getParameter("tenSanPham"));

            // XỬ LÝ FILE ẢNH (NẾU CHỌN FILE MỚI THÌ LƯU, KHÔNG THÌ GIỮ ẢNH CŨ)
            Part filePart = request.getPart("hinhAnhFile");
            String fileName = filePart.getSubmittedFileName();
            if (fileName != null && !fileName.isEmpty()) {
                filePart.write(uploadPath + File.separator + fileName);
                sp.setHinhAnh(fileName);
            } else {
                // Lấy lại tên ảnh cũ từ thẻ input hidden
                String oldHinhAnh = request.getParameter("oldHinhAnh");
                sp.setHinhAnh(oldHinhAnh != null && !oldHinhAnh.isEmpty() ? oldHinhAnh : "default.png");
            }

            DanhMuc dm = new DanhMuc();
            dm.setMaDanhMuc(request.getParameter("maDanhMuc"));
            sp.setDanhMuc(dm);

            String thongBao = sanPhamService.update(sp);
            request.getSession().setAttribute("message", thongBao);
        }
        response.sendRedirect(request.getContextPath() + "/san-pham?action=list");
    }
}