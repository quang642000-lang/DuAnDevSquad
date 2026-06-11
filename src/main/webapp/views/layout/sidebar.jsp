<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>

<div class="sidebar-overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

<nav class="sidebar" id="sidebar">
    <div class="sidebar-header d-flex align-items-center justify-content-center">
        <h4 class="mb-0 fw-bold menu-text" style="color: var(--brand-primary);">
            <i class="bi bi-cup-straw"></i> TEA POS
        </h4>
        <i class="bi bi-cup-straw fs-3 icon-only" style="color: var(--brand-primary); display: none;"></i>
    </div>

    <div class="sidebar-menu" id="main-sidebar-menu">
        <div class="text-uppercase text-white-50 fw-bold small px-3 mb-2 mt-2 menu-text" style="font-size: 0.7rem; letter-spacing: 1px;">
            Tổng Quan
        </div>

        <a href="${pageContext.request.contextPath}/admin" class="menu-item" data-path="/admin">
            <i class="bi bi-grid-1x2-fill"></i> <span class="menu-text">Bảng Điều Khiển</span>
        </a>
        <a href="${pageContext.request.contextPath}/ban-hang" class="menu-item text-warning" target="_blank">
            <i class="bi bi-display"></i> <span class="menu-text">Mở Máy POS</span>
        </a>

        <div class="text-uppercase text-white-50 fw-bold small px-3 mb-2 mt-4 menu-text" style="font-size: 0.7rem; letter-spacing: 1px;">
            Thực Đơn & Món
        </div>

        <a href="${pageContext.request.contextPath}/danh-muc" class="menu-item" data-path="/danh-muc">
            <i class="bi bi-collection-fill"></i> <span class="menu-text">Quản Lý Danh Mục</span>
        </a>
        <a href="${pageContext.request.contextPath}/san-pham" class="menu-item" data-path="/san-pham">
            <i class="bi bi-cup-hot-fill"></i> <span class="menu-text">Quản Lý Sản Phẩm</span>
        </a>
        <a href="${pageContext.request.contextPath}/bien-the" class="menu-item" data-path="/bien-the">
            <i class="bi bi-tags-fill"></i> <span class="menu-text">Biến Thể & Kích Cỡ</span>
        </a>
        <a href="${pageContext.request.contextPath}/topping" class="menu-item" data-path="/topping">
            <i class="bi bi-plus-square-fill"></i> <span class="menu-text">Quản Lý Topping</span>
        </a>

        <div class="text-uppercase text-white-50 fw-bold small px-3 mb-2 mt-4 menu-text" style="font-size: 0.7rem; letter-spacing: 1px;">
            Marketing & CRM
        </div>

        <a href="${pageContext.request.contextPath}/khach-hang" class="menu-item" data-path="/khach-hang">
            <i class="bi bi-person-vcard-fill"></i> <span class="menu-text">Thẻ Khách Hàng</span>
        </a>
        <a href="${pageContext.request.contextPath}/khuyen-mai" class="menu-item" data-path="/khuyen-mai">
            <i class="bi bi-ticket-perforated-fill"></i> <span class="menu-text">Mã Khuyến Mãi</span>
        </a>
        <a href="${pageContext.request.contextPath}/phuong-thuc" class="menu-item" data-path="/phuong-thuc">
            <i class="bi bi-wallet-fill"></i> <span class="menu-text">Cổng Thanh Toán</span>
        </a>

        <div class="text-uppercase text-white-50 fw-bold small px-3 mb-2 mt-4 menu-text" style="font-size: 0.7rem; letter-spacing: 1px;">
            Hệ Thống
        </div>

        <a href="${pageContext.request.contextPath}/nhan-vien" class="menu-item" data-path="/nhan-vien">
            <i class="bi bi-shield-lock-fill"></i> <span class="menu-text">Tài Khoản Nhân Viên</span>
        </a>
    </div>
</nav>