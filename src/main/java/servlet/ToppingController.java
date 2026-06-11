package servlet;

import model.Topping;
import service.ToppingService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 5,
        maxRequestSize = 1024 * 1024 * 10
)
@WebServlet(name = "ToppingController", value = "/topping")
public class ToppingController extends HttpServlet {

    private ToppingService toppingService = new ToppingService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "delete":
                String idDel = request.getParameter("id");
                request.getSession().setAttribute("message", toppingService.delete(idDel));
                response.sendRedirect(request.getContextPath() + "/topping?action=list");
                break;

            case "toggle-status":
                String idToggle = request.getParameter("id");
                int status = Integer.parseInt(request.getParameter("status"));
                request.getSession().setAttribute("message", toppingService.updateTrangThai(idToggle, status));
                response.sendRedirect(request.getContextPath() + "/topping?action=list");
                break;

            case "search":
                String keyword = request.getParameter("keyword");
                request.setAttribute("danhSach", toppingService.search(keyword));
                request.setAttribute("selectedKeyword", keyword);
                request.getRequestDispatcher("/views/topping.jsp").forward(request, response);
                break;

            case "list":
            default:
                request.setAttribute("danhSach", toppingService.getAll());
                request.getRequestDispatcher("/views/topping.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        String uploadPath = Util.ConfigUtil.getUploadDir();
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        if ("add".equals(action)) {
            Topping tp = new Topping();
            tp.setTenTopping(request.getParameter("tenTopping"));

            try {
                tp.setGiaBan(Integer.parseInt(request.getParameter("giaBan")));
            } catch (Exception e) {
                tp.setGiaBan(0);
            }

            Part filePart = request.getPart("hinhAnhFile");
            String fileName = filePart.getSubmittedFileName();
            if (fileName != null && !fileName.isEmpty()) {
                filePart.write(uploadPath + File.separator + fileName);
                tp.setHinhAnh(fileName);
            } else {
                tp.setHinhAnh("default.png");
            }

            String tb = toppingService.add(tp);
            request.getSession().setAttribute("message", tb);

        } else if ("update".equals(action)) {
            Topping tp = new Topping();
            tp.setMaTopping(request.getParameter("maTopping"));
            tp.setTenTopping(request.getParameter("tenTopping"));

            try {
                tp.setGiaBan(Integer.parseInt(request.getParameter("giaBan")));
            } catch (Exception e) {
                tp.setGiaBan(0);
            }

            Part filePart = request.getPart("hinhAnhFile");
            String fileName = filePart.getSubmittedFileName();
            if (fileName != null && !fileName.isEmpty()) {
                filePart.write(uploadPath + File.separator + fileName);
                tp.setHinhAnh(fileName);
            } else {
                String oldHinhAnh = request.getParameter("oldHinhAnh");
                tp.setHinhAnh(oldHinhAnh != null && !oldHinhAnh.isEmpty() ? oldHinhAnh : "default.png");
            }

            String tb = toppingService.update(tp);
            request.getSession().setAttribute("message", tb);
        }

        response.sendRedirect(request.getContextPath() + "/topping?action=list");
    }
}