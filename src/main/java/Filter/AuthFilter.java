package Filter;

import model.NhanVien;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;

@WebFilter("/*")
public class AuthFilter implements Filter {

    // Khai báo mảng chứa các đường dẫn bảo mật
    private static final String[] ADMIN_ROUTES = {
            "/nhan-vien", "/admin", "/san-pham", "/danh-muc",
            "/bien-the", "/khach-hang", "/topping", "/khuyen-mai", "/phuong-thuc"
    };

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String path = req.getServletPath();

        // 1. Cho phép tự do đi qua: Login, Quên pass, Assets, và API Webhook
        if (path.startsWith("/auth") || path.startsWith("/assets") || path.startsWith("/api/") || path.contains(".css") || path.contains(".js") || path.contains(".png") || path.contains(".jpg")) {
            chain.doFilter(request, response);
            return;
        }

        // 2. Chặn chưa đăng nhập
        boolean isLoggedIn = (session != null && session.getAttribute("nhanVienDangNhap") != null);
        if (!isLoggedIn) {
            res.sendRedirect(req.getContextPath() + "/auth?action=login");
            return;
        }

        // 3. Phân quyền chặt chẽ bằng Stream
        NhanVien nv = (NhanVien) session.getAttribute("nhanVienDangNhap");
        int role = nv.getVaiTro().getMaVaiTro();

        // Dùng Stream kiểm tra gọn gàng xem path hiện tại có nằm trong ADMIN_ROUTES không
        boolean isManagementPage = Arrays.stream(ADMIN_ROUTES).anyMatch(path::startsWith);

        if (role == 2 && isManagementPage) {
            session.setAttribute("message", "Lỗi: Bạn chỉ là Nhân Viên, không có quyền truy cập trang này!");
            res.sendRedirect(req.getContextPath() + "/ban-hang");
            return;
        }

        chain.doFilter(request, response);
    }
}