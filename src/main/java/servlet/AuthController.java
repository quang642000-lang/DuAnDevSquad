package servlet;

import model.NhanVien;
import service.AuthService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "AuthController", value = "/auth")
public class AuthController extends HttpServlet {

    private AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("logout".equals(action)) {
            HttpSession session = request.getSession();
            session.removeAttribute("nhanVienDangNhap");
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/auth?action=login");

        } else if ("forgot".equals(action)) {
            request.getRequestDispatcher("/views/forgot_password.jsp").forward(request, response);

        } else if ("reset_form".equals(action)) {
            HttpSession session = request.getSession();
            if (session.getAttribute("reset_user") != null) {
                request.getRequestDispatcher("/views/reset_password.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/auth?action=forgot");
            }
        } else {
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("login".equals(action)) {
            String tenDangNhap = request.getParameter("username");
            String matKhau = request.getParameter("password");

            NhanVien nv = authService.login(tenDangNhap, matKhau);

            if (nv != null) {
                // Đăng nhập thành công
                HttpSession session = request.getSession();
                session.setAttribute("nhanVienDangNhap", nv);

                // --- PHÂN QUYỀN ĐIỀU HƯỚNG ---
                if (nv.getVaiTro().getMaVaiTro() == 1) {
                    // 1: Admin -> Điều hướng vào trang quản lý đầu tiên (VD: Quản lý nhân viên)
                    response.sendRedirect(request.getContextPath() + "/nhan-vien");
                } else {
                    // 2: Nhân viên -> Bắt buộc điều hướng vào màn hình POS (Bán hàng)
                    response.sendRedirect(request.getContextPath() + "/ban-hang");
                }
                // -----------------------------
            } else {
                // Đăng nhập thất bại
                request.setAttribute("error", "Tên đăng nhập, mật khẩu sai hoặc tài khoản đã bị khóa!");
                request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            }

        } else if ("forgot".equals(action)) {
            String tenDangNhap = request.getParameter("username");
            String sdt = request.getParameter("sdt");

            boolean isValid = authService.verifyPhone(tenDangNhap, sdt);
            if (isValid) {
                HttpSession session = request.getSession();
                session.setAttribute("reset_user", tenDangNhap);
                response.sendRedirect(request.getContextPath() + "/auth?action=reset_form");
            } else {
                request.setAttribute("error", "Tài khoản và số điện thoại không khớp!");
                request.getRequestDispatcher("/views/forgot_password.jsp").forward(request, response);
            }

        } else if ("reset".equals(action)) {
            HttpSession session = request.getSession();
            String tenDangNhap = (String) session.getAttribute("reset_user");
            String matKhauMoi = request.getParameter("newPassword");

            if (tenDangNhap != null && authService.resetPassword(tenDangNhap, matKhauMoi)) {
                session.removeAttribute("reset_user");
                request.setAttribute("message", "Mật khẩu đã được đổi thành công. Vui lòng đăng nhập lại!");
                request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Đổi mật khẩu thất bại!");
                request.getRequestDispatcher("/views/reset_password.jsp").forward(request, response);
            }
        }
    }
}