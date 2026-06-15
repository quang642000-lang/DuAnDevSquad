<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Danh Mục - TEA POS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css?v=4">

    <!-- DataTables CSS cho Mobile -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/responsive/2.5.0/css/responsive.bootstrap5.min.css">
</head>
<body>
<%@ include file="layout/toast.jsp" %>

<div class="wrapper">
    <%@ include file="layout/sidebar.jsp" %>
    <div class="main-content">
        <header class="top-navbar bg-white shadow-sm mb-4 px-4 py-3 d-flex justify-content-between align-items-center">
            <div class="d-flex align-items-center">
                <button class="btn btn-light me-3 border-0 shadow-sm d-lg-none" onclick="toggleSidebar()"><i class="bi bi-list fs-5"></i></button>
                <h4 class="text-dark fw-bold m-0"><i class="bi bi-cup-hot-fill text-brand me-2"></i>Quản Lý...</h4> <!-- Sửa tên tiêu đề tương ứng -->
            </div>
            <div class="d-flex align-items-center"><span class="fw-bold text-dark d-none d-md-block me-3">${sessionScope.nhanVienDangNhap.hoTen}</span></div>
        </header>
        <div class="container-fluid px-4 mb-5">
        <!-- BẢNG DANH SÁCH CHIẾM 100% -->
        <div class="col-12 mb-4">
            <div class="card h-100">
                <div class="card-header d-flex flex-wrap justify-content-between align-items-center py-3 gap-2">
                    <h5 class="mb-0 fw-bold text-dark"><i class="bi bi-list-ul text-brand me-2"></i>Danh Sách Phân Loại</h5>

                    <div class="d-flex align-items-center gap-2">
                        <!-- FORM TÌM KIẾM BACKEND CHUẨN MỰC -->
                        <form action="${pageContext.request.contextPath}/danh-muc" method="get" class="d-flex m-0">
                            <input type="hidden" name="action" value="search">
                            <div class="input-group shadow-sm flex-grow-1">
                                <input type="text" class="form-control" name="keyword" placeholder="Tìm tên danh mục..." value="${param.keyword}">
                                <button class="btn btn-dark fw-bold" type="submit"><i class="bi bi-search"></i></button>
                            </div>
                        </form>
                        <c:if test="${not empty param.keyword}">
                            <a href="${pageContext.request.contextPath}/danh-muc?action=list" class="btn btn-light text-danger fw-bold shadow-sm"><i class="bi bi-x-circle"></i></a>
                        </c:if>

                        <!-- NÚT MỞ MODAL THÊM MỚI -->
                        <button type="button" class="btn btn-brand fw-bold shadow-sm rounded-pill px-3" data-bs-toggle="modal" data-bs-target="#addModal">
                            <i class="bi bi-plus-circle me-1"></i> Thêm Mới
                        </button>
                    </div>
                </div>

                <div class="card-body p-3">
                    <div class="table-responsive">
                        <table class="table table-hover table-custom mb-0 text-center align-middle dt-responsive nowrap" style="width:100%" id="danhMucTable">
                            <thead>
                            <tr>
                                <th class="text-center" width="10%">STT</th>
                                <th class="text-center" width="20%">Mã DM</th>
                                <th>Tên Danh Mục</th>
                                <th class="text-center" width="25%">Thao Tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="dm" items="${requestScope.danhSach}" varStatus="status">
                                <tr>
                                    <td class="text-center fw-semibold text-muted">
                                        <c:choose>
                                            <c:when test="${not empty currentPage}">${(currentPage - 1) * 5 + status.index + 1}</c:when>
                                            <c:otherwise>${status.index + 1}</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center fw-semibold text-brand">${dm.maDanhMuc}</td>
                                    <td class="fw-bold text-dark fs-6">${dm.tenDanhMuc}</td>
                                    <td class="text-center">
                                        <div class="btn-group btn-group-sm shadow-sm">
                                            <button class="btn btn-light text-primary border" data-bs-toggle="modal" data-bs-target="#editModal"
                                                    data-id="${dm.maDanhMuc}"
                                                    data-name="${fn:escapeXml(dm.tenDanhMuc)}"
                                                    onclick="fillEditModal(this.getAttribute('data-id'), this.getAttribute('data-name'))">
                                                <i class="bi bi-pencil-square"></i>
                                            </button>
                                            <a href="${pageContext.request.contextPath}/danh-muc?action=delete&id=${dm.maDanhMuc}"
                                               class="btn btn-light text-danger border"
                                               data-name="${fn:escapeXml(dm.tenDanhMuc)}"
                                               onclick="event.preventDefault(); showConfirmLink('Xóa Danh Mục', 'Bạn có chắc chắn muốn xóa danh mục [' + this.getAttribute('data-name') + ']?', this.href);">
                                                <i class="bi bi-trash"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>

                        <!-- PHÂN TRANG SERVER-SIDE -->
                        <c:if test="${totalPages > 1}">
                            <jsp:include page="layout/pagination.jsp">
                                <jsp:param name="baseUrl" value="/danh-muc?action=list" />
                            </jsp:include>
                        </c:if>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</div> <!-- Đóng container-fluid -->
