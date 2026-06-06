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

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 5,       // 5MB tối đa cho 1 file
        maxRequestSize = 1024 * 1024 * 10    // 10MB tối đa tổng request
)
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

        // Thiết lập đường dẫn kho lưu trữ cố định trên ổ đĩa C
        String uploadPath = "C:" + File.separator + "tea_pos_images";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs(); // mkdirs() tự động tạo tất cả các cấp thư mục cha con nếu chưa tồn tại
        }

        if ("add".equals(action)) {
            SanPham sp = new SanPham();
            sp.setTenSanPham(request.getParameter("tenSanPham"));

            // Đọc dữ liệu file ảnh gửi lên từ form
            Part filePart = request.getPart("hinhAnhFile");
            String fileName = filePart.getSubmittedFileName();
            if (fileName != null && !fileName.isEmpty()) {
                filePart.write(uploadPath + File.separator + fileName);
                sp.setHinhAnh(fileName);
            } else {
                sp.setHinhAnh("default.png");
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

            Part filePart = request.getPart("hinhAnhFile");
            String fileName = filePart.getSubmittedFileName();
            if (fileName != null && !fileName.isEmpty()) {
                filePart.write(uploadPath + File.separator + fileName);
                sp.setHinhAnh(fileName);
            } else {
                // Nhận lại tên file cũ thông qua trường ẩn nếu người dùng không thực hiện đổi ảnh mới
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