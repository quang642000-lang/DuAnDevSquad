package Util;

import java.io.InputStream;
import java.util.Properties;

public class ConfigUtil {
    private static Properties properties = new Properties();

    static {
        try (InputStream input = Thread.currentThread().getContextClassLoader().getResourceAsStream("application.properties")) {
            if (input != null) {
                properties.load(input);
            } else {
                System.err.println("❌ LỖI: Không tìm thấy file application.properties trong thư mục resources!");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static String getProperty(String key) {
        return properties.getProperty(key);
    }

    // Lấy thư mục upload ảnh, nếu file properties lỗi thì mặc định lưu vào thư mục của người dùng HĐH
    public static String getUploadDir() {
        String dir = properties.getProperty("upload.dir");
        if (dir == null || dir.isEmpty()) {
            dir = System.getProperty("user.home") + "/tea_pos_images";
        }
        return dir;
    }
}
