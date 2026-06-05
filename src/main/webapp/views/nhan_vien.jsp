<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Nhân Viên</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body class="bg-light">

<div class="container-fluid mt-4 px-4">
    <h2 class="mb-4 text-center text-primary fw-bold">QUẢN LÝ TÀI KHOẢN NHÂN VIÊN</h2>

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
        <!-- FORM THÊM NHÂN VIÊN -->
        <div class="col-lg-3 mb-4">
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0"><i class="bi bi-person-plus-fill"></i> Thêm Nhân Viên Mới</h5>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/nhan-vien" method="post">
                        <input type="hidden" name="action" value="add">

                        <div class="mb-3">
                            <label class="form-label fw-bold">Họ và Tên</label>
                            <input type="text" class="form-control" name="hoTen" placeholder="VD: Nguyễn Văn A" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Số Điện Thoại</label>
                            <!-- Sửa name thành SDT -->
                            <input type="text" class="form-control" name="SDT" placeholder="Nhập 10 chữ số" pattern="\d{10}" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Tên Đăng Nhập</label>
                            <input type="text" class="form-control" name="tenDangNhap" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Mật Khẩu</label>
                            <input type="password" class="form-control" name="matKhau" required>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold">Vai Trò</label>
                            <select class="form-select" name="maVaiTro" required>
                                <option value="1">Admin (Quản trị viên)</option>
                                <option value="2" selected>Nhân Viên</option>
                            </select>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 fw-bold">
                            <i class="bi bi-save"></i> Tạo Tài Khoản
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <!-- DANH SÁCH NHÂN VIÊN -->
        <div class="col-lg-9 mb-4">
            <div class="card shadow-sm">
                <div class="card-header bg-dark text-white d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="bi bi-people-fill"></i> Danh Sách Tài Khoản</h5>
                    <a href="${pageContext.request.contextPath}/nhan-vien?action=list" class="btn btn-sm btn-outline-light">
                        <i class="bi bi-arrow-clockwise"></i> Làm mới
                    </a>
                </div>
                <div class="card-body p-0">
                    <table class="table table-striped table-hover mb-0 align-middle">
                        <thead class="table-secondary">
                        <tr>
                            <th class="text-center">Mã NV</th>
                            <th>Họ Tên</th>
                            <th>SĐT</th>
                            <th>Tên Đăng Nhập</th>
                            <th class="text-center">Vai Trò</th>
                            <th class="text-center">Trạng Thái</th>
                            <th class="text-center">Hành Động</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty requestScope.danhSach}">
                                <c:forEach var="nv" items="${requestScope.danhSach}">
                                    <tr>
                                        <!-- Khớp chính xác tên biến maNV, SDT -->
                                        <td class="text-center fw-bold text-secondary">${nv.maNV}</td>
                                        <td class="fw-bold">${nv.hoTen}</td>
                                        <td>${nv.SDT}</td>
                                        <td class="fst-italic">${nv.tenDangNhap}</td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${nv.vaiTro.maVaiTro == 1}">
                                                    <span class="badge bg-danger"><i class="bi bi-shield-lock-fill"></i> ${nv.vaiTro.tenVaiTro}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-info text-dark"><i class="bi bi-person-badge"></i> ${nv.vaiTro.tenVaiTro}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${nv.trangThai == 1}">
                                                    <span class="badge bg-success">Hoạt Động</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-dark">Đã Khóa</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <!-- Nút Khóa / Mở Khóa -->
                                            <c:choose>
                                                <c:when test="${nv.trangThai == 1}">
                                                    <a href="${pageContext.request.contextPath}/nhan-vien?action=toggle-status&id=${nv.maNV}&status=0"
                                                       class="btn btn-sm btn-outline-danger" title="Khóa tài khoản"
                                                       onclick="return confirm('Khóa tài khoản của ${fn:escapeXml(nv.hoTen)}?');">
                                                        <i class="bi bi-lock-fill"></i>
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/nhan-vien?action=toggle-status&id=${nv.maNV}&status=1"
                                                       class="btn btn-sm btn-outline-success" title="Mở khóa">
                                                        <i class="bi bi-unlock-fill"></i>
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>

                                            <!-- Sửa thông tin (Bỏ truyền Mật khẩu) -->
                                            <button class="btn btn-sm btn-warning ms-1" data-bs-toggle="modal" data-bs-target="#editModal" title="Sửa thông tin"
                                                    onclick="fillEditModal('${nv.maNV}', '${fn:escapeXml(nv.hoTen)}', '${nv.SDT}', '${nv.tenDangNhap}', '${nv.vaiTro.maVaiTro}')">
                                                <i class="bi bi-pencil-square"></i>
                                            </button>

                                            <!-- Nút đổi mật khẩu mới (Reset Password) -->
                                            <button class="btn btn-sm btn-info ms-1 text-white" data-bs-toggle="modal" data-bs-target="#resetPasswordModal" title="Cấp lại mật khẩu"
                                                    onclick="fillResetPasswordModal('${nv.maNV}', '${nv.tenDangNhap}')">
                                                <i class="bi bi-key-fill"></i>
                                            </button>

                                            <!-- Xóa NV (Fix lỗi lấy sai id sp.maNV) -->
                                            <a href="${pageContext.request.contextPath}/nhan-vien?action=delete&id=${nv.maNV}"
                                               class="btn btn-sm btn-secondary ms-1" title="Xóa nhân viên"
                                               onclick="return confirm('Bạn có chắc chắn muốn xóa vĩnh viễn nhân viên ${fn:escapeXml(nv.hoTen)} không?');">
                                                <i class="bi bi-trash-fill"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7" class="text-center text-muted py-4">Chưa có dữ liệu nhân viên.</td>
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

