<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Biến Thể & Kích Cỡ - TEA POS</title>
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

<!-- THÔNG BÁO HỆ THỐNG NỔI (TOAST ALERT) -->
<div class="toast-container position-fixed top-0 end-0 p-3 mt-2" style="z-index: 1055;" id="js-toast-container">
    <c:if test="${not empty sessionScope.message}">
        <c:choose>
            <c:when test="${fn:contains(sessionScope.message, 'Lỗi') || fn:contains(sessionScope.message, 'Không thể') || fn:contains(sessionScope.message, 'thất bại')}">
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
    <!-- HEADER -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="text-dark fw-bold m-0"><i class="bi bi-tags-fill text-brand me-2"></i>Quản Lý Biến Thể & Kích Cỡ</h3>
        <a href="${pageContext.request.contextPath}/admin" class="btn btn-light border shadow-sm fw-bold">
            <i class="bi bi-arrow-left me-1"></i> Dashboard
        </a>
    </div>

    <div class="row">
        <!-- FORM THÊM -->
        <div class="col-lg-3 mb-4">
            <div class="card">
                <div class="card-header border-bottom-0 pb-0 pt-4">
                    <h5 class="mb-0 fw-bold text-dark"><i class="bi bi-plus-circle-fill text-brand me-2"></i>Thêm Kích Cỡ</h5>
                </div>
                <div class="card-body p-4">
                    <form action="${pageContext.request.contextPath}/bien-the" method="post" onsubmit="showConfirmForm(event, this, 'Tạo Kích Cỡ Mới', 'Xác nhận tạo kích cỡ mới cho sản phẩm này?');">
                        <input type="hidden" name="action" value="add">
                        <div class="mb-3">
                            <label class="form-label fw-semibold text-muted small text-uppercase">Sản Phẩm Gốc</label>
                            <select class="form-select bg-light" name="maSP" required>
                                <option value="" disabled selected>-- Chọn món --</option>
                                <c:forEach var="sp" items="${requestScope.danhSachSP}">
                                    <option value="${sp.maSP}">${sp.tenSanPham}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold text-muted small text-uppercase">Kích Cỡ (Size)</label>
                            <input type="text" class="form-control" name="kichCo" placeholder="VD: M, L, XL..." required>
                        </div>
                        <div class="mb-4">
                            <label class="form-label fw-semibold text-muted small text-uppercase">Giá Bán (VNĐ)</label>
                            <input type="number" class="form-control text-danger fw-bold fs-5" name="giaBan" min="0" placeholder="0" required>
                        </div>
                        <button type="submit" class="btn btn-brand w-100 py-2"><i class="bi bi-check2 me-1"></i> Lưu Dữ Liệu</button>
                    </form>
                </div>
            </div>
        </div>

        <!-- TÌM KIẾM & BẢNG -->
        <div class="col-lg-9 mb-4">
            <!-- Tìm kiếm -->
            <div class="card mb-4">
                <div class="card-body p-3">
                    <form action="${pageContext.request.contextPath}/bien-the" method="get">
                        <input type="hidden" name="action" value="search">
                        <div class="row g-3 align-items-center">
                            <div class="col-md-5">
                                <div class="input-group">
                                    <span class="input-group-text bg-white border-end-0 text-muted"><i class="bi bi-search"></i></span>
                                    <input type="text" class="form-control border-start-0 ps-0" name="keyword" placeholder="Tìm theo tên món, mã, size..." value="${requestScope.selectedKeyword}">
                                </div>
                            </div>
                            <div class="col-md-5">
                                <div class="input-group">
                                    <span class="input-group-text bg-white border-end-0 text-muted"><i class="bi bi-funnel"></i></span>
                                    <select class="form-select border-start-0 ps-0" name="filterSanPham">
                                        <option value="all">Tất cả sản phẩm</option>
                                        <c:forEach var="sp" items="${requestScope.danhSachSP}">
                                            <option value="${sp.maSP}" ${requestScope.selectedSanPham == sp.maSP ? 'selected' : ''}>${sp.tenSanPham}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-2">
                                <button type="submit" class="btn btn-dark w-100">Tìm Kiếm</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Bảng -->
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0 fw-bold text-dark">Danh Sách Giá Theo Size</h5>
                    <div>
                        <c:if test="${not empty requestScope.selectedKeyword or (not empty requestScope.selectedSanPham and requestScope.selectedSanPham != 'all')}">
                            <a href="${pageContext.request.contextPath}/bien-the?action=list" class="btn btn-sm btn-light text-danger fw-bold me-2"><i class="bi bi-x-circle"></i> Xóa lọc</a>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/bien-the?action=list" class="btn btn-sm btn-light border"><i class="bi bi-arrow-clockwise"></i></a>
                    </div>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover table-custom mb-0 text-center">
                            <thead>
                            <tr>
                                <th width="5%">STT</th>
                                <th>Mã BT</th>
                                <th class="text-start">Sản Phẩm Gốc</th>
                                <th>Size</th>
                                <th class="text-end">Giá Bán</th>
                                <th>Trạng Thái</th>
                                <th>Thao Tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${not empty requestScope.danhSach}">
                                    <c:forEach var="bt" items="${requestScope.danhSach}" varStatus="status">
                                        <tr>
                                            <td class="fw-semibold text-muted">${status.index + 1}</td>
                                            <td class="fw-semibold text-muted">${bt.maBienThe}</td>
                                            <td class="text-start fw-bold text-dark">${bt.sanPham.tenSanPham}</td>
                                            <td><span class="badge bg-light text-dark border px-3">${bt.kichCo}</span></td>
                                            <td class="text-end fw-bold text-danger"><fmt:formatNumber value="${bt.giaBan}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${bt.trangThai == 1}"><span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25">Hoạt Động</span></c:when>
                                                    <c:otherwise><span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary border-opacity-25">Tạm Ngừng</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="btn-group btn-group-sm shadow-sm">
                                                    <c:choose>
                                                        <c:when test="${bt.trangThai == 1}">
                                                            <a href="${pageContext.request.contextPath}/bien-the?action=toggle-status&id=${bt.maBienThe}&status=0" class="btn btn-light text-danger border" title="Tạm ngừng" onclick="event.preventDefault(); showConfirmLink('Tạm Ngừng', 'Tạm ngừng kinh doanh biến thể này?', this.href);"><i class="bi bi-pause-fill"></i></a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="${pageContext.request.contextPath}/bien-the?action=toggle-status&id=${bt.maBienThe}&status=1" class="btn btn-light text-success border" title="Mở lại" onclick="event.preventDefault(); showConfirmLink('Mở Lại', 'Mở bán lại biến thể này?', this.href);"><i class="bi bi-play-fill"></i></a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <button class="btn btn-light text-primary border" data-bs-toggle="modal" data-bs-target="#editModal"
                                                            onclick="fillEditModal('${bt.maBienThe}', '${bt.sanPham.maSP}', '${fn:escapeXml(bt.kichCo)}', '${bt.giaBan}')">
                                                        <i class="bi bi-pencil-square"></i>
                                                    </button>
                                                    <a href="${pageContext.request.contextPath}/bien-the?action=delete&id=${bt.maBienThe}" class="btn btn-light text-danger border" onclick="event.preventDefault(); showConfirmLink('Xóa Biến Thể', 'Bạn có chắc chắn muốn xóa vĩnh viễn biến thể này?', this.href);"><i class="bi bi-trash"></i></a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr><td colspan="7" class="text-center text-muted py-5"><i class="bi bi-inbox fs-1 d-block mb-3 opacity-50"></i>Chưa có dữ liệu biến thể.</td></tr>
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

