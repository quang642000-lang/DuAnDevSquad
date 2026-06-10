<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Nhân Viên - TEA POS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Plus Jakarta Sans', sans-serif; background-color: #F8FAFC; color: #334155; }
        .card { border-radius: 1rem; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); border: none; background: #fff;}
        .card-header { border-top-left-radius: 1rem !important; border-top-right-radius: 1rem !important; border-bottom: 1px solid #F1F5F9; padding: 1.25rem 1.5rem; background: transparent;}
        .btn { border-radius: 0.5rem; font-weight: 600; transition: all 0.2s; }
        .btn:hover { transform: translateY(-1px); }
        .table-custom th { text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.05em; color: #64748B; background: #F8FAFC; padding: 1rem; border-bottom: none;}
        .table-custom td { vertical-align: middle; padding: 1rem; border-bottom: 1px solid #F1F5F9; }
        .form-control, .form-select { border-radius: 0.5rem; padding: 0.6rem 1rem; border-color: #CBD5E1; font-weight: 500;}
        .form-control:focus, .form-select:focus { box-shadow: 0 0 0 3px rgba(217, 119, 6, 0.15); border-color: #D97706; }
        .badge { font-weight: 600; padding: 0.4em 0.8em; border-radius: 9999px; }
        .btn-brand { background-color: #D97706; color: white; }
        .btn-brand:hover { background-color: #B45309; color: white; }
        .text-brand { color: #D97706; }
        .modal-content { border-radius: 1.25rem; border: none; }
    </style>
</head>
<body>

<div class="toast-container position-fixed top-0 end-0 p-3 mt-2" style="z-index: 1055;" id="js-toast-container">
    <c:if test="${not empty sessionScope.message}">
        <c:choose>
            <c:when test="${fn:contains(sessionScope.message, 'Lỗi') || fn:contains(sessionScope.message, 'Không thể') || fn:contains(sessionScope.message, 'thất bại')}">
                <div class="toast align-items-center border-0 mb-2 shadow-lg rounded-3 alert-danger" role="alert" aria-live="assertive" aria-atomic="true">
                    <div class="d-flex">
                        <div class="toast-body fw-bold d-flex align-items-center"><i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i> ${sessionScope.message}</div>
                        <button type="button" class="btn-close me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="toast align-items-center border-0 mb-2 shadow-lg rounded-3 alert-success" role="alert" aria-live="assertive" aria-atomic="true">
                    <div class="d-flex">
                        <div class="toast-body fw-bold d-flex align-items-center"><i class="bi bi-check-circle-fill me-2 fs-5"></i> ${sessionScope.message}</div>
                        <button type="button" class="btn-close me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
        <c:remove var="message" scope="session"/>
        <script>
            setTimeout(function() {
                let toastElList = [].slice.call(document.querySelectorAll('.toast'));
                toastElList.map(function(toastEl) { return new bootstrap.Toast(toastEl, { delay: 5000 }).show(); });
            }, 100);
        </script>
    </c:if>
</div>

<div class="container-fluid mt-4 px-4 mb-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="text-dark fw-bold m-0"><i class="bi bi-shield-lock-fill text-brand me-2"></i>Hệ Thống Nhân Sự</h3>
        <a href="${pageContext.request.contextPath}/admin" class="btn btn-light border shadow-sm fw-bold">
            <i class="bi bi-arrow-left me-1"></i> Dashboard
        </a>
    </div>

    <div class="row">
        <div class="col-lg-3 mb-4">
            <div class="card">
                <div class="card-header border-bottom-0 pb-0 pt-4">
                    <h5 class="mb-0 fw-bold text-dark"><i class="bi bi-person-plus-fill text-brand me-2"></i>Cấp Tài Khoản Mới</h5>
                </div>
                <div class="card-body p-4">
                    <form action="${pageContext.request.contextPath}/nhan-vien" method="post" onsubmit="showConfirmForm(event, this, 'Xác Nhận Tạo', 'Xác nhận tạo tài khoản mới cho nhân viên này?');">
                        <input type="hidden" name="action" value="add">

                        <div class="mb-3">
                            <label class="form-label fw-semibold small text-muted text-uppercase">Họ và Tên</label>
                            <input type="text" class="form-control" name="hoTen" placeholder="VD: Nguyễn Văn A" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold small text-muted text-uppercase">Số Điện Thoại</label>
                            <input type="text" class="form-control" name="SDT" placeholder="Gồm 10 số..." pattern="\d{10,11}" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold small text-muted text-uppercase">Địa Chỉ Email</label>
                            <input type="email" class="form-control" name="email" placeholder="VD: mail@domain.com" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold small text-muted text-uppercase">Tên Đăng Nhập</label>
                            <input type="text" class="form-control fw-bold" name="tenDangNhap" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold small text-muted text-uppercase">Mật Khẩu</label>
                            <input type="password" class="form-control" name="matKhau" minlength="6" required>
                        </div>
                        <div class="mb-4">
                            <label class="form-label fw-semibold small text-muted text-uppercase">Quyền Hạn</label>
                            <select class="form-select" name="maVaiTro" required>
                                <option value="1">Admin (Quản trị viên)</option>
                                <option value="2" selected>Nhân Viên (Bán Hàng)</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-brand w-100 py-2"><i class="bi bi-person-check-fill me-1"></i> Khởi Tạo</button>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-lg-9 mb-4">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0 fw-bold text-dark">Danh Sách Nhân Sự</h5>
                    <a href="${pageContext.request.contextPath}/nhan-vien?action=list" class="btn btn-sm btn-light border"><i class="bi bi-arrow-clockwise"></i> Làm mới</a>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover table-custom mb-0 text-center">
                            <thead>
                            <tr>
                                <th class="text-start ps-4">Họ Tên & Liên Hệ</th>
                                <th>Tài Khoản</th>
                                <th>Vai Trò</th>
                                <th>Trạng Thái</th>
                                <th>Thao Tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${not empty requestScope.danhSach}">
                                    <c:forEach var="nv" items="${requestScope.danhSach}">
                                        <tr>
                                            <td class="text-start ps-4">
                                                <div class="d-flex align-items-center">
                                                    <div class="me-3 rounded-circle d-flex justify-content-center align-items-center text-white fw-bold shadow-sm" style="width: 42px; height: 42px; background: ${nv.vaiTro.maVaiTro == 1 ? '#DC2626' : '#2563EB'};">
                                                            ${fn:substring(nv.hoTen, 0, 1)}
                                                    </div>
                                                    <div>
                                                        <div class="fw-bold text-dark fs-6">${nv.hoTen} <span class="badge bg-light text-muted border fw-normal ms-1">${nv.maNV}</span></div>
                                                        <div class="small text-muted mt-1"><i class="bi bi-telephone"></i> ${nv.SDT} &nbsp;&bull;&nbsp; <i class="bi bi-envelope"></i> ${nv.email}</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="fw-bold text-secondary">${nv.tenDangNhap}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${nv.vaiTro.maVaiTro == 1}">
                                                        <span class="badge bg-danger bg-opacity-10 text-danger border border-danger border-opacity-25"><i class="bi bi-shield-star-fill"></i> ${nv.vaiTro.tenVaiTro}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25"><i class="bi bi-person-badge"></i> ${nv.vaiTro.tenVaiTro}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${nv.trangThai == 1}"><span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25">Hoạt Động</span></c:when>
                                                    <c:otherwise><span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary border-opacity-25">Bị Khóa</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="btn-group btn-group-sm shadow-sm">
                                                    <c:choose>
                                                        <c:when test="${nv.trangThai == 1}">
                                                            <a href="${pageContext.request.contextPath}/nhan-vien?action=toggle-status&id=${nv.maNV}&status=0" class="btn btn-light text-warning border" title="Khóa" onclick="event.preventDefault(); showConfirmLink('Khóa Tài Khoản', 'Bạn có chắc chắn muốn KHÓA nhân viên này?', this.href);"><i class="bi bi-pause-circle"></i></a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="${pageContext.request.contextPath}/nhan-vien?action=toggle-status&id=${nv.maNV}&status=1" class="btn btn-light text-success border" title="Mở khóa" onclick="event.preventDefault(); showConfirmLink('Mở Khóa', 'Bạn có muốn mở lại quyền truy cập cho nhân viên này?', this.href);"><i class="bi bi-play-circle"></i></a>
                                                        </c:otherwise>
                                                    </c:choose>

                                                    <button type="button" class="btn btn-light text-danger border" data-bs-toggle="modal" data-bs-target="#deleteModal"
                                                            onclick="prepareDelete('${nv.maNV}', '${fn:escapeXml(nv.hoTen)}')" title="Xóa">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr><td colspan="5" class="text-center text-muted py-5"><i class="bi bi-inbox fs-1 d-block mb-3 opacity-50"></i>Chưa có nhân viên.</td></tr>
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

<div class="modal fade" id="jsConfirmModal" tabindex="-1" aria-hidden="true" style="z-index: 1060;">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content shadow-lg border-0 text-center" style="border-radius: 16px;">
            <div class="modal-body p-4 bg-white">
                <div class="text-warning mb-3">
                    <i class="bi bi-question-circle-fill" style="font-size: 3.5rem;"></i>
                </div>
                <h5 class="fw-bold text-dark mb-2" id="jsConfirmTitle">Xác Nhận</h5>
                <p class="text-muted small mb-4" id="jsConfirmText">Bạn có chắc chắn không?</p>
                <div class="d-flex flex-column gap-2">
                    <button type="button" class="btn btn-brand fw-bold rounded-pill py-2 w-100 shadow-sm" id="jsConfirmYesBtn">Đồng Ý</button>
                    <button type="button" class="btn btn-light fw-bold rounded-pill py-2 w-100 border" data-bs-dismiss="modal">Hủy Bỏ</button>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content shadow-lg border-0 text-center" style="border-radius: 16px;">
            <div class="modal-body p-4 bg-white">
                <div class="text-danger mb-3">
                    <i class="bi bi-trash3-fill" style="font-size: 3.5rem; opacity: 0.8;"></i>
                </div>
                <h5 class="fw-bold text-dark mb-2">Xác Nhận Xóa Nhân Viên</h5>
                <p class="text-muted small mb-4">Bạn có chắc muốn xóa tài khoản <br><strong id="deleteItemName" class="text-danger fs-6"></strong>? Thao tác này không thể hoàn tác.</p>

                <div class="d-flex flex-column gap-2">
                    <a href="#" id="confirmDeleteBtn" class="btn btn-danger fw-bold rounded-pill py-2 w-100 shadow-sm">Đồng Ý Xóa</a>
                    <button type="button" class="btn btn-light fw-bold rounded-pill py-2 w-100 border" data-bs-dismiss="modal">Hủy Bỏ</button>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // --- LÕI XỬ LÝ CONFIRM CHUNG ---
    let confirmActionCallback = null;
    let jsConfirmModalObj = null;

    document.addEventListener("DOMContentLoaded", function() {
        if(document.getElementById('jsConfirmModal')) {
            jsConfirmModalObj = new bootstrap.Modal(document.getElementById('jsConfirmModal'));
            document.getElementById('jsConfirmYesBtn').addEventListener('click', function() {
                if(confirmActionCallback) {
                    confirmActionCallback();
                    confirmActionCallback = null;
                }
                jsConfirmModalObj.hide();
            });
        }
    });

    function showConfirmAction(title, text, callback) {
        document.getElementById('jsConfirmTitle').innerText = title;
        document.getElementById('jsConfirmText').innerText = text;
        confirmActionCallback = callback;
        jsConfirmModalObj.show();
    }

    function showConfirmLink(title, text, url) {
        showConfirmAction(title, text, function() {
            window.location.href = url;
        });
    }

    function showConfirmForm(event, formElement, title, text) {
        event.preventDefault(); // Chặn form submit ngay lập tức
        showConfirmAction(title, text, function() {
            formElement.submit(); // Đồng ý thì mới gửi dữ liệu
        });
    }

    function prepareDelete(maNV, hoTen) {
        document.getElementById('deleteItemName').innerText = hoTen;
        document.getElementById('confirmDeleteBtn').href = '${pageContext.request.contextPath}/nhan-vien?action=delete&id=' + maNV;
    }
</script>
</body>
</html>