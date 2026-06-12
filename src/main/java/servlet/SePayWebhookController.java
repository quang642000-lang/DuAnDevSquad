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
            String content = payload.get("content").getAsString(); // Nội dung chuyển khoản

            // Tách mã TEA từ nội dung CK (VD: TEA123456)
            for (String part : content.split("\\s+")) {
                if (part.startsWith("TEA")) {
                    PaymentStore.transactions.put(part, true);
                }
            }
            response.setStatus(200);
            response.getWriter().write("{\"success\":true}");
        } catch (Exception e) {
            response.setStatus(400);
        }
    }
}