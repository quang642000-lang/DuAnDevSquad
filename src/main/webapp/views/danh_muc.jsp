<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Danh Mục</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>body { background-color: #f4f6f9; }</style>
</head>
<body>

<div class="container mt-4 mb-5">
    <!-- HEADER & NÚT QUAY LẠI -->
    <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom border-2 border-primary">
        <h3 class="text-primary fw-bold m-0"><i class="bi bi-grid-fill me-2"></i>QUẢN LÝ DANH MỤC</h3>
        <a href="${pageContext.request.contextPath}/admin" class="btn btn-outline-secondary fw-bold shadow-sm">
            <i class="bi bi-arrow-left-circle"></i> Về Dashboard
        </a>
    </div>

    <c:if test="${not empty sessionScope.message}">
        <c:choose>
            <c:when test="${fn:contains(sessionScope.message, 'Lỗi') || fn:contains(sessionScope.message, 'thất bại') || fn:contains(sessionScope.message, 'Không thể')}">
                <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i> <strong>Cảnh báo:</strong> ${sessionScope.message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:when>
            <c:otherwise>
                <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i> <strong>Thành công:</strong> ${sessionScope.message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:otherwise>
        </c:choose>
        <c:remove var="message" scope="session"/>
    </c:if>

    <div class="row">
        <!-- FORM THÊM MỚI -->
        <div class="col-md-4 mb-4">
            <div class="card shadow-sm border-0 rounded-3">
                <div class="card-header bg-primary text-white py-3">
                    <h5 class="mb-0 fw-bold"><i class="bi bi-plus-circle"></i> Thêm Danh Mục</h5>
                </div>
                <div class="card-body bg-white p-4">
                    <form action="${pageContext.request.contextPath}/danh-muc" method="post">
                        <input type="hidden" name="action" value="add">
                        <div class="mb-4">
                            <label class="form-label fw-bold text-dark">Tên Danh Mục</label>
                            <input type="text" class="form-control" name="tenDanhMuc" placeholder="VD: Trà Sữa, Cà Phê..." required>
                        </div>
                        <button type="submit" class="btn btn-primary w-100 fw-bold py-2 shadow-sm">Thêm Mới</button>
                    </form>
                </div>
            </div>
        </div>

        <!-- BẢNG DANH SÁCH -->
        <div class="col-md-8 mb-4">
            <div class="card shadow-sm border-0 rounded-3">
                <div class="card-header bg-dark text-white d-flex justify-content-between align-items-center py-3">
                    <h5 class="mb-0 fw-bold"><i class="bi bi-list-ul"></i> Danh Sách</h5>
                    <a href="${pageContext.request.contextPath}/danh-muc?action=list" class="btn btn-sm btn-outline-light"><i class="bi bi-arrow-clockwise"></i> Làm mới</a>
                </div>
                <div class="card-body p-0">
                    <table class="table table-striped table-hover mb-0 align-middle">
                        <thead class="table-secondary">
                        <tr>
                            <th class="text-center" width="10%">STT</th>
                            <th class="text-center" width="20%">Mã DM</th>
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
                                        <td class="fw-bold text-dark">${dm.tenDanhMuc}</td>
                                        <td class="text-center">
                                            <button class="btn btn-sm btn-warning fw-bold text-dark me-1" data-bs-toggle="modal" data-bs-target="#editModal"
                                                    onclick="fillEditModal('${dm.maDanhMuc}', '${fn:escapeXml(dm.tenDanhMuc)}')">
                                                <i class="bi bi-pencil-square"></i>
                                            </button>
                                            <a href="${pageContext.request.contextPath}/danh-muc?action=delete&id=${dm.maDanhMuc}"
                                               class="btn btn-sm btn-danger fw-bold"
                                               onclick="return confirm('Xóa danh mục [${fn:escapeXml(dm.tenDanhMuc)}]?');">
                                                <i class="bi bi-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="4" class="text-center text-muted py-4">Chưa có danh mục nào.</td></tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- MODAL CẬP NHẬT -->
<div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content border-0 shadow">
            <div class="modal-header bg-warning">
                <h5 class="modal-title fw-bold text-dark"><i class="bi bi-pencil-square"></i> Cập Nhật Danh Mục</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/danh-muc" method="post">
                <div class="modal-body p-4 bg-light">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="maDanhMuc" id="edit_maDanhMuc">

                    <div class="mb-3">
                        <label class="form-label text-muted fw-bold">Mã Danh Mục</label>
                        <input type="text" class="form-control fw-bold text-secondary bg-white" id="display_maDanhMuc" disabled>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold text-dark">Tên Danh Mục</label>
                        <input type="text" class="form-control border-primary" name="tenDanhMuc" id="edit_tenDanhMuc" required>
                    </div>
                </div>
                <div class="modal-footer bg-white">
                    <button type="button" class="btn btn-secondary fw-bold" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary fw-bold"><i class="bi bi-save"></i> Lưu Thay Đổi</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function fillEditModal(maDM, tenDM) {
        document.getElementById("edit_maDanhMuc").value = maDM;
        document.getElementById("display_maDanhMuc").value = maDM;
        document.getElementById("edit_tenDanhMuc").value = tenDM;
    }
</script>
</body>
</html>