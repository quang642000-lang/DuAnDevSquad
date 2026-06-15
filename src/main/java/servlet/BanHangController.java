package servlet;

import model.*;
import service.*;
import Util.SecurityUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "BanHangController", value = "/ban-hang")
public class BanHangController extends HttpServlet {

    private DanhMucService danhMucService = new DanhMucService();
    private SanPhamService sanPhamService = new SanPhamService();
    private BienTheSanPhamService bienTheService = new BienTheSanPhamService();
    private PhuongThucThanhToanService ptttService = new PhuongThucThanhToanService();
    private ToppingService toppingService = new ToppingService();
    private KhuyenMaiService khuyenMaiService = new KhuyenMaiService();
    private DonHangService donHangService = new DonHangService();
    private KhachHangService khachHangService = new KhachHangService();
    private NhanVienService nhanVienService = new NhanVienService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("clear-bill".equals(action)) {
            request.getSession().removeAttribute("recentOrder");
            request.getSession().removeAttribute("diemSuDungBill");
            response.setStatus(HttpServletResponse.SC_OK);
            return;
        }

        if ("check-phone".equals(action)) {
            String phone = request.getParameter("phone");
            KhachHang kh = khachHangService.timKiemTheoSdt(phone);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            if (kh != null) {
                out.print("{\"found\":true, \"tenKH\":\"" + kh.getTenKH() + "\", \"diem\":" + kh.getDiemTichLuy() + "}");
            } else {
                out.print("{\"found\":false}");
            }
            out.flush();
            return;
        }

        String filterDanhMuc = request.getParameter("maDanhMuc");
        request.setAttribute("danhSachDanhMuc", danhMucService.getAll());

        List<SanPham> dsSanPham;

        // KIỂM TRA: Nếu người dùng có bấm lọc danh mục -> Giao cho SQL Server lọc
        if (filterDanhMuc != null && !filterDanhMuc.isEmpty()) {
            // Truyền chuỗi rỗng "" cho keyword, và truyền mã danh mục vào để Database tự lọc
            dsSanPham = sanPhamService.search("", filterDanhMuc);
        }
        // Nếu không lọc -> Mới tải tất cả danh sách
        else {
            dsSanPham = sanPhamService.getAll();
        }

        request.setAttribute("danhSachSanPham", dsSanPham);

        request.setAttribute("danhSachSanPham", dsSanPham);
        request.setAttribute("danhSachBienThe", bienTheService.getAll());
        request.setAttribute("danhSachTopping", toppingService.getAll());

        List<PhuongThucThanhToan> listPTTT = ptttService.getAll().stream()
                .filter(pt -> pt.getTrangThai() == 1).collect(Collectors.toList());
        request.setAttribute("danhSachPTTT", listPTTT);
        request.setAttribute("danhSachKhuyenMai", khuyenMaiService.getAll());

        request.getRequestDispatcher("/views/ban_hang.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("update-profile".equals(action)) {
            NhanVien nvSession = (NhanVien) request.getSession().getAttribute("nhanVienDangNhap");
            String oldPass = request.getParameter("oldPass");
            String newPass = request.getParameter("newPass");
            String hoTen = request.getParameter("hoTen");
            String sdt = request.getParameter("sdt");
            String email = request.getParameter("email");

            // ĐÃ BỔ SUNG: Kiểm tra null hoặc chuỗi rỗng trước khi băm để tránh NullPointerException
            if (oldPass == null || oldPass.trim().isEmpty()) {
                request.getSession().setAttribute("message", "Lỗi: Vui lòng nhập mật khẩu hiện tại để xác nhận thay đổi!");
                response.sendRedirect(request.getContextPath() + "/ban-hang");
                return;
            }

            String hashedOldPass = SecurityUtil.hashPassword(oldPass);

            if (hashedOldPass.equals(nvSession.getMatKhau())) {
                nvSession.setHoTen(hoTen);
                nvSession.setSDT(sdt);
                nvSession.setEmail(email);

                // 1. Cập nhật các thông tin cơ bản trước (Họ tên, SĐT, Email)
                boolean isUpdated = nhanVienService.update(nvSession).contains("thành công");

                if(isUpdated) {
                    // 2. Nếu nhân viên có nhập mật khẩu mới, băm mật khẩu và gọi hàm đổi riêng biệt
                    if (newPass != null && !newPass.trim().isEmpty()) {
                        String hashedNewPass = SecurityUtil.hashPassword(newPass);
                        nhanVienService.resetPassword(nvSession.getMaNV(), hashedNewPass);
                        nvSession.setMatKhau(hashedNewPass); // Cập nhật lại session
                    }

                    request.getSession().setAttribute("nhanVienDangNhap", nvSession);
                    request.getSession().setAttribute("message", "Cập nhật thông tin cá nhân thành công!");
                } else {
                    request.getSession().setAttribute("message", "Lỗi: Không thể cập nhật vào cơ sở dữ liệu!");
                }
            } else {
                request.getSession().setAttribute("message", "Lỗi: Mật khẩu hiện tại không chính xác. Đã hủy thay đổi!");
            }
            response.sendRedirect(request.getContextPath() + "/ban-hang");
            return;
        }

