package servlet;

import model.*;
import service.*;

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
    private PhuongThucThanhToanService ptttService = new PhuongThucThanhToanService();
    private ToppingService toppingService = new ToppingService();
    private KhuyenMaiService khuyenMaiService = new KhuyenMaiService();
    private DonHangService donHangService = new DonHangService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String filterDanhMuc = request.getParameter("maDanhMuc");
        request.setAttribute("danhSachDanhMuc", danhMucService.getAll());

        List<BienTheSanPham> menu = (filterDanhMuc != null && !filterDanhMuc.isEmpty())
                ? bienTheService.search("", filterDanhMuc)
                : bienTheService.getAll();
        request.setAttribute("danhSachBienThe", menu);

        request.setAttribute("danhSachTopping", toppingService.getAll());

        List<PhuongThucThanhToan> listPTTT = ptttService.getAll();
        listPTTT.removeIf(pt -> pt.getTrangThai() != 1);
        request.setAttribute("danhSachPTTT", listPTTT);

        request.setAttribute("danhSachKhuyenMai", khuyenMaiService.getAll());

        request.getRequestDispatcher("/views/ban_hang.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("checkout".equals(action)) {
            try {
                DonHang dh = new DonHang();

                NhanVien nv = (NhanVien) request.getSession().getAttribute("nhanVienDangNhap");
                dh.setNhanVien(nv);

                String sdtKhach = request.getParameter("sdtKhachHang");
                String tenKhach = request.getParameter("tenKhachHang");

                // ĐÃ XÓA: Lấy tongTienHang, tienGiamGia, tongPhaiTra từ JSP (Lỗ hổng bảo mật)

                // Tiền khách đưa lấy về để validate sau
                String tienKhachDuaStr = request.getParameter("tienKhachDua");
                int tienKhachDua = (tienKhachDuaStr != null && !tienKhachDuaStr.isEmpty()) ? Integer.parseInt(tienKhachDuaStr) : 0;
                dh.setSoTienKhachDua(tienKhachDua);

                PhuongThucThanhToan pttt = new PhuongThucThanhToan();
                pttt.setMaPTTT(request.getParameter("maPTTT"));
                dh.setPhuongThucThanhToan(pttt);

                String maKM = request.getParameter("maKM");
                if (maKM != null && !maKM.isEmpty()) {
                    KhuyenMai km = new KhuyenMai();
                    km.setMaKM(maKM);
                    dh.setKhuyenMai(km);
                }

                String[] indexArr = request.getParameterValues("itemIndex[]");

                if (indexArr != null) {
                    for (String idx : indexArr) {
                        ChiTietDonHang ct = new ChiTietDonHang();
                        BienTheSanPham bt = new BienTheSanPham();
                        bt.setMaBienThe(request.getParameter("maBT_" + idx));
                        ct.setBienThe(bt);

                        int soLuongLy = Integer.parseInt(request.getParameter("soLuong_" + idx));
                        ct.setSoLuong(soLuongLy);
                        // Bỏ lấy giaChot từ frontend
                        ct.setMucDa(request.getParameter("da_" + idx));
                        ct.setMucDuong(request.getParameter("duong_" + idx));
                        ct.setGhiChu("");

                        // Xử lý mảng Topping (Bỏ giá gửi từ Frontend)
                        String[] toppings = request.getParameterValues("toppings_" + idx + "[]");
                        if (toppings != null) {
                            for (String tpInfo : toppings) {
                                // Split giờ chỉ lấy maTopping và soLuong
                                String[] parts = tpInfo.split("\\|");
                                ChiTietTopping ctt = new ChiTietTopping();
                                Topping t = new Topping();
                                t.setMaTopping(parts[0]);
                                ctt.setTopping(t);

                                int soLuongTopping1Ly = Integer.parseInt(parts[1]);
                                ctt.setSoLuongTopping(soLuongTopping1Ly * soLuongLy);

                                ct.getDanhSachTopping().add(ctt);
                            }
                        }
                        dh.getDanhSachChiTiet().add(ct);
                    }
                }

                // GỌI SERVICE LƯU (Service sẽ tự tính lại tiền)
                String tb = donHangService.taoDonHangThanhToan(dh, sdtKhach, tenKhach);
                request.getSession().setAttribute("message", tb);

            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("message", "Lỗi dữ liệu thanh toán: Vui lòng kiểm tra lại đơn hàng.");
            }
        }

        response.sendRedirect(request.getContextPath() + "/ban-hang");
    }
}