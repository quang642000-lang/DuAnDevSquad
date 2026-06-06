<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Topping</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f4f6f9; }
        .product-img { width: 50px; height: 50px; object-fit: cover; border-radius: 8px; border: 1px solid #dee2e6; }
    </style>
</head>
<body>

<div class="container-fluid mt-4 px-4 mb-5">
    <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom border-2 border-primary">
        <h3 class="text-primary fw-bold m-0"><i class="bi bi-plugin me-2"></i>QUẢN LÝ TOPPING</h3>
        <a href="${pageContext.request.contextPath}/admin" class="btn btn-outline-secondary fw-bold shadow-sm">
            <i class="bi bi-arrow-left-circle"></i> Về Dashboard
        </a>
    </div>

    <c:if test="${not empty sessionScope.message}">
        <c:choose>
            <c:when test="${fn:contains(sessionScope.message, 'Lỗi') || fn:contains(sessionScope.message, 'Không thể')}">
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
        <div class="col-lg-3 mb-4">
            <div class="card shadow-sm border-0 rounded-3">
                <div class="card-header bg-primary text-white py-3">
                    <h5 class="mb-0 fw-bold"><i class="bi bi-plus-circle"></i> Thêm Topping Mới</h5>
                </div>
                <div class="card-body bg-white p-3">
                    <form action="${pageContext.request.contextPath}/topping" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="add">
                        <div class="mb-3">
                            <label class="form-label fw-bold text-dark">Tên Topping</label>
                            <input type="text" class="form-control" name="tenTopping" placeholder="VD: Trân châu trắng..." required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold text-dark">Giá Bán (VNĐ)</label>
                            <input type="number" class="form-control text-danger fw-bold" name="giaBan" min="0" placeholder="5000" required>
                        </div>
                        <div class="mb-4">
                            <label class="form-label fw-bold text-dark">Tải Ảnh Lên</label>
                            <input type="file" class="form-control" name="hinhAnhFile" accept="image/*">
                        </div>
                        <button type="submit" class="btn btn-primary w-100 fw-bold py-2 shadow-sm"><i class="bi bi-save"></i> Thêm Topping</button>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-lg-9 mb-4">
            <div class="card shadow-sm border-0 rounded-3 mb-3">
                <div class="card-body bg-white py-2">
                    <form action="${pageContext.request.contextPath}/topping" method="get">
                        <input type="hidden" name="action" value="search">
                        <div class="row g-2">
                            <div class="col-md-10">
                                <div class="input-group input-group-sm">
                                    <span class="input-group-text bg-light text-muted"><i class="bi bi-search"></i></span>
                                    <input type="text" class="form-control" name="keyword" placeholder="Nhập tên hoặc mã topping..." value="${requestScope.selectedKeyword}">
                                </div>
                            </div>
                            <div class="col-md-2">
                                <button type="submit" class="btn btn-success btn-sm w-100 fw-bold">Tìm Kiếm</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <div class="card shadow-sm border-0 rounded-3">
                <div class="card-header bg-dark text-white d-flex justify-content-between align-items-center py-2">
                    <h5 class="mb-0 fw-bold"><i class="bi bi-list-stars"></i> Danh Sách Món Thêm</h5>
                    <div>
                        <c:if test="${not empty requestScope.selectedKeyword}">
                            <a href="${pageContext.request.contextPath}/topping?action=list" class="btn btn-sm btn-warning text-dark fw-bold me-2"><i class="bi bi-x-circle"></i> Bỏ lọc</a>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/topping?action=list" class="btn btn-sm btn-outline-light"><i class="bi bi-arrow-clockwise"></i></a>
                    </div>
                </div>
                <div class="card-body p-0">
                    <table class="table table-striped table-hover mb-0 align-middle text-center">
                        <thead class="table-secondary">
                        <tr>
                            <th width="5%">STT</th>
                            <th width="10%">Ảnh</th>
                            <th>Mã Topping</th>
                            <th class="text-start">Tên Topping</th>
                            <th class="text-end">Giá Bán</th>
                            <th>Trạng Thái</th>
                            <th>Hành Động</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty requestScope.danhSach}">
                                <c:forEach var="tp" items="${requestScope.danhSach}" varStatus="status">
                                    <tr>
                                        <td class="fw-bold">${status.index + 1}</td>
                                        <td>
                                            <img src="${pageContext.request.contextPath}/image/${not empty tp.hinhAnh ? tp.hinhAnh : 'default.png'}"
                                                 class="product-img shadow-sm" onerror="this.src='https://placehold.co/100x100?text=No+Image'" alt="${fn:escapeXml(tp.tenTopping)}">
                                        </td>
                                        <td class="fw-bold text-secondary">${tp.maTopping}</td>
                                        <td class="text-start fw-bold text-dark">${tp.tenTopping}</td>
                                        <td class="text-end fw-bold text-danger pe-4"><fmt:formatNumber value="${tp.giaBan}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${tp.trangThai == 1}"><span class="badge bg-success">Đang Bán</span></c:when>
                                                <c:otherwise><span class="badge bg-danger">Ngừng Bán</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${tp.trangThai == 1}">
                                                    <a href="${pageContext.request.contextPath}/topping?action=toggle-status&id=${tp.maTopping}&status=0" class="btn btn-sm btn-outline-danger" title="Ngừng bán"><i class="bi bi-pause-fill"></i></a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/topping?action=toggle-status&id=${tp.maTopping}&status=1" class="btn btn-sm btn-outline-success" title="Mở lại"><i class="bi bi-play-fill"></i></a>
                                                </c:otherwise>
                                            </c:choose>
                                            <button class="btn btn-sm btn-warning text-dark mx-1" data-bs-toggle="modal" data-bs-target="#editModal"
                                                    onclick="fillEditModal('${tp.maTopping}', '${fn:escapeXml(tp.tenTopping)}', '${tp.giaBan}', '${tp.hinhAnh}')">
                                                <i class="bi bi-pencil-square"></i>
                                            </button>
                                            <a href="${pageContext.request.contextPath}/topping?action=delete&id=${tp.maTopping}" class="btn btn-sm btn-danger" onclick="return confirm('Xóa Topping này?');"><i class="bi bi-trash"></i></a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="7" class="text-center text-muted py-4">Chưa có Topping nào.</td></tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content border-0 shadow">
            <div class="modal-header bg-warning">
                <h5 class="modal-title fw-bold text-dark"><i class="bi bi-pencil-square"></i> Cập Nhật Topping</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/topping" method="post" enctype="multipart/form-data">
                <div class="modal-body bg-light p-4">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="maTopping" id="edit_maTopping">
                    <input type="hidden" name="oldHinhAnh" id="edit_oldHinhAnh">

                    <div class="mb-3">
                        <label class="form-label text-muted fw-bold">Mã Topping</label>
                        <input type="text" class="form-control bg-white fw-bold text-secondary" id="display_maTopping" disabled>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold text-dark">Tên Topping</label>
                        <input type="text" class="form-control border-primary" name="tenTopping" id="edit_tenTopping" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold text-dark">Giá Bán (VNĐ)</label>
                        <input type="number" class="form-control text-danger fw-bold border-primary" name="giaBan" id="edit_giaBan" min="0" required>
                    </div>
                    <div class="mb-2">
                        <label class="form-label fw-bold text-dark">Đổi Hình Ảnh (Để trống nếu giữ nguyên)</label>
                        <input type="file" class="form-control border-primary" name="hinhAnhFile" accept="image/*">
                        <div class="mt-2 text-center">
                            <img id="preview_hinhAnh" src="" alt="Ảnh hiện tại" style="width: 100px; height: 100px; object-fit: cover; border-radius: 8px; border: 1px solid #ccc;">
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-white d-flex justify-content-between">
                    <a href="#" id="btn-delete-modal" class="btn btn-outline-danger fw-bold" onclick="return confirm('Bạn chắc chắn muốn xóa?');"><i class="bi bi-trash"></i> Xóa</a>
                    <div>
                        <button type="button" class="btn btn-secondary fw-bold" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary fw-bold"><i class="bi bi-save"></i> Lưu</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function fillEditModal(maTP, tenTP, giaBan, hinhAnh) {
        document.getElementById('edit_maTopping').value = maTP;
        document.getElementById('display_maTopping').value = maTP;
        document.getElementById('edit_tenTopping').value = tenTP;
        document.getElementById('edit_giaBan').value = giaBan;

        document.getElementById('edit_oldHinhAnh').value = hinhAnh;
        let imgUrl = hinhAnh ? ('${pageContext.request.contextPath}/image/' + hinhAnh) : 'https://placehold.co/100x100?text=No+Image';
        document.getElementById('preview_hinhAnh').src = imgUrl;

        document.getElementById('btn-delete-modal').href = '${pageContext.request.contextPath}/topping?action=delete&id=' + maTP;
    }
</script>
</body>
</html>