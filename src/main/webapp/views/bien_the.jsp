<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Biến Thể (Kích Cỡ)</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body class="bg-light">

<div class="container mt-5">
    <h2 class="mb-4 text-center text-primary fw-bold">QUẢN LÝ BIẾN THỂ SẢN PHẨM</h2>

    <!-- TỐI ƯU GIAO DIỆN: Báo Đỏ nếu Lỗi, Báo Xanh nếu Thành Công -->
    <c:if test="${not empty sessionScope.message}">
        <c:choose>
            <c:when test="${fn:contains(sessionScope.message, 'Lỗi') || fn:contains(sessionScope.message, 'Không thể')}">
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
        <c:remove var="message" scope="session"/>
    </c:if>

    <div class="row">
        <!-- FORM THÊM BIẾN THỂ -->
        <div class="col-lg-4 mb-4">
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0"><i class="bi bi-plus-circle"></i> Thêm Kích Cỡ Mới</h5>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/bien-the" method="post">
                        <input type="hidden" name="action" value="add">

                        <div class="mb-3">
                            <label class="form-label fw-bold">Sản Phẩm</label>
                            <!-- Sửa thành name="maSp" cho đúng Controller -->
                            <select class="form-select" name="maSp" required>
                                <option value="" disabled selected>-- Chọn Sản Phẩm --</option>
                                <!-- Sửa thành danhSachSp cho đúng phân biệt chữ hoa/thường -->
                                <c:forEach var="sp" items="${requestScope.danhSachSp}">
                                    <!-- Cập nhật sử dụng maSP và tenSP -->
                                    <option value="${sp.maSP}">${sp.tenSP} (${sp.maSP})</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Kích Cỡ (Size)</label>
                            <input type="text" class="form-control" name="kichCo" placeholder="VD: M, L, XL..." required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Giá Bán (VNĐ)</label>
                            <input type="number" class="form-control" name="giaBan" min="0" placeholder="VD: 30000" required>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 fw-bold">
                            <i class="bi bi-save"></i> Thêm Biến Thể
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <!-- DANH SÁCH BIẾN THỂ -->
        <div class="col-lg-8 mb-4">
            <div class="card shadow-sm">
                <div class="card-header bg-dark text-white d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="bi bi-tags"></i> Danh Sách Biến Thể</h5>
                    <a href="${pageContext.request.contextPath}/bien-the?action=list" class="btn btn-sm btn-outline-light">
                        <i class="bi bi-arrow-clockwise"></i> Làm mới
                    </a>
                </div>
                <div class="card-body p-0">
                    <table class="table table-striped table-hover mb-0 align-middle">
                        <thead class="table-secondary">
                        <tr>
                            <th class="text-center">STT</th>
                            <th>Mã BT</th>
                            <th>Sản Phẩm</th>
                            <th class="text-center">Kích Cỡ</th>
                            <th class="text-end">Giá Bán</th>
                            <th class="text-center">Trạng Thái</th>
                            <th class="text-center">Hành Động</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty requestScope.danhSach}">
                                <c:forEach var="bt" items="${requestScope.danhSach}" varStatus="status">
                                    <tr>
                                        <td class="text-center fw-bold">${status.index + 1}</td>
                                        <td class="fw-bold text-secondary">${bt.maBienThe}</td>
                                        <!-- Cập nhật sử dụng tenSP -->
                                        <td class="fw-medium">${bt.sanPham.tenSP}</td>
                                        <td class="text-center fw-bold text-primary">${bt.kichCo}</td>
                                        <td class="text-end fw-bold text-danger">
                                            <!-- Format tiền tệ đẹp mắt -->
                                            <fmt:formatNumber value="${bt.giaBan}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${bt.trangThai == 1}">
                                                    <span class="badge bg-success">Hoạt Động</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger">Tạm Ngừng</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${bt.trangThai == 1}">
                                                    <a href="${pageContext.request.contextPath}/bien-the?action=toggle-status&id=${bt.maBienThe}&status=0"
                                                       class="btn btn-sm btn-outline-danger" title="Tạm ngừng">
                                                        <i class="bi bi-pause-circle"></i>
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/bien-the?action=toggle-status&id=${bt.maBienThe}&status=1"
                                                       class="btn btn-sm btn-outline-success" title="Hoạt động lại">
                                                        <i class="bi bi-play-circle"></i>
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>

                                            <!-- Sửa thông tin -->
                                            <button class="btn btn-sm btn-warning" data-bs-toggle="modal" data-bs-target="#editModal"
                                                    onclick="fillEditModal('${bt.maBienThe}', '${bt.sanPham.maSP}', '${bt.kichCo}', '${bt.giaBan}')">
                                                <i class="bi bi-pencil-square"></i>
                                            </button>

                                            <!-- Xóa -->
                                            <a href="${pageContext.request.contextPath}/bien-the?action=delete&id=${bt.maBienThe}"
                                               class="btn btn-sm btn-danger"
                                               onclick="return confirm('Bạn có chắc chắn muốn xóa biến thể ${bt.kichCo} của món này không?');">
                                                <i class="bi bi-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7" class="text-center text-muted py-4">Chưa có biến thể nào trong hệ thống.</td>
                                </tr>
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
        <div class="modal-content">
            <div class="modal-header bg-warning">
                <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square"></i> Cập Nhật Kích Cỡ</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/bien-the" method="post">
                <div class="modal-body">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="maBienThe" id="edit_maBienThe">

                    <div class="mb-3">
                        <label class="form-label text-muted fw-bold">Mã Biến Thể</label>
                        <input type="text" class="form-control bg-light" id="display_maBienThe" disabled>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Sản Phẩm</label>
                        <select class="form-select" name="maSp" id="edit_maSp" required>
                            <c:forEach var="sp" items="${requestScope.danhSachSp}">
                                <!-- Cập nhật sử dụng maSP và tenSP -->
                                <option value="${sp.maSP}">${sp.tenSP}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Kích Cỡ (Size)</label>
                        <input type="text" class="form-control" name="kichCo" id="edit_kichCo" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Giá Bán (VNĐ)</label>
                        <input type="number" class="form-control" name="giaBan" id="edit_giaBan" min="0" required>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function fillEditModal(maBT, maSp, kichCo, giaBan) {
        document.getElementById('edit_maBienThe').value = maBT;
        document.getElementById('display_maBienThe').value = maBT;
        // Đã sửa lại lỗi sai tên ID Javascript ở đây (từ edit_maSP thành edit_maSp)
        document.getElementById('edit_maSp').value = maSp;
        document.getElementById('edit_kichCo').value = kichCo;
        document.getElementById('edit_giaBan').value = giaBan;
    }
</script>

</body>
</html>