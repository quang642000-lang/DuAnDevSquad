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
    <style>body { background-color: #f4f6f9; }</style>
</head>
<body>

<div class="container-fluid mt-4 px-4 mb-5">
    <!-- HEADER & NÚT QUAY LẠI -->
    <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom border-2 border-primary">
        <h3 class="text-primary fw-bold m-0"><i class="bi bi-people-fill me-2"></i>QUẢN LÝ TÀI KHOẢN NHÂN VIÊN</h3>
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
        <!-- FORM THÊM NHÂN VIÊN -->
        <div class="col-lg-3 mb-4">
            <div class="card shadow-sm border-0 rounded-3">
                <div class="card-header bg-primary text-white py-3">
                    <h5 class="mb-0 fw-bold"><i class="bi bi-person-plus-fill"></i> Thêm Tài Khoản Mới</h5>
                </div>
                <div class="card-body bg-white p-3">
                    <form action="${pageContext.request.contextPath}/nhan-vien" method="post">
                        <input type="hidden" name="action" value="add">

                        <div class="mb-3">
                            <label class="form-label fw-bold text-dark small">Họ và Tên</label>
                            <input type="text" class="form-control" name="hoTen" placeholder="VD: Nguyễn Văn A" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold text-dark small">Số Điện Thoại</label>
                            <input type="text" class="form-control" name="SDT" placeholder="Gồm 10 số..." pattern="\d{10}" required>
                        </div>

                        <!-- ĐÃ THÊM TRƯỜNG EMAIL VÀO FORM THÊM MỚI -->
                        <div class="mb-3">
                            <label class="form-label fw-bold text-dark small">Địa Chỉ Email</label>
                            <input type="email" class="form-control border-info" name="email" placeholder="VD: email@domain.com" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold text-dark small">Tên Đăng Nhập</label>
                            <input type="text" class="form-control border-primary" name="tenDangNhap" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold text-dark small">Mật Khẩu</label>
                            <input type="password" class="form-control border-danger" name="matKhau" required>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold text-dark small">Vai Trò Hệ Thống</label>
                            <select class="form-select border-success" name="maVaiTro" required>
                                <option value="1">Admin (Quản trị viên)</option>
                                <option value="2" selected>Nhân Viên Bán Hàng</option>
                            </select>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 fw-bold py-2 shadow-sm">
                            <i class="bi bi-save"></i> Khởi Tạo Tài Khoản
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <!-- DANH SÁCH NHÂN VIÊN -->
        <div class="col-lg-9 mb-4">
            <div class="card shadow-sm border-0 rounded-3">
                <div class="card-header bg-dark text-white d-flex justify-content-between align-items-center py-3">
                    <h5 class="mb-0 fw-bold"><i class="bi bi-person-lines-fill"></i> Danh Sách Hệ Thống</h5>
                    <a href="${pageContext.request.contextPath}/nhan-vien?action=list" class="btn btn-sm btn-outline-light">
                        <i class="bi bi-arrow-clockwise"></i> Làm mới
                    </a>
                </div>
                <div class="card-body p-0">
                    <table class="table table-striped table-hover mb-0 align-middle text-center">
                        <thead class="table-secondary">
                        <tr>
                            <th width="10%">Mã NV</th>
                            <th class="text-start">Họ Tên</th>
                            <th>Liên Hệ</th>
                            <th>Tài Khoản</th>
                            <th>Quyền Hạn</th>
                            <th>Trạng Thái</th>
                            <th>Hành Động</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty requestScope.danhSach}">
                                <c:forEach var="nv" items="${requestScope.danhSach}">
                                    <tr>
                                        <td class="fw-bold text-secondary">${nv.maNV}</td>
                                        <td class="text-start fw-bold text-dark">
                                                ${nv.hoTen}
                                        </td>
                                        <td>
                                            <!-- ĐÃ BỔ SUNG HIỂN THỊ EMAIL Ở BẢNG -->
                                            <div class="small"><i class="bi bi-telephone"></i> ${nv.SDT}</div>
                                            <div class="small text-muted"><i class="bi bi-envelope"></i> ${nv.email}</div>
                                        </td>
                                        <td class="fst-italic text-primary">${nv.tenDangNhap}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${nv.vaiTro.maVaiTro == 1}">
                                                    <span class="badge bg-danger shadow-sm"><i class="bi bi-shield-lock-fill"></i> ${nv.vaiTro.tenVaiTro}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-info text-dark shadow-sm"><i class="bi bi-person-badge"></i> ${nv.vaiTro.tenVaiTro}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${nv.trangThai == 1}">
                                                    <span class="badge bg-success">Hoạt Động</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-dark">Bị Khóa</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
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

                                            <!-- Sửa thông tin (Đã sửa hàm truyền thêm email) -->
                                            <button class="btn btn-sm btn-warning ms-1 text-dark" data-bs-toggle="modal" data-bs-target="#editModal" title="Sửa thông tin"
                                                    onclick="fillEditModal('${nv.maNV}', '${fn:escapeXml(nv.hoTen)}', '${nv.SDT}', '${nv.email}', '${nv.tenDangNhap}', '${nv.vaiTro.maVaiTro}')">
                                                <i class="bi bi-pencil-square"></i>
                                            </button>

                                            <!-- Nút đổi mật khẩu mới -->
                                            <button class="btn btn-sm btn-info ms-1 text-white" data-bs-toggle="modal" data-bs-target="#resetPasswordModal" title="Cấp lại mật khẩu"
                                                    onclick="fillResetPasswordModal('${nv.maNV}', '${nv.tenDangNhap}')">
                                                <i class="bi bi-key-fill"></i>
                                            </button>

                                            <!-- Xóa NV -->
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
        <div class="modal-content border-0 shadow">
            <div class="modal-header bg-warning">
                <h5 class="modal-title fw-bold text-dark"><i class="bi bi-pencil-square"></i> Sửa Thông Tin Cá Nhân</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/nhan-vien" method="post">
                <div class="modal-body bg-light p-4">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="maNV" id="edit_maNV">

                    <div class="mb-3">
                        <label class="form-label text-muted fw-bold small">Mã Hệ Thống</label>
                        <input type="text" class="form-control bg-white fw-bold text-secondary" id="display_maNV" disabled>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold text-dark small">Họ và Tên</label>
                        <input type="text" class="form-control border-primary" name="hoTen" id="edit_hoTen" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold text-dark small">Số Điện Thoại</label>
                        <input type="text" class="form-control border-primary" name="SDT" id="edit_SDT" required pattern="\d{10}">
                    </div>

                    <!-- ĐÃ THÊM INPUT SỬA EMAIL -->
                    <div class="mb-3">
                        <label class="form-label fw-bold text-dark small">Địa Chỉ Email</label>
                        <input type="email" class="form-control border-info" name="email" id="edit_email" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold text-dark small">Tên Đăng Nhập</label>
                        <input type="text" class="form-control border-primary" name="tenDangNhap" id="edit_tenDangNhap" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold text-dark small">Vai Trò</label>
                        <select class="form-select border-success" name="maVaiTro" id="edit_maVaiTro" required>
                            <option value="1">Admin</option>
                            <option value="2">Nhân Viên</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer bg-white">
                    <button type="button" class="btn btn-secondary fw-bold" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary fw-bold"><i class="bi bi-save"></i> Cập Nhật</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- MODAL CẤP LẠI MẬT KHẨU -->
