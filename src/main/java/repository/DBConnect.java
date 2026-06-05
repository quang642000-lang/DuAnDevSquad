package repository;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnect {

    // ========================================================
    // ⚠️ BẠN BẮT BUỘC PHẢI SỬA 3 DÒNG NÀY CHO KHỚP VỚI SQL SERVER CỦA BẠN
    // ========================================================
    private static final String HOST = "localhost";
    private static final String PORT = "1433";

    // 1. Sửa thành Tên Database bạn đã tạo trong SQL Server
    private static final String DB_NAME = "QuanLyTraSua";

    // 2. Sửa thành Tài khoản SQL Server của bạn (Mặc định thường là sa)
    private static final String USER = "sa";

    // 3. Sửa thành Mật khẩu tài khoản sa của bạn
    private static final String PASS = "!";

    private static final String URL = "jdbc:sqlserver://" + HOST + ":" + PORT + ";databaseName=" + DB_NAME + ";encrypt=true;trustServerCertificate=true;";

    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            con = DriverManager.getConnection(URL, USER, PASS);
        } catch (ClassNotFoundException e) {
            System.err.println("❌ LỖI: Thiếu thư viện mssql-jdbc trong pom.xml!");
        } catch (SQLException e) {
            System.err.println("❌ LỖI KẾT NỐI DATABASE:");
            System.err.println("- Tên DB đang cấu hình: " + DB_NAME);
            System.err.println("- User đang dùng: " + USER);
            System.err.println("- Mật khẩu có đúng không?");
            System.err.println("👉 Chi tiết mã lỗi từ SQL Server: " + e.getMessage());
        }
        return con;
    }

    /**
     * HÀM TEST NHANH (Không cần chạy web)
     * Bạn hãy chuột phải vào file này -> Chọn "Run 'DBConnect.main()'"
     */
    public static void main(String[] args) {
        System.out.println("⏳ Đang thử kết nối tới SQL Server...");
        Connection con = getConnection();

        if (con != null) {
            System.out.println("✅ CHÚC MỪNG! KẾT NỐI THÀNH CÔNG TỚI DATABASE: " + DB_NAME);
        } else {
            System.out.println("❌ KẾT NỐI THẤT BẠI. HÃY KIỂM TRA LẠI DB_NAME, USER VÀ PASS NHÉ!");
        }
    }
}