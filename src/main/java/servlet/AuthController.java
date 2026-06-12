package servlet;

import model.NhanVien;
import service.AuthService;
import Util.EmailUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Random;

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
            if (session.getAttribute("otp_verified") != null && (boolean) session.getAttribute("otp_verified")) {
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
                HttpSession session = request.getSession();
                session.setAttribute("nhanVienDangNhap", nv);
                if (nv.getVaiTro().getMaVaiTro() == 1) {
                    response.sendRedirect(request.getContextPath() + "/admin");
                } else {
                    response.sendRedirect(request.getContextPath() + "/ban-hang");
                }
            } else {
                request.setAttribute("error", "Tên đăng nhập, mật khẩu sai hoặc tài khoản đã bị khóa!");
                request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            }
        } else if ("send-otp".equals(action)) {
            String email = request.getParameter("email");
            String tenDangNhap = authService.checkEmailAndGetUsername(email);
            if (tenDangNhap != null) {
                Random random = new Random();
                String otp = String.valueOf(100000 + random.nextInt(900000));

                if (EmailUtil.sendOtpEmail(email, otp)) {
                    HttpSession session = request.getSession();
                    session.setAttribute("reset_user", tenDangNhap);
                    session.setAttribute("reset_email", email);
                    session.setAttribute("saved_otp", otp);
                    // Lưu hạn sử dụng 5 phút (300,000 ms)
                    session.setAttribute("otp_expiry", System.currentTimeMillis() + 300000);
                    request.getRequestDispatcher("/views/verify_otp.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Lỗi hệ thống: Không thể gửi email OTP lúc này!");
                    request.getRequestDispatcher("/views/forgot_password.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "Email không tồn tại hoặc tài khoản bị khóa!");
                request.getRequestDispatcher("/views/forgot_password.jsp").forward(request, response);
            }
        } else if ("verify-otp".equals(action)) {
            HttpSession session = request.getSession();
            String userOtp = request.getParameter("otpInput");
            String savedOtp = (String) session.getAttribute("saved_otp");
            Long expiry = (Long) session.getAttribute("otp_expiry");

            if (expiry != null && System.currentTimeMillis() > expiry) {
                session.removeAttribute("saved_otp");
                request.setAttribute("error", "Mã OTP đã hết hạn (quá 5 phút). Vui lòng yêu cầu mã mới!");
                request.getRequestDispatcher("/views/verify_otp.jsp").forward(request, response);
            } else if (savedOtp != null && savedOtp.equals(userOtp)) {
                session.setAttribute("otp_verified", true);
                session.removeAttribute("saved_otp");
                response.sendRedirect(request.getContextPath() + "/auth?action=reset_form");
            } else {
                request.setAttribute("error", "Mã OTP không chính xác. Vui lòng thử lại!");
                request.getRequestDispatcher("/views/verify_otp.jsp").forward(request, response);
            }
        } else if ("reset".equals(action)) {
            HttpSession session = request.getSession();
            String tenDangNhap = (String) session.getAttribute("reset_user");
            String matKhauMoi = request.getParameter("newPassword");
            Boolean isVerified = (Boolean) session.getAttribute("otp_verified");
            if (isVerified != null && isVerified && tenDangNhap != null && authService.resetPassword(tenDangNhap, matKhauMoi)) {
                session.removeAttribute("reset_user");
                session.removeAttribute("reset_email");
                session.removeAttribute("otp_verified");
                request.setAttribute("message", "Mật khẩu đã được đổi thành công. Vui lòng đăng nhập lại!");
                request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Phiên đăng nhập hết hạn. Vui lòng thử lại từ đầu!");
                request.getRequestDispatcher("/views/reset_password.jsp").forward(request, response);
            }
        }
    }
}