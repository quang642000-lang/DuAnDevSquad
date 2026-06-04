<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Phần Mềm Bán Hàng (POS)</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f4f6f9; overflow-x: hidden; }
        .product-card { cursor: pointer; transition: transform 0.2s, box-shadow 0.2s; }
        .product-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.1) !important; border-color: #0d6efd;}
        .product-img { height: 120px; object-fit: cover; width: 100%; border-top-left-radius: var(--bs-border-radius); border-top-right-radius: var(--bs-border-radius); }
        .cart-container { height: calc(100vh - 80px); position: sticky; top: 70px; display: flex; flex-direction: column;}
        .cart-items { flex-grow: 1; overflow-y: auto; }
        .navbar { box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        /* Tùy chỉnh thanh cuộn cho giỏ hàng */
        .cart-items::-webkit-scrollbar { width: 6px; }
        .cart-items::-webkit-scrollbar-thumb { background-color: #ccc; border-radius: 4px; }
    </style>
</head>
<body>

<!-- TOP NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold text-warning" href="#"><i class="bi bi-cup-straw"></i> TEA POS</a>

        <div class="d-flex align-items-center text-white">
            <span class="me-4"><i class="bi bi-person-circle"></i> Xin chào, <strong>${sessionScope.nhanVienDangNhap.hoTen}</strong></span>

            <!-- Nếu là Admin thì hiện nút quay về trang Quản Lý -->
            <c:if test="${sessionScope.nhanVienDangNhap.vaiTro.maVaiTro == 1}">
                <a href="${pageContext.request.contextPath}/nhan-vien" class="btn btn-sm btn-outline-light me-2">
                    <i class="bi bi-gear-fill"></i> Quản Lý
                </a>
            </c:if>

            <a href="${pageContext.request.contextPath}/auth?action=logout" class="btn btn-sm btn-danger">
                <i class="bi bi-box-arrow-right"></i> Đăng Xuất
            </a>
        </div>
    </div>
</nav>

<div class="container-fluid mt-3">

    <!-- Thông báo tạo đơn thành công/thất bại từ Server -->
    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
            <i class="bi bi-check-circle-fill"></i> ${sessionScope.message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="message" scope="session"/>
    </c:if>

    <div class="row">
        <!-- CỘT TRÁI: DANH SÁCH MENU MÓN -->
        <div class="col-lg-8 mb-4">

            <!-- Thanh Lọc Danh Mục (Nâng cao) -->
            <div class="d-flex mb-3 overflow-auto pb-2" style="white-space: nowrap;">
                <a href="${pageContext.request.contextPath}/ban-hang" class="btn btn-${empty param.maDanhMuc ? 'primary' : 'outline-primary'} rounded-pill me-2 fw-bold">
                    Tất cả
                </a>
                <c:forEach var="dm" items="${requestScope.danhSachDanhMuc}">
                    <a href="${pageContext.request.contextPath}/ban-hang?maDanhMuc=${dm.maDanhMuc}"
                       class="btn btn-${param.maDanhMuc == dm.maDanhMuc ? 'primary' : 'outline-primary'} rounded-pill me-2 fw-bold">
                            ${dm.tenDanhMuc}
                    </a>
                </c:forEach>
            </div>

            <!-- Grid Sản Phẩm (Hiển thị Biến thể - Từng Kích cỡ) -->
            <div class="row row-cols-2 row-cols-md-3 row-cols-xl-4 g-3">
                <c:choose>
                    <c:when test="${not empty requestScope.danhSachBienThe}">
                        <c:forEach var="bt" items="${requestScope.danhSachBienThe}">
                            <div class="col">
                                <!-- Gọi hàm addToCart(maBT, tenSP, size, gia) khi click -->
                                <div class="card h-100 shadow-sm product-card border-0"
                                     onclick="addToCart('${bt.maBienThe}', '${bt.sanPham.tenSP}', '${bt.kichCo}', ${bt.giaBan})">
                                    <img src="${pageContext.request.contextPath}/assets/img/${not empty bt.sanPham.hinhAnh ? bt.sanPham.hinhAnh : 'default.png'}"
                                         class="product-img"
                                         onerror="this.src='https://placehold.co/300x200?text=No+Image'" alt="${bt.sanPham.tenSP}">

                                    <div class="card-body p-2 text-center">
                                        <h6 class="card-title fw-bold mb-1 text-truncate" title="${bt.sanPham.tenSP}">${bt.sanPham.tenSP}</h6>
                                        <span class="badge bg-warning text-dark mb-2">Size ${bt.kichCo}</span>
                                        <h5 class="text-danger fw-bold mb-0">
                                            <fmt:formatNumber value="${bt.giaBan}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                        </h5>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="col-12 text-center py-5">
                            <i class="bi bi-inbox fs-1 text-muted"></i>
                            <h5 class="text-muted mt-2">Không có sản phẩm nào đang bán!</h5>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- CỘT PHẢI: HÓA ĐƠN & GIỎ HÀNG -->
        <div class="col-lg-4">
            <div class="card shadow-sm border-0 cart-container">
                <div class="card-header bg-white border-bottom border-2 border-primary py-3">
                    <h5 class="mb-0 fw-bold text-primary"><i class="bi bi-receipt"></i> CHI TIẾT ĐƠN HÀNG</h5>
                </div>

                <!-- Khu vực chứa các món đã chọn -->
                <div class="card-body p-0 cart-items bg-light" id="cart-items-container">
                    <!-- Javascript sẽ đổ HTML các món hàng vào đây -->
                    <div class="text-center text-muted mt-5" id="empty-cart-msg">
                        <i class="bi bi-cart-x fs-1"></i>
                        <p class="mt-2">Chưa có món nào được chọn</p>
                    </div>
                </div>

                <!-- Khu vực Thanh toán & Khách hàng -->
                <div class="card-footer bg-white border-top shadow-lg p-3">
                    <form action="${pageContext.request.contextPath}/ban-hang" method="post" id="checkout-form" onsubmit="return validateCheckout()">
                        <input type="hidden" name="action" value="checkout">

                        <!-- Vùng chứa Dữ liệu Giỏ hàng Ẩn (Sẽ được JS sinh ra khi bấm Thanh toán) -->
                        <div id="hidden-cart-inputs"></div>

                        <!-- Khách hàng -->
                        <div class="mb-3">
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-telephone"></i></span>
                                <input type="text" class="form-control" name="sdtKhachHang" id="sdtKhachHang" placeholder="Nhập SĐT Khách (Để trống nếu khách lẻ)">
                            </div>
                        </div>

                        <!-- Tính tiền -->
                        <div class="d-flex justify-content-between mb-2">
                            <span class="fw-bold text-muted">Tổng số lượng:</span>
                            <span class="fw-bold" id="total-qty">0</span>
                        </div>
                        <div class="d-flex justify-content-between mb-3 align-items-center">
                            <span class="fw-bold fs-5 text-dark">TỔNG TIỀN:</span>
                            <span class="fw-bold fs-4 text-danger" id="total-price">0 ₫</span>
                        </div>

                        <div class="row g-2">
                            <div class="col-6">
                                <button type="button" class="btn btn-outline-danger w-100 fw-bold" onclick="clearCart()">
                                    <i class="bi bi-trash"></i> Hủy Đơn
                                </button>
                            </div>
                            <div class="col-6">
                                <button type="submit" class="btn btn-success w-100 fw-bold fs-5 shadow-sm" id="btn-checkout" disabled>
                                    <i class="bi bi-cash-coin"></i> THANH TOÁN
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- SCRIPT XỬ LÝ GIỎ HÀNG BẰNG JAVASCRIPT -->
<script>
    // Mảng lưu trữ giỏ hàng: [{ maBT, ten, size, gia, soLuong }]
    let cart = [];

    // 1. Thêm món vào giỏ
    function addToCart(maBT, ten, size, gia) {
        // Kiểm tra xem món đó (cùng mã biến thể) đã có trong giỏ chưa
        let existingItem = cart.find(item => item.maBT === maBT);

        if (existingItem) {
            existingItem.soLuong++;
        } else {
            cart.push({ maBT: maBT, ten: ten, size: size, gia: gia, soLuong: 1 });
        }
        renderCart();
    }

    // 2. Tăng/Giảm số lượng
    function updateQty(maBT, change) {
        let itemIndex = cart.findIndex(item => item.maBT === maBT);
        if (itemIndex > -1) {
            cart[itemIndex].soLuong += change;
            if (cart[itemIndex].soLuong <= 0) {
                cart.splice(itemIndex, 1); // Xóa nếu số lượng = 0
            }
        }
        renderCart();
    }

    // 3. Xóa hoàn toàn 1 món
    function removeItem(maBT) {
        cart = cart.filter(item => item.maBT !== maBT);
        renderCart();
    }

    // 4. Hủy toàn bộ đơn
    function clearCart() {
        if(confirm("Bạn có chắc chắn muốn hủy đơn hàng này?")) {
            cart = [];
            document.getElementById('sdtKhachHang').value = '';
            renderCart();
        }
    }

    // 5. Cập nhật giao diện giỏ hàng
    function renderCart() {
        const cartContainer = document.getElementById('cart-items-container');
        const emptyMsg = document.getElementById('empty-cart-msg');
        const totalQtyEl = document.getElementById('total-qty');
        const totalPriceEl = document.getElementById('total-price');
        const btnCheckout = document.getElementById('btn-checkout');

        // Reset nội dung cũ
        cartContainer.innerHTML = '';
        let totalQty = 0;
        let totalPrice = 0;

        if (cart.length === 0) {
            cartContainer.appendChild(emptyMsg);
            emptyMsg.style.display = 'block';
            btnCheckout.disabled = true;
        } else {
            if(emptyMsg) emptyMsg.style.display = 'none';
            btnCheckout.disabled = false;

            // Render từng dòng sản phẩm
            cart.forEach(item => {
                totalQty += item.soLuong;
                let thanhTien = item.gia * item.soLuong;
                totalPrice += thanhTien;

                // Format tiền
                let formattedThanhTien = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(thanhTien);

                let itemHtml = `
                    <div class="d-flex justify-content-between align-items-center p-3 border-bottom bg-white">
                        <div class="flex-grow-1">
                            <h6 class="mb-1 fw-bold">` + item.ten + `</h6>
                            <small class="text-muted">Size ` + item.size + ` | ` + new Intl.NumberFormat('vi-VN').format(item.gia) + `đ</small>
                        </div>

                        <div class="d-flex align-items-center mx-3">
                            <button type="button" class="btn btn-sm btn-light border rounded-circle fw-bold text-danger" onclick="updateQty('`+item.maBT+`', -1)">-</button>
                            <span class="mx-2 fw-bold">`+item.soLuong+`</span>
                            <button type="button" class="btn btn-sm btn-light border rounded-circle fw-bold text-success" onclick="updateQty('`+item.maBT+`', 1)">+</button>
                        </div>

                        <div class="text-end">
                            <h6 class="mb-1 fw-bold text-danger">` + formattedThanhTien + `</h6>
                            <a href="#" class="text-muted small text-decoration-none" onclick="removeItem('`+item.maBT+`')"><i class="bi bi-trash"></i> Xóa</a>
                        </div>
                    </div>
                `;
                cartContainer.insertAdjacentHTML('beforeend', itemHtml);
            });
        }

        // Cập nhật tổng
        totalQtyEl.innerText = totalQty;
        totalPriceEl.innerText = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(totalPrice);
    }

    // 6. Xử lý trước khi Submit Hóa Đơn về Server
    function validateCheckout() {
        if (cart.length === 0) {
            alert("Vui lòng chọn ít nhất 1 sản phẩm để thanh toán!");
            return false;
        }

        const hiddenContainer = document.getElementById('hidden-cart-inputs');
        hiddenContainer.innerHTML = ''; // Xóa dữ liệu cũ (nếu có)

        // Tạo mảng dữ liệu ẩn để gửi về Server (mảng maBT[] và mảng soLuong[])
        cart.forEach(item => {
            let inputMaBT = document.createElement('input');
            inputMaBT.type = 'hidden';
            inputMaBT.name = 'maBT[]'; // Mảng mã biến thể
            inputMaBT.value = item.maBT;

            let inputSoLuong = document.createElement('input');
            inputSoLuong.type = 'hidden';
            inputSoLuong.name = 'soLuong[]'; // Mảng số lượng tương ứng
            inputSoLuong.value = item.soLuong;

            hiddenContainer.appendChild(inputMaBT);
            hiddenContainer.appendChild(inputSoLuong);
        });

        // Xác nhận lần cuối
        return confirm("Tạo hóa đơn thanh toán?");
    }
</script>

</body>
</html>