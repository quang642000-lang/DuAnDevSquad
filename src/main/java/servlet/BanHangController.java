package servlet;

import model.*;
import service.*;

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

        List<SanPham> dsSanPham = sanPhamService.getAll();
        if (filterDanhMuc != null && !filterDanhMuc.isEmpty()) {
            dsSanPham = dsSanPham.stream()
                    .filter(sp -> sp.getDanhMuc() != null && sp.getDanhMuc().getMaDanhMuc().equals(filterDanhMuc))
                    .collect(Collectors.toList());
        }
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

        if ("checkout".equals(action)) {
            try {
                DonHang dh = new DonHang();

                NhanVien nv = (NhanVien) request.getSession().getAttribute("nhanVienDangNhap");
                dh.setNhanVien(nv);

                String sdtKhach = request.getParameter("sdtKhachHang");
                String tenKhach = request.getParameter("tenKhachHang");

                int diemSuDung = 0;
                try { diemSuDung = Integer.parseInt(request.getParameter("diemSuDung")); } catch (Exception ignored){}

                dh.setTongTienHang(Integer.parseInt(request.getParameter("tongTienHang")));
                dh.setSoTienKhachDua(Integer.parseInt(request.getParameter("tienKhachDua")));

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

                        SanPham sp = new SanPham();
                        // ĐÃ SỬA LỖI BUILD TẠI ĐÂY:
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
}