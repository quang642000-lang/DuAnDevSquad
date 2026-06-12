<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cổng Thanh Toán - TEA POS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
</head>
<body>
<%@ include file="layout/toast.jsp" %>

<div class="container mt-4 mb-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="text-dark fw-bold m-0"><i class="bi bi-wallet2 text-brand me-2"></i>Cấu Hình Thanh Toán</h3>
        <a href="${pageContext.request.contextPath}/admin" class="btn btn-light border shadow-sm fw-bold">
            <i class="bi bi-arrow-left me-1"></i> Dashboard
        </a>
    </div>
    <div class="row">

        <div class="col-12 mb-4">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center py-3">
                    <h5 class="mb-0 fw-bold text-dark"><i class="bi bi-wallet2 text-brand me-2"></i>Các Hình Thức Khả Dụng</h5>
                    <div>
                        <button type="button" class="btn btn-brand fw-bold shadow-sm me-2 rounded-pill px-3" data-bs-toggle="modal" data-bs-target="#addModal">
                            <i class="bi bi-plus-circle me-1"></i> Thêm Phương Thức
                        </button>
                        <a href="${pageContext.request.contextPath}/phuong-thuc?action=list" class="btn btn-light border rounded-circle" style="width: 38px; height: 38px;"><i class="bi bi-arrow-clockwise"></i></a>
                    </div>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover table-custom mb-0 text-center" id="ptttTable">
                            <thead>
                            <tr>
                                <th width="10%">STT</th>
                                <th width="15%">Mã Số</th>
                                <th class="text-start">Tên Hình Thức</th>
                                <th width="20%">Trạng Thái</th>
                                <th width="20%">Thao Tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${not empty requestScope.danhSach}">
                                    <c:forEach var="pt" items="${requestScope.danhSach}" varStatus="status">
                                        <tr>
                                            <td class="fw-semibold text-muted">${status.index + 1}</td>
                                            <td class="fw-bold text-secondary">${pt.maPTTT}</td>
                                            <td class="text-start fw-bold text-dark fs-6">${pt.tenPhuongThuc}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${pt.trangThai == 1}"><span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25">Đang Bật</span></c:when>
                                                    <c:otherwise><span class="badge bg-danger bg-opacity-10 text-danger border border-danger border-opacity-25">Đang Tắt</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="btn-group btn-group-sm shadow-sm">
                                                    <c:choose>
                                                        <c:when test="${pt.trangThai == 1}">
                                                            <a href="${pageContext.request.contextPath}/phuong-thuc?action=toggle-status&id=${pt.maPTTT}&status=0" class="btn btn-light text-danger border" title="Tắt" onclick="event.preventDefault(); showConfirmLink('Tắt Phương Thức', 'Khách hàng sẽ không thể thanh toán bằng phương thức này nữa?', this.href);"><i class="bi bi-power"></i></a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="${pageContext.request.contextPath}/phuong-thuc?action=toggle-status&id=${pt.maPTTT}&status=1" class="btn btn-light text-success border" title="Bật" onclick="event.preventDefault(); showConfirmLink('Bật Phương Thức', 'Mở lại phương thức thanh toán này?', this.href);"><i class="bi bi-power"></i></a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <button class="btn btn-light text-primary border" data-bs-toggle="modal" data-bs-target="#editModal" title="Đổi tên" onclick="fillEditModal('${pt.maPTTT}', '${fn:escapeXml(pt.tenPhuongThuc)}')">
                                                        <i class="bi bi-pencil-square"></i>
                                                    </button>
                                                    <a href="${pageContext.request.contextPath}/phuong-thuc?action=delete&id=${pt.maPTTT}" class="btn btn-light text-secondary border" title="Xóa bỏ" onclick="event.preventDefault(); showConfirmLink('Xóa', 'Cảnh báo: Nên ưu tiên TẮT. Bạn có chắc muốn XÓA VĨNH VIỄN không?', this.href);">
                                                        <i class="bi bi-trash"></i>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr><td colspan="5" class="text-center text-muted py-5"><i class="bi bi-inbox fs-1 d-block mb-3 opacity-50"></i>Chưa có phương thức nào.</td></tr>
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

