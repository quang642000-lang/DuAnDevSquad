<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Topping</title>
    <!-- Thêm Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        .product-img {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid #dee2e6;
        }
    </style>
</head>
<body class="bg-light">

<div class="container mt-5">
    <h2 class="mb-4 text-center text-primary fw-bold">QUẢN LÝ TOPPING (MÓN THÊM)</h2>

    <!-- Hiển thị thông báo -->
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
        <!-- FORM THÊM TOPPING -->
        <div class="col-lg-4 mb-4">
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0"><i class="bi bi-plus-circle"></i> Thêm Topping Mới</h5>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/topping" method="post">
                        <input type="hidden" name="action" value="add">

                        <div class="mb-3">
                            <label class="form-label fw-bold">Tên Topping</label>
                            <input type="text" class="form-control" name="tenTopping" placeholder="VD: Trân châu trắng, Thạch nha đam..." required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Giá Bán (VNĐ)</label>
                            <input type="number" class="form-control" name="giaBan" min="0" placeholder="VD: 5000" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Tên File Hình Ảnh</label>
                            <input type="text" class="form-control" name="hinhAnh" placeholder="VD: tranchau.jpg">
                        </div>

                        <button type="submit" class="btn btn-primary w-100 fw-bold">
                            <i class="bi bi-save"></i> Thêm Topping
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <!-- CỘT PHẢI: TÌM KIẾM & DANH SÁCH -->
        <div class="col-lg-8 mb-4">

            <!-- THANH TÌM KIẾM -->
            <div class="card shadow-sm mb-4">
                <div class="card-body bg-white rounded">
                    <form action="${pageContext.request.contextPath}/topping" method="get">
                        <input type="hidden" name="action" value="search">
                        <div class="row g-3">
                            <div class="col-md-9">
                                <label class="form-label fw-semibold text-muted small">Tìm theo tên hoặc mã Topping</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light text-muted"><i class="bi bi-search"></i></span>
                                    <input type="text" class="form-control" name="keyword"
                                           placeholder="Nhập từ khóa tìm kiếm..."
                                           value="${requestScope.selectedKeyword}">
                                </div>
                            </div>
                            <div class="col-md-3 d-flex align-items-end">
                                <button type="submit" class="btn btn-success w-100 fw-bold">
                                    Tìm Kiếm
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- BẢNG DANH SÁCH -->
            <div class="card shadow-sm">
                <div class="card-header bg-dark text-white d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="bi bi-plugin"></i> Danh Sách Topping</h5>
                    <div>
                        <c:if test="${not empty requestScope.selectedKeyword}">
                            <a href="${pageContext.request.contextPath}/topping?action=list" class="btn btn-sm btn-warning text-dark fw-bold me-2">
                                <i class="bi bi-x-circle"></i> Bỏ bộ lọc
                            </a>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/topping?action=list" class="btn btn-sm btn-outline-light">
                            <i class="bi bi-arrow-clockwise"></i> Làm mới
                        </a>
                    </div>
                </div>
                <div class="card-body p-0">
                    <table class="table table-striped table-hover mb-0 align-middle">
                        <thead class="table-secondary">
                        <tr>
                            <th class="text-center">STT</th>
                            <th class="text-center">Ảnh</th>
                            <th>Mã Topping</th>
                            <th>Tên Topping</th>
                            <th class="text-end">Giá Bán</th>
                            <th class="text-center">Trạng Thái</th>
                            <th class="text-center">Hành Động</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty requestScope.danhSach}">
                                <c:forEach var="tp" items="${requestScope.danhSach}" varStatus="status">
                                    <tr>
                                        <td class="text-center fw-bold">${status.index + 1}</td>
                                        <td class="text-center">
                                            <img src="${pageContext.request.contextPath}/assets/img/${not empty tp.hinhAnh ? tp.hinhAnh : 'default.png'}"
                                                 class="product-img"
                                                 onerror="this.src='https://placehold.co/100x100?text=No+Image'"
                                                 alt="${tp.tenTopping}">
                                        </td>
                                        <td class="fw-bold text-secondary">${tp.maTopping}</td>
                                        <td class="fw-medium">${tp.tenTopping}</td>
                                        <td class="text-end fw-bold text-danger">
                                            <fmt:formatNumber value="${tp.giaBan}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${tp.trangThai == 1}">
                                                    <span class="badge bg-success">Đang Bán</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger">Ngừng Bán</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <!-- Nút Bật/Tắt Trạng Thái -->
                                            <c:choose>
                                                <c:when test="${tp.trangThai == 1}">
                                                    <a href="${pageContext.request.contextPath}/topping?action=toggle-status&id=${tp.maTopping}&status=0"
                                                       class="btn btn-sm btn-outline-danger" title="Ngừng bán">
                                                        <i class="bi bi-pause-circle"></i>
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/topping?action=toggle-status&id=${tp.maTopping}&status=1"
                                                       class="btn btn-sm btn-outline-success" title="Mở bán lại">
                                                        <i class="bi bi-play-circle"></i>
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>

                                            <!-- Sửa thông tin -->
                                            <button class="btn btn-sm btn-warning" data-bs-toggle="modal" data-bs-target="#editModal" title="Cập nhật"
                                                    onclick="fillEditModal('${tp.maTopping}', '${fn:escapeXml(tp.tenTopping)}', '${tp.giaBan}', '${tp.hinhAnh}')">
                                                <i class="bi bi-pencil-square"></i>
                                            </button>

                                            <!-- Nút Xóa nhỏ ở ngoài bảng -->
                                            <a href="${pageContext.request.contextPath}/topping?action=delete&id=${tp.maTopping}"
                                               class="btn btn-sm btn-danger" title="Xóa vĩnh viễn"
                                               onclick="return confirm('Bạn có chắc chắn muốn xóa Topping ${fn:escapeXml(tp.tenTopping)} không?');">
                                                <i class="bi bi-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7" class="text-center text-muted py-4">Chưa có Topping nào khớp với bộ lọc.</td>
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

