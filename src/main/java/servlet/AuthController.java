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
            // Chỉ cho phép vào trang Reset khi đã xác minh OTP thành công
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

        } else if ("send-otp".equals(action)) { // XỬ LÝ GỬI EMAIL OTP
            String email = request.getParameter("email");
            String tenDangNhap = authService.checkEmailAndGetUsername(email);

            if (tenDangNhap != null) {
                // Tạo OTP ngẫu nhiên 6 số
                Random random = new Random();
                int otpValue = 100000 + random.nextInt(900000);
                String otp = String.valueOf(otpValue);

                // Gửi Email
                boolean emailSent = EmailUtil.sendOtpEmail(email, otp);

                if (emailSent) {
                    HttpSession session = request.getSession();
                    session.setAttribute("reset_user", tenDangNhap);
                    session.setAttribute("reset_email", email);
                    session.setAttribute("saved_otp", otp);

                    // Chuyển hướng tới trang nhập mã OTP
                    request.getRequestDispatcher("/views/verify_otp.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Lỗi hệ thống: Không thể gửi email OTP lúc này!");
                    request.getRequestDispatcher("/views/forgot_password.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "Email không tồn tại trong hệ thống hoặc tài khoản đã bị khóa!");
                request.getRequestDispatcher("/views/forgot_password.jsp").forward(request, response);
            }

        } else if ("verify-otp".equals(action)) { // KIỂM TRA MÃ OTP
            HttpSession session = request.getSession();
            String userOtp = request.getParameter("otpInput");
            String savedOtp = (String) session.getAttribute("saved_otp");

            if (savedOtp != null && savedOtp.equals(userOtp)) {
                // Đánh dấu là đã xác minh thành công để cho phép vào trang đổi pass
                session.setAttribute("otp_verified", true);
                session.removeAttribute("saved_otp"); // Hủy OTP sau khi dùng
                response.sendRedirect(request.getContextPath() + "/auth?action=reset_form");
            } else {
                request.setAttribute("error", "Mã OTP không chính xác. Vui lòng thử lại!");
                request.getRequestDispatcher("/views/verify_otp.jsp").forward(request, response);
            }

        } else if ("reset".equals(action)) { // LƯU MẬT KHẨU MỚI
            HttpSession session = request.getSession();
            String tenDangNhap = (String) session.getAttribute("reset_user");
            String matKhauMoi = request.getParameter("newPassword");
            Boolean isVerified = (Boolean) session.getAttribute("otp_verified");

            if (isVerified != null && isVerified && tenDangNhap != null && authService.resetPassword(tenDangNhap, matKhauMoi)) {
                // Xóa toàn bộ session reset
                session.removeAttribute("reset_user");
                session.removeAttribute("reset_email");
                session.removeAttribute("otp_verified");

                request.setAttribute("message", "Mật khẩu đã được đổi thành công. Vui lòng đăng nhập lại!");
                request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Lỗi hoặc phiên đăng nhập hết hạn. Vui lòng thử lại từ đầu!");
                request.getRequestDispatcher("/views/reset_password.jsp").forward(request, response);
            }
        }
    }
}