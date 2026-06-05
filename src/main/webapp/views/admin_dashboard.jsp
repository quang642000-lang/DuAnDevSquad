<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>TEA POS - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

    <style>
        body { background-color: #f4f6f9; overflow-x: hidden; }
        .wrapper { display: flex; width: 100%; height: 100vh; }
        .sidebar { width: 260px; background-color: #212529; color: #fff; display: flex; flex-direction: column; transition: all 0.3s; }
        .sidebar-header { padding: 20px; text-align: center; border-bottom: 1px solid #343a40; }
        .sidebar-menu { flex-grow: 1; padding: 10px 0; overflow-y: auto; }
        .sidebar-menu::-webkit-scrollbar { width: 6px; }
        .sidebar-menu::-webkit-scrollbar-thumb { background-color: #495057; border-radius: 4px; }
        .menu-item { padding: 12px 20px; display: block; color: #adb5bd; text-decoration: none; font-weight: 500; transition: 0.2s; }
        .menu-item:hover, .menu-item.active { color: #fff; background-color: #0d6efd; border-left: 4px solid #fff; }
        .menu-item i { margin-right: 10px; font-size: 1.1rem; }
        .main-content { flex-grow: 1; display: flex; flex-direction: column; height: 100vh; overflow-y: auto; }
        .top-navbar { background-color: #fff; height: 60px; display: flex; align-items: center; justify-content: space-between; padding: 0 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.08); z-index: 10; }
        .stat-card { border: none; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); transition: transform 0.2s; }
        .stat-card:hover { transform: translateY(-5px); }
        .stat-icon { width: 60px; height: 60px; display: flex; align-items: center; justify-content: center; border-radius: 50%; font-size: 1.8rem; }

        .table-custom th { background-color: #f8f9fa; color: #495057; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.5px; border-bottom: 2px solid #dee2e6; }
        .table-custom td { vertical-align: middle; font-size: 0.95rem; }
    </style>
</head>
<body>

<div class="wrapper">
    <!-- ================= SIDEBAR ================= -->
    <nav class="sidebar">
        <div class="sidebar-header">
            <h4 class="mb-0 fw-bold text-warning"><i class="bi bi-cup-straw"></i> TEA POS</h4>
            <span class="small text-muted">Hệ Thống Quản Trị</span>
        </div>

        <div class="sidebar-menu">
            <div class="text-uppercase text-secondary fw-bold small px-3 mb-2 mt-2">Tổng Quan</div>
            <a href="${pageContext.request.contextPath}/admin" class="menu-item active">
                <i class="bi bi-speedometer2"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/ban-hang" class="menu-item text-success">
                <i class="bi bi-cart-check-fill"></i> Màn Hình Bán Hàng
            </a>

            <div class="text-uppercase text-secondary fw-bold small px-3 mb-2 mt-4">Sản Phẩm & Menu</div>
            <a href="${pageContext.request.contextPath}/danh-muc" class="menu-item">
                <i class="bi bi-grid-fill"></i> Quản Lý Danh Mục
            </a>
            <a href="${pageContext.request.contextPath}/san-pham" class="menu-item">
                <i class="bi bi-cup-hot-fill"></i> Quản Lý Sản Phẩm
            </a>
            <a href="${pageContext.request.contextPath}/bien-the" class="menu-item">
                <i class="bi bi-tags-fill"></i> Biến Thể & Kích Cỡ
            </a>
            <a href="${pageContext.request.contextPath}/topping" class="menu-item">
                <i class="bi bi-plugin"></i> Quản Lý Topping
            </a>

            <div class="text-uppercase text-secondary fw-bold small px-3 mb-2 mt-4">Kinh Doanh & Marketing</div>
            <a href="${pageContext.request.contextPath}/khach-hang" class="menu-item">
                <i class="bi bi-person-vcard-fill"></i> Khách Hàng
            </a>
            <a href="${pageContext.request.contextPath}/khuyen-mai" class="menu-item">
                <i class="bi bi-ticket-perforated-fill"></i> Khuyến Mãi
            </a>
            <a href="${pageContext.request.contextPath}/phuong-thuc" class="menu-item">
                <i class="bi bi-wallet2"></i> Phương Thức Thanh Toán
            </a>

            <div class="text-uppercase text-secondary fw-bold small px-3 mb-2 mt-4">Hệ Thống</div>
            <a href="${pageContext.request.contextPath}/nhan-vien" class="menu-item">
                <i class="bi bi-people-fill"></i> Quản Lý Nhân Viên
            </a>
        </div>
    </nav>

    <!-- ================= MAIN CONTENT ================= -->
    <div class="main-content">
        <!-- NAVBAR -->
        <header class="top-navbar">
            <div class="d-flex align-items-center">
                <h5 class="mb-0 fw-bold text-dark me-4">Bảng Điều Khiển</h5>

                <!-- BỘ LỌC NGÀY THÁNG -->
                <form action="${pageContext.request.contextPath}/admin" method="get" class="d-flex align-items-center">
                    <label class="fw-bold text-muted small me-2 mb-0">Xem dữ liệu ngày:</label>
                    <div class="input-group input-group-sm">
                        <input type="date" class="form-control" name="dateFilter" value="${requestScope.selectedDate}">
                        <button class="btn btn-primary" type="submit"><i class="bi bi-search"></i> Tra cứu</button>
                    </div>
                    <c:if test="${not empty requestScope.selectedDate}">
                        <a href="${pageContext.request.contextPath}/admin" class="btn btn-sm btn-outline-secondary ms-2">Hôm nay</a>
                    </c:if>
                </form>
            </div>

            <div class="d-flex align-items-center">
                <div class="dropdown">
                    <button class="btn btn-light dropdown-toggle fw-bold border-0" type="button" data-bs-toggle="dropdown">
                        <i class="bi bi-person-circle text-primary"></i>
                        Xin chào, ${sessionScope.nhanVienDangNhap.hoTen}
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end shadow">
                        <li><a class="dropdown-item text-danger fw-bold" href="${pageContext.request.contextPath}/auth?action=logout"><i class="bi bi-box-arrow-right"></i> Đăng Xuất</a></li>
                    </ul>
                </div>
            </div>
        </header>

        <!-- NỘI DUNG TRANG CHỦ -->
        <div class="container-fluid p-4">

            <!-- THẺ THỐNG KÊ (4 Thẻ lấy dữ liệu từ DB) -->
            <div class="row g-4 mb-4">
                <div class="col-md-3">
                    <div class="card stat-card h-100 p-3 border-start border-4 border-success">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-muted fw-bold mb-1">
                                    ${empty requestScope.selectedDate ? 'DOANH THU HÔM NAY' : 'DOANH THU NGÀY LỌC'}
                                </h6>
                                <h3 class="fw-bold text-dark mb-0">
                                    <fmt:formatNumber value="${requestScope.thongKe.doanhThuHomNay}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                </h3>
                            </div>
                            <div class="stat-icon bg-success bg-opacity-10 text-success">
                                <i class="bi bi-cash-coin"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card stat-card h-100 p-3 border-start border-4 border-primary">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-muted fw-bold mb-1">
                                    ${empty requestScope.selectedDate ? 'ĐƠN HÀNG HÔM NAY' : 'TỔNG ĐƠN NGÀY LỌC'}
                                </h6>
                                <h3 class="fw-bold text-dark mb-0">${requestScope.thongKe.donHangMoi}</h3>
                            </div>
                            <div class="stat-icon bg-primary bg-opacity-10 text-primary">
                                <i class="bi bi-receipt-cutoff"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card stat-card h-100 p-3 border-start border-4 border-warning">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-muted fw-bold mb-1">SẢN PHẨM ĐANG BÁN</h6>
                                <h3 class="fw-bold text-dark mb-0">${requestScope.thongKe.tongSanPham}</h3>
                            </div>
                            <div class="stat-icon bg-warning bg-opacity-10 text-warning">
                                <i class="bi bi-cup-hot"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card stat-card h-100 p-3 border-start border-4 border-danger">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-muted fw-bold mb-1">TỔNG KHÁCH HÀNG</h6>
                                <h3 class="fw-bold text-dark mb-0">${requestScope.thongKe.tongKhachHang}</h3>
                            </div>
                            <div class="stat-icon bg-danger bg-opacity-10 text-danger">
                                <i class="bi bi-people"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row g-4">
                <!-- BẢNG DANH SÁCH ĐƠN HÀNG -->
                <div class="col-lg-8">
                    <div class="card shadow-sm border-0 h-100">
                        <div class="card-header bg-white border-bottom py-3 d-flex justify-content-between align-items-center">
                            <h6 class="mb-0 fw-bold text-primary"><i class="bi bi-list-task"></i> DANH SÁCH ĐƠN HÀNG
                                ${empty requestScope.selectedDate ? 'TRONG NGÀY' : ''}
                            </h6>
                            <span class="badge bg-primary rounded-pill">${fn:length(requestScope.listDonHang)} đơn</span>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive" style="max-height: 500px;">
                                <table class="table table-hover table-custom mb-0 text-center">
                                    <thead class="sticky-top bg-light">
                                    <tr>
                                        <th width="10%">Giờ</th>
                                        <th width="15%">Mã ĐH</th>
                                        <th width="35%" class="text-start">Chi Tiết Món Ăn</th>
                                        <th width="15%" class="text-end">Tổng Tiền</th>
                                        <th width="15%">Người Lập</th>
                                        <th width="10%" class="text-center">Trạng Thái</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:choose>
                                        <c:when test="${not empty requestScope.listDonHang}">
                                            <c:forEach var="dh" items="${requestScope.listDonHang}">
                                                <tr>
                                                    <td class="fw-bold text-secondary">
                                                        <fmt:formatDate value="${dh.thoiGian}" pattern="HH:mm"/>
                                                    </td>
                                                    <td class="fw-bold text-primary">${dh.maDH}</td>
                                                    <td class="text-start">
                                                        <small class="text-muted lh-sm d-block">${dh.chiTietMon}</small>
                                                    </td>
                                                    <td class="text-end fw-bold text-danger">
                                                        <fmt:formatNumber value="${dh.tongTien}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                                    </td>
                                                    <td><i class="bi bi-person text-secondary"></i> ${dh.tenNhanVien}</td>
                                                    <td class="text-center">
                                                        <c:choose>
                                                            <c:when test="${dh.trangThai == 'Hoàn thành'}">
                                                                <span class="badge bg-success bg-opacity-10 text-success border border-success">Hoàn thành</span>
                                                            </c:when>
                                                            <c:when test="${dh.trangThai == 'Đã hủy'}">
                                                                <span class="badge bg-danger bg-opacity-10 text-danger border border-danger">Đã hủy</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-warning bg-opacity-10 text-warning border border-warning">${dh.trangThai}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="6" class="text-center text-muted py-5">
                                                    <i class="bi bi-inbox fs-1 d-block mb-2 text-light"></i>
                                                    Không có đơn hàng nào.
                                                </td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- BẢNG TOP SẢN PHẨM BÁN CHẠY -->
                <div class="col-lg-4">
                    <div class="card shadow-sm border-0 h-100">
                        <div class="card-header bg-white border-bottom py-3">
                            <h6 class="mb-0 fw-bold text-danger"><i class="bi bi-fire"></i> TOP 5 MÓN BÁN CHẠY</h6>
                        </div>
                        <div class="card-body p-0">
                            <table class="table table-borderless table-hover align-middle mb-0">
                                <thead class="bg-light text-muted small">
                                <tr>
                                    <th class="ps-3">Hạng</th>
                                    <th>Tên Sản Phẩm</th>
                                    <th class="text-center pe-3">SL Bán</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:choose>
                                    <c:when test="${not empty requestScope.topSanPham}">
                                        <c:forEach var="top" items="${requestScope.topSanPham}" varStatus="stt">
                                            <tr class="border-bottom">
                                                <td class="ps-4">
                                                    <c:choose>
                                                        <c:when test="${stt.index == 0}">
                                                            <span class="badge bg-warning text-dark fs-6 shadow-sm"><i class="bi bi-trophy-fill"></i> #1</span>
                                                        </c:when>
                                                        <c:when test="${stt.index == 1}">
                                                            <span class="badge bg-secondary fs-6 shadow-sm">#2</span>
                                                        </c:when>
                                                        <c:when test="${stt.index == 2}">
                                                            <span class="badge" style="background-color: #cd7f32; font-size: 1rem; box-shadow: 0 .125rem .25rem rgba(0,0,0,.075);">#3</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="fw-bold text-muted ps-2">#${stt.index + 1}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="fw-bold text-dark">${top.tenSanPham}</td>
                                                <td class="text-center pe-3">
                                                    <span class="badge bg-primary rounded-pill px-3 py-2 fs-6">${top.soLuongBan}</span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="3" class="text-center text-muted py-4">Chưa có dữ liệu thống kê món ăn.</td>
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
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>