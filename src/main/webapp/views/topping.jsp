<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Topping - TEA POS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
</head>
<body>
<%@ include file="layout/toast.jsp" %>

<div class="container-fluid mt-4 px-4 mb-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="text-dark fw-bold m-0"><i class="bi bi-plus-square-fill text-brand me-2"></i>Quản Lý Topping</h3>
        <a href="${pageContext.request.contextPath}/admin" class="btn btn-light border shadow-sm fw-bold">
            <i class="bi bi-arrow-left me-1"></i> Dashboard
        </a>
    </div>
    <div class="row">
        <div class="col-lg-3 mb-4">
            <div class="card">
                <div class="card-header border-bottom-0 pb-0 pt-4">
                    <h5 class="mb-0 fw-bold text-dark"><i class="bi bi-plus-circle-fill text-brand me-2"></i>Thêm Món Thêm</h5>
                </div>
                <div class="card-body p-4">
                    <form action="${pageContext.request.contextPath}/topping" method="post" enctype="multipart/form-data" onsubmit="showConfirmForm(event, this, 'Xác Nhận Thêm', 'Bạn có chắc chắn muốn thêm Topping mới này?');">
                        <input type="hidden" name="action" value="add">
                        <div class="mb-3">
                            <label class="form-label fw-semibold text-muted small text-uppercase">Tên Topping</label>
                            <input type="text" class="form-control" name="tenTopping" placeholder="VD: Trân châu trắng..." required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold text-muted small text-uppercase">Giá Bán (VNĐ)</label>
                            <input type="number" class="form-control text-danger fw-bold fs-5" name="giaBan" min="0" placeholder="5000" required>
                        </div>
                        <div class="mb-4">
                            <label class="form-label fw-semibold text-muted small text-uppercase">Tải Ảnh Lên</label>
                            <input type="file" class="form-control" name="hinhAnhFile" accept="image/*" required>
                        </div>
                        <button type="submit" class="btn btn-brand w-100 py-2"><i class="bi bi-check2 me-1"></i> Lưu Topping</button>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-lg-9 mb-4">
            <div class="card mb-4">
                <div class="card-body p-3">
                    <form action="${pageContext.request.contextPath}/topping" method="get">
                        <input type="hidden" name="action" value="search">
                        <div class="row g-3">
                            <div class="col-md-10">
                                <div class="input-group">
                                    <span class="input-group-text bg-white border-end-0 text-muted"><i class="bi bi-search"></i></span>
                                    <input type="text" class="form-control border-start-0 ps-0" name="keyword" placeholder="Nhập tên hoặc mã topping..." value="${requestScope.selectedKeyword}">
                                </div>
                            </div>
                            <div class="col-md-2">
                                <button type="submit" class="btn btn-dark w-100 fw-bold">Tìm Kiếm</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0 fw-bold text-dark">Danh Sách Tùy Chọn Món</h5>
                    <div>
                        <c:if test="${not empty requestScope.selectedKeyword}">
                            <a href="${pageContext.request.contextPath}/topping?action=list" class="btn btn-sm btn-light text-danger fw-bold me-2"><i class="bi bi-x-circle"></i> Bỏ lọc</a>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/topping?action=list" class="btn btn-sm btn-light border"><i class="bi bi-arrow-clockwise"></i></a>
                    </div>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover table-custom mb-0 text-center">
                            <thead>
                            <tr>
                                <th width="5%">STT</th>
                                <th width="10%">Ảnh</th>
                                <th>Mã Số</th>
                                <th class="text-start">Tên Topping</th>
                                <th class="text-end">Giá Bán</th>
                                <th>Trạng Thái</th>
                                <th>Thao Tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${not empty requestScope.danhSach}">
                                    <c:forEach var="tp" items="${requestScope.danhSach}" varStatus="status">
                                        <tr>
                                            <td class="fw-semibold text-muted">${status.index + 1}</td>
                                            <td>
                                                <img src="${pageContext.request.contextPath}/image/${not empty tp.hinhAnh ? tp.hinhAnh : 'default.png'}"
                                                     class="product-img shadow-sm" onerror="this.src='https://placehold.co/100x100?text=No+Image'" alt="${fn:escapeXml(tp.tenTopping)}">
                                            </td>
                                            <td class="fw-semibold text-muted">${tp.maTopping}</td>
                                            <td class="text-start fw-bold text-dark fs-6">${tp.tenTopping}</td>
                                            <td class="text-end fw-bold text-danger fs-6"><fmt:formatNumber value="${tp.giaBan}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${tp.trangThai == 1}"><span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25">Đang Bán</span></c:when>
                                                    <c:otherwise><span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary border-opacity-25">Ngừng Bán</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="btn-group btn-group-sm shadow-sm">
                                                    <c:choose>
                                                        <c:when test="${tp.trangThai == 1}">
                                                            <a href="${pageContext.request.contextPath}/topping?action=toggle-status&id=${tp.maTopping}&status=0" class="btn btn-light text-warning border" title="Ngừng bán" onclick="event.preventDefault(); showConfirmLink('Tạm Ngừng Bán', 'Bạn muốn tạm ngừng bán topping này?', this.href);"><i class="bi bi-pause-circle"></i></a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="${pageContext.request.contextPath}/topping?action=toggle-status&id=${tp.maTopping}&status=1" class="btn btn-light text-success border" title="Mở lại" onclick="event.preventDefault(); showConfirmLink('Mở Bán Lại', 'Mở bán lại topping này trên hệ thống?', this.href);"><i class="bi bi-play-circle"></i></a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <button class="btn btn-light text-primary border" data-bs-toggle="modal" data-bs-target="#editModal"
                                                            onclick="fillEditModal('${tp.maTopping}', '${fn:escapeXml(tp.tenTopping)}', '${tp.giaBan}', '${tp.hinhAnh}')" title="Sửa">
                                                        <i class="bi bi-pencil-square"></i>
                                                    </button>
                                                    <a href="${pageContext.request.contextPath}/topping?action=delete&id=${tp.maTopping}" class="btn btn-light text-danger border" onclick="event.preventDefault(); showConfirmLink('Xóa Topping', 'Bạn có chắc chắn muốn xóa vĩnh viễn topping này?', this.href);"><i class="bi bi-trash"></i></a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr><td colspan="7" class="text-center text-muted py-5"><i class="bi bi-inbox fs-1 d-block mb-3 opacity-50"></i>Chưa có Topping nào.</td></tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="layout/confirm_modal.jsp" %>