        if ("checkout".equals(action)) {
            try {
                DonHang dh = new DonHang();
                NhanVien nv = (NhanVien) request.getSession().getAttribute("nhanVienDangNhap");
                dh.setNhanVien(nv);

                String sdtKhach = request.getParameter("sdtKhachHang");
                String tenKhach = request.getParameter("tenKhachHang");

                // Chống NumberFormatException gây sập trang khi parse dữ liệu rỗng
                int diemSuDung = 0;
                int tongTienHang = 0;
                int soTienKhachDua = 0;
                try {
                    if(request.getParameter("diemSuDung") != null && !request.getParameter("diemSuDung").isEmpty()) {
                        diemSuDung = Integer.parseInt(request.getParameter("diemSuDung"));
                    }
                    if(request.getParameter("tongTienHang") != null && !request.getParameter("tongTienHang").isEmpty()) {
                        tongTienHang = Integer.parseInt(request.getParameter("tongTienHang"));
                    }
                    if(request.getParameter("tienKhachDua") != null && !request.getParameter("tienKhachDua").isEmpty()) {
                        soTienKhachDua = Integer.parseInt(request.getParameter("tienKhachDua"));
                    }
                } catch (NumberFormatException e) {
                    request.getSession().setAttribute("message", "Lỗi: Dữ liệu tiền hoặc điểm nhập vào không hợp lệ!");
                    response.sendRedirect(request.getContextPath() + "/ban-hang");
                    return;
                }

                dh.setTongTienHang(tongTienHang);
                dh.setSoTienKhachDua(soTienKhachDua);

                String maPTTT = request.getParameter("maPTTT");
                PhuongThucThanhToan pttt = new PhuongThucThanhToan();
                pttt.setMaPTTT(maPTTT);
                for (PhuongThucThanhToan pt : ptttService.getAll()) {
                    if (pt.getMaPTTT().equals(maPTTT)) {
                        pttt.setTenPhuongThuc(pt.getTenPhuongThuc());
                        break;
                    }
                }
                dh.setPhuongThucThanhToan(pttt);

                String maKM = request.getParameter("maKM");
                if (maKM != null && !maKM.isEmpty()) {
                    KhuyenMai km = new KhuyenMai();
                    km.setMaKM(maKM);
                    dh.setKhuyenMai(km);
                }

                // Gọi hàm phụ trợ đã được tách
                buildCartItems(request, dh);

                String tb = donHangService.taoDonHangThanhToan(dh, sdtKhach, tenKhach, diemSuDung);
                if (tb.contains("thành công")) {
                    request.getSession().setAttribute("recentOrder", dh);
                    request.getSession().setAttribute("diemSuDungBill", diemSuDung);
                }
                request.getSession().setAttribute("message", tb);

            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("message", "Lỗi dữ liệu thanh toán: " + e.getMessage());
            }
        }
        response.sendRedirect(request.getContextPath() + "/ban-hang");
    }

    // Hàm phụ trợ xử lý giỏ hàng
    private void buildCartItems(HttpServletRequest request, DonHang dh) {
        String[] indexArr = request.getParameterValues("itemIndex[]");
        if (indexArr != null) {
            for (String idx : indexArr) {
                ChiTietDonHang ct = new ChiTietDonHang();

                BienTheSanPham bt = new BienTheSanPham();
                bt.setMaBienThe(request.getParameter("maBT_" + idx));

                SanPham sp = new SanPham();
                sp.setTenSanPham(request.getParameter("tenMon_" + idx));
                bt.setSanPham(sp);
                ct.setBienThe(bt);

                ct.setSoLuong(Integer.parseInt(request.getParameter("soLuong_" + idx)));
                ct.setGiaChot(Integer.parseInt(request.getParameter("giaChot_" + idx)));
                ct.setMucDa(request.getParameter("da_" + idx));
                ct.setMucDuong(request.getParameter("duong_" + idx));
                ct.setGhiChu("");

                String[] toppings = request.getParameterValues("toppings_" + idx + "[]");
                if (toppings != null) {
                    for (String tpInfo : toppings) {
                        String[] parts = tpInfo.split("\\|");
                        ChiTietTopping ctt = new ChiTietTopping();
                        Topping t = new Topping();
                        t.setMaTopping(parts[0]);
                        if (parts.length > 3) t.setTenTopping(parts[3]);
                        ctt.setTopping(t);

                        int qtyTopping = Integer.parseInt(parts[1]);
                        int unitPrice = Integer.parseInt(parts[2]);

                        ctt.setSoLuongTopping(qtyTopping * ct.getSoLuong());
                        ctt.setGiaChot(unitPrice);
                        ct.getDanhSachTopping().add(ctt);
                    }
                }
                dh.getDanhSachChiTiet().add(ct);
            }
        }
    }
}