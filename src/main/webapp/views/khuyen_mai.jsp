<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Khuyến Mãi</title>
    <!-- Thêm Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body class="bg-light">

<div class="container-fluid mt-4 px-4">
    <h2 class="mb-4 text-center text-primary fw-bold">QUẢN LÝ CHƯƠNG TRÌNH KHUYẾN MÃI (MARKETING)</h2>

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
        <!-- FORM THÊM MỚI -->
        <div class="col-lg-3 mb-4">
            <div class="card shadow-sm">
                <div class="card-header bg-danger text-white">
                    <h5 class="mb-0 fw-bold"><i class="bi bi-ticket-perforated-fill"></i> Tạo Mã Giảm Giá</h5>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/khuyen-mai" method="post">
                        <input type="hidden" name="action" value="add">

                        <div class="mb-2">
                            <label class="form-label fw-bold small">Tên chương trình</label>
                            <input type="text" name="tenKm" class="form-control form-control-sm" required placeholder="VD: Khuyến mãi Tết">
                        </div>
                        <div class="mb-2">
                            <label class="form-label fw-bold small text-danger">Mã Code (Nhập khi mua)</label>
                            <input type="text" name="maCode" class="form-control form-control-sm text-uppercase" required placeholder="VD: TET2026">
                        </div>
                        <div class="mb-2">
                            <label class="form-label fw-bold small">Loại Giảm</label>
                            <select name="loaiGiamGia" class="form-select form-select-sm">
                                <option value="Trực Tiếp">Giảm Trực Tiếp (VNĐ)</option>
                                <option value="Phần Trăm">Giảm Phần Trăm (%)</option>
                            </select>
                        </div>
                        <div class="mb-2">
                            <label class="form-label fw-bold small">Giá Trị Giảm</label>
                            <input type="number" name="giaTriGiam" class="form-control form-control-sm" min="1" required>
                        </div>
                        <div class="mb-2">
                            <label class="form-label fw-bold small">Đơn tối thiểu áp dụng</label>
                            <input type="number" name="dieuKienToiThieu" class="form-control form-control-sm" value="0" min="0" required>
                        </div>
                        <div class="mb-2">
                            <label class="form-label fw-bold small text-primary">Số Lượng Phát Hành</label>
                            <input type="number" name="soLuong" class="form-control form-control-sm" value="100" min="1" required>
                        </div>

                        <div class="mb-2">
                            <label class="form-label fw-bold small">Ngày Bắt Đầu</label>
                            <input type="date" name="ngayBatDau" class="form-control form-control-sm" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold small">Ngày Kết Thúc</label>
                            <input type="date" name="ngayKetThuc" class="form-control form-control-sm" required>
                        </div>

                        <button type="submit" class="btn btn-danger btn-sm w-100 fw-bold">
                            <i class="bi bi-save"></i> Lưu Chương Trình
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <!-- CỘT PHẢI: TÌM KIẾM & DANH SÁCH -->
        <div class="col-lg-9 mb-4">

            <!-- THANH TÌM KIẾM -->
            <div class="card shadow-sm mb-3">
                <div class="card-body bg-white rounded py-2">
                    <form action="${pageContext.request.contextPath}/khuyen-mai" method="get">
                        <input type="hidden" name="action" value="search">
                        <div class="row g-2">
                            <div class="col-md-10">
                                <div class="input-group input-group-sm">
                                    <span class="input-group-text bg-light text-muted"><i class="bi bi-search"></i></span>
                                    <input type="text" class="form-control" name="keyword"
                                           placeholder="Tìm theo Tên chương trình hoặc Mã Code..."
                                           value="${requestScope.selectedKeyword}">
                                </div>
                            </div>
                            <div class="col-md-2">
                                <button type="submit" class="btn btn-success btn-sm w-100 fw-bold">Tìm Kiếm</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- BẢNG DANH SÁCH -->
            <div class="card shadow-sm">
                <div class="card-header bg-dark text-white d-flex justify-content-between align-items-center py-2">
                    <h6 class="mb-0 fw-bold"><i class="bi bi-list-stars"></i> Danh Sách Khuyến Mãi</h6>
                    <div>
                        <c:if test="${not empty requestScope.selectedKeyword}">
                            <a href="${pageContext.request.contextPath}/khuyen-mai?action=list" class="btn btn-sm btn-warning text-dark fw-bold me-2 py-0">
                                <i class="bi bi-x-circle"></i> Bỏ lọc
                            </a>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/khuyen-mai?action=list" class="btn btn-sm btn-outline-light py-0">
                            <i class="bi bi-arrow-clockwise"></i> Làm mới
                        </a>
                    </div>
                </div>
                <div class="card-body p-0">
                    <table class="table table-striped table-hover mb-0 align-middle text-center" style="font-size: 0.9rem;">
                        <thead class="table-secondary">
                        <tr>
                            <th width="5%">STT</th>
                            <th>Mã KM</th>
                            <th class="text-start">Tên Chương Trình</th>
                            <th>Mã Code</th>
                            <th>Giá Trị Giảm</th>
                            <th>Lượt Dùng</th>
                            <th>Thời Gian Áp Dụng</th>
                            <th>Trạng Thái</th>
                            <th>Hành Động</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty requestScope.danhSach}">
                                <c:forEach var="km" items="${requestScope.danhSach}" varStatus="status">
                                    <tr>
                                        <td class="fw-bold">${status.index + 1}</td>
                                        <td class="fw-bold text-secondary">${km.maKM}</td>
                                        <td class="text-start fw-bold">${km.tenKM}</td>
                                        <td><span class="badge bg-warning text-dark fs-6 border border-dark border-1 border-dashed">${km.maCode}</span></td>

                                        <td class="fw-bold text-danger">
                                            <c:choose>
                                                <c:when test="${km.loaiGiamGia == 'Phần Trăm'}">
                                                    ${km.giaTrịGiam}%
                                                </c:when>
                                                <c:otherwise>
                                                    <fmt:formatNumber value="${km.giaTrịGiam}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                                </c:otherwise>
                                            </c:choose>
                                            <div class="small fw-normal text-muted mt-1">(Đơn Min: <fmt:formatNumber value="${km.dieuKienToiThieu}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>)</div>
                                        </td>

                                        <!-- CỘT HIỂN THỊ SỐ LƯỢNG ĐÃ DÙNG THỰC TẾ -->
                                        <td class="fw-bold text-primary">
                                            <c:choose>
                                                <c:when test="${km.soLuong - km.soLuongDaDung <= 0}">
                                                    <span class="text-danger">Đã dùng ${km.soLuongDaDung}/${km.soLuong} (Hết)</span>
                                                </c:when>
                                                <c:otherwise>
                                                    ${km.soLuongDaDung} / ${km.soLuong}
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td class="small">
                                            <fmt:formatDate value="${km.ngayBatDau}" pattern="dd/MM/yyyy"/>
                                            <br><i class="bi bi-arrow-down text-muted"></i><br>
                                            <fmt:formatDate value="${km.ngayKetThuc}" pattern="dd/MM/yyyy"/>
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${km.soLuong - km.soLuongDaDung <= 0}">
                                                    <span class="badge bg-danger shadow-sm">Đã Hết Lượt</span>
                                                </c:when>
                                                <c:when test="${km.trangThai == 1}">
                                                    <span class="badge bg-success shadow-sm">Đang Chạy</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary shadow-sm">Đã Dừng</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <!-- Chuyển trạng thái nhanh -->
                                            <c:choose>
                                                <c:when test="${km.trangThai == 1}">
                                                    <a href="${pageContext.request.contextPath}/khuyen-mai?action=toggle-status&id=${km.maKM}&status=0"
                                                       class="btn btn-sm btn-outline-danger py-0 px-1" title="Dừng chương trình">
                                                        <i class="bi bi-stop-circle-fill"></i>
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/khuyen-mai?action=toggle-status&id=${km.maKM}&status=1"
                                                       class="btn btn-sm btn-outline-success py-0 px-1" title="Bật lại">
                                                        <i class="bi bi-play-circle-fill"></i>
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>

                                            <!-- Sửa thông tin (Đã truyền thêm soLuongDaDung) -->
                                            <button class="btn btn-sm btn-warning py-0 px-1 mx-1" data-bs-toggle="modal" data-bs-target="#editModal" title="Cập nhật"
                                                    onclick="fillEditModal('${km.maKM}', '${fn:escapeXml(km.tenKM)}', '${km.maCode}', '${km.loaiGiamGia}', '${km.giaTrịGiam}', '${km.dieuKienToiThieu}', '${km.soLuong}', '${km.soLuongDaDung}', '${km.ngayBatDau}', '${km.ngayKetThuc}')">
                                                <i class="bi bi-pencil-square"></i>
                                            </button>

                                            <!-- Xóa -->
                                            <a href="${pageContext.request.contextPath}/khuyen-mai?action=delete&id=${km.maKM}"
                                               class="btn btn-sm btn-danger py-0 px-1" title="Xóa vĩnh viễn"
                                               onclick="return confirm('Bạn có chắc muốn xóa chương trình [${fn:escapeXml(km.tenKM)}] không?');">
                                                <i class="bi bi-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="9" class="text-center text-muted py-4">Chưa có Chương trình Khuyến Mãi nào.</td>
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

<!-- MODAL CẬP NHẬT -->
<div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-warning">
                <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square"></i> Cập Nhật Khuyến Mãi</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/khuyen-mai" method="post">
                <div class="modal-body">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="maKm" id="edit_maKm">

                    <!-- THÔNG BÁO KHÓA SỬA NẾU ĐÃ CÓ NGƯỜI DÙNG -->
                    <div id="lock_warning" class="alert alert-danger py-2 px-3 small fw-bold mb-3" style="display:none;">
                        <i class="bi bi-lock-fill"></i> Mã đã được sử dụng. Không thể sửa Loại giảm, Giá trị giảm và Đơn tối thiểu!
                    </div>

                    <div class="mb-2">
                        <label class="form-label fw-bold small text-muted">Mã Hệ Thống (Không sửa)</label>
                        <input type="text" class="form-control form-control-sm bg-light fw-bold text-secondary" id="display_maKm" disabled>
                    </div>

                    <div class="mb-2">
                        <label class="form-label fw-bold small">Tên chương trình</label>
                        <input type="text" class="form-control form-control-sm" name="tenKm" id="edit_tenKm" required>
                    </div>
                    <div class="row g-2 mb-2">
                        <div class="col-md-6">
                            <label class="form-label fw-bold small">Mã Code</label>
                            <input type="text" class="form-control form-control-sm text-uppercase" name="maCode" id="edit_maCode" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small">Loại Giảm</label>
                            <select class="form-select form-select-sm" name="loaiGiamGia" id="edit_loaiGiamGia" required>
                                <option value="Trực Tiếp">Giảm Trực Tiếp (VNĐ)</option>
                                <option value="Phần Trăm">Giảm Phần Trăm (%)</option>
                            </select>
                        </div>
                    </div>
                    <div class="row g-2 mb-2">
                        <div class="col-md-4">
                            <label class="form-label fw-bold small">Giá Trị Giảm</label>
                            <input type="number" class="form-control form-control-sm" name="giaTriGiam" id="edit_giaTriGiam" min="1" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-bold small">Đơn tối thiểu</label>
                            <input type="number" class="form-control form-control-sm" name="dieuKienToiThieu" id="edit_dieuKienToiThieu" min="0" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-bold small text-primary">Tổng Lượt <span id="display_daDung" class="text-danger fw-normal"></span></label>
                            <input type="number" class="form-control form-control-sm border-primary" name="soLuong" id="edit_soLuong" required>
                        </div>
                    </div>
                    <div class="row g-2 mb-2">
                        <div class="col-md-6">
                            <label class="form-label fw-bold small">Ngày Bắt Đầu</label>
                            <input type="date" class="form-control form-control-sm" name="ngayBatDau" id="edit_ngayBatDau" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small">Ngày Kết Thúc</label>
                            <input type="date" class="form-control form-control-sm" name="ngayKetThuc" id="edit_ngayKetThuc" required>
                        </div>
                    </div>
                </div>

                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-secondary btn-sm fw-bold" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary btn-sm fw-bold"><i class="bi bi-save"></i> Lưu Thay Đổi</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function fillEditModal(maKm, tenKm, maCode, loaiGiamGia, giaTri, toiThieu, soLuong, daDung, start, end) {
        document.getElementById('edit_maKm').value = maKm;
        document.getElementById('display_maKm').value = maKm;
        document.getElementById('edit_tenKm').value = tenKm;
        document.getElementById('edit_maCode').value = maCode;

        let selectLoaiGiam = document.getElementById('edit_loaiGiamGia');
        let inputGiaTri = document.getElementById('edit_giaTriGiam');
        let inputToiThieu = document.getElementById('edit_dieuKienToiThieu');
        let lockWarning = document.getElementById('lock_warning');

        selectLoaiGiam.value = loaiGiamGia;
        inputGiaTri.value = giaTri;
        inputToiThieu.value = toiThieu;

        // LOGIC KHÓA 3 Ô NHẬP LỆU NẾU ĐÃ CÓ NGƯỜI DÙNG
        if (daDung > 0) {
            lockWarning.style.display = 'block';

            // Dùng readOnly cho input để vẫn có thể submit dữ liệu về Server
            inputGiaTri.readOnly = true;
            inputToiThieu.readOnly = true;
            inputGiaTri.classList.add('bg-light');
            inputToiThieu.classList.add('bg-light');

            // Dùng pointer-events:none cho select vì select không hỗ trợ readOnly
            selectLoaiGiam.style.pointerEvents = 'none';
            selectLoaiGiam.classList.add('bg-light');
        } else {
            lockWarning.style.display = 'none';

            inputGiaTri.readOnly = false;
            inputToiThieu.readOnly = false;
            inputGiaTri.classList.remove('bg-light');
            inputToiThieu.classList.remove('bg-light');

            selectLoaiGiam.style.pointerEvents = 'auto';
            selectLoaiGiam.classList.remove('bg-light');
        }

        let inputSoLuong = document.getElementById('edit_soLuong');
        inputSoLuong.value = soLuong;
        inputSoLuong.min = daDung; // Ép HTML chặn nếu gõ số nhỏ hơn số đã dùng
        document.getElementById('display_daDung').innerText = "(Đã xài: " + daDung + ")";

        document.getElementById('edit_ngayBatDau').value = start;
        document.getElementById('edit_ngayKetThuc').value = end;
    }
</script>

</body>
</html>