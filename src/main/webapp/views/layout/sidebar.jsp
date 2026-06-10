<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<!-- OVERLAY CHO MOBILE -->
<div class="sidebar-overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

<!-- SIDEBAR -->
<nav class="sidebar" id="sidebar">
    <div class="sidebar-header">
        <h4 class="mb-0 fw-bold" style="color: var(--brand-primary);"><i class="bi bi-cup-straw"></i> TEA POS</h4>
        <span class="small text-white-50 fw-medium" style="letter-spacing: 1px; font-size: 0.8rem;">QUẢN TRỊ HỆ THỐNG</span>
    </div>

    <div class="sidebar-menu" id="main-sidebar-menu">
        <div class="text-uppercase text-white-50 fw-bold small px-3 mb-2 mt-2" style="font-size: 0.7rem; letter-spacing: 1px;">Tổng Quan</div>
        <a href="${pageContext.request.contextPath}/admin" class="menu-item" data-path="/admin">
            <i class="bi bi-grid-1x2-fill"></i> Bảng Điều Khiển
        </a>
        <a href="${pageContext.request.contextPath}/ban-hang" class="menu-item text-warning" target="_blank">
            <i class="bi bi-display"></i> Mở Máy POS Bán Hàng
        </a>

        <div class="text-uppercase text-white-50 fw-bold small px-3 mb-2 mt-4" style="font-size: 0.7rem; letter-spacing: 1px;">Thực Đơn & Món</div>
        <a href="${pageContext.request.contextPath}/danh-muc" class="menu-item" data-path="/danh-muc">
            <i class="bi bi-collection-fill"></i> Quản Lý Danh Mục
        </a>
        <a href="${pageContext.request.contextPath}/san-pham" class="menu-item" data-path="/san-pham">
            <i class="bi bi-cup-hot-fill"></i> Quản Lý Sản Phẩm
        </a>
        <a href="${pageContext.request.contextPath}/bien-the" class="menu-item" data-path="/bien-the">
            <i class="bi bi-tags-fill"></i> Biến Thể & Kích Cỡ
        </a>
        <a href="${pageContext.request.contextPath}/topping" class="menu-item" data-path="/topping">
            <i class="bi bi-plus-square-fill"></i> Quản Lý Topping
        </a>

        <div class="text-uppercase text-white-50 fw-bold small px-3 mb-2 mt-4" style="font-size: 0.7rem; letter-spacing: 1px;">Marketing & CRM</div>
        <a href="${pageContext.request.contextPath}/khach-hang" class="menu-item" data-path="/khach-hang">
            <i class="bi bi-person-vcard-fill"></i> Thẻ Khách Hàng
        </a>
        <a href="${pageContext.request.contextPath}/khuyen-mai" class="menu-item" data-path="/khuyen-mai">
            <i class="bi bi-ticket-perforated-fill"></i> Mã Khuyến Mãi
        </a>
        <a href="${pageContext.request.contextPath}/phuong-thuc" class="menu-item" data-path="/phuong-thuc">
            <i class="bi bi-wallet-fill"></i> Cổng Thanh Toán
        </a>

        <div class="text-uppercase text-white-50 fw-bold small px-3 mb-2 mt-4" style="font-size: 0.7rem; letter-spacing: 1px;">Hệ Thống</div>
        <a href="${pageContext.request.contextPath}/nhan-vien" class="menu-item" data-path="/nhan-vien">
            <i class="bi bi-shield-lock-fill"></i> Tài Khoản Nhân Viên
        </a>
    </div>
</nav>

<script>
    // Tự động thêm class "active" vào menu dựa trên URL hiện tại
    document.addEventListener("DOMContentLoaded", function() {
        let currentPath = window.location.pathname;
        let menuItems = document.querySelectorAll("#main-sidebar-menu .menu-item[data-path]");

        menuItems.forEach(function(item) {
            let path = item.getAttribute("data-path");
            if (currentPath.includes(path)) {
                item.classList.add("active");
            }
        });
    });

    // Xử lý bật/tắt Sidebar trên Mobile
    function toggleSidebar() {
        document.getElementById('sidebar').classList.toggle('show');
        document.getElementById('sidebarOverlay').classList.toggle('show');
    }
</script>