<!-- Modal Xác Nhận Giao Diện Chuẩn Thay Thế Confirm -->
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

<!-- MODAL SỬA -->
<div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content shadow-lg">
            <div class="modal-header bg-light border-0 py-3">
                <h5 class="modal-title fw-bold text-dark"><i class="bi bi-pencil-square text-brand me-2"></i>Cập Nhật Kích Cỡ</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/bien-the" method="post" onsubmit="showConfirmForm(event, this, 'Lưu Thay Đổi', 'Bạn chắc chắn muốn lưu thông tin này?');">
                <div class="modal-body p-4">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="maBienThe" id="edit_maBienThe">

                    <div class="mb-3">
                        <label class="form-label text-muted fw-bold small text-uppercase">Mã Biến Thể</label>
                        <input type="text" class="form-control bg-light fw-bold text-muted border-0" id="display_maBienThe" disabled>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold text-dark small text-uppercase">Sản Phẩm</label>
                        <select class="form-select" name="maSP" id="edit_maSP" required>
                            <c:forEach var="sp" items="${requestScope.danhSachSP}">
                                <option value="${sp.maSP}">${sp.tenSanPham}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold text-dark small text-uppercase">Kích Cỡ (Size)</label>
                        <input type="text" class="form-control" name="kichCo" id="edit_kichCo" required>
                    </div>
                    <div class="mb-2">
                        <label class="form-label fw-bold text-dark small text-uppercase">Giá Bán (VNĐ)</label>
                        <input type="number" class="form-control text-danger fw-bold fs-5" name="giaBan" id="edit_giaBan" min="0" required>
                    </div>
                </div>
                <div class="modal-footer bg-light border-0 d-flex justify-content-between p-3">
                    <a href="#" id="btn-delete-modal" class="btn btn-outline-danger fw-bold rounded-pill px-4" onclick="event.preventDefault(); showConfirmLink('Xóa Biến Thể', 'Bạn có chắc chắn muốn xóa vĩnh viễn?', this.href);">Xóa</a>
                    <div>
                        <button type="button" class="btn btn-light fw-bold rounded-pill px-4 me-2 border" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-brand fw-bold rounded-pill px-4">Lưu Lại</button>
                    </div>
                </div>
            </form>
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
        event.preventDefault();
        showConfirmAction(title, text, function() {
            formElement.submit();
        });
    }

    function fillEditModal(maBT, maSP, kichCo, giaBan) {
        document.getElementById('edit_maBienThe').value = maBT;
        document.getElementById('display_maBienThe').value = maBT;
        document.getElementById('edit_maSP').value = maSP;
        document.getElementById('edit_kichCo').value = kichCo;
        document.getElementById('edit_giaBan').value = giaBan;
        document.getElementById('btn-delete-modal').href = '${pageContext.request.contextPath}/bien-the?action=delete&id=' + maBT;
    }
</script>
</body>
</html>