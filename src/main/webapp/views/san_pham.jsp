<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Sản Phẩm</title>
    <!-- Thêm Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
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
    <h2 class="mb-4 text-center text-primary fw-bold">QUẢN LÝ SẢN PHẨM</h2>

    <!-- Hiển thị thông báo thành công / thất bại -->
    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-info alert-dismissible fade show shadow-sm" role="alert">
            <i class="bi bi-info-circle-fill me-2"></i> <strong>Thông báo:</strong> ${sessionScope.message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="message" scope="session"/>
    </c:if>

    <div class="row">
        <!-- FORM THÊM SẢN PHẨM -->
        <div class="col-lg-4 mb-4">
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0"><i class="bi bi-plus-circle"></i> Thêm Sản Phẩm Mới</h5>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/san-pham" method="post">
                        <input type="hidden" name="action" value="add">

                        <div class="mb-3">
                            <label class="form-label fw-bold">Tên Sản Phẩm</label>
                            <input type="text" class="form-control" name="tenSanPham" placeholder="Nhập tên trà sữa, trà trái cây..." required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Danh Mục</label>
                            <select class="form-select" name="maDanhMuc" required>
                                <option value="" disabled selected>-- Chọn danh mục sản phẩm --</option>
                                <c:forEach var="dm" items="${requestScope.danhSachDm}">
                                    <option value="${dm.maDanhMuc}">${dm.tenDanhMuc}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Tên File Hình Ảnh</label>
                            <input type="text" class="form-control" name="hinhAnh" placeholder="VD: trasua_tc.jpg">
                        </div>

                        <button type="submit" class="btn btn-primary w-100 fw-bold">
                            <i class="bi bi-save"></i> Thêm Sản Phẩm
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <!-- DANH SÁCH SẢN PHẨM -->
        <div class="col-lg-8 mb-4">
            <!-- THANH TÌM KIẾM VÀ LỌC SẢN PHẨM -->
            <div class="card shadow-sm mb-4">
                <div class="card-body bg-white rounded">
                    <form action="${pageContext.request.contextPath}/san-pham" method="get">
                        <input type="hidden" name="action" value="search">
                        <div class="row g-3">
                            <!-- Tìm theo tên/mã -->
                            <div class="col-md-6">
                                <label class="form-label fw-semibold text-muted small">Tìm theo tên hoặc mã SP</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light text-muted"><i class="bi bi-search"></i></span>
                                    <input type="text" class="form-control" name="keyword"
                                           placeholder="Nhập tên hoặc mã sản phẩm..."
                                           value="${requestScope.selectedKeyword}">
                                </div>
                            </div>
                            <!-- Lọc theo Danh mục -->
                            <div class="col-md-4">
                                <label class="form-label fw-semibold text-muted small">Lọc theo Danh mục</label>
                                <select class="form-select" name="filterDanhMuc">
                                    <option value="all">-- Tất cả danh mục --</option>
                                    <c:forEach var="dm" items="${requestScope.danhSachDm}">
                                        <option value="${dm.maDanhMuc}" ${requestScope.selectedDanhMuc == dm.maDanhMuc ? 'selected' : ''}>
                                                ${dm.tenDanhMuc}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <!-- Nút hành động -->
                            <div class="col-md-2 d-flex align-items-end">
                                <button type="submit" class="btn btn-success w-100 fw-bold">
                                    Tìm
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- BẢNG DANH SÁCH -->
            <div class="card shadow-sm">
                <div class="card-header bg-dark text-white d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="bi bi-cup-hot"></i> Danh Sách Sản Phẩm</h5>
                    <div>
                        <!-- Nút Xóa bộ lọc (Chỉ hiển thị khi đang trong trạng thái tìm kiếm) -->
                        <c:if test="${not empty requestScope.selectedKeyword or (not empty requestScope.selectedDanhMuc and requestScope.selectedDanhMuc != 'all')}">
                            <a href="${pageContext.request.contextPath}/san-pham?action=list" class="btn btn-sm btn-warning text-dark fw-bold me-2">
                                <i class="bi bi-x-circle"></i> Bỏ bộ lọc
                            </a>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/san-pham?action=list" class="btn btn-sm btn-outline-light">
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
                            <th>Mã SP</th>
                            <th>Tên Sản Phẩm</th>
                            <th>Danh Mục</th>
                            <th class="text-center">Trạng Thái</th>
                            <th class="text-center">Hành Động</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty requestScope.danhSachSp}">
                                <c:forEach var="sp" items="${requestScope.danhSachSp}" varStatus="status">
                                    <tr>
                                        <td class="text-center fw-bold">${status.index + 1}</td>
                                        <td class="text-center">
                                            <!-- Sử dụng sp.tenSP cho thuộc tính alt -->
                                            <img src="${pageContext.request.contextPath}/assets/img/${not empty sp.hinhAnh ? sp.hinhAnh : 'default.png'}"
                                                 class="product-img"
                                                 onerror="this.src='https://placehold.co/100x100?text=No+Image'"
                                                 alt="${sp.tenSP}">
                                        </td>
                                        <!-- Sử dụng sp.maSP và sp.tenSP -->
                                        <td class="fw-bold text-secondary">${sp.maSP}</td>
                                        <td class="fw-medium">${sp.tenSP}</td>
                                        <td>
                                            <span class="badge bg-secondary">${sp.danhMuc.tenDanhMuc}</span>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${sp.trangThai == 1}">
                                                    <span class="badge bg-success">Đang Bán</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger">Ngừng Bán</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <!-- Chuyển trạng thái nhanh, truyền id = sp.maSP -->
                                            <c:choose>
                                                <c:when test="${sp.trangThai == 1}">
                                                    <a href="${pageContext.request.contextPath}/san-pham?action=toggle-status&id=${sp.maSP}&status=0"
                                                       class="btn btn-sm btn-outline-danger" title="Ngừng bán">
                                                        <i class="bi bi-pause-circle"></i>
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/san-pham?action=toggle-status&id=${sp.maSP}&status=1"
                                                       class="btn btn-sm btn-outline-success" title="Mở bán lại">
                                                        <i class="bi bi-play-circle"></i>
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>

                                            <!-- Sửa thông tin: Gọi hàm JS kèm tham số maSP và tenSP -->
                                            <button class="btn btn-sm btn-warning" data-bs-toggle="modal" data-bs-target="#editSpModal"
                                                    onclick="fillEditModal('${sp.maSP}', '${sp.tenSP}', '${sp.hinhAnh}', '${sp.danhMuc.maDanhMuc}')">
                                                <i class="bi bi-pencil-square"></i>
                                            </button>

                                            <!-- Xóa sản phẩm: Truyền id = sp.maSP và tên = sp.tenSP -->
                                            <a href="${pageContext.request.contextPath}/san-pham?action=delete&id=${sp.maSP}"
                                               class="btn btn-sm btn-danger"
                                               onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm ${sp.tenSP}?');">
                                                <i class="bi bi-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7" class="text-center text-muted py-4">Chưa có sản phẩm nào khớp với bộ lọc tìm kiếm.</td>
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

