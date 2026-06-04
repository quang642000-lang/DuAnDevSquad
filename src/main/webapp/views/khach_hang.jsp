<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý Khách Hàng</title>
    <!-- Thêm Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body class="bg-light">

<div class="container mt-5">
    <h2 class="mb-4 text-center text-primary">QUẢN LÝ KHÁCH HÀNG</h2>

    <!-- Hiển thị thông báo (Thêm thành công / Thất bại) từ Session -->
    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-info alert-dismissible fade show shadow-sm" role="alert">
            <strong>Thông báo:</strong> ${sessionScope.message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="message" scope="session"/>
    </c:if>

    <div class="row">
        <!-- CỘT 1: FORM THÊM KHÁCH HÀNG -->
        <div class="col-md-6 mb-4">
            <div class="card shadow-sm h-100">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0">Thêm Khách Hàng Mới</h5>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/khach-hang" method="post">
                        <input type="hidden" name="action" value="add">
                        <div class="mb-3">
                            <label class="form-label">Tên Khách Hàng</label>
                            <input type="text" class="form-control" name="tenKhachHang" placeholder="Nhập họ và tên" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Số Điện Thoại</label>
                            <input type="text" class="form-control" name="soDienThoai" placeholder="Nhập 10 chữ số" required pattern="\d{10}">
                        </div>
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="bi bi-plus-circle"></i> Thêm Khách Hàng
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <!-- CỘT 2: FORM TÌM KIẾM THEO SĐT -->
        <div class="col-md-6 mb-4">
            <div class="card shadow-sm h-100">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0">Tìm Kiếm Khách Hàng</h5>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/khach-hang" method="get">
                        <input type="hidden" name="action" value="search">
                        <div class="mb-3">
                            <label class="form-label">Tìm theo Số Điện Thoại</label>
                            <div class="input-group">
                                <input type="text" class="form-control" name="sdt" placeholder="Nhập số điện thoại..." value="${param.sdt}" required>
                                <button class="btn btn-success" type="submit">Tìm Kiếm</button>
                            </div>
                        </div>
                    </form>

                    <c:if test="${not empty requestScope.khachHangTimDuoc}">
                        <div class="alert alert-success mt-3 shadow-sm">
                            <h6 class="alert-heading fw-bold">Đã tìm thấy:</h6><hr>
                            <p class="mb-1"><strong>Mã KH:</strong> ${khachHangTimDuoc.maKH}</p>
                            <p class="mb-1"><strong>Tên KH:</strong> ${khachHangTimDuoc.tenKH}</p>
                            <p class="mb-1"><strong>SĐT:</strong> ${khachHangTimDuoc.SDT}</p>
                            <p class="mb-0"><strong>Điểm tích lũy:</strong> <span class="badge bg-warning text-dark fs-6">${khachHangTimDuoc.diemTichLuy}</span></p>
                        </div>
                    </c:if>

                    <c:if test="${param.action == 'search' and empty requestScope.khachHangTimDuoc}">
                        <div class="alert alert-danger mt-3 shadow-sm">
                            Không tìm thấy khách hàng nào với số điện thoại <strong>${param.sdt}</strong>!
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- DANH SÁCH KHÁCH HÀNG -->
    <div class="card shadow-sm mb-5">
        <div class="card-header bg-dark text-white d-flex justify-content-between align-items-center">
            <h5 class="mb-0">Danh Sách Khách Hàng</h5>
            <a href="${pageContext.request.contextPath}/khach-hang?action=list" class="btn btn-sm btn-outline-light">Tải lại danh sách</a>
        </div>
        <div class="card-body p-0">
            <table class="table table-striped table-hover mb-0">
                <thead class="table-secondary">
                <tr>
                    <th class="text-center">STT</th>
                    <th>Mã KH</th>
                    <th>Tên Khách Hàng</th>
                    <th>Số Điện Thoại</th>
                    <th class="text-center">Điểm Tích Lũy</th>
                    <th class="text-center">Hành Động</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${not empty requestScope.danhSach}">
                        <c:forEach var="kh" items="${requestScope.danhSach}" varStatus="status">
                            <tr>
                                <td class="text-center fw-bold">${status.index + 1}</td>
                                <td>${kh.maKH}</td>
                                <td>${kh.tenKH}</td>
                                <td>${kh.SDT}</td>
                                <td class="text-center fw-bold text-success">${kh.diemTichLuy}</td>
                                <td class="text-center">
                                    <!-- Nút Mở Modal Sửa -->
                                    <button class="btn btn-sm btn-warning" data-bs-toggle="modal" data-bs-target="#editModal"
                                            onclick="fillEditModal('${kh.maKH}', '${kh.tenKH}', '${kh.SDT}')">
                                        <i class="bi bi-pencil-square"></i> Sửa
                                    </button>

                                    <!-- Nút Xóa (Xác nhận trước khi xóa) -->
                                    <a href="${pageContext.request.contextPath}/khach-hang?action=delete&maKH=${kh.maKH}"
                                       class="btn btn-sm btn-danger"
                                       onclick="return confirm('Bạn có chắc chắn muốn xóa khách hàng ${kh.tenKH} không?');">
                                        <i class="bi bi-trash"></i> Xóa
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="6" class="text-center text-muted py-4">Chưa có dữ liệu khách hàng nào trong hệ thống.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- MODAL CẬP NHẬT KHÁCH HÀNG -->
<div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-warning">
                <h5 class="modal-title fw-bold" id="editModalLabel">Cập Nhật Thông Tin</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/khach-hang" method="post">
                <div class="modal-body">
                    <input type="hidden" name="action" value="update">
                    <!-- Trường ẩn chứa mã KH để gửi về server -->
                    <input type="hidden" name="maKH" id="edit_maKH">

                    <div class="mb-3">
                        <label class="form-label text-muted">Mã Khách Hàng</label>
                        <!-- Input chỉ hiển thị, không cho phép sửa mã -->
                        <input type="text" class="form-control fw-bold" id="display_maKH" disabled>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Tên Khách Hàng</label>
                        <input type="text" class="form-control" name="tenKhachHang" id="edit_tenKH" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Số Điện Thoại</label>
                        <input type="text" class="form-control" name="soDienThoai" id="edit_sdt" required pattern="\d{10}">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn btn-primary">Lưu Thay Đổi</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- JS Script để điền dữ liệu vào Modal khi bấm nút Sửa -->
<script>
    function fillEditModal(maKH, tenKH, sdt) {
        document.getElementById("edit_maKH").value = maKH;
        document.getElementById("display_maKH").value = maKH; // Chỉ để hiển thị
        document.getElementById("edit_tenKH").value = tenKH;
        document.getElementById("edit_sdt").value = sdt;
    }
</script>

</body>
</html>