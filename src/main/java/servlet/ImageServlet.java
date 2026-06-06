package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "ImageServlet", value = "/image/*")
public class ImageServlet extends HttpServlet {

    // Đường dẫn kho lưu trữ ảnh cố định trên máy tính
    private static final String BASE_PATH = "C:" + File.separator + "tea_pos_images";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Tách lấy tên file ảnh từ URL đường dẫn tách biệt dấu gạch chéo đầu tiên
        String fileName = URLDecoder.decode(pathInfo.substring(1), StandardCharsets.UTF_8.name());
        File file = new File(BASE_PATH, fileName);

        // Kiểm tra file tồn tại trên ổ đĩa, nếu không tìm thấy sẽ sử dụng ảnh default hệ thống
        if (!file.exists() || file.isDirectory()) {
            String defaultPath = getServletContext().getRealPath("") + File.separator + "assets" + File.separator + "img" + File.separator + "default.png";
            file = new File(defaultPath);
            if (!file.exists()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
        }

        // Phân tích định dạng MimeType của file ảnh gửi về cho trình duyệt
        String contentType = getServletContext().getMimeType(file.getName());
        if (contentType == null) {
            contentType = "application/octet-stream";
        }

        response.setContentType(contentType);
        response.setContentLength((int) file.length());

        // Đọc dữ liệu từ ổ cứng và ghi trực tiếp ra luồng Output của Response
        try (FileInputStream in = new FileInputStream(file);
             OutputStream out = response.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
            out.flush();
        }
    }
}