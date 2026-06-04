package servlet;

import model.BienTheSanPham;
import model.NhanVien;
import service.BienTheSanPhamService;
import service.DanhMucService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "BanHangController", value = "/ban-hang")
public class BanHangController extends HttpServlet {

    private DanhMucService danhMucService = new DanhMucService();
    private BienTheSanPhamService bienTheService = new BienTheSanPhamService();

    // TODO: Sau này bạn sẽ khai báo thêm HoaDonService ở đây để lưu đơn hàng
    // private HoaDonService hoaDonService = new HoaDonService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Lấy danh sách Danh Mục (Trà sữa, Cà phê...) để làm thanh lọc ngang
        request.setAttribute("danhSachDanhMuc", danhMucService.getAll());

        // 2. Lấy danh sách tất cả các món đang bán (Biến thể) đẩy ra màn hình
        List<BienTheSanPham> danhSachBienThe = bienTheService.getAll();
        request.setAttribute("danhSachBienThe", danhSachBienThe);

        // Chuyển tiếp sang giao diện POS
        request.getRequestDispatcher("/views/ban_hang.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("checkout".equals(action)) {
            // Lấy thông tin từ form HTML (Giỏ hàng Javascript gửi lên)
            String[] maBTArray = request.getParameterValues("maBT[]");
            String[] soLuongArray = request.getParameterValues("soLuong[]");
            String sdtKhachHang = request.getParameter("sdtKhachHang");

            // Lấy thông tin nhân viên đang trực máy POS
            NhanVien nv = (NhanVien) request.getSession().getAttribute("nhanVienDangNhap");

            if (maBTArray != null && maBTArray.length > 0) {
                // CHỖ NÀY ĐỂ LƯU VÀO DATABASE
                // Bước 1: Tạo HÓA ĐƠN mới (Lưu SĐT Khách, Mã Nhân viên, Ngày tạo...)
                // Bước 2: Dùng vòng lặp for chạy qua mảng maBTArray để lưu HÓA ĐƠN CHI TIẾT

                // Demo tạm thời khi chưa có bảng HoaDon trong DB
                System.out.println("--- CÓ KHÁCH ĐẶT MUA ---");
                for (int i = 0; i < maBTArray.length; i++) {
                    System.out.println("Mã món: " + maBTArray[i] + " | Số lượng: " + soLuongArray[i]);
                }

                request.getSession().setAttribute("message", "Thanh toán thành công! (Dữ liệu đã gửi về Server chờ lưu Database)");
            } else {
                request.getSession().setAttribute("message", "Lỗi: Giỏ hàng trống!");
            }
        }

        // Trả về lại màn hình bán hàng để đón khách tiếp theo
        response.sendRedirect(request.getContextPath() + "/ban-hang");
    }
}