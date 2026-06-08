<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>TEA POS - Bảng Điều Khiển Quản Lý</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <!-- Nạp thư viện Chart.js vẽ biểu đồ -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        body { background-color: #f4f6f9; overflow-x: hidden; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;}
        .wrapper { display: flex; width: 100%; height: 100vh; }

        /* SIDEBAR PRO */
        .sidebar { width: 260px; background-color: #212529; color: #fff; display: flex; flex-direction: column; transition: all 0.3s; box-shadow: 2px 0 5px rgba(0,0,0,0.1); z-index: 100;}
        .sidebar-header { padding: 20px; text-align: center; border-bottom: 1px solid #343a40; background: linear-gradient(135deg, #1e2226, #212529); }
        .sidebar-menu { flex-grow: 1; padding: 10px 0; overflow-y: auto; }
        .sidebar-menu::-webkit-scrollbar { width: 6px; }
        .sidebar-menu::-webkit-scrollbar-thumb { background-color: #495057; border-radius: 4px; }
        .menu-item { padding: 12px 20px; display: block; color: #adb5bd; text-decoration: none; font-weight: 500; transition: 0.2s; border-left: 4px solid transparent;}
        .menu-item:hover, .menu-item.active { color: #fff; background-color: rgba(255,255,255,0.05); border-left: 4px solid #0d6efd; }
        .menu-item i { margin-right: 12px; font-size: 1.1rem; width: 20px; text-align: center; display: inline-block;}

        /* MAIN CONTENT */
        .main-content { flex-grow: 1; display: flex; flex-direction: column; height: 100vh; overflow-y: auto; }
        .top-navbar { background-color: #fff; height: 65px; display: flex; align-items: center; justify-content: space-between; padding: 0 25px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); z-index: 10; }

        /* CÁC THẺ THỐNG KÊ (GRADIENT) */
        .stat-card { border: none; border-radius: 12px; transition: transform 0.2s; position: relative; overflow: hidden;}
        .stat-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.08) !important; }
        .bg-grad-1 { background: linear-gradient(135deg, #fff, #f8f9fa); border-bottom: 4px solid #198754; }
        .bg-grad-2 { background: linear-gradient(135deg, #fff, #f8f9fa); border-bottom: 4px solid #0d6efd; }
        .bg-grad-3 { background: linear-gradient(135deg, #fff, #f8f9fa); border-bottom: 4px solid #ffc107; }
        .bg-grad-4 { background: linear-gradient(135deg, #fff, #f8f9fa); border-bottom: 4px solid #dc3545; }
        .stat-icon { width: 55px; height: 55px; display: flex; align-items: center; justify-content: center; border-radius: 12px; font-size: 1.8rem; }

        /* BẢNG ĐẸP */
        .card-box { border: none; border-radius: 12px; box-shadow: 0 2px 12px rgba(0,0,0,0.04); }
        .card-header-box { background-color: #fff; border-bottom: 1px solid #edf2f9; padding: 18px 20px; border-top-left-radius: 12px !important; border-top-right-radius: 12px !important;}
        .table-custom th { background-color: #f8f9fa; color: #6c757d; font-size: 0.8rem; text-transform: uppercase; letter-spacing: 0.5px; border-bottom: 1px solid #edf2f9; padding: 12px 15px;}
        .table-custom td { vertical-align: middle; font-size: 0.95rem; border-bottom: 1px solid #edf2f9; padding: 12px 15px;}

        .btn-view { border-radius: 50%; width: 32px; height: 32px; display: inline-flex; align-items: center; justify-content: center; padding: 0;}
    </style>
</head>
<body>

<div class="wrapper">
    <!-- ================= SIDEBAR ================= -->
    <nav class="sidebar">
        <div class="sidebar-header">
            <h4 class="mb-0 fw-bold text-warning"><i class="bi bi-cup-straw"></i> TEA POS</h4>
            <span class="small text-muted" style="letter-spacing: 1px;">QUẢN TRỊ VIÊN</span>
        </div>

        <div class="sidebar-menu">
            <div class="text-uppercase text-secondary fw-bold small px-4 mb-2 mt-2" style="font-size: 0.75rem;">Tổng Quan</div>
            <a href="${pageContext.request.contextPath}/admin" class="menu-item active">
                <i class="bi bi-speedometer2"></i> Báo Cáo Doanh Thu
            </a>
            <a href="${pageContext.request.contextPath}/ban-hang" class="menu-item text-info">
                <i class="bi bi-cart-check-fill"></i> Mở Máy POS
            </a>

            <div class="text-uppercase text-secondary fw-bold small px-4 mb-2 mt-4" style="font-size: 0.75rem;">Sản Phẩm & Menu</div>
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

            <div class="text-uppercase text-secondary fw-bold small px-4 mb-2 mt-4" style="font-size: 0.75rem;">Marketing & CRM</div>
            <a href="${pageContext.request.contextPath}/khach-hang" class="menu-item">
                <i class="bi bi-person-vcard-fill"></i> Thẻ Khách Hàng
            </a>
            <a href="${pageContext.request.contextPath}/khuyen-mai" class="menu-item">
                <i class="bi bi-ticket-perforated-fill"></i> Mã Khuyến Mãi
            </a>
            <a href="${pageContext.request.contextPath}/phuong-thuc" class="menu-item">
                <i class="bi bi-wallet2"></i> Cổng Thanh Toán
            </a>

            <div class="text-uppercase text-secondary fw-bold small px-4 mb-2 mt-4" style="font-size: 0.75rem;">Hệ Thống</div>
            <a href="${pageContext.request.contextPath}/nhan-vien" class="menu-item">
                <i class="bi bi-shield-lock-fill"></i> Tài Khoản Nhân Viên
            </a>
        </div>
    </nav>

    <!-- ================= MAIN CONTENT ================= -->
    <div class="main-content">
        <!-- NAVBAR -->
        <header class="top-navbar">
            <div class="d-flex align-items-center">
                <h4 class="mb-0 fw-bold text-dark me-4">Bảng Điều Khiển</h4>

                <!-- BỘ LỌC NGÀY THÁNG ĐẸP -->
                <form action="${pageContext.request.contextPath}/admin" method="get" class="d-flex align-items-center bg-light rounded-pill px-2 py-1 border border-secondary border-opacity-25">
                    <i class="bi bi-calendar-date text-primary ms-2 me-2"></i>
                    <input type="date" class="form-control form-control-sm border-0 bg-transparent shadow-none fw-medium" name="dateFilter" value="${requestScope.selectedDate}" style="width: 140px; outline: none;">
                    <button class="btn btn-sm btn-primary rounded-pill px-3 ms-1 fw-bold" type="submit">Lọc</button>
                    <c:if test="${not empty requestScope.selectedDate}">
                        <a href="${pageContext.request.contextPath}/admin" class="btn btn-sm btn-light text-danger rounded-pill px-2 ms-1" title="Xóa bộ lọc"><i class="bi bi-x-circle-fill"></i></a>
                    </c:if>
                </form>
            </div>

            <div class="d-flex align-items-center">
                <div class="dropdown">
                    <button class="btn btn-light rounded-pill px-3 fw-bold border-0 shadow-sm d-flex align-items-center" type="button" data-bs-toggle="dropdown">
                        <img src="https://ui-avatars.com/api/?name=${sessionScope.nhanVienDangNhap.hoTen}&background=0D8ABC&color=fff&rounded=true" alt="avatar" width="30" height="30" class="me-2">
                        ${sessionScope.nhanVienDangNhap.hoTen}
                        <i class="bi bi-chevron-down ms-2 small"></i>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2">
                        <li><a class="dropdown-item text-danger fw-bold py-2" href="${pageContext.request.contextPath}/auth?action=logout"><i class="bi bi-box-arrow-right me-2"></i> Đăng Xuất</a></li>
                    </ul>
                </div>
            </div>
        </header>

        <!-- NỘI DUNG TRANG CHỦ -->
        <div class="container-fluid p-4">

            <h6 class="text-muted fw-bold mb-3 text-uppercase small">Chỉ Số Tổng Quan <span class="text-primary">${empty requestScope.selectedDate ? '(Hôm nay)' : '(Ngày đang lọc)'}</span></h6>

            <!-- THẺ THỐNG KÊ 4 MÀU -->
            <div class="row g-4 mb-4">
                <div class="col-md-3">
                    <div class="card stat-card bg-grad-1 shadow-sm h-100 p-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-muted fw-bold mb-2">DOANH THU</h6>
                                <h3 class="fw-bold text-dark mb-0">
                                    <fmt:formatNumber value="${requestScope.thongKe.doanhThuHomNay}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                </h3>
                            </div>
                            <div class="stat-icon bg-success bg-opacity-10 text-success">
                                <i class="bi bi-wallet2"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card stat-card bg-grad-2 shadow-sm h-100 p-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-muted fw-bold mb-2">ĐƠN HÀNG MỚI</h6>
                                <h3 class="fw-bold text-dark mb-0">${requestScope.thongKe.donHangMoi} <span class="fs-6 fw-normal text-muted">đơn</span></h3>
                            </div>
                            <div class="stat-icon bg-primary bg-opacity-10 text-primary">
                                <i class="bi bi-receipt"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card stat-card bg-grad-3 shadow-sm h-100 p-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-muted fw-bold mb-2">MÓN ĐANG BÁN</h6>
                                <h3 class="fw-bold text-dark mb-0">${requestScope.thongKe.tongSanPham} <span class="fs-6 fw-normal text-muted">món</span></h3>
                            </div>
                            <div class="stat-icon bg-warning bg-opacity-10 text-warning">
                                <i class="bi bi-cup-hot-fill"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card stat-card bg-grad-4 shadow-sm h-100 p-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-muted fw-bold mb-2">TỔNG KHÁCH HÀNG</h6>
                                <h3 class="fw-bold text-dark mb-0">${requestScope.thongKe.tongKhachHang} <span class="fs-6 fw-normal text-muted">người</span></h3>
                            </div>
                            <div class="stat-icon bg-danger bg-opacity-10 text-danger">
                                <i class="bi bi-people-fill"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- PHẦN BIỂU ĐỒ VÀ TOP SẢN PHẨM -->
            <div class="row g-4 mb-4">
                <!-- BIỂU ĐỒ DOANH THU 7 NGÀY GẦN NHẤT -->
                <div class="col-lg-8">
                    <div class="card card-box h-100">
                        <div class="card-header-box d-flex justify-content-between align-items-center">
                            <h6 class="mb-0 fw-bold text-dark"><i class="bi bi-graph-up-arrow text-primary me-2"></i>Biểu Đồ Doanh Thu (7 Ngày Qua)</h6>
                        </div>
                        <div class="card-body p-4">
                            <canvas id="revenueChart" style="max-height: 280px;"></canvas>
                        </div>
                    </div>
                </div>

                <!-- TOP 5 SẢN PHẨM BÁN CHẠY -->
                <div class="col-lg-4">
                    <div class="card card-box h-100">
                        <div class="card-header-box border-bottom">
                            <h6 class="mb-0 fw-bold text-dark"><i class="bi bi-fire text-danger me-2"></i>Top 5 Món Bán Chạy Nhất</h6>
                        </div>
                        <div class="card-body p-0">
                            <table class="table table-borderless table-hover align-middle mb-0">
                                <tbody>
                                <c:choose>
                                    <c:when test="${not empty requestScope.topSanPham}">
                                        <c:forEach var="top" items="${requestScope.topSanPham}" varStatus="stt">
                                            <tr class="border-bottom border-light">
                                                <td class="ps-4" width="15%">
                                                    <c:choose>
                                                        <c:when test="${stt.index == 0}">
                                                            <div class="bg-warning text-white fw-bold rounded-circle d-flex align-items-center justify-content-center" style="width: 32px; height: 32px;"><i class="bi bi-trophy-fill"></i></div>
                                                        </c:when>
                                                        <c:when test="${stt.index == 1}">
                                                            <div class="bg-secondary text-white fw-bold rounded-circle d-flex align-items-center justify-content-center" style="width: 32px; height: 32px;">2</div>
                                                        </c:when>
                                                        <c:when test="${stt.index == 2}">
                                                            <div class="text-white fw-bold rounded-circle d-flex align-items-center justify-content-center" style="width: 32px; height: 32px; background-color: #cd7f32;">3</div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="bg-light text-muted fw-bold rounded-circle d-flex align-items-center justify-content-center" style="width: 32px; height: 32px;">${stt.index + 1}</div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="fw-bold text-dark">${top.tenSanPham}</td>
                                                <td class="text-end pe-4">
                                                    <span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25 rounded-pill px-3 py-2 fw-bold">${top.soLuongBan} ly</span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="3" class="text-center text-muted py-5">
                                                <i class="bi bi-cup text-light fs-1 d-block mb-2"></i>
                                                Chưa có dữ liệu bán hàng.
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

            <!-- BẢNG DANH SÁCH ĐƠN HÀNG (QUẢN LÝ TINH GỌN) -->
            <div class="row g-4">
                <div class="col-12">
                    <div class="card card-box">
                        <div class="card-header-box d-flex justify-content-between align-items-center">
                            <h6 class="mb-0 fw-bold text-dark"><i class="bi bi-receipt-cutoff text-success me-2"></i>Lịch Sử Giao Dịch Trong Ngày</h6>
                            <span class="badge bg-dark text-white rounded-pill px-3 py-2">${fn:length(requestScope.listDonHang)} đơn hàng</span>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive" style="max-height: 500px;">
                                <table class="table table-hover table-custom mb-0 text-center">
                                    <thead class="sticky-top">
                                    <tr>
                                        <th width="10%">Giờ Tạo</th>
                                        <th width="15%" class="text-start">Mã Hóa Đơn</th>
                                        <th width="20%">Người Thu Tiền</th>
                                        <th width="20%" class="text-end">Tổng Doanh Thu</th>
                                        <th width="15%">Trạng Thái</th>
                                        <th width="10%">Thao Tác</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:choose>
                                        <c:when test="${not empty requestScope.listDonHang}">
                                            <c:forEach var="dh" items="${requestScope.listDonHang}">
                                                <tr>
                                                    <td class="fw-bold text-secondary">
                                                        <fmt:formatDate value="${dh.thoiGian}" pattern="HH:mm:ss"/>
                                                    </td>
                                                    <td class="text-start fw-bold text-dark">
                                                        <i class="bi bi-hash text-muted"></i>${dh.maDH}
                                                    </td>
                                                    <td>
                                                        <div class="d-flex align-items-center justify-content-center">
                                                            <div class="bg-primary bg-opacity-10 text-primary rounded-circle d-flex align-items-center justify-content-center fw-bold me-2" style="width:28px; height:28px; font-size:0.75rem;">
                                                                    ${fn:substring(dh.tenNhanVien, 0, 1)}
                                                            </div>
                                                            <span class="fw-medium">${dh.tenNhanVien}</span>
                                                        </div>
                                                    </td>
                                                    <td class="text-end fw-bold text-danger fs-6">
                                                        <fmt:formatNumber value="${dh.tongTien}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${dh.trangThai == 'Hoàn thành'}">
                                                                <span class="badge bg-success bg-opacity-10 text-success border border-success px-3 py-2 rounded-pill"><i class="bi bi-check2-circle me-1"></i>Hoàn thành</span>
                                                            </c:when>
                                                            <c:when test="${dh.trangThai == 'Đã hủy'}">
                                                                <span class="badge bg-danger bg-opacity-10 text-danger border border-danger px-3 py-2 rounded-pill"><i class="bi bi-x-circle me-1"></i>Đã hủy</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-warning bg-opacity-10 text-warning border border-warning px-3 py-2 rounded-pill"><i class="bi bi-hourglass-split me-1"></i>${dh.trangThai}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <!-- NÚT XEM CHI TIẾT ĐƠN HÀNG (Gọi JS Modal) -->
                                                        <button class="btn btn-light btn-view border shadow-sm text-primary" title="Xem chi tiết món"
                                                                onclick="viewOrderDetails('${dh.maDH}', '${fn:escapeXml(dh.chiTietMon)}')">
                                                            <i class="bi bi-eye-fill"></i>
                                                        </button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="6" class="text-center text-muted py-5">
                                                    <img src="https://cdn-icons-png.flaticon.com/512/7486/7486744.png" alt="No data" width="80" class="opacity-50 mb-3">
                                                    <p class="mb-0 fw-medium">Chưa có giao dịch nào trong ngày này.</p>
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
            </div>

        </div>
    </div>
</div>

<!-- ============================================= -->
<!-- MODAL XEM CHI TIẾT ĐƠN HÀNG (THÔNG MINH)      -->
<!-- ============================================= -->
<div class="modal fade" id="orderDetailModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <div class="modal-header bg-dark text-white border-0">
                <div>
                    <h5 class="modal-title fw-bold mb-0"><i class="bi bi-card-list me-2"></i>Chi Tiết Đơn Hàng</h5>
                    <small class="text-white-50" id="modalOrderCode">Mã: DH...</small>
                </div>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body bg-light p-0">
                <ul class="list-group list-group-flush rounded-0" id="modalOrderItems">
                    <!-- Javascript sẽ đổ list món ăn (được tách từ chuỗi SQL) vào đây -->
                </ul>
            </div>
            <div class="modal-footer border-0 bg-white">
                <button type="button" class="btn btn-secondary fw-bold px-4 rounded-pill" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- JAVASCRIPT XỬ LÝ GIAO DIỆN -->
<script>
    // 1. TÍNH NĂNG: BUNG MODAL XEM CHI TIẾT MÓN ĂN
    const orderModal = new bootstrap.Modal(document.getElementById('orderDetailModal'));

    function viewOrderDetails(maDH, chiTietMonString) {
        document.getElementById('modalOrderCode').innerText = "Mã: " + maDH;
        let ul = document.getElementById('modalOrderItems');
        ul.innerHTML = ''; // Clear cũ

        if (!chiTietMonString || chiTietMonString.trim() === '' || chiTietMonString === 'Không có thông tin món') {
            ul.innerHTML = '<li class="list-group-item text-center text-muted py-4">Đơn hàng không có chi tiết món ăn.</li>';
        } else {
            // Chuỗi từ SQL có dạng: "Trà Sữa (Size M) x2 | Cà phê (Size L) x1"
            // Ta dùng JS cắt theo ký tự " | " để tạo thành list đẹp mắt
            let monArray = chiTietMonString.split(" | ");
            monArray.forEach(mon => {
                if(mon.trim() !== "") {
                    // Tách tên món và số lượng (VD x2) để bôi đậm số lượng
                    let parts = mon.split(" x");
                    let ten = parts[0];
                    let sl = parts.length > 1 ? ("x" + parts[1]) : "";

                    let li = document.createElement('li');
                    li.className = "list-group-item d-flex justify-content-between align-items-center py-3";
                    li.innerHTML = `<span class="fw-medium text-dark"><i class="bi bi-cup text-primary me-2"></i>\${ten}</span>
                                    <span class="badge bg-primary rounded-pill fs-6">\${sl}</span>`;
                    ul.appendChild(li);
                }
            });
        }
        orderModal.show();
    }

    // 2. TÍNH NĂNG: VẼ BIỂU ĐỒ DOANH THU 7 NGÀY (Chart.js)
    document.addEventListener("DOMContentLoaded", function() {
        // Nhận mảng dữ liệu JSON thô từ Java Controller
        const labels = ${requestScope.chartLabels};
        const dataValues = ${requestScope.chartValues};

        if (labels.length > 0) {
            const ctx = document.getElementById('revenueChart').getContext('2d');

            // Tạo Gradient màu cho thanh biểu đồ
            let gradient = ctx.createLinearGradient(0, 0, 0, 400);
            gradient.addColorStop(0, 'rgba(13, 110, 253, 0.8)'); // Màu xanh Bootstrap primary
            gradient.addColorStop(1, 'rgba(13, 110, 253, 0.2)');

            new Chart(ctx, {
                type: 'bar', // Biểu đồ cột
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Doanh thu (VNĐ)',
                        data: dataValues,
                        backgroundColor: gradient,
                        borderColor: '#0d6efd',
                        borderWidth: 1,
                        borderRadius: 6,
                        barPercentage: 0.6
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    // Format tiền tệ khi đưa chuột vào cột
                                    let value = context.raw;
                                    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value);
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            grid: { borderDash: [5, 5], color: '#e9ecef' },
                            ticks: {
                                callback: function(value) {
                                    // Rút gọn số 0 trên cột Y (VD: 2000000 -> 2M)
                                    if(value >= 1000000) return (value / 1000000) + 'M';
                                    if(value >= 1000) return (value / 1000) + 'k';
                                    return value;
                                }
                            }
                        },
                        x: { grid: { display: false } }
                    }
                }
            });
        } else {
            // Nếu không có dữ liệu (DB rỗng), ẩn Canvas và hiện chữ báo lỗi
            let canvasParent = document.getElementById('revenueChart').parentElement;
            canvasParent.innerHTML = '<div class="text-center text-muted py-5"><i class="bi bi-graph-down text-light fs-1 d-block mb-2"></i>Chưa có đủ dữ liệu giao dịch để vẽ biểu đồ.</div>';
        }
    });
</script>

</body>
</html>