<!-- MODAL CẬP NHẬT TOPPING -->
<div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-warning">
                <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square"></i> Cập Nhật Topping</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/topping" method="post">
                <div class="modal-body">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="maTopping" id="edit_maTopping">

                    <div class="mb-3">
                        <label class="form-label text-muted fw-bold">Mã Topping</label>
                        <input type="text" class="form-control bg-light fw-bold text-secondary" id="display_maTopping" disabled>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Tên Topping</label>
                        <input type="text" class="form-control" name="tenTopping" id="edit_tenTopping" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Giá Bán (VNĐ)</label>
                        <input type="number" class="form-control" name="giaBan" id="edit_giaBan" min="0" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Tên File Hình Ảnh</label>
                        <input type="text" class="form-control" name="hinhAnh" id="edit_hinhAnh">
                    </div>
                </div>

                <div class="modal-footer d-flex justify-content-between">
                    <a href="#" id="btn-delete-modal" class="btn btn-outline-danger fw-bold"
                       onclick="return confirm('Cảnh báo: Bạn có chắc chắn muốn xóa vĩnh viễn Topping này?');">
                        <i class="bi bi-trash"></i> Xóa
                    </a>

                    <div>
                        <button type="button" class="btn btn-secondary fw-bold" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary fw-bold"><i class="bi bi-save"></i> Lưu</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Hàm nạp dữ liệu từ dòng được chọn vào Modal sửa
    function fillEditModal(maTP, tenTP, giaBan, hinhAnh) {
        document.getElementById('edit_maTopping').value = maTP;
        document.getElementById('display_maTopping').value = maTP;
        document.getElementById('edit_tenTopping').value = tenTP;
        document.getElementById('edit_giaBan').value = giaBan;
        document.getElementById('edit_hinhAnh').value = hinhAnh;

        // Cập nhật đường link cho nút XÓA bên trong Modal
        document.getElementById('btn-delete-modal').href = '${pageContext.request.contextPath}/topping?action=delete&id=' + maTP;
    }
</script>

</body>
</html>