package servlet;

import Util.PaymentStore;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;

@WebServlet(name = "SePayWebhookController", value = "/api/sepay-webhook")
public class SePayWebhookController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) {
        try (BufferedReader reader = request.getReader()) {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) sb.append(line);

            JsonObject payload = JsonParser.parseString(sb.toString()).getAsJsonObject();
            String content = payload.get("content").getAsString().toUpperCase(); // Đổi tất cả thành IN HOA để chống phân biệt hoa/thường

            // Tìm đoạn mã bắt đầu bằng chữ TEA và theo sau là các chữ số (VD: TEA2606123456) bất chấp khoảng trắng
            java.util.regex.Matcher matcher = java.util.regex.Pattern.compile("TEA\\d+").matcher(content);
            while (matcher.find()) {
                PaymentStore.transactions.put(matcher.group(), true); // Bắt dính mã và đưa vào bộ nhớ tạm
            }

            response.setStatus(200);
            response.getWriter().write("{\"success\":true}");
        } catch (Exception e) {
            response.setStatus(400);
        }
    }
}