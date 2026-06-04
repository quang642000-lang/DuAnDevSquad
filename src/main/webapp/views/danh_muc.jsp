<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Danh Mục</title>
    <!-- Thêm Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body class="bg-light">

<div class="container mt-5">
    <h2 class="mb-4 text-center text-primary fw-bold">QUẢN LÝ DANH MỤC SẢN PHẨM</h2>

    <!-- Hiển thị thông báo (Thêm/Sửa/Xóa thành công hoặc thất bại) từ Session -->
    <c:if test="${not empty sessionScope.message}">
        <c:choose>
            <c:when test="${fn:contains(sessionScope.message, 'Lỗi') || fn:contains(sessionScope.message, 'thất bại') || fn:contains(sessionScope.message, 'Không thể')}">
                <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i> <strong>Cảnh báo:</strong> ${sessionScope.message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:when>
            <c:otherwise>
                <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i> <strong>Thành công:</strong> ${sessionScope.message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:otherwise>
        </c:choose>
        <!-- Xóa message sau khi hiển thị để không lặp lại khi F5 -->
        <c:remove var="message" scope="session"/>
    </c:if>

    <div class="row mb-4">
        <!-- FORM THÊM DANH MỤC MỚI -->
        <div class="col-md-6 mx-auto">
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0"><i class="bi bi-plus-circle"></i> Thêm Danh Mục Mới</h5>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/danh-muc" method="post">
                        <input type="hidden" name="action" value="add">

                        <div class="mb-3">
                            <label for="tenDanhMuc" class="form-label fw-bold">Tên Danh Mục</label>
                            <input type="text" class="form-control" id="tenDanhMuc" name="tenDanhMuc" placeholder="Nhập tên danh mục (VD: Trà Sữa, Cà Phê...)" required>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 fw-bold">
                            Thêm Mới
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- BẢNG DANH SÁCH DANH MỤC -->
    <div class="card shadow-sm mb-5">
        <div class="card-header bg-dark text-white d-flex justify-content-between align-items-center">
            <h5 class="mb-0"><i class="bi bi-list-ul"></i> Danh Sách Danh Mục</h5>
            <a href="${pageContext.request.contextPath}/danh-muc?action=list" class="btn btn-sm btn-outline-light">
                <i class="bi bi-arrow-clockwise"></i> Làm mới
            </a>
        </div>
        <div class="card-body p-0">
            <table class="table table-striped table-hover mb-0 align-middle">
                <thead class="table-secondary">
                <tr>
                    <th class="text-center" width="10%">STT</th>
                    <th class="text-center" width="20%">Mã Danh Mục</th>
                    <th>Tên Danh Mục</th>
                    <th class="text-center" width="25%">Hành Động</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${not empty requestScope.danhSach}">
                        <c:forEach var="dm" items="${requestScope.danhSach}" varStatus="status">
                            <tr>
                                <td class="text-center fw-bold">${status.index + 1}</td>
                                <td class="text-center text-primary fw-bold">${dm.maDanhMuc}</td>
                                <td class="fw-medium">${dm.tenDanhMuc}</td>
                                <td class="text-center">
                                    <!-- Nút Mở Modal Sửa (Đã thêm xử lý chống lỗi chuỗi JS bằng fn:escapeXml) -->
                                    <button class="btn btn-sm btn-warning fw-bold text-dark" data-bs-toggle="modal" data-bs-target="#editModal"
                                            onclick="fillEditModal('${dm.maDanhMuc}', '${fn:escapeXml(dm.tenDanhMuc)}')">
                                        <i class="bi bi-pencil-square"></i> Sửa
                                    </button>

                                    <!-- Nút Xóa -->
                                    <a href="${pageContext.request.contextPath}/danh-muc?action=delete&id=${dm.maDanhMuc}"
                                       class="btn btn-sm btn-danger fw-bold"
                                       onclick="return confirm('Bạn có chắc chắn muốn xóa danh mục [${fn:escapeXml(dm.tenDanhMuc)}] không?');">
                                        <i class="bi bi-trash"></i> Xóa
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="4" class="text-center text-muted py-4">
                                <i class="bi bi-inbox fs-2 d-block mb-2"></i>
                                Chưa có danh mục nào trong hệ thống.
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- MODAL CẬP NHẬT DANH MỤC -->
<div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-warning">
                <h5 class="modal-title fw-bold text-dark" id="editModalLabel"><i class="bi bi-pencil-square"></i> Cập Nhật Danh Mục</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/danh-muc" method="post">
                <div class="modal-body">
                    <input type="hidden" name="action" value="update">

                    <!-- Trường ẩn chứa mã Danh Mục để gửi về server -->
                    <input type="hidden" name="maDanhMuc" id="edit_maDanhMuc">

                    <div class="mb-3">
                        <label class="form-label text-muted fw-bold">Mã Danh Mục</label>
                        <!-- Input chỉ hiển thị, không cho phép sửa mã -->
                        <input type="text" class="form-control bg-light fw-bold text-secondary" id="display_maDanhMuc" disabled>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Tên Danh Mục</label>
                        <input type="text" class="form-control" name="tenDanhMuc" id="edit_tenDanhMuc" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary fw-bold" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary fw-bold">Lưu Thay Đổi</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- JS Script để điền dữ liệu vào Modal khi bấm nút Sửa -->
<script>
    function fillEditModal(maDanhMuc, tenDanhMuc) {
        // Gán vào input hidden để submit
        document.getElementById("edit_maDanhMuc").value = maDanhMuc;
        // Gán vào input disabled để hiển thị
        document.getElementById("display_maDanhMuc").value = maDanhMuc;
        // Gán tên danh mục cũ
        document.getElementById("edit_tenDanhMuc").value = tenDanhMuc;
    }
</script>

</body>
</html>