<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Khách Hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>body { background-color: #f4f6f9; }</style>
</head>
<body>

<div class="container-fluid mt-4 px-4 mb-5">
    <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom border-2 border-primary">
        <h3 class="text-primary fw-bold m-0"><i class="bi bi-person-vcard-fill me-2"></i>QUẢN LÝ KHÁCH HÀNG CRM</h3>
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
        <!-- FORM THÊM & TÌM KIẾM -->
        <div class="col-lg-4 mb-4">
            <!-- Tìm kiếm Card -->
            <div class="card shadow-sm border-0 rounded-3 mb-4">
                <div class="card-header bg-success text-white py-3">
                    <h5 class="mb-0 fw-bold"><i class="bi bi-search"></i> Tra Cứu Khách Hàng</h5>
                </div>
                <div class="card-body bg-white p-3">
                    <form action="${pageContext.request.contextPath}/khach-hang" method="get">
                        <input type="hidden" name="action" value="search">
                        <label class="form-label fw-bold text-dark small">Nhập Số Điện Thoại</label>
                        <div class="input-group">
                            <input type="text" class="form-control border-success" name="sdt" placeholder="Nhập 10 số..." value="${param.sdt}" required>
                            <button class="btn btn-success fw-bold" type="submit">Tìm</button>
                        </div>
                    </form>

                    <c:if test="${not empty requestScope.khachHangTimDuoc}">
                        <div class="alert alert-success mt-3 shadow-sm border-success bg-success bg-opacity-10 mb-0">
                            <div class="d-flex justify-content-between border-bottom border-success pb-2 mb-2">
                                <h6 class="fw-bold mb-0 text-success"><i class="bi bi-person-check-fill"></i> Đã tìm thấy</h6>
                                <span class="badge bg-warning text-dark"><i class="bi bi-coin"></i> ${khachHangTimDuoc.diemTichLuy} điểm</span>
                            </div>
                            <div class="small">
                                <span class="fw-bold text-dark d-block">${khachHangTimDuoc.tenKH}</span>
                                <span class="text-muted d-block">${khachHangTimDuoc.SDT} - Mã: ${khachHangTimDuoc.maKH}</span>
                            </div>
                        </div>
                    </c:if>
                    <c:if test="${param.action == 'search' and empty requestScope.khachHangTimDuoc}">
                        <div class="alert alert-danger mt-3 shadow-sm small mb-0"><i class="bi bi-info-circle-fill"></i> Không tìm thấy khách hàng.</div>
                    </c:if>
                </div>
            </div>

            <!-- Thêm mới Card -->
            <div class="card shadow-sm border-0 rounded-3">
                <div class="card-header bg-primary text-white py-3">
                    <h5 class="mb-0 fw-bold"><i class="bi bi-person-plus-fill"></i> Mở Thẻ Khách Hàng</h5>
                </div>
                <div class="card-body bg-white p-3">
                    <form action="${pageContext.request.contextPath}/khach-hang" method="post">
                        <input type="hidden" name="action" value="add">
                        <div class="mb-3">
                            <label class="form-label fw-bold text-dark small">Họ và Tên</label>
                            <input type="text" class="form-control" name="tenKhachHang" placeholder="Nhập họ và tên khách..." required>
                        </div>
                        <div class="mb-4">
                            <label class="form-label fw-bold text-dark small">Số Điện Thoại</label>
                            <input type="text" class="form-control" name="soDienThoai" placeholder="Gồm 10 chữ số..." required pattern="\d{10}">
                        </div>
                        <button type="submit" class="btn btn-primary w-100 fw-bold py-2 shadow-sm"><i class="bi bi-save"></i> Đăng Ký Thẻ</button>
                    </form>
                </div>
            </div>
        </div>

        <!-- BẢNG DANH SÁCH -->
        <div class="col-lg-8 mb-4">
            <div class="card shadow-sm border-0 rounded-3 h-100">
                <div class="card-header bg-dark text-white d-flex justify-content-between align-items-center py-3">
                    <h5 class="mb-0 fw-bold"><i class="bi bi-people-fill"></i> Danh Sách Thành Viên</h5>
                    <a href="${pageContext.request.contextPath}/khach-hang?action=list" class="btn btn-sm btn-outline-light"><i class="bi bi-arrow-clockwise"></i> Làm mới toàn bộ</a>
                </div>
                <div class="card-body p-0">
                    <table class="table table-striped table-hover mb-0 align-middle text-center">
                        <thead class="table-secondary">
                        <tr>
                            <th width="5%">STT</th>
                            <th width="15%">Mã KH</th>
                            <th class="text-start">Tên Khách Hàng</th>
                            <th>Số Điện Thoại</th>
                            <th>Điểm Tích Lũy</th>
                            <th>Hành Động</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty requestScope.danhSach}">
                                <c:forEach var="kh" items="${requestScope.danhSach}" varStatus="status">
                                    <tr>
                                        <td class="fw-bold">${status.index + 1}</td>
                                        <td class="fw-bold text-secondary">${kh.maKH}</td>
                                        <td class="text-start fw-bold text-dark">${kh.tenKH}</td>
                                        <td>${kh.SDT}</td>
                                        <td><span class="badge bg-warning text-dark fs-6 rounded-pill px-3 shadow-sm"><i class="bi bi-coin"></i> ${kh.diemTichLuy}</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-warning text-dark me-1" data-bs-toggle="modal" data-bs-target="#editModal"
                                                    onclick="fillEditModal('${kh.maKH}', '${fn:escapeXml(kh.tenKH)}', '${kh.SDT}')">
                                                <i class="bi bi-pencil-square"></i>
                                            </button>
                                            <a href="${pageContext.request.contextPath}/khach-hang?action=delete&maKH=${kh.maKH}"
                                               class="btn btn-sm btn-danger" onclick="return confirm('Xóa thành viên ${fn:escapeXml(kh.tenKH)}?');">
                                                <i class="bi bi-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="6" class="text-center text-muted py-4">Chưa có thành viên nào.</td></tr>
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
                <h5 class="modal-title fw-bold text-dark"><i class="bi bi-pencil-square"></i> Cập Nhật Thành Viên</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/khach-hang" method="post">
                <div class="modal-body bg-light p-4">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="maKH" id="edit_maKH">
                    <div class="mb-3">
                        <label class="form-label text-muted fw-bold small">Mã Khách Hàng</label>
                        <input type="text" class="form-control fw-bold bg-white text-secondary" id="display_maKH" disabled>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold text-dark small">Tên Khách Hàng</label>
                        <input type="text" class="form-control border-primary" name="tenKhachHang" id="edit_tenKH" required>
                    </div>
                    <div class="mb-2">
                        <label class="form-label fw-bold text-dark small">Số Điện Thoại</label>
                        <input type="text" class="form-control border-primary" name="soDienThoai" id="edit_sdt" required pattern="\d{10}">
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
    function fillEditModal(maKH, tenKH, sdt) {
        document.getElementById("edit_maKH").value = maKH;
        document.getElementById("display_maKH").value = maKH;
        document.getElementById("edit_tenKH").value = tenKH;
        document.getElementById("edit_sdt").value = sdt;
    }
</script>
</body>
</html>