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

        /* CSS cho thiết kế hóa đơn máy in nhiệt chuẩn Highlands */
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
        @media print {
            body * { visibility: hidden; }
            #receiptModal .modal-body, #receiptModal .modal-body * { visibility: visible; }
            #receiptModal .modal-body { position: absolute; left: 0; top: 0; width: 100%; margin: 0; padding: 0; }
        }
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
                                        <img src="${pageContext.request.contextPath}/assets/img/${not empty sp.hinhAnh ? sp.hinhAnh : 'default.png'}"
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
                        <div class="col-12 text-center py-5"><h5 class="text-muted">Không có sản phẩm nào thuộc danh mục này!</h5></div>
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
                    <form action="${pageContext.request.contextPath}/ban-hang" method="post" id="checkout-form" onsubmit="return validateCheckout()">
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
                            <i class="bi bi-info-circle"></i> Khách mới. Hệ thống tự tạo thẻ thành viên sau thanh toán!
                        </div>

                        <div class="d-flex justify-content-between align-items-center mb-2 bg-light p-2 rounded border">
                            <span class="fw-bold small text-muted"><i class="bi bi-ticket-perforated"></i> Mã KM: <span id="voucherLabel" class="text-muted fw-normal">Trống</span></span>
                            <button type="button" class="btn btn-sm btn-outline-success fw-bold" data-bs-toggle="modal" data-bs-target="#voucherModal">
                                Chọn Mã
                            </button>
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
                                <select class="form-select form-select-sm fw-bold border-secondary" name="maPTTT" required>
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
                                <button type="button" class="btn btn-outline-danger w-100 fw-bold py-2" onclick="clearCart()">
                                    Hủy Đơn
                                </button>
                            </div>
                            <div class="col-8">
                                <button type="submit" class="btn btn-primary w-100 fw-bold fs-5 shadow-sm py-2" id="btn-checkout" disabled>
                                    THANH TOÁN (XUẤT BILL)
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="optionModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg">
            <div class="modal-header bg-primary text-white border-0">
                <h5 class="modal-title fw-bold" id="modalProductName">Tên Sản Phẩm</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
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

                <label class="fw-bold small text-muted mb-2">4. CHỌN THÊM TOPPING VÀO MÓN</label>
                <div class="max-height-200 overflow-auto bg-white border rounded p-2">
                    <c:forEach var="tp" items="${requestScope.danhSachTopping}">
                        <c:if test="${tp.trangThai == 1}">
                            <div class="d-flex justify-content-between align-items-center mb-2 pb-2 border-bottom">
                                <div>
                                    <span class="fw-bold">${tp.tenTopping}</span><br>
                                    <small class="text-danger">+<fmt:formatNumber value="${tp.giaBan}" type="number"/>đ</small>
                                </div>
                                <div class="input-group input-group-sm w-auto">
                                    <button class="btn btn-outline-secondary" type="button" onclick="changeModalTpQty('${tp.maTopping}', -1)">-</button>
                                    <input type="text" class="form-control text-center fw-bold" style="max-width: 40px;"
                                           id="tp_qty_${tp.maTopping}" value="0" readonly
                                           data-id="${tp.maTopping}" data-name="${tp.tenTopping}" data-price="${tp.giaBan}">
                                    <button class="btn btn-outline-secondary" type="button" onclick="changeModalTpQty('${tp.maTopping}', 1)">+</button>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
            </div>
            <div class="modal-footer border-0 p-3 bg-white">
                <button type="button" class="btn btn-primary w-100 fw-bold fs-5 shadow-sm" onclick="confirmAddToCart()">
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
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
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
                <div class="modal-body thermal-receipt">
                    <div class="text-center mb-3">
                        <h4 class="fw-bold mb-0 text-uppercase">TEA POS RECEIPT</h4>
                        <div class="small-text fw-semibold">ĐC: FPT Polytechnic - Bình Dương</div>
                        <div class="small-text">SĐT Hệ Thống: 0988.888.888</div>
                        <hr>
                        <h5 class="fw-bold mt-2">HÓA ĐƠN THANH TOÁN</h5>
                    </div>

                    <div class="small-text mb-2">
                        <div><span class="fw-bold">Mã phiếu:</span> ${sessionScope.recentOrder.maDH}</div>
                        <div><span class="fw-bold">Thời gian nhập:</span> <fmt:formatDate value="${sessionScope.recentOrder.thoiGianTao}" pattern="dd/MM/yyyy HH:mm:ss"/></div>
                        <div><span class="fw-bold">Thu ngân:</span> ${sessionScope.nhanVienDangNhap.hoTen}</div>
                        <c:if test="${not empty sessionScope.recentOrder.khachHang}">
                            <div><span class="fw-bold">Khách hàng:</span> ${sessionScope.recentOrder.khachHang.tenKH} (${sessionScope.recentOrder.khachHang.SDT})</div>
                        </c:if>
                    </div>
                    <hr>

                    <div class="small-text">
                        <table class="mb-2">
                            <c:forEach var="ct" items="${sessionScope.recentOrder.danhSachChiTiet}">
                                <tr>
                                    <td colspan="2" class="fw-bold">${ct.soLuong}x ${ct.bienThe.sanPham.tenSanPham}</td>
                                </tr>
                                <tr>
                                    <td colspan="2" class="ps-2 text-muted" style="font-size:0.75rem;">- Tùy biến: ${ct.mucDa} Đá | ${ct.mucDuong} Đường</td>
                                </tr>
                                <c:forEach var="tpItem" items="${ct.danhSachTopping}">
                                    <tr>
                                        <td class="ps-3 text-muted" style="font-size:0.75rem;">+ ${tpItem.soLuongTopping}x Topping: ${tpItem.topping.tenTopping}</td>
                                        <td></td>
                                    </tr>
                                </c:forEach>
                                <tr>
                                    <td></td>
                                    <td class="text-end fw-semibold">
                                        <fmt:formatNumber value="${ct.giaChot * ct.soLuong}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                    </td>
                                </tr>
                            </c:forEach>
                        </table>
                    </div>
                    <hr>

                    <div class="small-text">
                        <div class="d-flex justify-content-between mb-1">
                            <span>Tổng tiền hàng:</span>
                            <span><fmt:formatNumber value="${sessionScope.recentOrder.tongTienHang}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
                        </div>

                        <c:if test="${sessionScope.recentOrder.tienGiamGia > 0}">
                            <div class="d-flex justify-content-between mb-1 text-danger">
                                <span>Giảm Voucher:</span>
                                <c:set var="giamVoucherBill" value="${sessionScope.recentOrder.tienGiamGia - (not empty sessionScope.diemSuDungBill ? sessionScope.diemSuDungBill * 1000 : 0)}"/>
                                <span>-<fmt:formatNumber value="${giamVoucherBill > 0 ? giamVoucherBill : 0}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
                            </div>
                        </c:if>

                        <c:if test="${not empty sessionScope.diemSuDungBill && sessionScope.diemSuDungBill > 0}">
                            <div class="d-flex justify-content-between mb-1 text-danger">
                                <span>Khấu trừ điểm (${sessionScope.diemSuDungBill}đ):</span>
                                <span>-<fmt:formatNumber value="${sessionScope.diemSuDungBill * 1000}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
                            </div>
                        </c:if>

                        <hr>
                        <div class="d-flex justify-content-between fw-bold fs-6 mt-2">
                            <span>TỔNG TIỀN PHẢI TRẢ:</span>
                            <span><fmt:formatNumber value="${sessionScope.recentOrder.tongTienTra}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
                        </div>

                        <div class="d-flex justify-content-between mb-1 mt-2">
                            <span>Tiền nhận của khách:</span>
                            <span><fmt:formatNumber value="${sessionScope.recentOrder.soTienKhachDua}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
                        </div>
                        <div class="d-flex justify-content-between mb-1">
                            <span>Tiền thối lại chuẩn:</span>
                            <span><fmt:formatNumber value="${sessionScope.recentOrder.soTienKhachDua - sessionScope.recentOrder.tongTienTra}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
                        </div>
                    </div>

                    <hr>
                    <div class="text-center small-text mt-3">
                        <p class="fw-bold mb-0">CẢM ƠN QUÝ KHÁCH & HẸN GẶP LẠI!</p>
                        <p class="text-muted" style="font-size: 0.7rem;">Hệ thống phần mềm hỗ trợ TEA POS</p>
                    </div>

                    <div class="mt-4 d-print-none text-center">
                        <button type="button" class="btn btn-outline-secondary btn-sm fw-bold me-2" data-bs-dismiss="modal">Đóng cửa sổ</button>
                        <button type="button" class="btn btn-primary btn-sm fw-bold" onclick="window.print()"><i class="bi bi-printer"></i> Ra Lệnh In</button>
                    </div>
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
    // Tải mảng biến thể sản phẩm chuẩn từ DOM ẩn
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

    let optionModalElement = document.getElementById('optionModal');
    let optionModal = optionModalElement ? new bootstrap.Modal(optionModalElement) : null;

    let voucherModalElement = document.getElementById('voucherModal');
    let voucherModal = voucherModalElement ? new bootstrap.Modal(voucherModalElement) : null;

    let currentVoucher = null;
    let currentProductVariants = [];
    let customerPoints = 0;
    let isUsingPoints = false;
    let customPointsToUse = 0;

    const appBasePath = document.getElementById('appContextPath').value;

    // Lắng nghe sự kiện tải trang để hiển thị bill ngầm nếu có hóa đơn mới
    window.onload = function() {
        let receiptElement = document.getElementById('receiptModal');
        if(receiptElement) {
            let myModal = new bootstrap.Modal(receiptElement);
            myModal.show();
            // Gọi lệnh ngầm giải phóng hóa đơn cũ để chống trùng lặp bill khi F5
            fetch(appBasePath + '/ban-hang?action=clear-bill').catch(e => console.log(e));
        }
    };

    // 1. GỌI AJAX TRA CỨU KHÁCH HÀNG THÂN THIẾT THEO SĐT
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
                })
                .catch(err => console.error(err));
        } else {
            tenInput.readOnly = false;
            infoPanel.style.display = 'none';
            newPanel.style.display = 'none';
            renderCart();
        }
    }

    // 2. BẬT TẮT CHỨC NĂNG DÙNG ĐIỂM TÍCH LŨY
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

    // Bộ lọc tính số điểm tối đa được phép tiêu thụ cho hóa đơn hiện tại
    function getMaxAllowedPoints() {
        let tongHang = 0;
        cart.forEach(item => { tongHang += item.giaChot * item.soLuong; });

        let giamVoucher = 0;
        if (currentVoucher && tongHang >= currentVoucher.min) {
            if (currentVoucher.loai === 'Phần Trăm') giamVoucher = (tongHang * currentVoucher.giaTri) / 100;
            else giamVoucher = currentVoucher.giaTri;
            if(giamVoucher > tongHang) giamVoucher = tongHang;
        }

        let tienSauVoucher = tongHang - giamVoucher;
        let maxPointsForBill = Math.floor(tienSauVoucher / 1000);
        return (customerPoints > maxPointsForBill) ? maxPointsForBill : customerPoints;
    }

    // Kiểm tra tính hợp lệ khi người dùng gõ số điểm bằng tay
    function calculateCustomPoints() {
        let inputVal = parseInt(document.getElementById('input_nhapDiemTay').value) || 0;
        let maxAllowed = getMaxAllowedPoints();

        if (inputVal > maxAllowed) {
            inputVal = maxAllowed;
            document.getElementById('input_nhapDiemTay').value = maxAllowed;
        } else if (inputVal < 0) {
            inputVal = 0;
            document.getElementById('input_nhapDiemTay').value = 0;
        }
        customPointsToUse = inputVal;
        renderCart();
    }

    // Nút tắt gán số điểm tối đa nhanh
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

    // 3. MỞ HỘP THOẠI CHỌN SIZE VÀ CẤU HÌNH LY NƯỚC
    function openOptionsModal(maSP, tenSP) {
        let decodedTenSP = tenSP.replace(/&amp;/g, '&').replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#034;/g, '"').replace(/&#039;/g, "'");
        document.getElementById('modalProductName').innerText = decodedTenSP;

        currentProductVariants = allVariants.filter(v => v.maSP === maSP);

        if (currentProductVariants.length === 0) {
            alert("Sản phẩm này hiện chưa được cấu hình kích cỡ (Size) nào! Vui lòng kiểm tra lại dữ liệu bên trang cấu hình.");
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

    // 4. XÁC NHẬN GOM DỮ LIỆU ĐỂ ĐẨY VÀO GIỎ HÀNG ẢO
    function confirmAddToCart() {
        let selectedSizeRadio = document.querySelector('input[name="modalSizeRadio"]:checked');
        if (!selectedSizeRadio) { alert("Vui lòng chọn Size món nước!"); return; }

        let maBT = selectedSizeRadio.value;
        let selectedVariant = currentProductVariants.find(v => v.maBT === maBT);

        let ten = document.getElementById('modalProductName').innerText + " (Size " + selectedVariant.size + ")";
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

        let existingItem = cart.find(item => item.cartId === cartId);
        if (existingItem) {
            existingItem.soLuong++;
        } else {
            cart.push({ cartId: cartId, maBT: maBT, ten: ten, giaChot: gia + extraToppingPrice, soLuong: 1, da: da, duong: duong, toppings: toppings });
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
            removeVoucher();
            document.getElementById('tienKhachDua').value = '';
            document.getElementById('sdtKhachHang').value = '';
            document.getElementById('tenKhachHang').value = '';
            checkCustomerPhone();
            renderCart();
        }
    }

    function applyVoucher(id, code, loai, giaTri, min) {
        currentVoucher = { id: id, code: code, loai: loai, giaTri: giaTri, min: min };
        voucherModal.hide();
        if(isUsingPoints) { calculateCustomPoints(); } else { renderCart(); }
    }

    function removeVoucher() {
        currentVoucher = null;
        document.getElementById('input_maKM').value = '';
        document.getElementById('voucherLabel').innerText = 'Không áp dụng';
        document.getElementById('voucherLabel').className = 'text-muted';
        if(voucherModal) voucherModal.hide();
        if(isUsingPoints) { calculateCustomPoints(); } else { renderCart(); }
    }

    // 5. XỬ LÝ VẼ GIỎ HÀNG LÊN MÀN HÌNH POS VÀ TÍNH TOÁN TÀI CHÍNH
    function renderCart() {
        const container = document.getElementById('cart-items-container');
        container.innerHTML = '';

        let tongTienHang = 0;
        let tienGiamGia = 0;
        let tienGiamDiem = 0;
        let diemThucTeSuDung = 0;

        if (cart.length === 0) {
            container.innerHTML = "<div class='text-center text-muted mt-5' id='empty-cart-msg'>" +
                "<i class='bi bi-cart-x text-secondary' style='font-size: 4rem;'></i>" +
                "<p class='mt-2 fw-medium'>Chưa chọn món nào</p></div>";
            document.getElementById('btn-checkout').disabled = true;
            removeVoucher();
        } else {
            document.getElementById('btn-checkout').disabled = false;

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
                    "<a href='javascript:void(0)' class='text-danger small text-decoration-none' onclick=\"updateQty('" + item.cartId + "', -999)\"><i class='bi bi-trash'></i> Xóa</a>" +
                    "<div class='btn-group btn-group-sm shadow-sm'>" +
                    "<button type='button' class='btn btn-light border' onclick=\"updateQty('" + item.cartId + "', -1)\"><i class='bi bi-dash-lg'></i></button>" +
                    "<span class='btn btn-light border fw-bold text-primary px-3' style='pointer-events: none;'>" + item.soLuong + "</span>" +
                    "<button type='button' class='btn btn-light border' onclick=\"updateQty('" + item.cartId + "', 1)\"><i class='bi bi-plus-lg'></i></button>" +
                    "</div></div></div>";
                container.insertAdjacentHTML('beforeend', itemHtml);
            });
        }

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
                removeVoucher();
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

        calculateChange();
    }

    function calculateChange() {
        let khachDua = parseInt(document.getElementById('tienKhachDua').value) || 0;
        let phaiTra = parseInt(document.getElementById('input_tongPhaiTra').value) || 0;
        let tienThua = khachDua - phaiTra;

        let container = document.getElementById('tienThuaContainer');
        if (khachDua > 0) {
            container.style.display = 'block';
            let label = document.getElementById('tienThuaLabel');
            if (tienThua < 0) {
                label.innerText = "Khách đưa chưa đủ tiền!";
                label.className = "fw-bold fs-6 text-danger";
            } else {
                label.innerText = formatCurrency(tienThua);
                label.className = "fw-bold fs-5 text-success";
            }
        } else {
            container.style.display = 'none';
        }
    }

    // 6. ĐÓNG GÓI VÀ KIỂM TRA TOÀN BỘ GIỎ HÀNG TRƯỚC KHI SUBMIT VỀ SERVLET
    function validateCheckout() {
        let khachDua = parseInt(document.getElementById('tienKhachDua').value);
        let phaiTra = parseInt(document.getElementById('input_tongPhaiTra').value);
        if (!khachDua || khachDua < phaiTra) {
            alert("Số tiền khách đưa chưa đủ để thực hiện giao dịch thanh toán!");
            document.getElementById('tienKhachDua').focus();
            return false;
        }

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
                // Định dạng đóng gói chuỗi Topping: ID | QTY | PRICE | NAME chuẩn
                inputs += "<input type='hidden' name='toppings_" + idx + "[]' value='" + tp.id + "|" + tp.qty + "|" + tp.price + "|" + tp.name + "'>";
            });
            h.insertAdjacentHTML('beforeend', inputs);
        });
        return confirm("Hệ thống chuẩn bị xuất hóa đơn in nhiệt. Xác nhận hoàn tất thanh toán?");
    }
</script>

</body>
</html>