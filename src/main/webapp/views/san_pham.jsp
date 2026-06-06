<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Sản Phẩm</title>
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
        <h3 class="text-primary fw-bold m-0"><i class="bi bi-cup-hot-fill me-2"></i>QUẢN LÝ SẢN PHẨM</h3>
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
                    <h5 class="mb-0 fw-bold"><i class="bi bi-plus-circle"></i> Thêm Sản Phẩm</h5>
                </div>
                <div class="card-body bg-white p-3">
                    <form action="${pageContext.request.contextPath}/san-pham" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="add">
                        <div class="mb-3">
                            <label class="form-label fw-bold text-dark">Tên Sản Phẩm</label>
                            <input type="text" class="form-control" name="tenSanPham" placeholder="VD: Trà sữa Oolong..." required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold text-dark">Danh Mục</label>
                            <select class="form-select" name="maDanhMuc" required>
                                <option value="" disabled selected>-- Chọn danh mục --</option>
                                <c:forEach var="dm" items="${requestScope.danhSachDm}">
                                    <option value="${dm.maDanhMuc}">${dm.tenDanhMuc}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-4">
                            <label class="form-label fw-bold text-dark">Tải Hình Ảnh Lên</label>
                            <input type="file" class="form-control" name="hinhAnhFile" accept="image/*">
                        </div>
                        <button type="submit" class="btn btn-primary w-100 fw-bold py-2 shadow-sm"><i class="bi bi-save"></i> Lưu Sản Phẩm</button>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-lg-9 mb-4">
            <div class="card shadow-sm border-0 rounded-3 mb-3">
                <div class="card-body bg-white py-2">
                    <form action="${pageContext.request.contextPath}/san-pham" method="get">
                        <input type="hidden" name="action" value="search">
                        <div class="row g-2">
                            <div class="col-md-5">
                                <div class="input-group input-group-sm">
                                    <span class="input-group-text bg-light"><i class="bi bi-search"></i></span>
                                    <input type="text" class="form-control" name="keyword" placeholder="Tên hoặc mã SP..." value="${requestScope.selectedKeyword}">
                                </div>
                            </div>
                            <div class="col-md-5">
                                <div class="input-group input-group-sm">
                                    <span class="input-group-text bg-light"><i class="bi bi-filter"></i></span>
                                    <select class="form-select" name="filterDanhMuc">
                                        <option value="all">Tất cả danh mục</option>
                                        <c:forEach var="dm" items="${requestScope.danhSachDm}">
                                            <option value="${dm.maDanhMuc}" ${requestScope.selectedDanhMuc == dm.maDanhMuc ? 'selected' : ''}>${dm.tenDanhMuc}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-2">
                                <button type="submit" class="btn btn-success btn-sm w-100 fw-bold">Tìm</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <div class="card shadow-sm border-0 rounded-3">
                <div class="card-header bg-dark text-white d-flex justify-content-between align-items-center py-2">
                    <h5 class="mb-0 fw-bold"><i class="bi bi-list-task"></i> Danh Sách Món</h5>
                    <div>
                        <c:if test="${not empty requestScope.selectedKeyword or (not empty requestScope.selectedDanhMuc and requestScope.selectedDanhMuc != 'all')}">
                            <a href="${pageContext.request.contextPath}/san-pham?action=list" class="btn btn-sm btn-warning text-dark fw-bold me-2"><i class="bi bi-x-circle"></i> Bỏ lọc</a>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/san-pham?action=list" class="btn btn-sm btn-outline-light"><i class="bi bi-arrow-clockwise"></i></a>
                    </div>
                </div>
                <div class="card-body p-0">
                    <table class="table table-striped table-hover mb-0 align-middle">
                        <thead class="table-secondary">
                        <tr>
                            <th class="text-center" width="5%">STT</th>
                            <th class="text-center" width="10%">Ảnh</th>
                            <th width="10%">Mã SP</th>
                            <th>Tên Sản Phẩm</th>
                            <th>Danh Mục</th>
                            <th class="text-center">Trạng Thái</th>
                            <th class="text-center" width="20%">Hành Động</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty requestScope.danhSachSp}">
                                <c:forEach var="sp" items="${requestScope.danhSachSp}" varStatus="status">
                                    <tr>
                                        <td class="text-center fw-bold">${status.index + 1}</td>
                                        <td class="text-center">
                                            <img src="${pageContext.request.contextPath}/image/${not empty sp.hinhAnh ? sp.hinhAnh : 'default.png'}"
                                                 class="product-img shadow-sm" onerror="this.src='https://placehold.co/100x100?text=No+Image'" alt="${fn:escapeXml(sp.tenSanPham)}">
                                        </td>
                                        <td class="fw-bold text-secondary">${sp.maSP}</td>
                                        <td class="fw-bold text-dark">${sp.tenSanPham}</td>
                                        <td><span class="badge bg-secondary border border-dark text-white">${sp.danhMuc.tenDanhMuc}</span></td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${sp.trangThai == 1}"><span class="badge bg-success">Đang Bán</span></c:when>
                                                <c:otherwise><span class="badge bg-danger">Ngừng Bán</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${sp.trangThai == 1}">
                                                    <a href="${pageContext.request.contextPath}/san-pham?action=toggle-status&id=${sp.maSP}&status=0" class="btn btn-sm btn-outline-danger" title="Ngừng bán"><i class="bi bi-pause-fill"></i></a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/san-pham?action=toggle-status&id=${sp.maSP}&status=1" class="btn btn-sm btn-outline-success" title="Mở bán"><i class="bi bi-play-fill"></i></a>
                                                </c:otherwise>
                                            </c:choose>
                                            <button class="btn btn-sm btn-warning text-dark mx-1" data-bs-toggle="modal" data-bs-target="#editSpModal"
                                                    onclick="fillEditModal('${sp.maSP}', '${fn:escapeXml(sp.tenSanPham)}', '${sp.hinhAnh}', '${sp.danhMuc.maDanhMuc}')">
                                                <i class="bi bi-pencil-square"></i>
                                            </button>
                                            <a href="${pageContext.request.contextPath}/san-pham?action=delete&id=${sp.maSP}" class="btn btn-sm btn-danger" onclick="return confirm('Xóa sản phẩm ${fn:escapeXml(sp.tenSanPham)}?');">
                                                <i class="bi bi-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="7" class="text-center text-muted py-4">Chưa có sản phẩm nào.</td></tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="editSpModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content border-0 shadow">
            <div class="modal-header bg-warning">
                <h5 class="modal-title fw-bold text-dark"><i class="bi bi-pencil-square"></i> Cập Nhật Sản Phẩm</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/san-pham" method="post" enctype="multipart/form-data">
                <div class="modal-body bg-light p-4">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="maSP" id="edit_maSP">
                    <input type="hidden" name="oldHinhAnh" id="edit_oldHinhAnh">

                    <div class="mb-3">
                        <label class="form-label text-muted fw-bold">Mã Sản Phẩm</label>
                        <input type="text" class="form-control bg-white fw-bold text-secondary" id="display_maSP" disabled>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold text-dark">Tên Sản Phẩm</label>
                        <input type="text" class="form-control border-primary" name="tenSanPham" id="edit_tenSanPham" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold text-dark">Danh Mục</label>
                        <select class="form-select border-primary" name="maDanhMuc" id="edit_maDanhMuc" required>
                            <c:forEach var="dm" items="${requestScope.danhSachDm}">
                                <option value="${dm.maDanhMuc}">${dm.tenDanhMuc}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-2">
                        <label class="form-label fw-bold text-dark">Thay Đổi Hình Ảnh (Để trống nếu giữ nguyên)</label>
                        <input type="file" class="form-control border-primary" name="hinhAnhFile" accept="image/*">
                        <div class="mt-2 text-center">
                            <img id="preview_hinhAnh" src="" alt="Ảnh hiện tại" style="width: 100px; height: 100px; object-fit: cover; border-radius: 8px; border: 1px solid #ccc;">
                        </div>
                    </div>
                </div>
                <div class="modal-footer d-flex justify-content-between bg-white">
                    <a href="#" id="btn-delete-modal" class="btn btn-outline-danger fw-bold" onclick="return confirm('Bạn muốn xóa sản phẩm này?');"><i class="bi bi-trash"></i> Xóa Bỏ</a>
                    <div>
                        <button type="button" class="btn btn-secondary fw-bold" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary fw-bold"><i class="bi bi-save"></i> Lưu Thay Đổi</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function fillEditModal(maSP, tenSanPham, hinhAnh, maDanhMuc) {
        document.getElementById('edit_maSP').value = maSP;
        document.getElementById('display_maSP').value = maSP;
        document.getElementById('edit_tenSanPham').value = tenSanPham;
        document.getElementById('edit_oldHinhAnh').value = hinhAnh;

        let imgUrl = hinhAnh ? ('${pageContext.request.contextPath}/image/' + hinhAnh) : 'https://placehold.co/100x100?text=No+Image';
        document.getElementById('preview_hinhAnh').src = imgUrl;

        document.getElementById('edit_maDanhMuc').value = maDanhMuc;
        document.getElementById('btn-delete-modal').href = '${pageContext.request.contextPath}/san-pham?action=delete&id=' + maSP;
    }
</script>
</body>
</html>