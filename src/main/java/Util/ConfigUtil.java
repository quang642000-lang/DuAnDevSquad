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
                System.err.println(" ❌  LỖI: Không tìm thấy file application.properties trong thư mục resources!");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static String getProperty(String key) {
        String val = properties.getProperty(key);
        // Tích hợp đọc biến môi trường hệ điều hành (.env)
        if (val != null && val.startsWith("${") && val.endsWith("}")) {
            String inner = val.substring(2, val.length() - 1);
            String[] parts = inner.split(":", 2);
            String envKey = parts[0];
            String defaultVal = parts.length > 1 ? parts[1] : null;

            String envVal = System.getenv(envKey);
            if (envVal != null && !envVal.isEmpty()) {
                return envVal;
            }
            return defaultVal;
        }
        return val;
    }

    public static String getUploadDir() {
        String dir = getProperty("upload.dir");
        if (dir == null || dir.isEmpty()) {
            dir = System.getProperty("user.home") + "/tea_pos_images";
        }
        return dir;
    }
}