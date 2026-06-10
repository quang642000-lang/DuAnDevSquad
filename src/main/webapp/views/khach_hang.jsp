<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Khách Hàng CRM - TEA POS</title>
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
        .form-control { border-radius: 0.5rem; padding: 0.6rem 1rem; border-color: #CBD5E1; font-weight: 500;}
        .form-control:focus { box-shadow: 0 0 0 3px rgba(217, 119, 6, 0.15); border-color: #D97706; }
        .badge { font-weight: 600; padding: 0.4em 0.8em; border-radius: 9999px; }
        .btn-brand { background-color: #D97706; color: white; }
        .btn-brand:hover { background-color: #B45309; color: white; }
        .text-brand { color: #D97706; }
        .modal-content { border-radius: 1.25rem; border: none; }
        .points-badge { background: linear-gradient(135deg, #F59E0B, #D97706); color: white; box-shadow: 0 2px 4px rgba(217,119,6,0.3); }
    </style>
</head>
<body>

<div class="toast-container position-fixed top-0 end-0 p-3 mt-2" style="z-index: 1055;" id="js-toast-container">
    <c:if test="${not empty sessionScope.message}">
        <c:choose>
            <c:when test="${fn:contains(sessionScope.message, 'Lỗi') || fn:contains(sessionScope.message, 'Không thể')}">
                <div class="toast align-items-center border-0 mb-2 shadow-lg rounded-3 alert-danger" role="alert" aria-live="assertive" aria-atomic="true">
                    <div class="d-flex">
                        <div class="toast-body fw-bold d-flex align-items-center"><i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i> ${sessionScope.message}</div>
                        <button type="button" class="btn-close me-2 m-auto" data-bs-dismiss="toast"></button>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="toast align-items-center border-0 mb-2 shadow-lg rounded-3 alert-success" role="alert" aria-live="assertive" aria-atomic="true">
                    <div class="d-flex">
                        <div class="toast-body fw-bold d-flex align-items-center"><i class="bi bi-check-circle-fill me-2 fs-5"></i> ${sessionScope.message}</div>
                        <button type="button" class="btn-close me-2 m-auto" data-bs-dismiss="toast"></button>
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
        <h3 class="text-dark fw-bold m-0"><i class="bi bi-person-vcard-fill text-brand me-2"></i>CRM Thành Viên</h3>
        <a href="${pageContext.request.contextPath}/admin" class="btn btn-light border shadow-sm fw-bold">
            <i class="bi bi-arrow-left me-1"></i> Dashboard
        </a>
    </div>

    <div class="row">
        <div class="col-lg-4 mb-4">
            <!-- Tìm kiếm Card -->
            <div class="card mb-4">
                <div class="card-header border-bottom-0 pb-0 pt-4">
                    <h5 class="mb-0 fw-bold text-success"><i class="bi bi-search me-2"></i>Tra Cứu Khách Hàng</h5>
                </div>
                <div class="card-body p-4">
                    <form action="${pageContext.request.contextPath}/khach-hang" method="get">
                        <input type="hidden" name="action" value="search">
                        <label class="form-label fw-semibold text-muted small text-uppercase">Số Điện Thoại</label>
                        <div class="input-group">
                            <input type="text" class="form-control" name="sdt" placeholder="Nhập 10 số..." value="${param.sdt}" required>
                            <button class="btn btn-success fw-bold px-4" type="submit">Tìm</button>
                        </div>
                    </form>

                    <c:if test="${not empty requestScope.khachHangTimDuoc}">
                        <div class="mt-4 p-3 rounded-4 bg-success bg-opacity-10 border border-success border-opacity-25">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <h6 class="fw-bold mb-0 text-success"><i class="bi bi-person-check-fill me-1"></i> Đã tìm thấy</h6>
                                <span class="badge points-badge px-3 py-2"><i class="bi bi-coin me-1"></i> ${khachHangTimDuoc.diemTichLuy} điểm</span>
                            </div>
                            <div>
                                <div class="fw-bold text-dark fs-5">${khachHangTimDuoc.tenKH}</div>
                                <div class="text-muted small">${khachHangTimDuoc.SDT} &bull; Mã: ${khachHangTimDuoc.maKH}</div>
                            </div>
                        </div>
                    </c:if>
                    <c:if test="${param.action == 'search' and empty requestScope.khachHangTimDuoc}">
                        <div class="alert alert-danger mt-3 shadow-sm small rounded-3 border-0"><i class="bi bi-info-circle-fill"></i> Không tìm thấy khách hàng.</div>
                    </c:if>
                </div>
            </div>

            <!-- Thêm mới Card -->
            <div class="card">
                <div class="card-header border-bottom-0 pb-0 pt-4">
                    <h5 class="mb-0 fw-bold text-dark"><i class="bi bi-person-plus-fill text-brand me-2"></i>Mở Thẻ Thành Viên</h5>
                </div>
                <div class="card-body p-4">
                    <form action="${pageContext.request.contextPath}/khach-hang" method="post" onsubmit="showConfirmForm(event, this, 'Mở Thẻ Mới', 'Xác nhận tạo thẻ thành viên cho khách hàng này?');">
                        <input type="hidden" name="action" value="add">
                        <div class="mb-3">
                            <label class="form-label fw-semibold text-muted small text-uppercase">Họ và Tên</label>
                            <input type="text" class="form-control" name="tenKhachHang" placeholder="Nhập tên khách..." required>
                        </div>
                        <div class="mb-4">
                            <label class="form-label fw-semibold text-muted small text-uppercase">Số Điện Thoại</label>
                            <input type="text" class="form-control" name="soDienThoai" placeholder="VD: 0988..." required pattern="\d{10,11}">
                        </div>
                        <button type="submit" class="btn btn-brand w-100 py-2"><i class="bi bi-check2 me-1"></i> Đăng Ký Thẻ</button>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-lg-8 mb-4">
            <div class="card h-100">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0 fw-bold text-dark">Danh Sách Thành Viên</h5>
                    <a href="${pageContext.request.contextPath}/khach-hang?action=list" class="btn btn-sm btn-light border"><i class="bi bi-arrow-clockwise"></i> Làm mới toàn bộ</a>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover table-custom mb-0 text-center">
                            <thead>
                            <tr>
                                <th width="5%">STT</th>
                                <th>Mã KH</th>
                                <th class="text-start">Họ Tên</th>
                                <th>Liên Hệ</th>
                                <th>Điểm Tích Lũy</th>
                                <th>Thao Tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${not empty requestScope.danhSach}">
                                    <c:forEach var="kh" items="${requestScope.danhSach}" varStatus="status">
                                        <tr>
                                            <td class="fw-semibold text-muted">${status.index + 1}</td>
                                            <td class="fw-semibold text-muted">${kh.maKH}</td>
                                            <td class="text-start fw-bold text-dark">${kh.tenKH}</td>
                                            <td class="fw-medium">${kh.SDT}</td>
                                            <td><span class="badge points-badge fs-6 px-3"><i class="bi bi-stars"></i> ${kh.diemTichLuy}</span></td>
                                            <td>
                                                <div class="btn-group btn-group-sm shadow-sm">
                                                    <button class="btn btn-light text-primary border" data-bs-toggle="modal" data-bs-target="#editModal"
                                                            onclick="fillEditModal('${kh.maKH}', '${fn:escapeXml(kh.tenKH)}', '${kh.SDT}')">
                                                        <i class="bi bi-pencil-square"></i>
                                                    </button>
                                                    <a href="${pageContext.request.contextPath}/khach-hang?action=delete&maKH=${kh.maKH}"
                                                       class="btn btn-light text-danger border" onclick="event.preventDefault(); showConfirmLink('Xóa Khách Hàng', 'Bạn có chắc chắn muốn xóa thành viên [${fn:escapeXml(kh.tenKH)}]? Thao tác không thể hoàn tác.', this.href);">
                                                        <i class="bi bi-trash"></i>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr><td colspan="6" class="text-center text-muted py-5"><i class="bi bi-inbox fs-1 d-block mb-3 opacity-50"></i>Chưa có thành viên nào.</td></tr>
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

<!-- MODAL CẬP NHẬT -->
<div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content shadow-lg">
            <div class="modal-header bg-light border-0 py-3">
                <h5 class="modal-title fw-bold text-dark"><i class="bi bi-pencil-square text-brand me-2"></i>Cập Nhật Thành Viên</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/khach-hang" method="post" onsubmit="showConfirmForm(event, this, 'Lưu Thay Đổi', 'Xác nhận cập nhật thông tin khách hàng này?');">
                <div class="modal-body p-4">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="maKH" id="edit_maKH">
                    <div class="mb-3">
                        <label class="form-label text-muted fw-bold small text-uppercase">Mã Khách Hàng</label>
                        <input type="text" class="form-control bg-light fw-bold text-muted border-0" id="display_maKH" disabled>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold text-dark small text-uppercase">Họ và Tên</label>
                        <input type="text" class="form-control" name="tenKhachHang" id="edit_tenKH" required>
                    </div>
                    <div class="mb-2">
                        <label class="form-label fw-bold text-dark small text-uppercase">Số Điện Thoại</label>
                        <input type="text" class="form-control" name="soDienThoai" id="edit_sdt" required pattern="\d{10,11}">
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
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
        event.preventDefault();
        showConfirmAction(title, text, function() {
            formElement.submit();
        });
    }

    function fillEditModal(maKH, tenKH, sdt) {
        document.getElementById("edit_maKH").value = maKH;
        document.getElementById("display_maKH").value = maKH;
        document.getElementById("edit_tenKH").value = tenKH;
        document.getElementById("edit_sdt").value = sdt;
    }
</script>
</body>
</html>