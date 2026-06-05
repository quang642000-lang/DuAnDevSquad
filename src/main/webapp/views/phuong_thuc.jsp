<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Cấu Hình Thanh Toán</title>
    <!-- Thêm Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body class="bg-light">

<div class="container mt-5">
    <h2 class="mb-4 text-center text-primary fw-bold">CẤU HÌNH PHƯƠNG THỨC THANH TOÁN</h2>

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
        <!-- FORM THÊM MỚI -->
        <div class="col-lg-4 mb-4">
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0 fw-bold"><i class="bi bi-wallet2"></i> Thêm Phương Thức Mới</h5>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/phuong-thuc" method="post">
                        <input type="hidden" name="action" value="add">

                        <div class="mb-3">
                            <label class="form-label fw-bold text-muted">Tên phương thức</label>
                            <input type="text" class="form-control" name="tenPhuongThuc" placeholder="VD: Ví VNPay, Thẻ tín dụng..." required>
                        </div>

                        <div class="alert alert-info py-2 small">
                            <i class="bi bi-info-circle"></i> Phương thức mới sẽ tự động được <strong class="text-success">Kích hoạt</strong> trên màn hình thu ngân.
                        </div>

                        <button type="submit" class="btn btn-primary w-100 fw-bold">
                            <i class="bi bi-save"></i> Thêm Mới
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <!-- CỘT PHẢI: TÌM KIẾM & BẢNG -->
        <div class="col-lg-8 mb-4">

            <!-- THANH TÌM KIẾM -->
            <div class="card shadow-sm mb-3">
                <div class="card-body bg-white rounded py-2">
                    <form action="${pageContext.request.contextPath}/phuong-thuc" method="get">
                        <input type="hidden" name="action" value="search">
                        <div class="row g-2">
                            <div class="col-md-9">
                                <div class="input-group">
                                    <span class="input-group-text bg-light"><i class="bi bi-search"></i></span>
                                    <input type="text" class="form-control" name="keyword"
                                           placeholder="Tìm theo tên hoặc mã phương thức..."
                                           value="${requestScope.selectedKeyword}">
                                </div>
                            </div>
                            <div class="col-md-3">
                                <button type="submit" class="btn btn-success w-100 fw-bold">Tìm Kiếm</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- BẢNG DANH SÁCH -->
            <div class="card shadow-sm">
                <div class="card-header bg-dark text-white d-flex justify-content-between align-items-center py-2">
                    <h6 class="mb-0 fw-bold"><i class="bi bi-list-check"></i> Các Hình Thức Khả Dụng</h6>
                    <a href="${pageContext.request.contextPath}/phuong-thuc?action=list" class="btn btn-sm btn-outline-light py-0">
                        <i class="bi bi-arrow-clockwise"></i> Làm mới
                    </a>
                </div>
                <div class="card-body p-0">
                    <table class="table table-striped table-hover mb-0 align-middle">
                        <thead class="table-secondary">
                        <tr>
                            <th class="text-center" width="5%">STT</th>
                            <th width="15%">Mã Số</th>
                            <th>Tên Hình Thức Thanh Toán</th>
                            <th class="text-center" width="15%">Trạng Thái</th>
                            <th class="text-center" width="25%">Hành Động</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty requestScope.danhSach}">
                                <c:forEach var="pt" items="${requestScope.danhSach}" varStatus="status">
                                    <tr>
                                        <td class="text-center fw-bold">${status.index + 1}</td>
                                        <td class="fw-bold text-secondary">${pt.maPTTT}</td>
                                        <td class="fw-bold">${pt.tenPhuongThuc}</td>

                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${pt.trangThai == 1}">
                                                    <span class="badge bg-success shadow-sm">Đang Bật</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger shadow-sm">Đang Tắt</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td class="text-center">
                                            <!-- CHUYỂN TRẠNG THÁI -->
                                            <c:choose>
                                                <c:when test="${pt.trangThai == 1}">
                                                    <a href="${pageContext.request.contextPath}/phuong-thuc?action=toggle-status&id=${pt.maPTTT}&status=0"
                                                       class="btn btn-sm btn-outline-danger py-0 px-1" title="Tắt tính năng">
                                                        <i class="bi bi-power"></i> Tắt
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/phuong-thuc?action=toggle-status&id=${pt.maPTTT}&status=1"
                                                       class="btn btn-sm btn-outline-success py-0 px-1" title="Bật lại">
                                                        <i class="bi bi-power"></i> Bật
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>

                                            <!-- SỬA -->
                                            <button class="btn btn-sm btn-warning py-0 px-1 mx-1 text-dark" data-bs-toggle="modal" data-bs-target="#editModal" title="Đổi tên"
                                                    onclick="fillEditModal('${pt.maPTTT}', '${fn:escapeXml(pt.tenPhuongThuc)}')">
                                                <i class="bi bi-pencil-square"></i>
                                            </button>

                                            <!-- XÓA -->
                                            <a href="${pageContext.request.contextPath}/phuong-thuc?action=delete&id=${pt.maPTTT}"
                                               class="btn btn-sm btn-secondary py-0 px-1" title="Xóa bỏ"
                                               onclick="return confirm('Cảnh báo: Nếu có hóa đơn cũ dùng PTTT này, việc xóa sẽ bị chặn. Nên ưu tiên dùng tính năng [Tắt]. Bạn có muốn xóa?');">
                                                <i class="bi bi-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="5" class="text-center text-muted py-4">Chưa có phương thức thanh toán nào.</td>
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

<!-- MODAL SỬA -->
<div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-warning">
                <h5 class="modal-title fw-bold text-dark"><i class="bi bi-pencil-square"></i> Cập Nhật Thông Tin</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/phuong-thuc" method="post">
                <div class="modal-body">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="maPTTT" id="edit_maPTTT">

                    <div class="mb-3">
                        <label class="form-label fw-bold small text-muted">Mã Hệ Thống</label>
                        <input type="text" class="form-control bg-light fw-bold text-secondary" id="display_maPTTT" disabled>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Tên Phương Thức</label>
                        <input type="text" class="form-control" name="tenPhuongThuc" id="edit_tenPhuongThuc" required>
                    </div>
                </div>

                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-secondary fw-bold" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary fw-bold"><i class="bi bi-save"></i> Lưu</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function fillEditModal(maPT, tenPT) {
        document.getElementById('edit_maPTTT').value = maPT;
        document.getElementById('display_maPTTT').value = maPT;
        document.getElementById('edit_tenPhuongThuc').value = tenPT;
    }
</script>

</body>
</html>