package servlet;

import Util.PaymentStore;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "CheckPaymentController", value = "/api/check-payment")
public class CheckPaymentController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String code = request.getParameter("code"); // VD: TEA12345

        if (code == null || code.trim().isEmpty()) {
            out.print("{\"status\":\"error\", \"message\":\"Thiếu mã giao dịch\"}");
            return;
        }

        // TỐI ƯU: Đọc từ Local Store của Webhook, tránh spam/polling API của SePay
        if (PaymentStore.transactions.containsKey(code)) {
            PaymentStore.transactions.remove(code); // Giải phóng bộ nhớ ngay sau khi check xong
            out.print("{\"status\":\"success\"}");
        } else {
            out.print("{\"status\":\"pending\"}");
        }
    }
}