<%@ include file="layout/confirm_modal.jsp" %>

<!-- MODAL THÊM MỚI PHƯƠNG THỨC THANH TOÁN -->
<div class="modal fade" id="addModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content shadow-lg border-0" style="border-radius: 16px;">
            <div class="modal-header border-0 py-3 bg-light">
                <h5 class="modal-title fw-bold text-dark"><i class="bi bi-wallet-fill text-brand me-2"></i>Thêm Cổng Thanh Toán</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/phuong-thuc" method="post" onsubmit="showConfirmForm(event, this, 'Thêm Phương Thức', 'Xác nhận tạo cổng thanh toán mới?');">
                <div class="modal-body p-4">
                    <input type="hidden" name="action" value="add">
                    <div class="mb-4">
                        <label class="form-label fw-semibold text-muted small text-uppercase">Tên hình thức thanh toán</label>
                        <input type="text" class="form-control fw-bold" name="tenPhuongThuc" placeholder="VD: Tiền mặt, VNPay, MoMo..." required>
                    </div>
                    <div class="alert alert-light py-2 px-3 small border mb-0 rounded-3 text-muted">
                        <i class="bi bi-info-circle-fill text-primary"></i> Sẽ được <strong>Kích hoạt</strong> tự động sau khi lưu.
                    </div>
                </div>
                <div class="modal-footer bg-light border-0 d-flex justify-content-end p-3">
                    <button type="button" class="btn btn-light fw-bold rounded-pill px-4 border me-2" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-brand fw-bold rounded-pill px-4 shadow-sm"><i class="bi bi-check2-circle me-1"></i> Lưu Dữ Liệu</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content shadow-lg">
            <div class="modal-header bg-light border-0 py-3">
                <h5 class="modal-title fw-bold text-dark"><i class="bi bi-pencil-square text-brand me-2"></i>Cập Nhật Tên</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/phuong-thuc" method="post" onsubmit="showConfirmForm(event, this, 'Lưu Thay Đổi', 'Xác nhận cập nhật thông tin cổng thanh toán?');">
                <div class="modal-body p-4">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="maPTTT" id="edit_maPTTT">
                    <div class="mb-3">
                        <label class="form-label text-muted fw-bold small text-uppercase">Mã Phương Thức</label>
                        <input type="text" class="form-control bg-light fw-bold text-muted border-0" id="display_maPTTT" disabled>
                    </div>
                    <div class="mb-2">
                        <label class="form-label fw-bold text-dark small text-uppercase">Tên Phương Thức</label>
                        <input type="text" class="form-control" name="tenPhuongThuc" id="edit_tenPhuongThuc" required>
                    </div>
                </div>
                <div class="modal-footer bg-light border-0 p-3">
                    <button type="button" class="btn btn-light fw-bold rounded-pill px-4 border" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-brand fw-bold rounded-pill px-4">Lưu Cập Nhật</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/global.js"></script>

<script>
    function fillEditModal(maPT, tenPT) {
        document.getElementById('edit_maPTTT').value = maPT;
        document.getElementById('display_maPTTT').value = maPT;
        document.getElementById('edit_tenPhuongThuc').value = tenPT;
    }
</script>
<!-- Thư viện jQuery và DataTables -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

<script>
    $(document).ready(function() {
        $('#ptttTable').DataTable({
            "pageLength": 5,
            "lengthMenu": [[5, 10, 20, -1], [5, 10, 20, "Tất cả"]],
            "language": {
                "lengthMenu": "Hiển thị _MENU_ dòng",
                "zeroRecords": "Không tìm thấy Phương Thức Thanh Toán nào",
                "info": "Đang hiển thị trang _PAGE_ / _PAGES_",
                "infoEmpty": "Không có dữ liệu",
                "search": "Tìm kiếm nhanh:",
                "paginate": {
                    "first": "Đầu",
                    "last": "Cuối",
                    "next": "Sau",
                    "previous": "Trước"
                }
            }
        });
    });
</script>
</body>
</html>