<div class="modal fade" id="resetPasswordModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content border-0 shadow">
            <div class="modal-header bg-info text-white">
                <h5 class="modal-title fw-bold"><i class="bi bi-key-fill"></i> Đổi Mật Khẩu Khẩn Cấp</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/nhan-vien" method="post">
                <div class="modal-body bg-light p-4">
                    <input type="hidden" name="action" value="reset-password">
                    <input type="hidden" name="maNV" id="reset_maNV">

                    <div class="mb-3">
                        <label class="form-label text-muted fw-bold small">Tài Khoản Đang Xử Lý:</label>
                        <input type="text" class="form-control bg-white fw-bold text-danger" id="display_reset_tenDangNhap" disabled>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold text-dark">Mật Khẩu Mới</label>
                        <input type="password" class="form-control border-danger" name="matKhauMoi" placeholder="Nhập ít nhất 6 ký tự..." required minlength="6">
                    </div>
                </div>
                <div class="modal-footer bg-white">
                    <button type="button" class="btn btn-secondary fw-bold" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-info text-white fw-bold"><i class="bi bi-shield-check"></i> Xác Nhận Đổi</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // ĐÃ SỬA HÀM TRUYỀN THÊM EMAIL
    function fillEditModal(maNV, hoTen, SDT, email, tenDN, maVaiTro) {
        document.getElementById('edit_maNV').value = maNV;
        document.getElementById('display_maNV').value = maNV;
        document.getElementById('edit_hoTen').value = hoTen;
        document.getElementById('edit_SDT').value = SDT;
        document.getElementById('edit_email').value = email;
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