</div> <!-- Đóng main-content -->
</div> <!-- Đóng wrapper -->

<!-- CÁC MODAL BÊN DƯỚI GIỮ NGUYÊN... -->
<%@ include file="layout/confirm_modal.jsp" %>

<!-- MODAL THÊM MỚI (CHUYỂN TỪ CỘT TRÁI VÀO ĐÂY) -->
<div class="modal fade" id="addModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content shadow-lg border-0" style="border-radius: 16px;">
            <div class="modal-header border-0 py-3 bg-light">
                <h5 class="modal-title fw-bold text-dark"><i class="bi bi-plus-circle-fill text-brand me-2"></i>Thêm Danh Mục Mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/danh-muc" method="post" onsubmit="showConfirmForm(event, this, 'Tạo Danh Mục', 'Xác nhận tạo danh mục mới này?');">
                <div class="modal-body p-4">
                    <input type="hidden" name="action" value="add">
                    <div class="mb-3">
                        <label class="form-label fw-semibold text-muted small text-uppercase">Tên Danh Mục</label>
                        <input type="text" class="form-control" name="tenDanhMuc" placeholder="VD: Trà Sữa, Cà Phê..." required>
                    </div>
                </div>
                <div class="modal-footer bg-light border-0 p-3">
                    <button type="button" class="btn btn-light fw-bold rounded-pill px-4 border me-2" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-brand fw-bold rounded-pill px-4 shadow-sm"><i class="bi bi-check2 me-1"></i> Khởi Tạo</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- MODAL SỬA -->
<div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content shadow-lg border-0" style="border-radius: 16px;">
            <div class="modal-header bg-light border-0 py-3">
                <h5 class="modal-title fw-bold text-dark"><i class="bi bi-pencil-square text-brand me-2"></i>Cập Nhật Danh Mục</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/danh-muc" method="post" onsubmit="showConfirmForm(event, this, 'Lưu Thay Đổi', 'Bạn chắc chắn muốn lưu thông tin này?');">
                <div class="modal-body p-4">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="maDanhMuc" id="edit_maDanhMuc">
                    <div class="mb-3">
                        <label class="form-label text-muted fw-bold small text-uppercase">Mã Danh Mục</label>
                        <input type="text" class="form-control bg-light fw-bold text-muted border-0" id="display_maDanhMuc" disabled>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold text-dark small text-uppercase">Tên Danh Mục</label>
                        <input type="text" class="form-control" name="tenDanhMuc" id="edit_tenDanhMuc" required>
                    </div>
                </div>
                <div class="modal-footer bg-light border-0 p-3">
                    <button type="button" class="btn btn-light fw-bold rounded-pill px-4 border" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-brand fw-bold rounded-pill px-4">Lưu Thay Đổi</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.0.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script src="${pageContext.request.contextPath}/assets/js/global.js"></script>

<script>
    function fillEditModal(maDM, tenDM) {
        document.getElementById("edit_maDanhMuc").value = maDM;
        document.getElementById("display_maDanhMuc").value = maDM;
        document.getElementById("edit_tenDanhMuc").value = tenDM;
    }
</script>

<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.datatables.net/responsive/2.5.0/js/dataTables.responsive.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.datatables.net/responsive/2.5.0/js/responsive.bootstrap5.min.js" crossorigin="anonymous"></script>

<script>
    $(document).ready(function() {
        $('#danhMucTable').DataTable({
            "responsive": true,
            "paging": false,
            "searching": false,
            "info": false,
            "order": [],
            "columnDefs": [
                { "orderable": false, "targets": [3] }
            ],
            "language": {
                "emptyTable": "<div class='text-muted py-5'><i class='bi bi-inbox fs-1 d-block mb-3 opacity-50'></i>Chưa có danh mục nào.</div>"
            }
        });
    });
</script>
</body>
</html>