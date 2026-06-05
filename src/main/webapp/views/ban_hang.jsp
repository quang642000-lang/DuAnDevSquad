<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
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
        .product-img { height: 120px; object-fit: cover; width: 100%; border-top-left-radius: var(--bs-border-radius); border-top-right-radius: var(--bs-border-radius); }
        .cart-container { height: calc(100vh - 75px); position: sticky; top: 70px; display: flex; flex-direction: column;}
        .cart-items { flex-grow: 1; overflow-y: auto; background-color: #fafbfe; }
        .cart-items::-webkit-scrollbar { width: 5px; }
        .cart-items::-webkit-scrollbar-thumb { background-color: #cbd5e1; border-radius: 5px; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold text-warning fs-4" href="#"><i class="bi bi-cup-straw"></i> TEA POS</a>
        <div class="d-flex align-items-center text-white">
            <span class="me-4"><i class="bi bi-person-badge-fill"></i> ${sessionScope.nhanVienDangNhap.hoTen}</span>
            <c:if test="${sessionScope.nhanVienDangNhap.vaiTro.maVaiTro == 1}">
                <a href="${pageContext.request.contextPath}/nhan-vien" class="btn btn-sm btn-outline-light me-3"><i class="bi bi-gear-fill"></i> Quản Lý</a>
            </c:if>
            <a href="${pageContext.request.contextPath}/auth?action=logout" class="btn btn-sm btn-danger"><i class="bi bi-power"></i> Đăng Xuất</a>
        </div>
    </div>
</nav>

<div class="container-fluid mt-3">
    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
            <i class="bi bi-check-circle-fill"></i> <strong class="fs-6">${sessionScope.message}</strong>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="message" scope="session"/>
    </c:if>

    <div class="row">
        <!-- CỘT TRÁI: DANH SÁCH MENU -->
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
                    <c:when test="${not empty requestScope.danhSachBienThe}">
                        <c:forEach var="bt" items="${requestScope.danhSachBienThe}">
                            <div class="col">
                                <div class="card h-100 shadow-sm product-card bg-white rounded-3"
                                     onclick="openOptionsModal('${bt.maBienThe}', '${bt.sanPham.tenSP}', '${bt.kichCo}', ${bt.giaBan})">
                                    <img src="${pageContext.request.contextPath}/assets/img/${not empty bt.sanPham.hinhAnh ? bt.sanPham.hinhAnh : 'default.png'}"
                                         class="product-img" onerror="this.src='https://placehold.co/300x200?text=No+Image'">

                                    <div class="card-body p-3 text-center">
                                        <h6 class="card-title fw-bold mb-2 text-truncate" title="${bt.sanPham.tenSP}">${bt.sanPham.tenSP}</h6>
                                        <span class="badge bg-warning text-dark mb-2 border border-warning">Size ${bt.kichCo}</span>
                                        <h5 class="text-danger fw-bold mb-0">
                                            <fmt:formatNumber value="${bt.giaBan}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                        </h5>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="col-12 text-center py-5"><h5 class="text-muted">Không có món nào!</h5></div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- CỘT PHẢI: GIỎ HÀNG & THANH TOÁN -->
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

                        <!-- KHÁCH HÀNG -->
                        <div class="row g-2 mb-2">
                            <div class="col-5">
                                <input type="text" class="form-control form-control-sm" name="sdtKhachHang" placeholder="SĐT Khách">
                            </div>
                            <div class="col-7">
                                <input type="text" class="form-control form-control-sm" name="tenKhachHang" placeholder="Tên (Nếu là Khách Mới)">
                            </div>
                        </div>

                        <!-- VOUCHER -->
                        <div class="input-group input-group-sm mb-2">
                            <button class="btn btn-outline-primary fw-bold" type="button" data-bs-toggle="modal" data-bs-target="#voucherModal"><i class="bi bi-list-stars"></i> Xem Mã</button>
                            <input type="text" class="form-control text-uppercase text-center" id="voucherCode" placeholder="Nhập mã voucher...">
                            <button class="btn btn-success fw-bold" type="button" onclick="applyVoucher()">Áp Dụng</button>
                        </div>

                        <!-- TỔNG KẾT -->
                        <div class="border rounded p-2 mb-2 bg-light text-end small">
                            <div class="d-flex justify-content-between">
                                <span class="text-muted fw-bold">Tổng tiền hàng:</span>
                                <span class="fw-bold text-dark" id="display_tongTienHang">0 ₫</span>
                            </div>
                            <div class="d-flex justify-content-between text-success">
                                <span class="fw-bold">Khuyến mãi:</span>
                                <span class="fw-bold" id="display_tienGiamGia">- 0 ₫</span>
                            </div>
                            <hr class="my-1">
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="fw-bold fs-6 text-dark">PHẢI THANH TOÁN:</span>
                                <span class="fw-bold fs-4 text-danger" id="display_tongPhaiTra">0 ₫</span>
                            </div>
                        </div>

                        <!-- THANH TOÁN -->
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
                                    <span class="input-group-text bg-white fw-bold">Khách đưa</span>
                                    <input type="number" class="form-control text-end fw-bold text-primary" name="tienKhachDua" id="tienKhachDua" required oninput="calculateChange()">
                                </div>
                            </div>
                            <div class="col-12 text-end small" id="tienThuaContainer" style="display: none;">
                                <span class="fw-bold text-muted">Tiền thừa trả khách:</span>
                                <span class="fw-bold text-success fs-6" id="tienThuaLabel">0 ₫</span>
                            </div>
                        </div>

                        <div class="row g-2">
                            <div class="col-4">
                                <button type="button" class="btn btn-outline-danger w-100 fw-bold py-2" onclick="clearCart()"><i class="bi bi-trash"></i> Hủy</button>
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

<div class="modal fade" id="optionModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg">
            <div class="modal-header bg-primary text-white border-0">
                <h5 class="modal-title fw-bold" id="modalProductName">Tên Sản Phẩm</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body bg-light">
                <input type="hidden" id="modalMaBT">
                <input type="hidden" id="modalSize">
                <input type="hidden" id="modalGiaBan">

                <div class="row mb-3">
                    <div class="col-6">
                        <label class="fw-bold small text-muted mb-2">MỨC ĐÁ</label>
                        <select class="form-select form-select-sm" id="modalDa">
                            <option value="100%">100% Đá</option>
                            <option value="50%">50% Đá</option>
                            <option value="0%">Không đá</option>
                        </select>
                    </div>
                    <div class="col-6">
                        <label class="fw-bold small text-muted mb-2">MỨC ĐƯỜNG</label>
                        <select class="form-select form-select-sm" id="modalDuong">
                            <option value="100%">100% Đường</option>
                            <option value="50%">50% Đường</option>
                            <option value="0%">Không đường</option>
                        </select>
                    </div>
                </div>

                <label class="fw-bold small text-muted mb-2">THÊM TOPPING</label>
                <!-- ĐÃ SỬA: Nút chọn số lượng Topping thay vì Checkbox -->
                <div class="d-flex flex-column gap-2 max-height-200 overflow-auto px-1">
                    <c:forEach var="tp" items="${requestScope.danhSachTopping}">
                        <c:if test="${tp.trangThai == 1}">
                            <div class="d-flex justify-content-between align-items-center bg-white p-2 border rounded shadow-sm">
                                <div>
                                    <span class="fw-bold d-block">${tp.tenTopping}</span>
                                    <span class="text-danger small">+<fmt:formatNumber value="${tp.giaBan}" type="number"/>đ</span>
                                </div>
                                <div class="input-group input-group-sm" style="width: 100px;">
                                    <button class="btn btn-outline-secondary fw-bold" type="button" onclick="changeToppingQty('${tp.maTopping}', -1)">-</button>
                                    <input type="text" class="form-control text-center fw-bold topping-qty-input"
                                           id="qty_tp_${tp.maTopping}" data-id="${tp.maTopping}" data-name="${tp.tenTopping}" data-price="${tp.giaBan}" value="0" readonly>
                                    <button class="btn btn-outline-secondary fw-bold" type="button" onclick="changeToppingQty('${tp.maTopping}', 1)">+</button>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
            </div>
            <div class="modal-footer border-0 p-3 bg-white">
                <button type="button" class="btn btn-primary w-100 fw-bold fs-5 shadow-sm" onclick="confirmAddToCart()">
                    <i class="bi bi-cart-plus"></i> XONG & THÊM VÀO ĐƠN
                </button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="voucherModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title fw-bold"><i class="bi bi-ticket-perforated"></i> Danh Sách Khuyến Mãi</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-2">
                <ul class="list-group">
                    <c:forEach var="km" items="${requestScope.danhSachKhuyenMai}">
                        <c:if test="${km.trangThai == 1 && (km.soLuong - km.soLuongDaDung > 0)}">
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="mb-0 fw-bold text-danger">${km.maCode}</h6>
                                    <small class="text-muted">${km.tenKM} (Đơn Min: <fmt:formatNumber value="${km.dieuKienToiThieu}" type="number"/>đ)</small>
                                </div>
                                <button class="btn btn-sm btn-outline-success fw-bold" onclick="selectVoucher('${km.maCode}')">Chọn</button>
                            </li>
                        </c:if>
                    </c:forEach>
                </ul>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    const danhSachVoucher = [
        <c:forEach var="km" items="${requestScope.danhSachKhuyenMai}">
        <c:if test="${km.trangThai == 1 && (km.soLuong - km.soLuongDaDung > 0)}">
        { code: '${km.maCode}', loai: '${km.loaiGiamGia}', giaTri: ${km.giaTrịGiam}, min: ${km.dieuKienToiThieu}, id: '${km.maKM}' },
        </c:if>
        </c:forEach>
    ];
</script>

<script>
    let cart = [];
    const formatCurrency = (number) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(number);

    const optionModal = new bootstrap.Modal(document.getElementById('optionModal'));
    const voucherModal = new bootstrap.Modal(document.getElementById('voucherModal'));

    function openOptionsModal(maBT, ten, size, gia) {
        document.getElementById('modalMaBT').value = maBT;
        document.getElementById('modalProductName').innerText = ten + " (Size " + size + ")";
        document.getElementById('modalSize').value = size;
        document.getElementById('modalGiaBan').value = gia;

        // Reset Modal Options
        document.getElementById('modalDa').value = '100%';
        document.getElementById('modalDuong').value = '100%';
        document.querySelectorAll('.topping-qty-input').forEach(input => input.value = '0');

        optionModal.show();
    }

    // Nút cộng/trừ Topping trong Modal
    function changeToppingQty(id, change) {
        let input = document.getElementById('qty_tp_' + id);
        let currentQty = parseInt(input.value);
        let newQty = currentQty + change;
        if (newQty >= 0 && newQty <= 10) { // Giới hạn max 10 phần mỗi loại
            input.value = newQty;
        }
    }

    function confirmAddToCart() {
        let maBT = document.getElementById('modalMaBT').value;
        let ten = document.getElementById('modalProductName').innerText;
        let gia = parseInt(document.getElementById('modalGiaBan').value);
        let da = document.getElementById('modalDa').value;
        let duong = document.getElementById('modalDuong').value;

        let toppings = [];
        let extraToppingPrice = 0;

        // Lấy tất cả topping có số lượng > 0
        document.querySelectorAll('.topping-qty-input').forEach(input => {
            let qty = parseInt(input.value);
            if (qty > 0) {
                let price = parseInt(input.getAttribute('data-price'));
                toppings.push({
                    id: input.getAttribute('data-id'),
                    name: input.getAttribute('data-name'),
                    price: price,
                    qty: qty
                });
                extraToppingPrice += (price * qty);
            }
        });

        // Ghép chuỗi ID giỏ hàng để gom nhóm các ly y chang nhau
        let cartId = maBT + "_" + da + "_" + duong + "_" + toppings.map(t => t.id + "x" + t.qty).join('-');

        let existingItem = cart.find(item => item.cartId === cartId);
        if (existingItem) {
            existingItem.soLuong++;
        } else {
            cart.push({ cartId, maBT, ten, giaChot: gia + extraToppingPrice, soLuong: 1, da, duong, toppings });
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
        renderCart();
    }

    function clearCart() {
        if(confirm("Hủy đơn hàng này?")) {
            cart = [];
            document.getElementById('voucherCode').value = '';
            document.getElementById('input_maKM').value = '';
            document.getElementById('tienKhachDua').value = '';
            document.getElementsByName('sdtKhachHang')[0].value = '';
            document.getElementsByName('tenKhachHang')[0].value = '';
            renderCart();
        }
    }

    // Xử lý Khuyến Mãi
    let currentDiscount = 0;

    function selectVoucher(code) {
        document.getElementById('voucherCode').value = code;
        voucherModal.hide();
        applyVoucher();
    }

    function applyVoucher() {
        let code = document.getElementById('voucherCode').value.toUpperCase();
        if(!code) {
            currentDiscount = 0; document.getElementById('input_maKM').value = ''; renderCart(); return;
        }

        let tongTienHienTai = cart.reduce((sum, item) => sum + (item.giaChot * item.soLuong), 0);
        let voucher = danhSachVoucher.find(v => v.code === code);

        if (!voucher) { alert("Mã giảm giá không tồn tại hoặc đã hết!"); return; }
        if (tongTienHienTai < voucher.min) { alert("Đơn chưa đạt mức tối thiểu " + formatCurrency(voucher.min) + "!"); return; }

        if (voucher.loai === 'Phần Trăm') {
            currentDiscount = (tongTienHienTai * voucher.giaTri) / 100;
        } else {
            currentDiscount = voucher.giaTri;
            if(currentDiscount > tongTienHienTai) currentDiscount = tongTienHienTai; // Không thối tiền km
        }

        document.getElementById('input_maKM').value = voucher.id;
        renderCart(); // Cập nhật lại UI tiền
    }

    function renderCart() {
        const container = document.getElementById('cart-items-container');
        const emptyMsg = document.getElementById('empty-cart-msg');
        container.innerHTML = '';

        let tongTienHang = 0;

        if (cart.length === 0) {
            container.appendChild(emptyMsg);
            emptyMsg.style.display = 'block';
            document.getElementById('btn-checkout').disabled = true;
            currentDiscount = 0;
            document.getElementById('input_maKM').value = '';
        } else {
            emptyMsg.style.display = 'none';
            document.getElementById('btn-checkout').disabled = false;

            cart.forEach(item => {
                tongTienHang += item.giaChot * item.soLuong;

                // Nối tên topping kèm số lượng
                let tpStr = item.toppings.map(t => `<span class='badge bg-info text-dark me-1'>+`+t.name+` (x`+t.qty+`)</span>`).join('');
                let itemHtml = `
                    <div class="p-3 border-bottom bg-white shadow-sm mb-1">
                        <div class="d-flex justify-content-between align-items-start">
                            <div class="flex-grow-1">
                                <h6 class="mb-1 fw-bold text-dark">` + item.ten + `</h6>
                                <div class="small text-secondary mb-1">Đá: `+item.da+` | Đường: `+item.duong+`</div>
                                <div>` + tpStr + `</div>
                            </div>
                            <div class="text-end ms-2">
                                <h6 class="mb-1 fw-bold text-danger">` + formatCurrency(item.giaChot * item.soLuong) + `</h6>
                                <small class="text-muted">`+formatCurrency(item.giaChot)+`/ly</small>
                            </div>
                        </div>
                        <div class="d-flex justify-content-between align-items-center mt-2">
                            <a href="javascript:void(0)" class="text-danger small text-decoration-none" onclick="updateQty('`+item.cartId+`', -999)"><i class="bi bi-trash"></i> Xóa</a>
                            <div class="btn-group btn-group-sm shadow-sm">
                                <button type="button" class="btn btn-light border fw-bold" onclick="updateQty('`+item.cartId+`', -1)">-</button>
                                <span class="btn btn-light border fw-bold text-primary px-3" style="pointer-events: none;">`+item.soLuong+`</span>
                                <button type="button" class="btn btn-light border fw-bold" onclick="updateQty('`+item.cartId+`', 1)">+</button>
                            </div>
                        </div>
                    </div>`;
                container.insertAdjacentHTML('beforeend', itemHtml);
            });
        }

        // Tự động gỡ voucher nếu đơn rớt xuống dưới mức tối thiểu
        let code = document.getElementById('voucherCode').value.toUpperCase();
        if (code) {
            let voucher = danhSachVoucher.find(v => v.code === code);
            if (voucher && tongTienHang < voucher.min) {
                currentDiscount = 0;
                document.getElementById('voucherCode').value = '';
                document.getElementById('input_maKM').value = '';
                alert("Đơn hàng không còn đủ điều kiện áp dụng mã giảm giá!");
            }
        }

        let tongPhaiTra = tongTienHang - currentDiscount;

        document.getElementById('display_tongTienHang').innerText = formatCurrency(tongTienHang);
        document.getElementById('display_tienGiamGia').innerText = "- " + formatCurrency(currentDiscount);
        document.getElementById('display_tongPhaiTra').innerText = formatCurrency(tongPhaiTra);

        document.getElementById('input_tongTienHang').value = tongTienHang;
        document.getElementById('input_tienGiamGia').value = currentDiscount;
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

    function validateCheckout() {
        let khachDua = parseInt(document.getElementById('tienKhachDua').value);
        let phaiTra = parseInt(document.getElementById('input_tongPhaiTra').value);
        if (!khachDua || khachDua < phaiTra) {
            alert("Số tiền khách đưa không đủ!");
            document.getElementById('tienKhachDua').focus();
            return false;
        }

        const h = document.getElementById('hidden-cart-inputs');
        h.innerHTML = '';

        cart.forEach((item, idx) => {
            h.innerHTML += `<input type="hidden" name="itemIndex[]" value="`+idx+`">`;
            h.innerHTML += `<input type="hidden" name="maBT_`+idx+`" value="`+item.maBT+`">`;
            h.innerHTML += `<input type="hidden" name="soLuong_`+idx+`" value="`+item.soLuong+`">`;
            h.innerHTML += `<input type="hidden" name="giaChot_`+idx+`" value="`+item.giaChot+`">`;
            h.innerHTML += `<input type="hidden" name="da_`+idx+`" value="`+item.da+`">`;
            h.innerHTML += `<input type="hidden" name="duong_`+idx+`" value="`+item.duong+`">`;

            // Format gửi về: maTopping|giaBan|soLuongCuaTopping
            item.toppings.forEach(tp => {
                h.innerHTML += `<input type="hidden" name="toppings_`+idx+`[]" value="`+tp.id+`|`+tp.price+`|`+tp.qty+`">`;
            });
        });

        return confirm("Hoàn tất thanh toán đơn hàng này?");
    }
</script>

</body>
</html>