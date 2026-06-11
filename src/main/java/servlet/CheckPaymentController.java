package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;

@WebServlet(name = "CheckPaymentController", value = "/api/check-payment")
public class CheckPaymentController extends HttpServlet {

    // CHÚ Ý: LẤY TỪ TRANG CÀI ĐẶT CỦA SEPAY (Mục "Tích hợp" -> "API")
    // Thay chuỗi bên dưới bằng Token API của bạn
    private static final String SEPAY_TOKEN = Util.ConfigUtil.getProperty("sepay.token");
    private static final String SEPAY_API_URL = "https://my.sepay.vn/userapi/transactions/list";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String code = request.getParameter("code"); // Mã hóa đơn (VD: TEA123456)

        if (code == null || code.trim().isEmpty()) {
            out.print("{\"status\":\"error\", \"message\":\"Thiếu mã giao dịch\"}");
            return;
        }

        try {
            URL url = new URL(SEPAY_API_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "Bearer " + SEPAY_TOKEN);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setConnectTimeout(5000); // Timeout kết nối 5s
            conn.setReadTimeout(5000); // Timeout đọc dữ liệu 5s

            int responseCode = conn.getResponseCode();
            System.out.println("SePay API Status: " + responseCode); // Log để kiểm tra trong Console

            if (responseCode == 200) {
                BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
                StringBuilder content = new StringBuilder();
                String inputLine;
                while ((inputLine = in.readLine()) != null) {
                    content.append(inputLine);
                }
                in.close();

                String jsonResponse = content.toString();

                // Kiểm tra mã giao dịch có xuất hiện trong nội dung chuyển khoản trả về từ SePay không
                if (jsonResponse.contains(code)) {
                    System.out.println("Giao dịch " + code + " đã thanh toán thành công!");
                    out.print("{\"status\":\"success\"}");
                } else {
                    System.out.println("Giao dịch " + code + " đang chờ...");
                    out.print("{\"status\":\"pending\"}");
                }
            } else if (responseCode == 401) {
                System.err.println("LỖI 401: Token SePay không hợp lệ! Vui lòng vào trang quản trị my.sepay.vn -> Tích hợp -> API Keys để copy lại Token chính xác.");
                out.print("{\"status\":\"error\", \"message\":\"Lỗi 401: Sai Token API\"}");
            } else {
                System.out.println("Lỗi gọi API SePay: HTTP " + responseCode);
                out.print("{\"status\":\"error\", \"message\":\"Lỗi kết nối API\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"status\":\"error\", \"message\":\"" + e.getMessage() + "\"}");
        }
    }
}