<!-- MODAL CẬP NHẬT SẢN PHẨM -->
<div class="modal fade" id="editSpModal" tabindex="-1" aria-labelledby="editSpModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-warning">
                <h5 class="modal-title fw-bold" id="editSpModalLabel"><i class="bi bi-pencil-square"></i> Cập Nhật Sản Phẩm</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/san-pham" method="post">
                <div class="modal-body">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="maSP" id="edit_maSP">

                    <div class="mb-3">
                        <label class="form-label text-muted fw-bold">Mã Sản Phẩm</label>
                        <input type="text" class="form-control bg-light" id="display_maSP" disabled>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Tên Sản Phẩm</label>
                        <input type="text" class="form-control" name="tenSanPham" id="edit_tenSanPham" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Danh Mục</label>
                        <select class="form-select" name="maDanhMuc" id="edit_maDanhMuc" required>
                            <c:forEach var="dm" items="${requestScope.danhSachDm}">
                                <option value="${dm.maDanhMuc}">${dm.tenDanhMuc}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Tên File Hình Ảnh</label>
                        <input type="text" class="form-control" name="hinhAnh" id="edit_hinhAnh">
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

<script>
    // Hàm nạp dữ liệu từ dòng được chọn vào Modal sửa
    function fillEditModal(maSP, tenSP, hinhAnh, maDanhMuc) {
        document.getElementById('edit_maSP').value = maSP;
        document.getElementById('display_maSP').value = maSP;
        document.getElementById('edit_tenSP').value = tenSP;
        document.getElementById('edit_hinhAnh').value = hinhAnh;
        document.getElementById('edit_maDanhMuc').value = maDanhMuc;
    }
</script>

</body>
</html>