<!-- MODAL CẬP NHẬT THÔNG TIN -->
<div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-warning">
                <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square"></i> Sửa Thông Tin Nhân Viên</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/nhan-vien" method="post">
                <div class="modal-body">
                    <input type="hidden" name="action" value="update">
                    <!-- Sửa name thành maNV -->
                    <input type="hidden" name="maNV" id="edit_maNV">

                    <div class="mb-3">
                        <label class="form-label text-muted fw-bold">Mã Nhân Viên</label>
                        <input type="text" class="form-control bg-light fw-bold text-secondary" id="display_maNV" disabled>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Họ và Tên</label>
                        <input type="text" class="form-control" name="hoTen" id="edit_hoTen" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Số Điện Thoại</label>
                        <!-- Sửa name thành SDT -->
                        <input type="text" class="form-control" name="SDT" id="edit_SDT" required pattern="\d{10}">
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Tên Đăng Nhập</label>
                        <input type="text" class="form-control" name="tenDangNhap" id="edit_tenDangNhap" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Vai Trò</label>
                        <select class="form-select" name="maVaiTro" id="edit_maVaiTro" required>
                            <option value="1">Admin</option>
                            <option value="2">Nhân Viên</option>
                        </select>
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

<!-- MODAL CẤP LẠI MẬT KHẨU -->
<div class="modal fade" id="resetPasswordModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-info text-white">
                <h5 class="modal-title fw-bold"><i class="bi bi-key-fill"></i> Cấp Lại Mật Khẩu</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/nhan-vien" method="post">
                <div class="modal-body">
                    <input type="hidden" name="action" value="reset-password">
                    <input type="hidden" name="maNV" id="reset_maNV">

                    <div class="mb-3">
                        <label class="form-label text-muted fw-bold">Tài Khoản Đang Chọn:</label>
                        <input type="text" class="form-control bg-light fw-bold text-danger" id="display_reset_tenDangNhap" disabled>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Nhập Mật Khẩu Mới</label>
                        <input type="text" class="form-control" name="matKhauMoi" placeholder="Nhập mật khẩu mới..." required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary fw-bold" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-info fw-bold text-white">Cập Nhật Mật Khẩu</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Điền form Cập nhật thông tin (Không truyền matKhau)
    function fillEditModal(maNV, hoTen, SDT, tenDN, maVaiTro) {
        document.getElementById('edit_maNV').value = maNV;
        document.getElementById('display_maNV').value = maNV;
        document.getElementById('edit_hoTen').value = hoTen;
        document.getElementById('edit_SDT').value = SDT;
        document.getElementById('edit_tenDangNhap').value = tenDN;
        document.getElementById('edit_maVaiTro').value = maVaiTro;
    }

    // Điền form Cấp lại mật khẩu
    function fillResetPasswordModal(maNV, tenDN) {
        document.getElementById('reset_maNV').value = maNV;
        document.getElementById('display_reset_tenDangNhap').value = tenDN;
    }
</script>

</body>
</html>