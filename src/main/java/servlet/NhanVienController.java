package servlet;

import model.NhanVien;
import model.VaiTro;
import service.NhanVienService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "NhanVienController", value = "/nhan-vien")
public class NhanVienController extends HttpServlet {

    private NhanVienService nhanVienService = new NhanVienService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "toggle-status":
                String idToggle = request.getParameter("id");
                int status = Integer.parseInt(request.getParameter("status"));
                request.getSession().setAttribute("message", nhanVienService.updateTrangThai(idToggle, status));
                response.sendRedirect(request.getContextPath() + "/nhan-vien?action=list");
                break;

            case "list":
            default:
                request.setAttribute("danhSach", nhanVienService.getAll());
                request.getRequestDispatcher("/views/nhan_vien.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            NhanVien nv = new NhanVien();
            nv.setHoTen(request.getParameter("hoTen"));
            nv.setTenDangNhap(request.getParameter("tenDangNhap"));
            nv.setMatKhau(request.getParameter("matKhau"));
            nv.setSDT(request.getParameter("SDT"));

            VaiTro vt = new VaiTro();
            vt.setMaVaiTro(Integer.parseInt(request.getParameter("maVaiTro")));
            nv.setVaiTro(vt);

            request.getSession().setAttribute("message", nhanVienService.add(nv));

        } else if ("update".equals(action)) {
            NhanVien nv = new NhanVien();
            nv.setMaNV(request.getParameter("maNV"));
            nv.setHoTen(request.getParameter("hoTen"));
            nv.setTenDangNhap(request.getParameter("tenDangNhap"));
            nv.setMatKhau(request.getParameter("matKhau"));
            nv.setSDT(request.getParameter("SDT"));

            VaiTro vt = new VaiTro();
            vt.setMaVaiTro(Integer.parseInt(request.getParameter("maVaiTro")));
            nv.setVaiTro(vt);

            request.getSession().setAttribute("message", nhanVienService.update(nv));
        }

        response.sendRedirect(request.getContextPath() + "/nhan-vien?action=list");
    }
}