<div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content shadow-lg border-0" style="border-radius: 16px;">
            <div class="modal-header border-0 py-3 bg-light">
                <h5 class="modal-title fw-bold text-dark"><i class="bi bi-pencil-square text-primary me-2"></i>Cập Nhật Món Thêm</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/topping" method="post" enctype="multipart/form-data" onsubmit="showConfirmForm(event, this, 'Lưu Thay Đổi', 'Bạn chắc chắn muốn lưu thông tin vừa sửa của Topping này?');">
                <div class="modal-body p-4">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="maTopping" id="edit_maTopping">
                    <input type="hidden" name="oldHinhAnh" id="edit_oldHinhAnh">
                    <div class="mb-3">
                        <label class="form-label text-muted fw-bold small text-uppercase">Mã Topping</label>
                        <input type="text" class="form-control bg-light fw-bold text-muted border-0" id="display_maTopping" disabled>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold text-dark small text-uppercase">Tên Topping</label>
                        <input type="text" class="form-control" name="tenTopping" id="edit_tenTopping" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold text-dark small text-uppercase">Giá Bán (VNĐ)</label>
                        <input type="number" class="form-control text-danger fw-bold fs-5" name="giaBan" id="edit_giaBan" min="0" required>
                    </div>
                    <div class="mb-2">
                        <label class="form-label fw-bold text-dark small text-uppercase">Thay Ảnh Mới (Trống để giữ nguyên)</label>
                        <input type="file" class="form-control mb-2" name="hinhAnhFile" accept="image/*">
                        <div class="text-center p-2 rounded-4" style="background: #F8FAFC; border: 1px dashed #CBD5E1;">
                            <span class="small text-muted fw-semibold d-block mb-2">Ảnh hiện tại</span>
                            <img id="preview_hinhAnh" src="" alt="Ảnh hiện tại" style="width: 80px; height: 80px; object-fit: cover; border-radius: 12px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light border-0 d-flex justify-content-end p-3">
                    <button type="button" class="btn btn-light fw-bold rounded-pill px-4 border me-2" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary fw-bold rounded-pill px-4 shadow-sm"><i class="bi bi-check-lg me-1"></i> Lưu Lại</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/global.js"></script>

<script>
    function fillEditModal(maTP, tenTP, giaBan, hinhAnh) {
        document.getElementById('edit_maTopping').value = maTP;
        document.getElementById('display_maTopping').value = maTP;
        document.getElementById('edit_tenTopping').value = tenTP;
        document.getElementById('edit_giaBan').value = giaBan;
        document.getElementById('edit_oldHinhAnh').value = hinhAnh;
        let imgUrl = hinhAnh ? ('${pageContext.request.contextPath}/image/' + hinhAnh) : 'https://placehold.co/100x100?text=No+Image';
        document.getElementById('preview_hinhAnh').src = imgUrl;
    }
</script>
</body>
</html>