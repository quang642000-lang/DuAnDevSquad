<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!-- Overlay làm tối màn hình khi mở menu trên điện thoại -->
<div class="sidebar-overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

<nav class="sidebar" id="sidebar">
    <div class="sidebar-header d-flex align-items-center justify-content-center">
        <a href="${pageContext.request.contextPath}/admin" class="text-decoration-none">
            <h4 class="mb-0 fw-bold d-flex align-items-center" style="color: var(--brand-primary); letter-spacing: 1px;">
                <i class="bi bi-cup-straw fs-3 me-2"></i> TEA POS
            </h4>
        </a>
    </div>

    <div class="sidebar-menu" id="main-sidebar-menu">
        <div class="text-uppercase text-white-50 fw-bold small px-3 mb-2 mt-2" style="font-size: 0.7rem; letter-spacing: 1px;">Tổng Quan</div>
        <a href="${pageContext.request.contextPath}/admin" class="menu-item"><i class="bi bi-grid-1x2-fill"></i> <span>Bảng Điều Khiển</span></a>
        <a href="${pageContext.request.contextPath}/ban-hang" class="menu-item text-warning" target="_blank"><i class="bi bi-display"></i> <span>Mở Máy POS</span></a>

        <div class="text-uppercase text-white-50 fw-bold small px-3 mb-2 mt-4" style="font-size: 0.7rem; letter-spacing: 1px;">Thực Đơn & Món</div>
        <a href="${pageContext.request.contextPath}/danh-muc" class="menu-item"><i class="bi bi-collection-fill"></i> <span>Quản Lý Danh Mục</span></a>
        <a href="${pageContext.request.contextPath}/san-pham" class="menu-item"><i class="bi bi-cup-hot-fill"></i> <span>Quản Lý Sản Phẩm</span></a>
        <a href="${pageContext.request.contextPath}/bien-the" class="menu-item"><i class="bi bi-tags-fill"></i> <span>Biến Thể & Kích Cỡ</span></a>
        <a href="${pageContext.request.contextPath}/topping" class="menu-item"><i class="bi bi-plus-square-fill"></i> <span>Quản Lý Topping</span></a>

        <div class="text-uppercase text-white-50 fw-bold small px-3 mb-2 mt-4" style="font-size: 0.7rem; letter-spacing: 1px;">Marketing & CRM</div>
        <a href="${pageContext.request.contextPath}/khach-hang" class="menu-item"><i class="bi bi-person-vcard-fill"></i> <span>Thẻ Khách Hàng</span></a>
        <a href="${pageContext.request.contextPath}/khuyen-mai" class="menu-item"><i class="bi bi-ticket-perforated-fill"></i> <span>Mã Khuyến Mãi</span></a>
        <a href="${pageContext.request.contextPath}/phuong-thuc" class="menu-item"><i class="bi bi-wallet-fill"></i> <span>Cổng Thanh Toán</span></a>

        <div class="text-uppercase text-white-50 fw-bold small px-3 mb-2 mt-4" style="font-size: 0.7rem; letter-spacing: 1px;">Hệ Thống</div>
        <a href="${pageContext.request.contextPath}/nhan-vien" class="menu-item"><i class="bi bi-shield-lock-fill"></i> <span>Tài Khoản Nhân Viên</span></a>
    </div>
</nav>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        var currentPath = window.location.pathname;
        var menuLinks = document.querySelectorAll('#main-sidebar-menu .menu-item');
        menuLinks.forEach(function(link) { link.classList.remove('active'); });
        var foundActive = false;
        menuLinks.forEach(function(link) {
            var href = link.getAttribute('href');
            if (href && href.includes('/ban-hang')) return;
            if (href && currentPath.includes(href)) { link.classList.add('active'); foundActive = true; }
        });
        if (!foundActive && (currentPath.endsWith('/admin') || currentPath.endsWith('/admin.jsp'))) {
            let dashboardLink = document.querySelector('#main-sidebar-menu a[href$="/admin"]');
            if(dashboardLink) dashboardLink.classList.add('active');
        }
    });
</script>