package Filter;

import model.NhanVien;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

// Bật bộ lọc cho mọi đường dẫn trên website
@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String path = req.getServletPath();

        // 1. Cho phép tự do đi qua: Màn hình Login, Quên mật khẩu, file tĩnh (CSS, JS, Hình ảnh)
        if (path.startsWith("/auth") || path.startsWith("/assets") || path.contains(".css") || path.contains(".js") || path.contains(".png") || path.contains(".jpg")) {
            chain.doFilter(request, response);
            return;
        }

        // 2. Chặn chưa đăng nhập: Nếu rỗng thì bắt buộc về trang đăng nhập
        boolean isLoggedIn = (session != null && session.getAttribute("nhanVienDangNhap") != null);
        if (!isLoggedIn) {
            res.sendRedirect(req.getContextPath() + "/auth?action=login");
            return;
        }

        // 3. Phân quyền chặt chẽ (Chỉ xét khi đã đăng nhập)
        NhanVien nv = (NhanVien) session.getAttribute("nhanVienDangNhap");
        int role = nv.getVaiTro().getMaVaiTro(); // 1 là Admin, 2 là Nhân Viên

        // Danh sách các trang CRUD hệ thống
        boolean isManagementPage = path.startsWith("/nhan-vien") ||
                path.startsWith("/san-pham") ||
                path.startsWith("/danh-muc") ||
                path.startsWith("/bien-the") ||
                path.startsWith("/khach-hang");

        if (role == 2 && isManagementPage) {
            // Nếu Nhân viên (role=2) cố tình gõ link quản trị viên -> Ép văng ra trang bán hàng
            session.setAttribute("message", "Lỗi: Bạn chỉ là Nhân Viên, không có quyền vào trang Quản lý!");
            res.sendRedirect(req.getContextPath() + "/ban-hang");
            return;
        }

        // 4. Nếu qua được hết bài kiểm tra, cho phép tải trang
        chain.doFilter(request, response);
    }
}