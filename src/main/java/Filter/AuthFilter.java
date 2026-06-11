package Filter;

import model.NhanVien;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String path = req.getServletPath();

        // 1. Cho phép tự do đi qua: Login, Quên pass, Assets
        if (path.startsWith("/auth") || path.startsWith("/assets") || path.contains(".css") || path.contains(".js") || path.contains(".png") || path.contains(".jpg")) {
            chain.doFilter(request, response);
            return;
        }

        // 2. Chặn chưa đăng nhập
        boolean isLoggedIn = (session != null && session.getAttribute("nhanVienDangNhap") != null);
        if (!isLoggedIn) {
            res.sendRedirect(req.getContextPath() + "/auth?action=login");
            return;
        }

        // 3. ĐÃ SỬA: Phân quyền chặt chẽ (Bổ sung các route còn thiếu để chống thu ngân vượt rào)
        NhanVien nv = (NhanVien) session.getAttribute("nhanVienDangNhap");
        int role = nv.getVaiTro().getMaVaiTro();

        boolean isManagementPage = path.startsWith("/nhan-vien") ||
                path.startsWith("/admin") ||
                path.startsWith("/san-pham") ||
                path.startsWith("/danh-muc") ||
                path.startsWith("/bien-the") ||
                path.startsWith("/khach-hang") ||
                path.startsWith("/topping") ||
                path.startsWith("/khuyen-mai") ||
                path.startsWith("/phuong-thuc");

        if (role == 2 && isManagementPage) {
            session.setAttribute("message", "Lỗi: Bạn chỉ là Nhân Viên, không có quyền truy cập trang này!");
            res.sendRedirect(req.getContextPath() + "/ban-hang");
            return;
        }

        chain.doFilter(request, response);
    }
}