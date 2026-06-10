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
            <c:when test="${fn:contains(sessionScope.message, 'Lỗi') || fn:contains(sessionScope.message, 'thất bại') || fn:contains(sessionScope.message, 'Không thể')}">
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

<div class="container mt-4 mb-5">
    <!-- HEADER -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="text-dark fw-bold m-0"><i class="bi bi-collection-fill text-brand me-2"></i>Quản Lý Danh Mục</h3>
        <a href="${pageContext.request.contextPath}/admin" class="btn btn-light border shadow-sm fw-bold">
            <i class="bi bi-arrow-left me-1"></i> Dashboard
        </a>
    </div>

    <div class="row">
        <!-- FORM THÊM -->
        <div class="col-md-4 mb-4">
            <div class="card">
                <div class="card-header border-bottom-0 pb-0 pt-4">
                    <h5 class="mb-0 fw-bold text-dark"><i class="bi bi-plus-circle-fill text-brand me-2"></i>Thêm Mới</h5>
                </div>
                <div class="card-body p-4">
                    <form action="${pageContext.request.contextPath}/danh-muc" method="post" onsubmit="showConfirmForm(event, this, 'Tạo Danh Mục', 'Xác nhận tạo danh mục mới này?');">
                        <input type="hidden" name="action" value="add">
                        <div class="mb-4">
                            <label class="form-label fw-semibold text-muted small text-uppercase">Tên Danh Mục</label>
                            <input type="text" class="form-control" name="tenDanhMuc" placeholder="VD: Trà Sữa, Cà Phê..." required>
                        </div>
                        <button type="submit" class="btn btn-brand w-100 py-2"><i class="bi bi-check2 me-1"></i> Khởi Tạo</button>
                    </form>
                </div>
            </div>
        </div>

        <!-- BẢNG DANH SÁCH -->
        <div class="col-md-8 mb-4">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0 fw-bold text-dark">Danh Sách Phân Loại</h5>
                    <a href="${pageContext.request.contextPath}/danh-muc?action=list" class="btn btn-sm btn-light border"><i class="bi bi-arrow-clockwise"></i> Làm mới</a>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover table-custom mb-0">
                            <thead>
                            <tr>
                                <th class="text-center" width="10%">STT</th>
                                <th class="text-center" width="20%">Mã DM</th>
                                <th>Tên Danh Mục</th>
                                <th class="text-center" width="25%">Thao Tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${not empty requestScope.danhSach}">
                                    <c:forEach var="dm" items="${requestScope.danhSach}" varStatus="status">
                                        <tr>
                                            <td class="text-center fw-semibold text-muted">${status.index + 1}</td>
                                            <td class="text-center fw-semibold text-brand">${dm.maDanhMuc}</td>
                                            <td class="fw-bold text-dark fs-6">${dm.tenDanhMuc}</td>
                                            <td class="text-center">
                                                <div class="btn-group btn-group-sm shadow-sm">
                                                    <button class="btn btn-light text-primary border" data-bs-toggle="modal" data-bs-target="#editModal"
                                                            onclick="fillEditModal('${dm.maDanhMuc}', '${fn:escapeXml(dm.tenDanhMuc)}')">
                                                        <i class="bi bi-pencil-square"></i> Sửa
                                                    </button>
                                                    <a href="${pageContext.request.contextPath}/danh-muc?action=delete&id=${dm.maDanhMuc}"
                                                       class="btn btn-light text-danger border"
                                                       onclick="event.preventDefault(); showConfirmLink('Xóa Danh Mục', 'Bạn có chắc chắn muốn xóa danh mục [${fn:escapeXml(dm.tenDanhMuc)}]?', this.href);">
                                                        <i class="bi bi-trash"></i>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr><td colspan="4" class="text-center text-muted py-5"><i class="bi bi-inbox fs-1 d-block mb-3 opacity-50"></i>Chưa có danh mục nào.</td></tr>
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

    function fillEditModal(maDM, tenDM) {
        document.getElementById("edit_maDanhMuc").value = maDM;
        document.getElementById("display_maDanhMuc").value = maDM;
        document.getElementById("edit_tenDanhMuc").value = tenDM;
    }
</script>
</body>
</html>