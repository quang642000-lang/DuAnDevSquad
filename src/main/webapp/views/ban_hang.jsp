<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>TEA POS - Hệ Thống Bán Hàng</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root { --brand: #D97706; --brand-dark: #0F172A; }
        body { background-color: #F8FAFC; overflow-x: hidden; font-family: 'Plus Jakarta Sans', sans-serif; user-select: none; }
        .navbar { background-color: var(--brand-dark) !important; padding: 0.75rem 1.5rem; }
        .product-card { cursor: pointer; transition: all 0.2s ease; border: 1px solid #E2E8F0; border-radius: 16px; overflow: hidden; background: #fff;}
        .product-card:hover, .product-card:active { transform: translateY(-4px); box-shadow: 0 12px 24px rgba(217, 119, 6, 0.15) !important; border-color: var(--brand);}
        .product-img { height: 140px; object-fit: cover; width: 100%; transition: transform 0.3s; }
        .product-card:hover .product-img { transform: scale(1.05); }
        .product-img-wrapper { overflow: hidden; position: relative; }
        .category-scroll { overflow-x: auto; scrollbar-width: none; -ms-overflow-style: none; padding-bottom: 0.5rem; }
        .category-scroll::-webkit-scrollbar { display: none; }
        .btn-filter { border-radius: 99px; font-weight: 600; white-space: nowrap; padding: 0.5rem 1.5rem; border: 1px solid #E2E8F0; color: #475569; background: #fff; transition: all 0.2s;}
        .btn-filter.active { background-color: var(--brand); color: #fff; border-color: var(--brand); box-shadow: 0 4px 10px rgba(217, 119, 6, 0.3); }
        .cart-wrapper { height: calc(100vh - 75px); position: sticky; top: 75px; display: flex; flex-direction: column; border-radius: 16px; overflow: hidden;}
        .cart-items { flex-grow: 1; overflow-y: auto; background-color: #fff; padding: 0.5rem;}
        .cart-items::-webkit-scrollbar { width: 6px; }
        .cart-items::-webkit-scrollbar-thumb { background-color: #CBD5E1; border-radius: 10px; }
        .form-control, .form-select { border-radius: 8px; border-color: #E2E8F0; padding: 0.6rem 1rem; font-weight: 500;}
        .form-control:focus, .form-select:focus { box-shadow: 0 0 0 3px rgba(217, 119, 6, 0.15); border-color: var(--brand); }
        .btn-brand { background-color: var(--brand); color: white; border-radius: 12px; font-weight: 700; transition: 0.2s; }
        .btn-brand:hover { background-color: #B45309; color: white; transform: translateY(-1px);}
        .modal-content { border-radius: 20px; border: none; }
        .modal-header { border-bottom: 1px solid #F1F5F9; border-top-left-radius: 20px; border-top-right-radius: 20px; }
        .modal-footer { border-top: 1px solid #F1F5F9; border-bottom-left-radius: 20px; border-bottom-right-radius: 20px; }
        .topping-list { max-height: 250px; overflow-y: auto; }
        .thermal-receipt { background: #fff; width: 100%; max-width: 320px; margin: 0 auto; padding: 20px; font-family: 'Courier New', Courier, monospace; color: #000; box-shadow: 0 10px 30px rgba(0,0,0,0.1); border-radius: 4px;}
        .thermal-receipt table { width: 100%; border-collapse: collapse; }
        .thermal-receipt hr { border-top: 1px dashed #000; opacity: 1; margin: 10px 0; background: none; }
        @media (max-width: 991.98px) {
            .cart-wrapper { height: auto; position: static; margin-top: 1rem; border: 1px solid #E2E8F0; }
            .cart-items { max-height: 400px; }
        }
    </style>
</head>
<body>
<input type="hidden" id="appContextPath" value="${pageContext.request.contextPath}">

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

<nav class="navbar navbar-expand-lg navbar-dark shadow-sm sticky-top">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold fs-4 d-flex align-items-center" href="${pageContext.request.contextPath}/ban-hang" style="color: var(--brand);">
            <i class="bi bi-cup-straw me-2 fs-3"></i> TEA POS
        </a>
        <div class="d-flex align-items-center text-white">
            <span class="me-3 fw-medium d-none d-md-inline"><i class="bi bi-person-circle me-1"></i> ${sessionScope.nhanVienDangNhap.hoTen}</span>
            <button class="btn btn-sm btn-outline-light fw-bold me-3 rounded-pill px-3 shadow-sm" data-bs-toggle="modal" data-bs-target="#profileModal">
                <i class="bi bi-gear-fill"></i> Cài đặt
            </button>
            <c:if test="${sessionScope.nhanVienDangNhap.vaiTro.maVaiTro == 1}">
                <a href="${pageContext.request.contextPath}/admin" class="btn btn-sm btn-light text-dark fw-bold me-2 rounded-pill px-3 shadow-sm"><i class="bi bi-grid-fill"></i> Admin</a>
            </c:if>
            <a href="${pageContext.request.contextPath}/auth?action=logout" class="btn btn-sm btn-danger fw-bold rounded-pill px-3 shadow-sm"><i class="bi bi-power"></i> Thoát</a>
        </div>
    </div>
</nav>

<div class="container-fluid mt-3 px-3 px-xl-4 pb-5">
    <div class="row g-4">
        <!-- BÊN TRÁI: SẢN PHẨM -->
        <div class="col-lg-7 col-xl-8">
            <div class="d-flex category-scroll gap-2 mb-3">
                <a href="${pageContext.request.contextPath}/ban-hang" class="btn-filter text-decoration-none ${empty param.maDanhMuc ? 'active' : ''}">Tất cả</a>
                <c:forEach var="dm" items="${requestScope.danhSachDanhMuc}">
                    <a href="${pageContext.request.contextPath}/ban-hang?maDanhMuc=${dm.maDanhMuc}" class="btn-filter text-decoration-none ${param.maDanhMuc == dm.maDanhMuc ? 'active' : ''}">${dm.tenDanhMuc}</a>
                </c:forEach>
            </div>
            <div class="row row-cols-2 row-cols-md-3 row-cols-xl-4 g-3">
                <c:choose>
                    <c:when test="${not empty requestScope.danhSachSanPham}">
                        <c:forEach var="sp" items="${requestScope.danhSachSanPham}">
                            <c:if test="${sp.trangThai == 1}">
                                <div class="col">
                                    <div class="card h-100 shadow-sm product-card" onclick="openOptionsModal('${sp.maSP}', '${fn:escapeXml(sp.tenSanPham)}')">
                                        <div class="product-img-wrapper">
                                            <img src="${pageContext.request.contextPath}/image/${not empty sp.hinhAnh ? sp.hinhAnh : 'default.png'}" class="product-img" onerror="this.src='https://placehold.co/300x200?text=No+Image'" alt="${fn:escapeXml(sp.tenSanPham)}">
                                        </div>
                                        <div class="card-body p-3 d-flex flex-column justify-content-between text-center">
                                            <h6 class="card-title fw-bold mb-2 text-dark" style="font-size: 0.9rem; line-height: 1.3;" title="${fn:escapeXml(sp.tenSanPham)}">${sp.tenSanPham}</h6>
                                            <div class="mt-auto">
                                                <span class="badge bg-light text-primary border border-primary border-opacity-25 rounded-pill px-3 py-2 w-100 fw-bold"><i class="bi bi-plus-lg"></i> Chọn</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="col-12 text-center py-5">
                            <i class="bi bi-cup-straw text-muted opacity-50" style="font-size: 4rem;"></i>
                            <h5 class="text-muted mt-3 fw-semibold">Không có sản phẩm nào!</h5>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- BÊN PHẢI: GIỎ HÀNG -->
        <div class="col-lg-5 col-xl-4">
            <div class="card shadow-lg border-0 cart-wrapper">
                <div class="card-header bg-white border-bottom py-3 d-flex justify-content-between align-items-center">
                    <h5 class="mb-0 fw-bold text-dark"><i class="bi bi-cart3 me-2" style="color: var(--brand);"></i> ĐƠN HÀNG</h5>
                    <button class="btn btn-sm btn-outline-danger rounded-pill fw-bold" onclick="clearCart()"><i class="bi bi-trash"></i> Xóa Hết</button>
                </div>
                <div class="card-body p-0 cart-items" id="cart-items-container">
                    <div class="text-center text-muted mt-5" id="empty-cart-msg">
                        <i class="bi bi-cart-x text-secondary opacity-25" style="font-size: 4rem;"></i>
                        <p class="mt-3 fw-medium">Chưa có món nào được chọn</p>
                    </div>
                </div>
                <div class="card-footer bg-white border-top shadow-sm p-3">
                    <form action="${pageContext.request.contextPath}/ban-hang" method="post" id="checkout-form" onsubmit="return validateCheckout(event)">
                        <input type="hidden" name="action" value="checkout">
                        <div id="hidden-cart-inputs"></div>
                        <input type="hidden" name="tongTienHang" id="input_tongTienHang" value="0">
                        <input type="hidden" name="tienGiamGia" id="input_tienGiamGia" value="0">
                        <input type="hidden" name="tongPhaiTra" id="input_tongPhaiTra" value="0">
                        <input type="hidden" name="maKM" id="input_maKM" value="">

                        <div class="row g-2 mb-2">
                            <div class="col-5">
                                <input type="text" class="form-control form-control-sm text-center fw-bold" name="sdtKhachHang" id="sdtKhachHang" placeholder="SĐT Khách" maxlength="10" pattern="\d*" oninput="checkCustomerPhone()">
                            </div>
                            <div class="col-7">
                                <input type="text" class="form-control form-control-sm fw-medium" name="tenKhachHang" id="tenKhachHang" placeholder="Tên khách (nếu mới)">
                            </div>
                        </div>

                        <div id="customerInfoPanel" class="bg-light p-2 rounded-3 border mb-2" style="display: none; border-color: #E2E8F0 !important;">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <span class="fw-bold text-dark small"><i class="bi bi-person-check-fill text-success"></i> <span id="lblTenKH"></span></span>
                                <span class="badge bg-warning text-dark px-2 rounded-pill"><i class="bi bi-coin"></i> <span id="lblDiem">0</span></span>
                            </div>
                            <div class="form-check form-switch small mb-1">
                                <input class="form-check-input" type="checkbox" id="toggleDiem" onchange="applyPoints()">
                                <label class="form-check-label text-danger fw-bold" for="toggleDiem">Dùng điểm (1đ = 1.000đ)</label>
                            </div>
                            <div id="nhapDiemContainer" class="input-group input-group-sm mt-1" style="display: none;">
                                <span class="input-group-text bg-white fw-medium">Dùng:</span>
                                <input type="number" class="form-control text-end text-danger fw-bold" id="input_nhapDiemTay" value="0" min="0" oninput="calculateCustomPoints()">
                                <button class="btn btn-outline-danger fw-bold" type="button" onclick="useMaxPoints()">Max</button>
                            </div>
                            <input type="hidden" name="diemSuDung" id="input_diemSuDung" value="0">
                        </div>
                        <div id="newCustomerPanel" class="text-primary small fw-semibold mb-2 ps-1" style="display: none;">
                            <i class="bi bi-stars"></i> Tự động tạo thẻ tích điểm cho khách mới!
                        </div>

                        <div class="mb-3 bg-light p-3 rounded-3 border" style="border-color: #E2E8F0 !important;">
                            <label class="fw-bold small text-muted mb-2 d-block"><i class="bi bi-ticket-perforated"></i> Mã Giảm Giá</label>
                            <div class="input-group">
                                <input type="text" class="form-control text-uppercase fw-bold border-dark" id="inputVoucherCode" placeholder="Nhập mã KM...">
                                <button class="btn btn-dark fw-bold px-3" type="button" onclick="checkAndApplyVoucher()">Áp Dụng</button>
                            </div>
                            <div id="activeVoucherInfo" class="mt-2 pt-2 border-top" style="display: none;">
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="text-success fw-bold"><i class="bi bi-check-circle-fill me-1"></i> Đã áp mã: <span id="voucherLabel" class="text-decoration-underline"></span></span>
                                    <button type="button" class="btn btn-sm btn-outline-danger py-0 px-2" onclick="removeVoucher()"><i class="bi bi-x"></i> Gỡ</button>
                                </div>
                            </div>
                        </div>

                        <div class="border rounded-3 p-3 mb-3 bg-light" style="border-color: #E2E8F0 !important;">
                            <div class="d-flex justify-content-between mb-1 small">
                                <span class="text-muted fw-semibold">Tổng tiền hàng:</span>
                                <span class="fw-bold text-dark" id="display_tongTienHang">0 ₫</span>
                            </div>
                            <div class="d-flex justify-content-between mb-1 small text-success">
                                <span class="fw-semibold">Giảm Voucher:</span>
                                <span class="fw-bold" id="display_tienGiamGia">- 0 ₫</span>
                            </div>
                            <div class="d-flex justify-content-between mb-2 small text-danger" id="row_giamDiem" style="display: none !important;">
                                <span class="fw-semibold">Trừ điểm tích lũy:</span>
                                <span class="fw-bold" id="display_giamDiem">- 0 ₫</span>
                            </div>
                            <hr class="my-2 border-secondary opacity-25">
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="fw-bold text-dark">TỔNG THANH TOÁN:</span>
                                <span class="fw-bold text-danger" style="font-size: 1.4rem;" id="display_tongPhaiTra">0 ₫</span>
                            </div>
                        </div>

                        <div class="row g-2 align-items-center mb-3">
                            <div class="col-12 col-sm-5">
                                <select class="form-select fw-bold bg-light" name="maPTTT" id="select_pttt" required onchange="handlePaymentMethodChange()">
                                    <c:forEach var="pt" items="${requestScope.danhSachPTTT}">
                                        <option value="${pt.maPTTT}">${pt.tenPhuongThuc}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-12 col-sm-7">
                                <div class="input-group">
                                    <span class="input-group-text bg-white fw-bold border-end-0"><i class="bi bi-cash"></i></span>
                                    <input type="number" class="form-control text-end fw-bold text-primary border-start-0 ps-0" name="tienKhachDua" id="tienKhachDua" placeholder="Khách đưa" required oninput="calculateChange()">
                                </div>
                            </div>
                            <div class="col-12 text-end small mt-1" id="tienThuaContainer" style="display: none;">
                                <span class="fw-semibold text-muted">Tiền thối lại:</span>
                                <span class="fw-bold text-success fs-6 ms-2" id="tienThuaLabel">0 ₫</span>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-brand w-100 py-3 fs-5 shadow-sm" id="btn-checkout" disabled>
                            <i class="bi bi-check-circle me-2"></i> THANH TOÁN ĐƠN
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- MODALS -->
<div class="modal fade" id="jsConfirmModal" tabindex="-1" aria-hidden="true" style="z-index: 1060;">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content shadow-lg border-0 text-center" style="border-radius: 16px;">
            <div class="modal-body p-4 bg-white">
                <div class="text-warning mb-3"><i class="bi bi-question-circle-fill" style="font-size: 3.5rem;"></i></div>
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

<div class="modal fade" id="profileModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content shadow-lg border-0">
            <div class="modal-header text-white py-3 border-0" style="background-color: var(--brand-dark);">
                <h5 class="modal-title fw-bold"><i class="bi bi-person-lines-fill text-brand me-2"></i>Thiết Lập Tài Khoản</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/ban-hang" method="post" id="form-profile" onsubmit="validateProfileAndConfirm(event, this)">
                <div class="modal-body p-4 bg-light">
                    <input type="hidden" name="action" value="update-profile">
                    <div class="alert alert-info small shadow-sm border-0 mb-4">
                        <i class="bi bi-shield-lock-fill me-1"></i> Để bảo mật, mọi thay đổi đều yêu cầu <strong>Mật khẩu hiện tại</strong>.
                    </div>

                    <h6 class="fw-bold text-dark mb-3 text-uppercase small" style="letter-spacing: 1px;">Thông tin cơ bản</h6>
                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label class="form-label fw-bold small text-muted">Họ và Tên</label>
                            <input type="text" class="form-control fw-medium" name="hoTen" value="${sessionScope.nhanVienDangNhap.hoTen}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small text-muted">Số Điện Thoại</label>
                            <input type="text" class="form-control fw-medium" name="sdt" value="${sessionScope.nhanVienDangNhap.SDT}" pattern="\d{10,11}" required>
                        </div>
                        <div class="col-md-12 mt-3">
                            <label class="form-label fw-bold small text-muted">Địa Chỉ Email</label>
                            <input type="email" class="form-control fw-medium" name="email" value="${sessionScope.nhanVienDangNhap.email}" required>
                        </div>
                    </div>

                    <h6 class="fw-bold text-dark mb-3 text-uppercase small" style="letter-spacing: 1px;">Bảo mật & Đổi mật khẩu</h6>
                    <div class="mb-3">
                        <label class="form-label fw-bold small text-danger">Mật Khẩu Hiện Tại (Bắt buộc) *</label>
                        <input type="password" class="form-control border-danger" name="oldPass" required placeholder="Nhập mật khẩu hiện tại...">
                    </div>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold small text-muted">Mật Khẩu Mới</label>
                            <input type="password" class="form-control" name="newPass" id="newPass" minlength="6" placeholder="Bỏ trống nếu không đổi">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small text-muted">Xác Nhận Mật Khẩu</label>
                            <input type="password" class="form-control" id="confirmPass" placeholder="Nhập lại mật khẩu mới">
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0 p-3 bg-white d-flex justify-content-between">
                    <button type="button" class="btn btn-light fw-bold rounded-pill px-4 border" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-brand fw-bold rounded-pill px-4"><i class="bi bi-floppy-fill me-1"></i> Lưu Thiết Lập</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="qrModal" tabindex="-1" data-bs-backdrop="static" data-bs-keyboard="false">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content shadow-lg border-0">
            <div class="modal-header text-white border-0 py-3" style="background-color: var(--brand);">
                <h6 class="modal-title fw-bold m-0"><i class="bi bi-qr-code-scan me-2"></i> Quét Mã Thanh Toán</h6>
            </div>
            <div class="modal-body text-center bg-white p-4">
                <h3 class="text-danger fw-bold mb-1" id="qrAmount">0 ₫</h3>
                <p class="text-muted small fw-medium mb-3">Mã GD: <span class="fw-bold text-dark" id="qrCodeDisplay"></span></p>

                <div class="bg-light p-3 rounded-4 d-inline-block mb-3 position-relative border">
                    <img id="qrImage" src="" alt="QR" style="width: 200px; height: 200px; object-fit: contain;">
                    <div id="qrSuccessOverlay" class="position-absolute top-0 start-0 w-100 h-100 bg-white bg-opacity-75 d-flex flex-column justify-content-center align-items-center rounded-4" style="display: none !important; z-index: 10; backdrop-filter: blur(2px);">
                        <i class='bi bi-check-circle-fill text-success' style='font-size: 4rem;'></i>
                        <h5 class='text-success mt-2 fw-bold'>Đã Nhận Tiền!</h5>
                    </div>
                </div>

                <div id="qrLoadingStatus" class="text-primary fw-bold small mb-2 d-flex align-items-center justify-content-center">
                    <div class="spinner-border spinner-border-sm me-2" role="status"></div>
                    <span>Hệ thống đang chờ tiền vào...</span>
                </div>
            </div>
            <div class="modal-footer border-0 p-3 bg-light d-flex justify-content-between rounded-bottom-4">
                <button type="button" class="btn btn-outline-danger fw-bold rounded-pill px-3" onclick="cancelQRPayment()">Hủy</button>
                <button type="button" class="btn btn-success fw-bold rounded-pill px-3" onclick="forceSubmitCheckout()">
                    Bỏ Qua <i class="bi bi-arrow-right"></i>
                </button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="optionModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content shadow-lg">
            <div class="modal-header border-0 py-3 bg-light">
                <h5 class="modal-title fw-bold text-dark" id="modalProductName">Tên Sản Phẩm</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <div class="mb-4">
                    <label class="fw-bold text-muted small mb-2 text-uppercase" style="letter-spacing: 0.5px;">1. Chọn Kích Cỡ (Size)</label>
                    <div id="sizeContainer" class="d-flex flex-wrap gap-2"></div>
                </div>
                <div class="row mb-4">
                    <div class="col-6">
                        <label class="fw-bold text-muted small mb-2 text-uppercase" style="letter-spacing: 0.5px;">2. Mức Đá</label>
                        <select class="form-select bg-light fw-medium" id="modalDa">
                            <option value="100%">100% Đá (Bình thường)</option>
                            <option value="50%">50% Đá (Ít đá)</option>
                            <option value="0%">0% Đá (Không đá)</option>
                        </select>
                    </div>
                    <div class="col-6">
                        <label class="fw-bold text-muted small mb-2 text-uppercase" style="letter-spacing: 0.5px;">3. Mức Đường</label>
                        <select class="form-select bg-light fw-medium" id="modalDuong">
                            <option value="100%">100% Đường (Bình thường)</option>
                            <option value="50%">50% Đường (Ít ngọt)</option>
                            <option value="0%">0% Đường (Không đường)</option>
                        </select>
                    </div>
                </div>
                <label class="fw-bold text-muted small mb-2 text-uppercase" style="letter-spacing: 0.5px;">4. Chọn Thêm Topping</label>
                <div class="topping-list bg-light rounded-3 p-2 border">
                    <c:forEach var="tp" items="${requestScope.danhSachTopping}">
                        <c:if test="${tp.trangThai == 1}">
                            <div class="d-flex justify-content-between align-items-center p-2 mb-1 bg-white rounded shadow-sm">
                                <div class="d-flex align-items-center">
                                    <img src="${pageContext.request.contextPath}/image/${not empty tp.hinhAnh ? tp.hinhAnh : 'default.png'}" class="rounded me-3 border" style="width: 44px; height: 44px; object-fit: cover;" onerror="this.src='https://placehold.co/100x100?text=No+Image'">
                                    <div>
                                        <div class="fw-bold text-dark" style="font-size: 0.95rem;">${tp.tenTopping}</div>
                                        <div class="text-danger fw-semibold small">+<fmt:formatNumber value="${tp.giaBan}" type="number"/>đ</div>
                                    </div>
                                </div>
                                <div class="input-group input-group-sm" style="width: 100px;">
                                    <button class="btn btn-outline-secondary fw-bold" type="button" onclick="changeModalTpQty('${tp.maTopping}', -1)">-</button>
                                    <input type="text" class="form-control text-center fw-bold bg-white" id="tp_qty_${tp.maTopping}" value="0" readonly data-id="${tp.maTopping}" data-name="${fn:escapeXml(tp.tenTopping)}" data-price="${tp.giaBan}">
                                    <button class="btn btn-outline-secondary fw-bold text-dark" type="button" onclick="changeModalTpQty('${tp.maTopping}', 1)">+</button>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
            </div>
            <div class="modal-footer border-0 p-3 bg-light">
                <button type="button" id="btn-confirm-modal" class="btn btn-brand w-100 py-3 fs-6 rounded-pill" onclick="confirmAddToCart()">
                    <i class="bi bi-cart-plus me-2"></i> XÁC NHẬN THÊM MÓN
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Receipt Modal -->
<c:if test="${not empty sessionScope.recentOrder}">
    <div class="modal fade" id="receiptModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content border-0 bg-transparent shadow-none">
                <div class="modal-body thermal-receipt" id="printable-receipt-content">
                    <div style="text-align:center; margin-bottom:15px;">
                        <h3 style="font-weight:bold; margin:0; letter-spacing: 1px;">TEA POS</h3>
                        <div style="font-size:12px; margin-top: 5px;">Hệ Thống Bán Hàng Premium</div>
                        <div style="font-size:12px;">Hotline: 0988.888.888</div>
                        <hr>
                        <h5 style="font-weight:bold; margin-top:10px;">HÓA ĐƠN THANH TOÁN</h5>
                    </div>

                    <div style="font-size:12px; margin-bottom:15px; line-height: 1.6;">
                        <div><span style="font-weight:bold;">Mã HD:</span> ${sessionScope.recentOrder.maDH}</div>
                        <div><span style="font-weight:bold;">Ngày:</span> <fmt:formatDate value="${sessionScope.recentOrder.thoiGianTao}" pattern="dd/MM/yyyy HH:mm"/></div>
                        <div><span style="font-weight:bold;">Thu ngân:</span> ${sessionScope.nhanVienDangNhap.hoTen}</div>
                        <c:if test="${not empty sessionScope.recentOrder.khachHang}">
                            <div><span style="font-weight:bold;">Khách:</span> ${sessionScope.recentOrder.khachHang.tenKH}</div>
                        </c:if>
                        <div><span style="font-weight:bold;">TT:</span> ${sessionScope.recentOrder.phuongThucThanhToan.tenPhuongThuc}</div>
                    </div>

                    <hr>
                    <div style="font-size:12px;">
                        <table style="width:100%; border-collapse:collapse;">
                            <c:forEach var="ct" items="${sessionScope.recentOrder.danhSachChiTiet}">
                                <tr>
                                    <td colspan="2" style="font-weight:bold; padding-top: 5px;">${ct.soLuong} x ${ct.bienThe.sanPham.tenSanPham}</td>
                                </tr>
                                <tr>
                                    <td colspan="2" style="padding-left:10px; color:#444; font-size:11px;">(Size ${ct.bienThe.kichCo} | ${ct.mucDa} Đá | ${ct.mucDuong} Đường)</td>
                                </tr>
                                <c:forEach var="tpItem" items="${ct.danhSachTopping}">
                                    <tr>
                                        <td style="padding-left:15px; color:#444; font-size:11px;">+ ${tpItem.soLuongTopping} x ${tpItem.topping.tenTopping}</td>
                                        <td></td>
                                    </tr>
                                </c:forEach>
                                <tr>
                                    <td></td>
                                    <td style="text-align:right; font-weight:bold; padding-bottom: 5px;">
                                        <fmt:formatNumber value="${ct.giaChot * ct.soLuong}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                    </td>
                                </tr>
                            </c:forEach>
                        </table>
                    </div>
                    <hr>

                    <div style="font-size:12px; line-height: 1.6;">
                        <div style="display:flex; justify-content:space-between;">
                            <span>Tổng cộng:</span>
                            <span style="font-weight:bold;"><fmt:formatNumber value="${sessionScope.recentOrder.tongTienHang}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
                        </div>
                        <c:if test="${sessionScope.recentOrder.tienGiamGia > 0}">
                            <div style="display:flex; justify-content:space-between;">
                                <span>Giảm Voucher:</span>
                                <c:set var="giamVoucherBill" value="${sessionScope.recentOrder.tienGiamGia - (not empty sessionScope.diemSuDungBill ? sessionScope.diemSuDungBill * 1000 : 0)}"/>
                                <span>-<fmt:formatNumber value="${giamVoucherBill > 0 ? giamVoucherBill : 0}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
                            </div>
                        </c:if>
                        <c:if test="${not empty sessionScope.diemSuDungBill && sessionScope.diemSuDungBill > 0}">
                            <div style="display:flex; justify-content:space-between;">
                                <span>Trừ điểm (${sessionScope.diemSuDungBill}):</span>
                                <span>-<fmt:formatNumber value="${sessionScope.diemSuDungBill * 1000}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
                            </div>
                        </c:if>
                        <hr>
                        <div style="display:flex; justify-content:space-between; font-weight:bold; font-size:16px; margin-top:5px; margin-bottom:5px;">
                            <span>THANH TOÁN:</span>
                            <span><fmt:formatNumber value="${sessionScope.recentOrder.tongTienTra}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
                        </div>
                        <div style="display:flex; justify-content:space-between;">
                            <span>Tiền nhận:</span>
                            <span><fmt:formatNumber value="${sessionScope.recentOrder.soTienKhachDua}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
                        </div>
                        <div style="display:flex; justify-content:space-between;">
                            <span>Tiền thối:</span>
                            <span><fmt:formatNumber value="${sessionScope.recentOrder.soTienKhachDua - sessionScope.recentOrder.tongTienTra}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
                        </div>
                    </div>
                    <hr>
                    <div style="text-align:center; font-size:12px; margin-top:15px;">
                        <p style="font-weight:bold; margin:0;">CẢM ƠN QUÝ KHÁCH!</p>
                        <p style="margin:5px 0 0 0; font-size: 10px;">Powered by TEA POS</p>
                    </div>
                </div>
                <div class="mt-4 text-center pb-3">
                    <button type="button" class="btn btn-light fw-bold px-4 rounded-pill me-2 shadow-sm" data-bs-dismiss="modal">Đóng</button>
                    <button type="button" class="btn btn-primary fw-bold px-4 rounded-pill shadow-sm" onclick="printReceipt()"><i class="bi bi-printer me-2"></i> In Lại</button>
                </div>
            </div>
        </div>
    </div>
</c:if>

<div id="hidden-variants-data" style="display: none;">
    <c:forEach var="bt" items="${requestScope.danhSachBienThe}">
        <div class="variant-item-data" data-mabt="${bt.maBienThe}" data-masp="${bt.sanPham.maSP}" data-size="${fn:escapeXml(bt.kichCo)}" data-price="${bt.giaBan}"></div>
    </c:forEach>
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

    function showToast(message, type = 'danger') {
        let icon = type === 'danger' ? 'bi-exclamation-triangle-fill' : (type === 'success' ? 'bi-check-circle-fill' : 'bi-info-circle-fill');
        let bgClass = type === 'danger' ? 'alert-danger' : (type === 'success' ? 'alert-success' : 'alert-warning text-dark');

        let toastHTML = `
                <div class="toast align-items-center border-0 mb-2 shadow-lg rounded-3 \${bgClass}" role="alert" aria-live="assertive" aria-atomic="true">
                    <div class="d-flex">
                        <div class="toast-body fw-bold d-flex align-items-center"><i class="bi \${icon} me-2 fs-5"></i> \${message}</div>
                        <button type="button" class="btn-close me-2 m-auto" data-bs-dismiss="toast"></button>
                    </div>
                </div>`;

        let container = document.getElementById('js-toast-container');
        container.insertAdjacentHTML('beforeend', toastHTML);
        let toastEl = container.lastElementChild;
        let bsToast = new bootstrap.Toast(toastEl, { delay: 4000 });
        bsToast.show();

        toastEl.addEventListener('hidden.bs.toast', () => { toastEl.remove(); });
    }

    function validateProfileAndConfirm(event, formElement) {
        event.preventDefault();
        let newP = document.getElementById('newPass').value;
        let confP = document.getElementById('confirmPass').value;
        if(newP !== '' && newP !== confP) {
            showToast("Cảnh báo: Mật khẩu mới và Xác nhận không khớp nhau!", "danger");
            return false;
        }
        showConfirmAction('Lưu Thiết Lập', 'Xác nhận thay đổi thông tin cá nhân và bảo mật?', function() {
            formElement.submit();
        });
    }

    const allVariants = [];
    document.querySelectorAll('.variant-item-data').forEach(function(item) {
        allVariants.push({
            maBT: item.getAttribute('data-mabt'),
            maSP: item.getAttribute('data-masp'),
            size: item.getAttribute('data-size'),
            price: parseInt(item.getAttribute('data-price'))
        });
    });

    // BẢN VÁ: Tích hợp Session Storage để không bị mất giỏ hàng khi chuyển danh mục
    let cart = JSON.parse(sessionStorage.getItem('tea_pos_cart')) || [];

    const formatCurrency = (number) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(number);

    let optionModal = new bootstrap.Modal(document.getElementById('optionModal'));
    let qrModal = new bootstrap.Modal(document.getElementById('qrModal'));

    const availableVouchers = [
        <c:forEach var="km" items="${requestScope.danhSachKhuyenMai}">
        <c:if test="${km.trangThai == 1 && (km.soLuong - km.soLuongDaDung > 0)}">
        { id: '${km.maKM}', code: '${km.maCode}'.toUpperCase(), loai: '${km.loaiGiamGia}', giaTri: ${km.giaTriGiam}, min: ${km.dieuKienToiThieu} },
        </c:if>
        </c:forEach>
    ];

    let currentVoucher = null;
    let currentProductVariants = [];
    let customerPoints = 0;
    let isUsingPoints = false;
    let customPointsToUse = 0;
    let checkPaymentInterval = null;
    let editingCartId = null;

    const appBasePath = document.getElementById('appContextPath').value;

    window.onload = function() {
        let receiptElement = document.getElementById('receiptModal');
        if(receiptElement) {
            // Xóa giỏ hàng khỏi Session khi đã thanh toán và in bill thành công
            sessionStorage.removeItem('tea_pos_cart');
            cart = [];
            let myModal = new bootstrap.Modal(receiptElement);
            myModal.show();
            setTimeout(() => { printReceipt(); }, 500);
            fetch(appBasePath + '/ban-hang?action=clear-bill').catch(e => console.log(e));
        } else {
            renderCart(); // Gọi renderCart để vẽ lại giao diện nếu có giỏ hàng lưu sẵn
        }
    };

    function printReceipt() {
        const receiptContent = document.getElementById('printable-receipt-content').innerHTML;
        const iframe = document.createElement('iframe');
        iframe.style.position = 'absolute';
        iframe.style.top = '-9999px';
        iframe.style.left = '-9999px';
        document.body.appendChild(iframe);

        const doc = iframe.contentWindow.document;
        const style = `
                <style>
                    @page { margin: 0; }
                    body { font-family: 'Courier New', Courier, monospace; margin: 0; padding: 5mm; width: 70mm; color: #000; }
                    table { width: 100%; border-collapse: collapse; }
                    hr { border-top: 1px dashed #000; opacity: 1; margin: 8px 0; background: none; }
                </style>
            `;
        doc.open();
        doc.write('<html><head>' + style + '</head><body>' + receiptContent + '</body></html>');
        doc.close();

        iframe.onload = function() {
            iframe.contentWindow.focus();
            iframe.contentWindow.print();
            setTimeout(() => { document.body.removeChild(iframe); }, 2000);
        };
    }

    function checkAndApplyVoucher() {
        let codeInput = document.getElementById('inputVoucherCode').value.trim().toUpperCase();
        if (codeInput === '') {
            showToast("Vui lòng nhập mã giảm giá!", "danger");
            return;
        }

        let found = availableVouchers.find(v => v.code === codeInput);
        if (found) {
            let tongTienHang = 0;
            cart.forEach(item => { tongTienHang += item.giaChot * item.soLuong; });

            if (tongTienHang >= found.min) {
                currentVoucher = found;
                showToast("Áp dụng mã giảm giá thành công!", "success");
                document.getElementById('activeVoucherInfo').style.display = 'block';
                document.getElementById('voucherLabel').innerText = found.code;
                document.getElementById('inputVoucherCode').value = '';
                if(isUsingPoints) { calculateCustomPoints(); } else { renderCart(); }
            } else {
                showToast('Đơn hàng chưa đạt mức tối thiểu ' + formatCurrency(found.min) + ' để áp dụng mã!', "danger");
                removeVoucher(false, true);
            }
        } else {
            showToast("Mã không hợp lệ hoặc đã hết lượt dùng!", "danger");
            removeVoucher(false, true);
        }
    }

    function removeVoucher(skipRender = false, silent = false) {
        currentVoucher = null;
        document.getElementById('input_maKM').value = '';
        document.getElementById('activeVoucherInfo').style.display = 'none';
        if(!silent) showToast("Đã gỡ mã giảm giá!", "warning");
        if(!skipRender) {
            if(isUsingPoints) { calculateCustomPoints(); } else { renderCart(); }
        }
    }

    function handlePaymentMethodChange() {
        let ptttSelect = document.getElementById('select_pttt');
        let ptttName = ptttSelect.options[ptttSelect.selectedIndex].text.toLowerCase();
        let tienKhachDuaInput = document.getElementById('tienKhachDua');
        let phaiTra = parseInt(document.getElementById('input_tongPhaiTra').value) || 0;

        if (ptttName.includes("tiền mặt") || ptttName.includes("cash")) {
            tienKhachDuaInput.readOnly = false;
            tienKhachDuaInput.classList.remove('bg-light');
            tienKhachDuaInput.value = '';
        } else {
            tienKhachDuaInput.readOnly = true;
            tienKhachDuaInput.classList.add('bg-light');
            tienKhachDuaInput.value = phaiTra;
        }
        calculateChange();
    }

    function calculateChange() {
        let khachDua = parseInt(document.getElementById('tienKhachDua').value) || 0;
        let phaiTra = parseInt(document.getElementById('input_tongPhaiTra').value) || 0;
        let ptttSelect = document.getElementById('select_pttt');
        let ptttName = ptttSelect.options[ptttSelect.selectedIndex].text.toLowerCase();
        let container = document.getElementById('tienThuaContainer');

        if (ptttName.includes("tiền mặt") || ptttName.includes("cash")) {
            if (khachDua >= phaiTra && phaiTra > 0) {
                container.style.display = 'block';
                document.getElementById('tienThuaLabel').innerText = formatCurrency(khachDua - phaiTra);
            } else {
                container.style.display = 'none';
            }
        } else {
            container.style.display = 'none';
        }
    }

    function generateHiddenCartInputs() {
        const h = document.getElementById('hidden-cart-inputs');
        h.innerHTML = '';
        cart.forEach(function(item, idx) {
            // BẢN VÁ: Loại bỏ dấu [] ở "name='tenMon_..." để Java hứng được biến String chứ không phải Array
            let inputs = "<input type='hidden' name='itemIndex[]' value='" + idx + "'>" +
                "<input type='hidden' name='tenMon_" + idx + "' value='" + item.ten + "'>" +
                "<input type='hidden' name='maBT_" + idx + "' value='" + item.maBT + "'>" +
                "<input type='hidden' name='soLuong_" + idx + "' value='" + item.soLuong + "'>" +
                "<input type='hidden' name='giaChot_" + idx + "' value='" + item.giaChot + "'>" +
                "<input type='hidden' name='da_" + idx + "' value='" + item.da + "'>" +
                "<input type='hidden' name='duong_" + idx + "' value='" + item.duong + "'>";

            item.toppings.forEach(function(tp) {
                inputs += "<input type='hidden' name='toppings_" + idx + "[]' value='" + tp.id + "|" + tp.qty + "|" + tp.price + "|" + tp.name + "'>";
            });
            h.insertAdjacentHTML('beforeend', inputs);
        });
    }

    function validateCheckout(event) {
        event.preventDefault();
        let khachDua = parseInt(document.getElementById('tienKhachDua').value);
        let phaiTra = parseInt(document.getElementById('input_tongPhaiTra').value);

        if (!khachDua || khachDua < phaiTra) {
            showToast("Số tiền khách đưa (" + formatCurrency(khachDua || 0) + ") không đủ để thanh toán hóa đơn (" + formatCurrency(phaiTra) + ")!", "danger");
            document.getElementById('tienKhachDua').focus();
            return false;
        }

        generateHiddenCartInputs();

        let ptttSelect = document.getElementById('select_pttt');
        let ptttName = ptttSelect.options[ptttSelect.selectedIndex].text.toLowerCase();

        if (ptttName.includes("tiền mặt") || ptttName.includes("cash")) {
            showConfirmAction("Xác Nhận Thanh Toán", "Xác nhận thu đủ " + formatCurrency(khachDua) + " tiền mặt của khách?", function() {
                submitCheckoutForm();
            });
        } else {
            let myBankBin = "TPB";
            let myAccountNum = "0346406405";

            document.getElementById('qrAmount').innerText = formatCurrency(phaiTra);

            let now = new Date();
            let yy = now.getFullYear().toString().slice(-2);
            let mm = String(now.getMonth() + 1).padStart(2, '0');
            let dd = String(now.getDate()).padStart(2, '0');
            let dateStr = yy + mm + dd;
            let randStr = Math.floor(1000 + Math.random() * 9000);
            let transactionCode = "TEA" + dateStr + randStr;

            document.getElementById('qrCodeDisplay').innerText = transactionCode;

            let qrUrl = "https://img.vietqr.io/image/" + myBankBin + "-" + myAccountNum + "-compact2.png?amount=" + phaiTra + "&addInfo=" + transactionCode;
            document.getElementById('qrImage').src = qrUrl;

            document.getElementById('qrSuccessOverlay').style.setProperty('display', 'none', 'important');
            document.getElementById('qrLoadingStatus').style.setProperty('display', 'flex', 'important');

            if (checkPaymentInterval) clearInterval(checkPaymentInterval);
            qrModal.show();

            checkPaymentInterval = setInterval(function() {
                fetch(appBasePath + '/api/check-payment?code=' + transactionCode)
                    .then(response => response.json())
                    .then(data => {
                        if (data.status === 'success') {
                            clearInterval(checkPaymentInterval);
                            document.getElementById('qrLoadingStatus').style.setProperty('display', 'none', 'important');
                            document.getElementById('qrSuccessOverlay').style.setProperty('display', 'flex', 'important');
                            setTimeout(function() {
                                qrModal.hide();
                                document.getElementById('checkout-form').submit();
                            }, 1500);
                        } else if (data.status === 'error' && data.message.includes('401')) {
                            clearInterval(checkPaymentInterval);
                            showToast("LỖI 401: Sai mã API Token của SePay. Vui lòng kiểm tra lại cấu hình.", "danger");
                            qrModal.hide();
                        }
                    }).catch(err => console.error(err));
            }, 3000);
        }
        return false;
    }

    function cancelQRPayment() {
        if (checkPaymentInterval) clearInterval(checkPaymentInterval);
        qrModal.hide();
    }

    function forceSubmitCheckout() {
        if (checkPaymentInterval) clearInterval(checkPaymentInterval);
        qrModal.hide();
        document.getElementById('checkout-form').submit();
    }

    function submitCheckoutForm() { document.getElementById('checkout-form').submit(); }

    function checkCustomerPhone() {
        let phone = document.getElementById('sdtKhachHang').value;
        let tenInput = document.getElementById('tenKhachHang');
        let infoPanel = document.getElementById('customerInfoPanel');
        let newPanel = document.getElementById('newCustomerPanel');

        document.getElementById('toggleDiem').checked = false;
        isUsingPoints = false;
        customerPoints = 0;
        customPointsToUse = 0;
        document.getElementById('input_nhapDiemTay').value = 0;
        document.getElementById('nhapDiemContainer').style.display = 'none';

        if (phone.length >= 10) {
            fetch(appBasePath + '/ban-hang?action=check-phone&phone=' + phone)
                .then(response => response.json())
                .then(data => {
                    if (data.found) {
                        tenInput.value = data.tenKH;
                        tenInput.readOnly = true;
                        document.getElementById('lblTenKH').innerText = data.tenKH;
                        document.getElementById('lblDiem').innerText = data.diem;
                        customerPoints = parseInt(data.diem);

                        infoPanel.style.display = 'block';
                        newPanel.style.display = 'none';
                        showToast("Đã áp dụng thông tin thành viên!", "success");
                    } else {
                        tenInput.value = '';
                        tenInput.readOnly = false;
                        infoPanel.style.display = 'none';
                        newPanel.style.display = 'block';
                    }
                    renderCart();
                }).catch(err => console.error(err));
        } else {
            tenInput.readOnly = false;
            infoPanel.style.display = 'none';
            newPanel.style.display = 'none';
            renderCart();
        }
    }

    function applyPoints() {
        isUsingPoints = document.getElementById('toggleDiem').checked;
        if(isUsingPoints) {
            document.getElementById('nhapDiemContainer').style.display = 'flex';
            useMaxPoints();
        } else {
            document.getElementById('nhapDiemContainer').style.display = 'none';
            customPointsToUse = 0;
            document.getElementById('input_nhapDiemTay').value = 0;
        }
        renderCart();
    }

    function getMaxAllowedPoints() {
        let tongHang = 0;
        cart.forEach(item => { tongHang += item.giaChot * item.soLuong; });

        let giamVoucher = 0;
        if (currentVoucher && tongHang >= currentVoucher.min) {
            if (currentVoucher.loai === 'Phần Trăm') giamVoucher = (tongHang * currentVoucher.giaTri) / 100;
            else giamVoucher = currentVoucher.giaTri;
            if(giamVoucher > tongHang) giamVoucher = tongHang;
        }

        let maxPointsForBill = Math.floor((tongHang - giamVoucher) / 1000);
        return (customerPoints > maxPointsForBill) ? maxPointsForBill : customerPoints;
    }

    function calculateCustomPoints() {
        let inputVal = parseInt(document.getElementById('input_nhapDiemTay').value) || 0;
        let maxAllowed = getMaxAllowedPoints();

        if (inputVal > maxAllowed) inputVal = maxAllowed;
        if (inputVal < 0) inputVal = 0;

        document.getElementById('input_nhapDiemTay').value = inputVal;
        customPointsToUse = inputVal;
        renderCart();
    }

    function useMaxPoints() {
        let maxAllowed = getMaxAllowedPoints();
        document.getElementById('input_nhapDiemTay').value = maxAllowed;
        customPointsToUse = maxAllowed;
        renderCart();
    }

    function changeModalTpQty(id, amount) {
        let input = document.getElementById('tp_qty_' + id);
        let val = parseInt(input.value) + amount;
        if(val >= 0) input.value = val;
    }

    function openOptionsModal(maSP, tenSP) {
        editingCartId = null;
        document.getElementById('btn-confirm-modal').innerHTML = '<i class="bi bi-cart-plus me-2"></i> THÊM VÀO ĐƠN';

        let decodedTenSP = tenSP.replace(/&amp;/g, '&').replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#034;/g, '"').replace(/&#039;/g, "'");
        document.getElementById('modalProductName').innerText = decodedTenSP;

        currentProductVariants = allVariants.filter(v => v.maSP === maSP);
        if (currentProductVariants.length === 0) {
            showToast("Sản phẩm này chưa được thiết lập Size để bán!", "danger");
            return;
        }

        let sizeHtml = '';
        currentProductVariants.forEach(function(v, index) {
            let checked = index === 0 ? "checked" : "";
            sizeHtml += "<input type='radio' class='btn-check' name='modalSizeRadio' id='size_" + v.maBT + "' value='" + v.maBT + "' " + checked + ">" +
                "<label class='btn btn-outline-primary fw-bold rounded-3 px-3 py-2' for='size_" + v.maBT + "'>" +
                "Size " + v.size + " <br> <small class='text-dark'>" + formatCurrency(v.price) + "</small>" +
                "</label>";
        });
        document.getElementById('sizeContainer').innerHTML = sizeHtml;

        document.querySelectorAll('input[id^="tp_qty_"]').forEach(function(inp) { inp.value = 0; });
        document.getElementById('modalDa').value = '100%';
        document.getElementById('modalDuong').value = '100%';

        optionModal.show();
    }

    function editCartItem(cartId) {
        let item = cart.find(i => i.cartId === cartId);
        if(!item) return;

        editingCartId = cartId;
        document.getElementById('modalProductName').innerText = item.tenGoc;
        document.getElementById('btn-confirm-modal').innerHTML = '<i class="bi bi-pencil-square me-2"></i> LƯU THAY ĐỔI';

        currentProductVariants = allVariants.filter(v => v.maSP === item.maSP);
        let sizeHtml = '';
        currentProductVariants.forEach(function(v) {
            let checked = (v.maBT === item.maBT) ? "checked" : "";
            sizeHtml += "<input type='radio' class='btn-check' name='modalSizeRadio' id='size_" + v.maBT + "' value='" + v.maBT + "' " + checked + ">" +
                "<label class='btn btn-outline-primary fw-bold rounded-3 px-3 py-2' for='size_" + v.maBT + "'>" +
                "Size " + v.size + " <br> <small class='text-dark'>" + formatCurrency(v.price) + "</small>" +
                "</label>";
        });
        document.getElementById('sizeContainer').innerHTML = sizeHtml;

        document.getElementById('modalDa').value = item.da;
        document.getElementById('modalDuong').value = item.duong;

        document.querySelectorAll('input[id^="tp_qty_"]').forEach(function(inp) { inp.value = 0; });
        if(item.toppings) {
            item.toppings.forEach(function(tp) {
                let input = document.getElementById('tp_qty_' + tp.id);
                if (input) input.value = tp.qty;
            });
        }

        optionModal.show();
    }

    function confirmAddToCart() {
        let selectedSizeRadio = document.querySelector('input[name="modalSizeRadio"]:checked');
        if (!selectedSizeRadio) {
            showToast("Vui lòng chọn Size món nước!", "warning");
            return;
        }

        let maBT = selectedSizeRadio.value;
        let selectedVariant = currentProductVariants.find(v => v.maBT === maBT);
        let tenGoc = document.getElementById('modalProductName').innerText;
        let ten = tenGoc + " (Size " + selectedVariant.size + ")";
        let gia = selectedVariant.price;
        let da = document.getElementById('modalDa').value;
        let duong = document.getElementById('modalDuong').value;

        let toppings = [];
        let extraToppingPrice = 0;
        document.querySelectorAll('input[id^="tp_qty_"]').forEach(function(inp) {
            let qty = parseInt(inp.value);
            if (qty > 0) {
                let id = inp.getAttribute('data-id');
                let name = inp.getAttribute('data-name');
                let price = parseInt(inp.getAttribute('data-price'));
                toppings.push({ id: id, name: name, price: price, qty: qty });
                extraToppingPrice += (price * qty);
            }
        });

        let cartId = maBT + "_" + da + "_" + duong;
        if (toppings.length > 0) {
            cartId += "_" + toppings.map(function(t) { return t.id + "-" + t.qty; }).join('_');
        }

        let qtyToSet = 1;
        if (editingCartId) {
            let oldItemIndex = cart.findIndex(i => i.cartId === editingCartId);
            if (oldItemIndex > -1) {
                qtyToSet = cart[oldItemIndex].soLuong;
                cart.splice(oldItemIndex, 1);
            }
            editingCartId = null;
        }

        let existingItem = cart.find(item => item.cartId === cartId);
        if (existingItem) {
            existingItem.soLuong += qtyToSet;
        } else {
            cart.push({
                cartId: cartId,
                maSP: selectedVariant.maSP,
                tenGoc: tenGoc,
                maBT: maBT,
                ten: ten,
                giaChot: gia + extraToppingPrice,
                soLuong: qtyToSet,
                da: da,
                duong: duong,
                toppings: toppings
            });
        }

        optionModal.hide();

        if(currentVoucher) {
            let tongTest = 0;
            cart.forEach(item => { tongTest += item.giaChot * item.soLuong; });
            if(tongTest < currentVoucher.min) {
                removeVoucher(true, true);
                showToast("Đã tự động gỡ Mã do tổng tiền không còn đạt mức tối thiểu!", "danger");
            }
        }

        renderCart();
    }

    function updateQty(cartId, change) {
        let idx = cart.findIndex(i => i.cartId === cartId);
        if (idx > -1) {
            cart[idx].soLuong += change;
            if (cart[idx].soLuong <= 0) {
                cart.splice(idx, 1);
                showToast("Đã bỏ món khỏi giỏ hàng!", "warning");
            }
        }

        if(currentVoucher) {
            let tongTest = 0;
            cart.forEach(item => { tongTest += item.giaChot * item.soLuong; });
            if(tongTest < currentVoucher.min) {
                removeVoucher(true, true);
                showToast("Đã tự động gỡ Mã do tổng tiền không còn đạt mức tối thiểu!", "danger");
            }
        }

        if(isUsingPoints) { calculateCustomPoints(); } else { renderCart(); }
    }

    function clearCart() {
        if(cart.length === 0) return;
        showConfirmAction("Xóa Giỏ Hàng", "Bạn có chắc chắn muốn xóa toàn bộ giỏ hàng hiện tại?", function() {
            cart = [];
            sessionStorage.removeItem('tea_pos_cart');

            document.getElementById('tienKhachDua').value = '';
            document.getElementById('sdtKhachHang').value = '';
            document.getElementById('tenKhachHang').value = '';
            document.getElementById('customerInfoPanel').style.display = 'none';
            document.getElementById('newCustomerPanel').style.display = 'none';
            customerPoints = 0;
            isUsingPoints = false;
            customPointsToUse = 0;
            let toggleDiem = document.getElementById('toggleDiem');
            if(toggleDiem) toggleDiem.checked = false;
            renderCart();
            showToast("Đã xóa giỏ hàng thành công!", "success");
        });
    }

    function renderCart() {
        sessionStorage.setItem('tea_pos_cart', JSON.stringify(cart));
        const container = document.getElementById('cart-items-container');
        container.innerHTML = '';

        if (cart.length === 0) {
            container.innerHTML = "<div class='text-center text-muted mt-5' id='empty-cart-msg'>" +
                "<i class='bi bi-cart-x text-secondary opacity-25' style='font-size: 4rem;'></i>" +
                "<p class='mt-3 fw-medium'>Chưa có món nào được chọn</p></div>";

            document.getElementById('btn-checkout').disabled = true;
            removeVoucher(true, true);

            document.getElementById('display_tongTienHang').innerText = "0 ₫";
            document.getElementById('display_tienGiamGia').innerText = "- 0 ₫";
            document.getElementById('display_tongPhaiTra').innerText = "0 ₫";

            document.getElementById('input_tongTienHang').value = 0;
            document.getElementById('input_tienGiamGia').value = 0;
            document.getElementById('input_tongPhaiTra').value = 0;
            document.getElementById('input_diemSuDung').value = 0;
            document.getElementById('row_giamDiem').style.setProperty('display', 'none', 'important');

            isUsingPoints = false;
            customPointsToUse = 0;
            let toggleBtn = document.getElementById('toggleDiem');
            if(toggleBtn) toggleBtn.checked = false;
            handlePaymentMethodChange();
            return;
        }

        document.getElementById('btn-checkout').disabled = false;
        let tongTienHang = 0;
        let tienGiamGia = 0;
        let tienGiamDiem = 0;
        let diemThucTeSuDung = 0;

        cart.forEach(function(item, index) {
            tongTienHang += item.giaChot * item.soLuong;

            let tpStr = "";
            if (item.toppings && item.toppings.length > 0) {
                tpStr = item.toppings.map(function(t) {
                    return "<span class='badge bg-warning bg-opacity-10 text-dark border border-warning border-opacity-50 me-1 mb-1'>+" + t.name + " (x" + t.qty + ")</span>";
                }).join('');
            }

            let itemHtml = "<div class='p-3 border-bottom bg-white'>" +
                "<div class='d-flex justify-content-between align-items-start'>" +
                "<div class='flex-grow-1 pe-2'><h6 class='mb-1 fw-bold text-dark'>" + item.ten + "</h6><div class='small text-muted mb-2 fw-medium'>Đá: " + item.da + " &bull; Đường: " + item.duong + "</div><div class='d-flex flex-wrap'>" + tpStr + "</div></div>" +
                "<div class='text-end'><h6 class='mb-1 fw-bold text-danger'>" + formatCurrency(item.giaChot * item.soLuong) + "</h6><small class='text-muted'>" + formatCurrency(item.giaChot) + "/ly</small></div>" +
                "</div>" +
                "<div class='d-flex justify-content-between align-items-center mt-3'>" +
                "<div>" +
                "<a href='javascript:void(0)' class='text-primary small text-decoration-none me-3 fw-bold' onclick=\"editCartItem('" + item.cartId + "')\"><i class='bi bi-pencil-square'></i> Sửa</a>" +
                "<a href='javascript:void(0)' class='text-danger small text-decoration-none fw-bold' onclick=\"updateQty('" + item.cartId + "', -999)\"><i class='bi bi-trash'></i> Xóa</a>" +
                "</div>" +
                "<div class='btn-group btn-group-sm shadow-sm'>" +
                "<button type='button' class='btn btn-light border fw-bold px-3' onclick=\"updateQty('" + item.cartId + "', -1)\"><i class='bi bi-dash-lg'></i></button>" +
                "<span class='btn btn-white border fw-bold px-3 text-primary' style='pointer-events: none; background: #fff;'>" + item.soLuong + "</span>" +
                "<button type='button' class='btn btn-light border fw-bold px-3' onclick=\"updateQty('" + item.cartId + "', 1)\"><i class='bi bi-plus-lg'></i></button>" +
                "</div></div></div>";

            container.insertAdjacentHTML('beforeend', itemHtml);
        });

        if (currentVoucher) {
            if (currentVoucher.loai === 'Phần Trăm') {
                tienGiamGia = (tongTienHang * currentVoucher.giaTri) / 100;
            } else {
                tienGiamGia = currentVoucher.giaTri;
            }
            if(tienGiamGia > tongTienHang) tienGiamGia = tongTienHang;
            document.getElementById('input_maKM').value = currentVoucher.id;
        }

        let tienSauVoucher = tongTienHang - tienGiamGia;

        if (isUsingPoints && customerPoints > 0) {
            let maxPointsCanUse = Math.floor(tienSauVoucher / 1000);
            diemThucTeSuDung = (customPointsToUse > maxPointsCanUse) ? maxPointsCanUse : customPointsToUse;
            tienGiamDiem = diemThucTeSuDung * 1000;

            document.getElementById('row_giamDiem').style.setProperty('display', 'flex', 'important');
            document.getElementById('display_giamDiem').innerText = "- " + formatCurrency(tienGiamDiem);
        } else {
            document.getElementById('row_giamDiem').style.setProperty('display', 'none', 'important');
        }

        let tongPhaiTra = tienSauVoucher - tienGiamDiem;

        document.getElementById('display_tongTienHang').innerText = formatCurrency(tongTienHang);
        document.getElementById('display_tienGiamGia').innerText = "- " + formatCurrency(tienGiamGia);
        document.getElementById('display_tongPhaiTra').innerText = formatCurrency(tongPhaiTra);

        document.getElementById('input_tongTienHang').value = tongTienHang;
        document.getElementById('input_tienGiamGia').value = tienGiamGia;
        document.getElementById('input_diemSuDung').value = diemThucTeSuDung;
        document.getElementById('input_tongPhaiTra').value = tongPhaiTra;

        handlePaymentMethodChange();
    }
</script>
</body>
</html>