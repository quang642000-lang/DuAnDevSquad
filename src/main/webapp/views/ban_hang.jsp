<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>TEA POS - Hệ Thống Bán Hàng</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f4f6f9; overflow-x: hidden; }
        .product-card { cursor: pointer; transition: transform 0.2s, box-shadow 0.2s; border: 1px solid #e9ecef; }
        .product-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.1) !important; border-color: #0d6efd;}
        .product-img { height: 120px; object-fit: cover; width: 100%; border-top-left-radius: 8px; border-top-right-radius: 8px; }
        .cart-container { height: calc(100vh - 75px); position: sticky; top: 70px; display: flex; flex-direction: column;}
        .cart-items { flex-grow: 1; overflow-y: auto; background-color: #fafbfe; }
        .cart-items::-webkit-scrollbar { width: 5px; }
        .cart-items::-webkit-scrollbar-thumb { background-color: #cbd5e1; border-radius: 5px; }

        .thermal-receipt {
            background: #fff;
            width: 100%;
            max-width: 350px;
            margin: 0 auto;
            padding: 15px;
            font-family: 'Courier New', Courier, monospace;
            color: #000;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .thermal-receipt table { width: 100%; border-collapse: collapse; }
        .thermal-receipt hr { border-top: 1px dashed #000; opacity: 1; margin: 8px 0; background: none; }
        .thermal-receipt .fw-bold { font-weight: 700 !important; }
        .thermal-receipt .small-text { font-size: 0.85rem; }
    </style>
</head>
<body>

<input type="hidden" id="appContextPath" value="${pageContext.request.contextPath}">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold text-warning fs-4" href="${pageContext.request.contextPath}/ban-hang"><i class="bi bi-cup-straw"></i> TEA POS</a>
        <div class="d-flex align-items-center text-white">
            <span class="me-4"><i class="bi bi-person-badge-fill"></i> ${sessionScope.nhanVienDangNhap.hoTen}</span>
            <c:if test="${sessionScope.nhanVienDangNhap.vaiTro.maVaiTro == 1}">
                <a href="${pageContext.request.contextPath}/admin" class="btn btn-sm btn-outline-light me-3"><i class="bi bi-speedometer2"></i> Trang Admin</a>
            </c:if>
            <a href="${pageContext.request.contextPath}/auth?action=logout" class="btn btn-sm btn-danger"><i class="bi bi-power"></i> Đăng Xuất</a>
        </div>
    </div>
</nav>

<div class="container-fluid mt-3">
    <c:if test="${not empty sessionScope.message}">
        <c:choose>
            <c:when test="${fn:contains(sessionScope.message, 'Lỗi') || fn:contains(sessionScope.message, 'thất bại')}">
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
        <div class="col-lg-7 col-xl-8 mb-4">
            <div class="d-flex mb-3 overflow-auto pb-2" style="white-space: nowrap;">
                <a href="${pageContext.request.contextPath}/ban-hang" class="btn btn-${empty param.maDanhMuc ? 'primary shadow-sm' : 'outline-primary'} rounded-pill me-2 fw-bold px-4">
                    Tất cả
                </a>
                <c:forEach var="dm" items="${requestScope.danhSachDanhMuc}">
                    <a href="${pageContext.request.contextPath}/ban-hang?maDanhMuc=${dm.maDanhMuc}"
                       class="btn btn-${param.maDanhMuc == dm.maDanhMuc ? 'primary shadow-sm' : 'outline-primary'} rounded-pill me-2 fw-bold px-3">
                            ${dm.tenDanhMuc}
                    </a>
                </c:forEach>
            </div>

            <div class="row row-cols-2 row-cols-md-3 row-cols-xl-4 g-3">
                <c:choose>
                    <c:when test="${not empty requestScope.danhSachSanPham}">
                        <c:forEach var="sp" items="${requestScope.danhSachSanPham}">
                            <c:if test="${sp.trangThai == 1}">
                                <div class="col">
                                    <div class="card h-100 shadow-sm product-card bg-white rounded-3"
                                         onclick="openOptionsModal('${sp.maSP}', '${fn:escapeXml(sp.tenSanPham)}')">
                                        <img src="${pageContext.request.contextPath}/image/${not empty sp.hinhAnh ? sp.hinhAnh : 'default.png'}"
                                             class="product-img" onerror="this.src='https://placehold.co/300x200?text=No+Image'" alt="${fn:escapeXml(sp.tenSanPham)}">
                                        <div class="card-body p-3 text-center d-flex flex-column justify-content-center">
                                            <h6 class="card-title fw-bold mb-1 text-truncate" title="${fn:escapeXml(sp.tenSanPham)}">${sp.tenSanPham}</h6>
                                            <small class="text-primary fw-bold"><i class="bi bi-hand-index-thumb"></i> Chọn Size</small>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="col-12 text-center py-5"><h5 class="text-muted">Không có sản phẩm nào!</h5></div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="col-lg-5 col-xl-4">
            <div class="card shadow-sm border-0 cart-container rounded-3">
                <div class="card-header bg-white border-bottom border-2 border-primary py-3">
                    <h5 class="mb-0 fw-bold text-primary"><i class="bi bi-receipt"></i> ĐƠN HÀNG</h5>
                </div>

                <div class="card-body p-0 cart-items" id="cart-items-container">
                    <div class="text-center text-muted mt-5" id="empty-cart-msg">
                        <i class="bi bi-cart-x text-secondary" style="font-size: 4rem;"></i>
                        <p class="mt-2 fw-medium">Chưa chọn món nào</p>
                    </div>
                </div>

                <div class="card-footer bg-white border-top shadow-lg p-3">
                    <form action="${pageContext.request.contextPath}/ban-hang" method="post" id="checkout-form" onsubmit="return validateCheckout(event)">
                        <input type="hidden" name="action" value="checkout">
                        <div id="hidden-cart-inputs"></div>

                        <input type="hidden" name="tongTienHang" id="input_tongTienHang" value="0">
                        <input type="hidden" name="tienGiamGia" id="input_tienGiamGia" value="0">
                        <input type="hidden" name="tongPhaiTra" id="input_tongPhaiTra" value="0">
                        <input type="hidden" name="maKM" id="input_maKM" value="">

                        <div class="row g-2 mb-1">
                            <div class="col-5">
                                <input type="text" class="form-control form-control-sm" name="sdtKhachHang" id="sdtKhachHang" placeholder="SĐT Khách" maxlength="10" oninput="checkCustomerPhone()">
                            </div>
                            <div class="col-7">
                                <input type="text" class="form-control form-control-sm" name="tenKhachHang" id="tenKhachHang" placeholder="Tên khách (nếu mới)">
                            </div>
                        </div>

                        <div id="customerInfoPanel" class="bg-light p-2 rounded border border-warning mb-2" style="display: none;">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <span class="fw-bold text-dark small"><i class="bi bi-person-check-fill text-success"></i> <span id="lblTenKH"></span></span>
                                <span class="badge bg-warning text-dark"><i class="bi bi-coin"></i> <span id="lblDiem">0</span> Điểm</span>
                            </div>
                            <div class="form-check form-switch small mb-1">
                                <input class="form-check-input" type="checkbox" id="toggleDiem" onchange="applyPoints()">
                                <label class="form-check-label text-danger fw-bold" for="toggleDiem">Dùng điểm trừ tiền (1đ = 1.000đ)</label>
                            </div>

                            <div id="nhapDiemContainer" class="input-group input-group-sm mt-1" style="display: none;">
                                <span class="input-group-text bg-white small">Dùng:</span>
                                <input type="number" class="form-control text-end text-danger fw-bold" id="input_nhapDiemTay" value="0" min="0" oninput="calculateCustomPoints()">
                                <button class="btn btn-outline-danger fw-bold" type="button" onclick="useMaxPoints()">Max</button>
                            </div>
                            <input type="hidden" name="diemSuDung" id="input_diemSuDung" value="0">
                        </div>
                        <div id="newCustomerPanel" class="text-primary small fw-bold mb-2 ps-1" style="display: none;">
                            <i class="bi bi-info-circle"></i> Khách mới. Tự tạo thẻ sau thanh toán!
                        </div>

                        <div class="d-flex justify-content-between align-items-center mb-2 bg-light p-2 rounded border">
                            <span class="fw-bold small text-muted"><i class="bi bi-ticket-perforated"></i> Mã KM: <span id="voucherLabel" class="text-muted fw-normal">Trống</span></span>
                            <button type="button" class="btn btn-sm btn-outline-success fw-bold" data-bs-toggle="modal" data-bs-target="#voucherModal">Chọn Mã</button>
                        </div>

                        <div class="border rounded p-2 mb-2 bg-light text-end small">
                            <div class="d-flex justify-content-between">
                                <span class="text-muted fw-bold">Tổng tiền hàng:</span>
                                <span class="fw-bold text-dark" id="display_tongTienHang">0 ₫</span>
                            </div>
                            <div class="d-flex justify-content-between text-success">
                                <span class="fw-bold">Giảm Voucher:</span>
                                <span class="fw-bold" id="display_tienGiamGia">- 0 ₫</span>
                            </div>
                            <div class="d-flex justify-content-between text-danger" id="row_giamDiem" style="display: none !important;">
                                <span class="fw-bold">Trừ tiền tích lũy:</span>
                                <span class="fw-bold" id="display_giamDiem">- 0 ₫</span>
                            </div>
                            <hr class="my-1">
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="fw-bold fs-6 text-dark">TỔNG PHẢI TRẢ:</span>
                                <span class="fw-bold fs-4 text-danger" id="display_tongPhaiTra">0 ₫</span>
                            </div>
                        </div>

                        <div class="row g-2 align-items-center mb-3">
                            <div class="col-5">
                                <select class="form-select form-select-sm fw-bold border-secondary" name="maPTTT" id="select_pttt" required onchange="handlePaymentMethodChange()">
                                    <c:forEach var="pt" items="${requestScope.danhSachPTTT}">
                                        <option value="${pt.maPTTT}">${pt.tenPhuongThuc}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-7">
                                <div class="input-group input-group-sm">
                                    <span class="input-group-text bg-white fw-bold">Khách Đưa</span>
                                    <input type="number" class="form-control text-end fw-bold text-primary" name="tienKhachDua" id="tienKhachDua" required oninput="calculateChange()">
                                </div>
                            </div>
                            <div class="col-12 text-end small" id="tienThuaContainer" style="display: none;">
                                <span class="fw-bold text-muted">Tiền thối lại:</span>
                                <span class="fw-bold text-success fs-6" id="tienThuaLabel">0 ₫</span>
                            </div>
                        </div>

                        <div class="row g-2">
                            <div class="col-4">
                                <button type="button" class="btn btn-outline-danger w-100 fw-bold py-2" onclick="clearCart()">Hủy Đơn</button>
                            </div>
                            <div class="col-8">
                                <button type="submit" class="btn btn-primary w-100 fw-bold fs-5 shadow-sm py-2" id="btn-checkout" disabled>THANH TOÁN</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="qrModal" tabindex="-1" data-bs-backdrop="static" data-bs-keyboard="false">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content border-0 shadow-lg">
            <div class="modal-header bg-primary text-white border-0 py-2">
                <h6 class="modal-title fw-bold m-0"><i class="bi bi-qr-code-scan"></i> Quét Mã Thanh Toán</h6>
            </div>
            <div class="modal-body text-center bg-light">
                <h4 class="text-danger fw-bold mb-1" id="qrAmount">0 ₫</h4>
                <p class="text-muted small mb-3">Nội dung CK: <span class="fw-bold text-dark" id="qrCodeDisplay"></span></p>

                <div class="bg-white p-2 rounded shadow-sm d-inline-block mb-3 position-relative">
                    <img id="qrImage" src="" alt="Mã QR Thanh Toán" style="width: 220px; height: 220px; object-fit: contain;">
                    <div id="qrSuccessOverlay" class="position-absolute top-0 start-0 w-100 h-100 bg-white d-flex flex-column justify-content-center align-items-center rounded" style="display: none !important; z-index: 10;">
                        <i class='bi bi-check-circle-fill text-success' style='font-size: 3.5rem;'></i>
                        <h5 class='text-success mt-2 fw-bold'>Thanh toán thành công!</h5>
                    </div>
                </div>

                <div id="qrLoadingStatus" class="text-primary fw-bold small mb-3 d-flex align-items-center justify-content-center">
                    <div class="spinner-border spinner-border-sm me-2" role="status"></div>
                    <span>Đang chờ tiền vào...</span>
                </div>

                <div class="alert alert-info py-2 small mb-0">
                    <i class="bi bi-info-circle-fill"></i> Hệ thống đang tự động kiểm tra giao dịch.
                </div>
            </div>
            <div class="modal-footer border-0 p-2 bg-white d-flex justify-content-between">
                <button type="button" class="btn btn-sm btn-outline-danger fw-bold" onclick="cancelQRPayment()">Hủy Giao Dịch</button>
                <button type="button" class="btn btn-sm btn-success fw-bold" onclick="forceSubmitCheckout()">
                    <i class="bi bi-check-circle-fill"></i> Bỏ Qua (Đã Nhận)
                </button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="optionModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg">
            <div class="modal-header bg-primary text-white border-0">
                <h5 class="modal-title fw-bold" id="modalProductName">Tên Sản Phẩm</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body bg-light">
                <div class="mb-3 border-bottom pb-2">
                    <label class="fw-bold small text-muted mb-2">1. CHỌN KÍCH CỠ (SIZE)</label>
                    <div id="sizeContainer" class="d-flex flex-wrap gap-2"></div>
                </div>

                <div class="row mb-3">
                    <div class="col-6">
                        <label class="fw-bold small text-muted mb-2">2. MỨC ĐÁ</label>
                        <select class="form-select form-select-sm" id="modalDa">
                            <option value="100%">100% Đá (Bình thường)</option>
                            <option value="50%">50% Đá (Ít đá)</option>
                            <option value="0%">0% Đá (Không đá)</option>
                        </select>
                    </div>
                    <div class="col-6">
                        <label class="fw-bold small text-muted mb-2">3. MỨC ĐƯỜNG</label>
                        <select class="form-select form-select-sm" id="modalDuong">
                            <option value="100%">100% Đường (Bình thường)</option>
                            <option value="50%">50% Đường (Ít ngọt)</option>
                            <option value="0%">0% Đường (Không đường)</option>
                        </select>
                    </div>
                </div>

                <label class="fw-bold small text-muted mb-2">4. CHỌN THÊM TOPPING</label>
                <div class="max-height-200 overflow-auto bg-white border rounded p-2">
                    <c:forEach var="tp" items="${requestScope.danhSachTopping}">
                        <c:if test="${tp.trangThai == 1}">
                            <div class="d-flex justify-content-between align-items-center mb-2 pb-2 border-bottom">
                                <div class="d-flex align-items-center">
                                    <img src="${pageContext.request.contextPath}/image/${not empty tp.hinhAnh ? tp.hinhAnh : 'default.png'}"
                                         class="rounded me-2 shadow-sm" style="width: 40px; height: 40px; object-fit: cover;"
                                         onerror="this.src='https://placehold.co/100x100?text=No+Image'">
                                    <div>
                                        <span class="fw-bold" style="font-size: 0.9rem;">${tp.tenTopping}</span><br>
                                        <small class="text-danger">+<fmt:formatNumber value="${tp.giaBan}" type="number"/>đ</small>
                                    </div>
                                </div>
                                <div class="input-group input-group-sm w-auto">
                                    <button class="btn btn-outline-secondary" type="button" onclick="changeModalTpQty('${tp.maTopping}', -1)">-</button>
                                    <input type="text" class="form-control text-center fw-bold" style="max-width: 40px;"
                                           id="tp_qty_${tp.maTopping}" value="0" readonly
                                           data-id="${tp.maTopping}" data-name="${fn:escapeXml(tp.tenTopping)}" data-price="${tp.giaBan}">
                                    <button class="btn btn-outline-secondary" type="button" onclick="changeModalTpQty('${tp.maTopping}', 1)">+</button>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
            </div>
            <div class="modal-footer border-0 p-3 bg-white">
                <button type="button" id="btn-confirm-modal" class="btn btn-primary w-100 fw-bold fs-5 shadow-sm" onclick="confirmAddToCart()">
                    <i class="bi bi-cart-plus"></i> XÁC NHẬN THÊM MÓN
                </button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="voucherModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title fw-bold"><i class="bi bi-ticket-perforated"></i> Áp Dụng Mã Khuyến Mãi</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-2 bg-light">
                <button class="btn btn-outline-danger w-100 mb-3 fw-bold" onclick="removeVoucher()">Không sử dụng mã giảm giá</button>
                <div class="list-group">
                    <c:forEach var="km" items="${requestScope.danhSachKhuyenMai}">
                        <c:if test="${km.trangThai == 1 && (km.soLuong - km.soLuongDaDung > 0)}">
                            <a href="javascript:void(0)" class="list-group-item list-group-item-action"
                               onclick="applyVoucher('${km.maKM}', '${km.maCode}', '${km.loaiGiamGia}', ${km.giaTriGiam}, ${km.dieuKienToiThieu})">
                                <div class="d-flex w-100 justify-content-between">
                                    <h6 class="mb-1 fw-bold text-success">${km.maCode} - ${km.tenKM}</h6>
                                    <small class="text-danger fw-bold">
                                        <c:choose>
                                            <c:when test="${km.loaiGiamGia == 'Phần Trăm'}">Giảm ${km.giaTriGiam}%</c:when>
                                            <c:otherwise>Giảm <fmt:formatNumber value="${km.giaTriGiam}" type="number"/>đ</c:otherwise>
                                        </c:choose>
                                    </small>
                                </div>
                                <small class="text-muted">Điều kiện đơn hàng tối thiểu: <fmt:formatNumber value="${km.dieuKienToiThieu}" type="number"/>đ</small>
                            </a>
                        </c:if>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</div>

<c:if test="${not empty sessionScope.recentOrder}">
    <div class="modal fade" id="receiptModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content border-0 bg-transparent shadow-none">
                <div class="modal-body thermal-receipt" id="printable-receipt-content" style="background:#fff; margin:0 auto; padding:15px; width:300px;">
                    <div style="text-align:center; margin-bottom:10px;">
                        <h4 style="font-weight:bold; margin:0;">TEA POS RECEIPT</h4>
                        <div style="font-size:12px; font-weight:600;">ĐC: FPT Polytechnic</div>
                        <div style="font-size:12px;">SĐT Hệ Thống: 0988.888.888</div>
                        <hr style="border-top:1px dashed #000;">
                        <h5 style="font-weight:bold; margin-top:5px;">HÓA ĐƠN THANH TOÁN</h5>
                    </div>

                    <div style="font-size:12px; margin-bottom:10px;">
                        <div><span style="font-weight:bold;">Số phiếu:</span> ${sessionScope.recentOrder.maDH}</div>
                        <div><span style="font-weight:bold;">Thời gian nhập:</span> <fmt:formatDate value="${sessionScope.recentOrder.thoiGianTao}" pattern="dd/MM/yyyy HH:mm:ss"/></div>
                        <div><span style="font-weight:bold;">Thu ngân:</span> ${sessionScope.nhanVienDangNhap.hoTen}</div>
                        <c:if test="${not empty sessionScope.recentOrder.khachHang}">
                            <div><span style="font-weight:bold;">Khách hàng:</span> ${sessionScope.recentOrder.khachHang.tenKH}</div>
                        </c:if>
                        <div><span style="font-weight:bold;">Thanh toán:</span> ${sessionScope.recentOrder.phuongThucThanhToan.tenPhuongThuc}</div>
                    </div>
                    <hr style="border-top:1px dashed #000;">

                    <div style="font-size:12px;">
                        <table style="width:100%; border-collapse:collapse;">
                            <c:forEach var="ct" items="${sessionScope.recentOrder.danhSachChiTiet}">
                                <tr>
                                    <td colspan="2" style="font-weight:bold;">${ct.soLuong}x ${ct.bienThe.sanPham.tenSanPham}</td>
                                </tr>
                                <tr>
                                    <td colspan="2" style="padding-left:10px; color:#555; font-size:10px;">- Tùy biến: ${ct.mucDa} Đá | ${ct.mucDuong} Đường</td>
                                </tr>
                                <c:forEach var="tpItem" items="${ct.danhSachTopping}">
                                    <tr>
                                        <td style="padding-left:15px; color:#555; font-size:10px;">+ ${tpItem.soLuongTopping}x Topping: ${tpItem.topping.tenTopping}</td>
                                        <td></td>
                                    </tr>
                                </c:forEach>
                                <tr>
                                    <td></td>
                                    <td style="text-align:right; font-weight:600;">
                                        <fmt:formatNumber value="${ct.giaChot * ct.soLuong}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                    </td>
                                </tr>
                            </c:forEach>
                        </table>
                    </div>
                    <hr style="border-top:1px dashed #000;">

                    <div style="font-size:12px;">
                        <div style="display:flex; justify-content:space-between;">
                            <span>Tổng tiền hàng:</span>
                            <span><fmt:formatNumber value="${sessionScope.recentOrder.tongTienHang}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
                        </div>
                        <c:if test="${sessionScope.recentOrder.tienGiamGia > 0}">
                            <div style="display:flex; justify-content:space-between; color:red;">
                                <span>Giảm Voucher:</span>
                                <c:set var="giamVoucherBill" value="${sessionScope.recentOrder.tienGiamGia - (not empty sessionScope.diemSuDungBill ? sessionScope.diemSuDungBill * 1000 : 0)}"/>
                                <span>-<fmt:formatNumber value="${giamVoucherBill > 0 ? giamVoucherBill : 0}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
                            </div>
                        </c:if>
                        <c:if test="${not empty sessionScope.diemSuDungBill && sessionScope.diemSuDungBill > 0}">
                            <div style="display:flex; justify-content:space-between; color:red;">
                                <span>Khấu trừ điểm (${sessionScope.diemSuDungBill}đ):</span>
                                <span>-<fmt:formatNumber value="${sessionScope.diemSuDungBill * 1000}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
                            </div>
                        </c:if>
                        <hr style="border-top:1px dashed #000;">
                        <div style="display:flex; justify-content:space-between; font-weight:bold; font-size:14px; margin-top:5px;">
                            <span>TỔNG PHẢI TRẢ:</span>
                            <span><fmt:formatNumber value="${sessionScope.recentOrder.tongTienTra}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
                        </div>
                        <div style="display:flex; justify-content:space-between; margin-top:5px;">
                            <span>Tiền khách đưa:</span>
                            <span><fmt:formatNumber value="${sessionScope.recentOrder.soTienKhachDua}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
                        </div>
                        <div style="display:flex; justify-content:space-between;">
                            <span>Tiền thối lại:</span>
                            <span><fmt:formatNumber value="${sessionScope.recentOrder.soTienKhachDua - sessionScope.recentOrder.tongTienTra}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
                        </div>
                    </div>
                    <hr style="border-top:1px dashed #000;">
                    <div style="text-align:center; font-size:12px; margin-top:10px;">
                        <p style="font-weight:bold; margin:0;">CẢM ƠN QUÝ KHÁCH & HẸN GẶP LẠI!</p>
                    </div>
                </div>

                <div class="mt-4 text-center pb-3">
                    <button type="button" class="btn btn-secondary fw-bold me-2" data-bs-dismiss="modal">Đóng</button>
                    <button type="button" class="btn btn-primary fw-bold" onclick="printReceipt()"><i class="bi bi-printer"></i> In Lại Hóa Đơn</button>
                </div>
            </div>
        </div>
    </div>
</c:if>

<div id="hidden-variants-data" style="display: none;">
    <c:forEach var="bt" items="${requestScope.danhSachBienThe}">
        <div class="variant-item-data"
             data-mabt="${bt.maBienThe}"
             data-masp="${bt.sanPham.maSP}"
             data-size="${fn:escapeXml(bt.kichCo)}"
             data-price="${bt.giaBan}"></div>
    </c:forEach>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    const allVariants = [];
    document.querySelectorAll('.variant-item-data').forEach(function(item) {
        allVariants.push({
            maBT: item.getAttribute('data-mabt'),
            maSP: item.getAttribute('data-masp'),
            size: item.getAttribute('data-size'),
            price: parseInt(item.getAttribute('data-price'))
        });
    });

    let cart = [];
    const formatCurrency = (number) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(number);

    let optionModal = new bootstrap.Modal(document.getElementById('optionModal'));
    let voucherModal = new bootstrap.Modal(document.getElementById('voucherModal'));
    let qrModal = new bootstrap.Modal(document.getElementById('qrModal'));

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
            let myModal = new bootstrap.Modal(receiptElement);
            myModal.show();
            setTimeout(() => { printReceipt(); }, 500);
            fetch(appBasePath + '/ban-hang?action=clear-bill').catch(e => console.log(e));
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
            alert("Số tiền khách đưa không đủ để thanh toán!");
            document.getElementById('tienKhachDua').focus();
            return false;
        }

        generateHiddenCartInputs();

        let ptttSelect = document.getElementById('select_pttt');
        let ptttName = ptttSelect.options[ptttSelect.selectedIndex].text.toLowerCase();

        if (ptttName.includes("tiền mặt") || ptttName.includes("cash")) {
            if(confirm("Xác nhận thu đủ " + formatCurrency(khachDua) + " tiền mặt của khách?")) {
                submitCheckoutForm();
            }
        } else {
            let myBankBin = "TPB";
            let myAccountNum = "0346406405";

            document.getElementById('qrAmount').innerText = formatCurrency(phaiTra);

            // ========================================================
            // THUẬT TOÁN MỚI: TỰ ĐỘNG SINH MÃ RESET THEO NGÀY (YYMMDD + 4 số)
            // ========================================================
            let now = new Date();
            let yy = now.getFullYear().toString().slice(-2); // VD: "26"
            let mm = String(now.getMonth() + 1).padStart(2, '0'); // VD: "06"
            let dd = String(now.getDate()).padStart(2, '0'); // VD: "09"
            let dateStr = yy + mm + dd; // Ghép lại: "260609"

            let randStr = Math.floor(1000 + Math.random() * 9000); // 4 số ngẫu nhiên: 1000 - 9999
            let transactionCode = "TEA" + dateStr + randStr; // VD: TEA2606094825

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
                            alert("LỖI 401: Sai mã API Token của SePay. Vui lòng vào Cấu hình -> API Keys lấy đúng mã API.");
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
        document.getElementById('btn-confirm-modal').innerHTML = '<i class="bi bi-cart-plus"></i> XÁC NHẬN THÊM MÓN';

        let decodedTenSP = tenSP.replace(/&amp;/g, '&').replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#034;/g, '"').replace(/&#039;/g, "'");
        document.getElementById('modalProductName').innerText = decodedTenSP;

        currentProductVariants = allVariants.filter(v => v.maSP === maSP);
        if (currentProductVariants.length === 0) {
            alert("Sản phẩm này hiện chưa được cấu hình kích cỡ (Size) nào!");
            return;
        }

        let sizeHtml = '';
        currentProductVariants.forEach(function(v, index) {
            let checked = index === 0 ? "checked" : "";
            sizeHtml += "<input type='radio' class='btn-check' name='modalSizeRadio' id='size_" + v.maBT + "' value='" + v.maBT + "' " + checked + ">" +
                "<label class='btn btn-outline-primary fw-bold' for='size_" + v.maBT + "'>" +
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
        document.getElementById('btn-confirm-modal').innerHTML = '<i class="bi bi-pencil-square"></i> CẬP NHẬT MÓN';

        currentProductVariants = allVariants.filter(v => v.maSP === item.maSP);

        let sizeHtml = '';
        currentProductVariants.forEach(function(v) {
            let checked = (v.maBT === item.maBT) ? "checked" : "";
            sizeHtml += "<input type='radio' class='btn-check' name='modalSizeRadio' id='size_" + v.maBT + "' value='" + v.maBT + "' " + checked + ">" +
                "<label class='btn btn-outline-primary fw-bold' for='size_" + v.maBT + "'>" +
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
        if (!selectedSizeRadio) { alert("Vui lòng chọn Size món nước!"); return; }

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
        renderCart();
    }

    function updateQty(cartId, change) {
        let idx = cart.findIndex(i => i.cartId === cartId);
        if (idx > -1) {
            cart[idx].soLuong += change;
            if (cart[idx].soLuong <= 0) cart.splice(idx, 1);
        }
        if(isUsingPoints) { calculateCustomPoints(); } else { renderCart(); }
    }

    function clearCart() {
        if(confirm("Bạn có chắc chắn muốn hủy và xóa sạch giỏ hàng hiện tại không?")) {
            cart = [];
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
        }
    }

    function applyVoucher(id, code, loai, giaTri, min) {
        currentVoucher = { id: id, code: code, loai: loai, giaTri: giaTri, min: min };
        voucherModal.hide();
        if(isUsingPoints) { calculateCustomPoints(); } else { renderCart(); }
    }

    function removeVoucher(skipRender = false) {
        currentVoucher = null;
        document.getElementById('input_maKM').value = '';
        let voucherLabel = document.getElementById('voucherLabel');
        if(voucherLabel) {
            voucherLabel.innerText = 'Không áp dụng';
            voucherLabel.className = 'text-muted';
        }
        if(voucherModal) voucherModal.hide();

        if(!skipRender) {
            if(isUsingPoints) { calculateCustomPoints(); } else { renderCart(); }
        }
    }

    function renderCart() {
        const container = document.getElementById('cart-items-container');
        container.innerHTML = '';

        if (cart.length === 0) {
            container.innerHTML = "<div class='text-center text-muted mt-5' id='empty-cart-msg'>" +
                "<i class='bi bi-cart-x text-secondary' style='font-size: 4rem;'></i>" +
                "<p class='mt-2 fw-medium'>Chưa chọn món nào</p></div>";
            document.getElementById('btn-checkout').disabled = true;

            removeVoucher(true);

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
                    return "<span class='badge bg-info text-dark me-1'>+" + t.name + " (x" + t.qty + ")</span>";
                }).join('');
            }

            let itemHtml = "<div class='p-3 border-bottom bg-white shadow-sm mb-1'>" +
                "<div class='d-flex justify-content-between align-items-start'>" +
                "<div class='flex-grow-1'><h6 class='mb-1 fw-bold text-dark'>" + item.ten + "</h6><div class='small text-secondary mb-1'>Đá: " + item.da + " | Đường: " + item.duong + "</div><div>" + tpStr + "</div></div>" +
                "<div class='text-end ms-2'><h6 class='mb-1 fw-bold text-danger'>" + formatCurrency(item.giaChot * item.soLuong) + "</h6><small class='text-muted'>" + formatCurrency(item.giaChot) + "/ly</small></div>" +
                "</div>" +
                "<div class='d-flex justify-content-between align-items-center mt-2'>" +
                "<div>" +
                "<a href='javascript:void(0)' class='text-primary small text-decoration-none me-3 fw-bold' onclick=\"editCartItem('" + item.cartId + "')\"><i class='bi bi-pencil-square'></i> Sửa</a>" +
                "<a href='javascript:void(0)' class='text-danger small text-decoration-none fw-bold' onclick=\"updateQty('" + item.cartId + "', -999)\"><i class='bi bi-trash'></i> Xóa</a>" +
                "</div>" +
                "<div class='btn-group btn-group-sm shadow-sm'>" +
                "<button type='button' class='btn btn-light border' onclick=\"updateQty('" + item.cartId + "', -1)\"><i class='bi bi-dash-lg'></i></button>" +
                "<span class='btn btn-light border fw-bold text-primary px-3' style='pointer-events: none;'>" + item.soLuong + "</span>" +
                "<button type='button' class='btn btn-light border' onclick=\"updateQty('" + item.cartId + "', 1)\"><i class='bi bi-plus-lg'></i></button>" +
                "</div></div></div>";
            container.insertAdjacentHTML('beforeend', itemHtml);
        });

        if (currentVoucher) {
            if (tongTienHang >= currentVoucher.min) {
                if (currentVoucher.loai === 'Phần Trăm') {
                    tienGiamGia = (tongTienHang * currentVoucher.giaTri) / 100;
                } else {
                    tienGiamGia = currentVoucher.giaTri;
                }
                if(tienGiamGia > tongTienHang) tienGiamGia = tongTienHang;

                document.getElementById('input_maKM').value = currentVoucher.id;
                document.getElementById('voucherLabel').innerText = currentVoucher.code;
                document.getElementById('voucherLabel').className = 'text-success fw-bold';
            } else {
                alert("Đơn hàng chưa đạt mức tối thiểu " + formatCurrency(currentVoucher.min) + " để áp mã " + currentVoucher.code + "!");
                removeVoucher(false);
            }
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