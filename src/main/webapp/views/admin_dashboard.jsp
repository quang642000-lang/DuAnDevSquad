<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TEA POS - Bảng Điều Khiển Quản Lý</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root {
            --brand-primary: #D97706; /* Amber 600 */
            --brand-dark: #0F172A; /* Slate 900 */
            --bg-surface: #F8FAFC; /* Slate 50 */
            --card-radius: 16px;
        }
        body { font-family: 'Plus Jakarta Sans', sans-serif; background-color: var(--bg-surface); overflow-x: hidden; color: #334155;}
        .wrapper { display: flex; width: 100%; min-height: 100vh; }

        /* KẾ THỪA CSS SIDEBAR */
        .sidebar { width: 280px; background-color: var(--brand-dark); color: #fff; display: flex; flex-direction: column; transition: all 0.3s ease; z-index: 1050;}
        .sidebar-header { padding: 24px 20px; text-align: center; background: rgba(0,0,0,0.1); border-bottom: 1px solid rgba(255,255,255,0.05); }
        .sidebar-menu { flex-grow: 1; padding: 15px 10px; overflow-y: auto; }
        .sidebar-menu::-webkit-scrollbar { width: 4px; }
        .sidebar-menu::-webkit-scrollbar-thumb { background-color: rgba(255,255,255,0.1); border-radius: 4px; }
        .menu-item { padding: 12px 16px; margin-bottom: 4px; display: flex; align-items: center; color: #94A3B8; text-decoration: none; font-weight: 500; border-radius: 8px; transition: all 0.2s;}
        .menu-item:hover, .menu-item.active { color: #fff; background-color: rgba(255,255,255,0.1); transform: translateX(4px); }
        .menu-item i { margin-right: 12px; font-size: 1.2rem; width: 24px; text-align: center;}
        .sidebar-overlay { display: none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(0,0,0,0.5); z-index: 1040; }

        /* MAIN CONTENT */
        .main-content { flex-grow: 1; display: flex; flex-direction: column; min-height: 100vh; width: calc(100% - 280px); transition: all 0.3s ease; }
        .top-navbar { background-color: #fff; height: 70px; display: flex; align-items: center; justify-content: space-between; padding: 0 24px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); z-index: 10; position: sticky; top: 0;}

        /* BẢNG & CARD */
        .stat-card { border: none; border-radius: var(--card-radius); transition: transform 0.2s; background: #fff; padding: 24px;}
        .stat-card:hover { transform: translateY(-4px); box-shadow: 0 12px 24px rgba(0,0,0,0.06) !important; }
        .stat-icon { width: 56px; height: 56px; display: flex; align-items: center; justify-content: center; border-radius: 14px; font-size: 1.75rem; }
        .card-box { border: none; border-radius: var(--card-radius); box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); background: #fff; }
        .card-header-box { background-color: transparent; border-bottom: 1px solid #F1F5F9; padding: 20px 24px; border-top-left-radius: var(--card-radius) !important; border-top-right-radius: var(--card-radius) !important;}
        .table-custom th { background-color: #F8FAFC; color: #64748B; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.05em; border-bottom: none; padding: 16px;}
        .table-custom td { vertical-align: middle; font-size: 0.95rem; border-bottom: 1px solid #F1F5F9; padding: 16px;}

        /* BẢN IN HÓA ĐƠN */
        .receipt-view { background: #fff; width: 100%; max-width: 350px; margin: 0 auto; padding: 25px; font-family: 'Courier New', Courier, monospace; color: #000; box-shadow: 0 10px 30px rgba(0,0,0,0.1); border-radius: 8px;}
        .receipt-view table { width: 100%; border-collapse: collapse; font-size: 13px;}
        .receipt-view hr { border-top: 1px dashed #000; opacity: 1; margin: 12px 0; background: none; }

        @media (max-width: 991.98px) {
            .sidebar { position: fixed; transform: translateX(-100%); }
            .sidebar.show { transform: translateX(0); }
            .sidebar-overlay.show { display: block; }
            .main-content { width: 100%; margin-left: 0; }
        }
    </style>
</head>
<body>
<input type="hidden" id="appContextPath" value="${pageContext.request.contextPath}">

<!-- THÔNG BÁO NỔI -->
<div class="toast-container position-fixed top-0 end-0 p-3 mt-2" style="z-index: 1055;" id="js-toast-container"></div>

<div class="wrapper">
    <!-- NHÚNG SIDEBAR TỪ FILE DÙNG CHUNG -->
    <%@ include file="layout/sidebar.jsp" %>

    <!-- ================= MAIN CONTENT ================= -->
    <div class="main-content">
        <!-- NAVBAR CỦA ADMIN -->
        <header class="top-navbar" style="height: auto; min-height: 70px; padding: 15px 24px; flex-wrap: wrap; gap: 15px;">
            <div class="d-flex align-items-center">
                <button class="btn btn-light d-lg-none me-3 border-0 shadow-sm rounded-3" onclick="toggleSidebar()">
                    <i class="bi bi-list fs-5"></i>
                </button>
                <h5 class="mb-0 fw-bold text-dark d-none d-sm-block me-4">Dashboard</h5>
            </div>

            <!-- BỘ LỌC NGÀY & NHÂN VIÊN -->
            <form action="${pageContext.request.contextPath}/admin" method="get" class="d-flex flex-wrap align-items-center gap-2 bg-white rounded-3 p-2 border shadow-sm flex-grow-1 justify-content-end" style="border-color: #E2E8F0 !important;">
                <div class="d-flex align-items-center bg-light rounded-pill px-3 py-1">
                    <span class="small text-muted fw-bold me-2">Từ:</span>
                    <input type="date" class="form-control form-control-sm border-0 bg-transparent shadow-none p-0 fw-medium text-dark" name="tuNgay" id="filterTuNgay" value="${requestScope.tuNgay}" style="width: 110px;">
                </div>
                <div class="d-flex align-items-center bg-light rounded-pill px-3 py-1">
                    <span class="small text-muted fw-bold me-2">Đến:</span>
                    <input type="date" class="form-control form-control-sm border-0 bg-transparent shadow-none p-0 fw-medium text-dark" name="denNgay" id="filterDenNgay" value="${requestScope.denNgay}" style="width: 110px;">
                </div>
                <div class="d-flex align-items-center bg-light rounded-pill px-2 py-1">
                    <i class="bi bi-person-badge text-primary ms-1 me-2"></i>
                    <select class="form-select form-select-sm border-0 bg-transparent shadow-none fw-medium text-dark p-0 pe-4" name="maNV" id="filterMaNV" style="width: 130px;">
                        <option value="">Mọi nhân viên</option>
                        <c:forEach var="nv" items="${requestScope.danhSachNhanVien}">
                            <option value="${nv.maNV}" ${requestScope.selectedNV == nv.maNV ? 'selected' : ''}>${nv.hoTen}</option>
                        </c:forEach>
                    </select>
                </div>
                <button class="btn btn-sm btn-dark rounded-pill px-4 fw-bold" type="submit">Lọc</button>
                <a href="${pageContext.request.contextPath}/admin" class="btn btn-sm btn-light border text-danger rounded-pill px-3" title="Xóa Lọc"><i class="bi bi-arrow-clockwise"></i></a>
            </form>

            <div class="d-flex align-items-center ms-auto">
                <!-- ĐÃ XÓA NÚT XUẤT BÁO CÁO Ở ĐÂY -->

                <div class="dropdown">
                    <button class="btn btn-light rounded-pill px-3 py-2 fw-semibold border-0 shadow-sm d-flex align-items-center" type="button" data-bs-toggle="dropdown">
                        <img src="https://ui-avatars.com/api/?name=${sessionScope.nhanVienDangNhap.hoTen}&background=D97706&color=fff&rounded=true&bold=true" alt="avatar" width="28" height="28" class="me-2 rounded-circle">
                        <span class="d-none d-md-inline">${sessionScope.nhanVienDangNhap.hoTen}</span>
                        <i class="bi bi-chevron-down ms-2 small text-muted"></i>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0 mt-2 rounded-3">
                        <li><a class="dropdown-item text-danger fw-semibold py-2" href="${pageContext.request.contextPath}/auth?action=logout"><i class="bi bi-box-arrow-right me-2"></i> Đăng Xuất</a></li>
                    </ul>
                </div>
            </div>
        </header>

        <!-- NỘI DUNG TRANG CHỦ -->
        <div class="container-fluid p-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h6 class="text-muted fw-bold mb-0 text-uppercase small" style="letter-spacing: 0.5px;">Chỉ Số Doanh Thu</h6>
                <span class="badge bg-danger bg-opacity-10 text-danger border border-danger border-opacity-25 px-3 py-2 fs-6 rounded-pill shadow-sm">
                        <i class="bi bi-graph-up-arrow me-1"></i> Tháng này: <fmt:formatNumber value="${not empty requestScope.thongKe.doanhThuThangNay ? requestScope.thongKe.doanhThuThangNay : 0}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                    </span>
            </div>

            <!-- THẺ THỐNG KÊ -->
            <div class="row g-4 mb-4">
                <div class="col-md-6 col-xl-3">
                    <div class="card stat-card shadow-sm h-100">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-muted fw-semibold mb-1 small text-uppercase">DOANH THU KỲ LỌC</h6>
                                <h3 class="fw-bold text-dark mb-0" id="statDoanhThu">
                                    <fmt:formatNumber value="${requestScope.thongKe.doanhThuHomNay}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                </h3>
                            </div>
                            <div class="stat-icon bg-success bg-opacity-10 text-success">
                                <i class="bi bi-cash-stack"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-xl-3">
                    <div class="card stat-card shadow-sm h-100">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-muted fw-semibold mb-1 small text-uppercase">ĐƠN HÀNG KỲ LỌC</h6>
                                <h3 class="fw-bold text-dark mb-0" id="statDonHang">${requestScope.thongKe.donHangMoi} <span class="fs-6 fw-medium text-muted">đơn</span></h3>
                            </div>
                            <div class="stat-icon bg-primary bg-opacity-10 text-primary">
                                <i class="bi bi-receipt-cutoff"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-xl-3">
                    <div class="card stat-card shadow-sm h-100">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-muted fw-semibold mb-1 small text-uppercase">MÓN ĐANG BÁN</h6>
                                <h3 class="fw-bold text-dark mb-0">${requestScope.thongKe.tongSanPham} <span class="fs-6 fw-medium text-muted">món</span></h3>
                            </div>
                            <div class="stat-icon bg-warning bg-opacity-10 text-warning">
                                <i class="bi bi-cup-hot-fill"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-xl-3">
                    <div class="card stat-card shadow-sm h-100">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-muted fw-semibold mb-1 small text-uppercase">TỔNG KHÁCH HÀNG</h6>
                                <h3 class="fw-bold text-dark mb-0">${requestScope.thongKe.tongKhachHang} <span class="fs-6 fw-medium text-muted">người</span></h3>
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
                <div class="col-lg-8">
                    <div class="card card-box h-100">
                        <div class="card-header-box d-flex justify-content-between align-items-center">
                            <h6 class="mb-0 fw-bold text-dark"><i class="bi bi-bar-chart-fill text-primary me-2"></i>Biểu Đồ Doanh Thu Lọc</h6>
                        </div>
                        <div class="card-body p-4">
                            <canvas id="revenueChart" style="max-height: 300px; width: 100%;"></canvas>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="card card-box h-100">
                        <div class="card-header-box">
                            <h6 class="mb-0 fw-bold text-dark"><i class="bi bi-fire text-danger me-2"></i>Top 5 Món Bán Chạy Nhất</h6>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-borderless table-hover align-middle mb-0">
                                    <tbody>
                                    <c:choose>
                                        <c:when test="${not empty requestScope.topSanPham}">
                                            <c:forEach var="top" items="${requestScope.topSanPham}" varStatus="stt">
                                                <tr class="border-bottom border-light">
                                                    <td class="ps-4" width="15%">
                                                        <c:choose>
                                                            <c:when test="${stt.index == 0}">
                                                                <div class="bg-warning text-white fw-bold rounded-circle d-flex align-items-center justify-content-center shadow-sm" style="width: 36px; height: 36px;"><i class="bi bi-trophy-fill"></i></div>
                                                            </c:when>
                                                            <c:when test="${stt.index == 1}">
                                                                <div class="bg-secondary text-white fw-bold rounded-circle d-flex align-items-center justify-content-center shadow-sm" style="width: 36px; height: 36px;">2</div>
                                                            </c:when>
                                                            <c:when test="${stt.index == 2}">
                                                                <div class="text-white fw-bold rounded-circle d-flex align-items-center justify-content-center shadow-sm" style="width: 36px; height: 36px; background-color: #CD7F32;">3</div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="bg-light text-muted fw-bold rounded-circle d-flex align-items-center justify-content-center" style="width: 36px; height: 36px;">${stt.index + 1}</div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="fw-semibold text-dark">${top.tenSanPham}</td>
                                                    <td class="text-end pe-4">
                                                        <span class="badge bg-primary bg-opacity-10 text-primary px-3 py-2 fw-bold rounded-pill">${top.soLuongBan} ly</span>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="3" class="text-center text-muted py-5">
                                                    <i class="bi bi-cup text-light fs-1 d-block mb-2"></i>
                                                    <span class="fw-medium">Chưa có dữ liệu bán hàng.</span>
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

            <!-- BẢNG DANH SÁCH ĐƠN HÀNG -->
            <div class="row g-4">
                <div class="col-12">
                    <div class="card card-box mb-4">
                        <div class="card-header-box d-flex justify-content-between align-items-center">
                            <h6 class="mb-0 fw-bold text-dark"><i class="bi bi-receipt text-success me-2"></i>Lịch Sử Giao Dịch Đã Lọc</h6>
                            <span class="badge bg-dark text-white rounded-pill px-3 py-2 shadow-sm">${fn:length(requestScope.listDonHang)} đơn hàng</span>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive" style="max-height: 500px; overflow-y: auto;">
                                <table class="table table-hover table-custom mb-0 text-center" id="orderTable">
                                    <thead class="sticky-top bg-white shadow-sm">
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
                                                    <td class="fw-semibold text-muted">
                                                        <fmt:formatDate value="${dh.thoiGian}" pattern="HH:mm:ss dd/MM"/>
                                                    </td>
                                                    <td class="text-start fw-bold text-dark">
                                                            ${dh.maDH}
                                                    </td>
                                                    <td>
                                                        <div class="d-flex align-items-center justify-content-center">
                                                            <div class="bg-primary bg-opacity-10 text-primary rounded-circle d-flex align-items-center justify-content-center fw-bold me-2" style="width:28px; height:28px; font-size:0.75rem;">
                                                                    ${fn:substring(dh.tenNhanVien, 0, 1)}
                                                            </div>
                                                            <span class="fw-medium text-dark">${dh.tenNhanVien}</span>
                                                        </div>
                                                    </td>
                                                    <td class="text-end fw-bold text-danger fs-6">
                                                        <fmt:formatNumber value="${dh.tongTien}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${dh.trangThai == 'Hoàn thành'}">
                                                                <span class="badge bg-success bg-opacity-10 text-success px-3 py-2 rounded-pill"><i class="bi bi-check2-circle me-1"></i>Hoàn thành</span>
                                                            </c:when>
                                                            <c:when test="${dh.trangThai == 'Đã hủy'}">
                                                                <span class="badge bg-danger bg-opacity-10 text-danger px-3 py-2 rounded-pill"><i class="bi bi-x-circle me-1"></i>Đã hủy</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-warning bg-opacity-10 text-warning px-3 py-2 rounded-pill"><i class="bi bi-hourglass-split me-1"></i>${dh.trangThai}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <button class="btn btn-light btn-sm rounded-circle shadow-sm text-primary" style="width: 36px; height: 36px;" title="Xem Hóa Đơn"
                                                                onclick="viewOrderReceipt('${dh.maDH}')">
                                                            <i class="bi bi-receipt"></i>
                                                        </button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="6" class="text-center text-muted py-5">
                                                    <div class="d-flex flex-column align-items-center">
                                                        <i class="bi bi-inbox fs-1 text-light mb-3"></i>
                                                        <p class="mb-0 fw-medium">Chưa có giao dịch nào phù hợp với bộ lọc.</p>
                                                    </div>
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
<!-- MODAL XEM CHI TIẾT ĐƠN HÀNG LẤY TỪ AJAX       -->
<!-- ============================================= -->
<div class="modal fade" id="orderDetailModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content border-0 bg-transparent shadow-none">
            <div class="modal-body receipt-view" id="receiptContent">
                <div style="text-align:center; margin-bottom:15px;">
                    <h3 style="font-weight:bold; margin:0; letter-spacing: 1px;">TEA POS</h3>
                    <div style="font-size:12px; margin-top: 5px;">Bản Sao Hóa Đơn</div>
                    <hr>
                </div>

                <div style="font-size:12px; margin-bottom:15px; line-height: 1.6;">
                    <div><span style="font-weight:bold;">Mã HD:</span> <span id="r_maDH">Đang tải...</span></div>
                    <div><span style="font-weight:bold;">Ngày:</span> <span id="r_ngay">...</span></div>
                    <div><span style="font-weight:bold;">Thu ngân:</span> <span id="r_nhanVien">...</span></div>
                    <div><span style="font-weight:bold;">Khách:</span> <span id="r_khach">...</span></div>
                    <div><span style="font-weight:bold;">TT:</span> <span id="r_pttt">...</span></div>
                </div>

                <hr>
                <div style="font-size:12px;">
                    <table style="width:100%; border-collapse:collapse;" id="r_items">
                        <tr><td class="text-center py-3"><div class="spinner-border text-brand" role="status"></div></td></tr>
                    </table>
                </div>
                <hr>

                <div style="font-size:12px; line-height: 1.6;">
                    <div style="display:flex; justify-content:space-between;">
                        <span>Tổng cộng:</span>
                        <span style="font-weight:bold;" id="r_tongTienHang">0</span>
                    </div>
                    <div style="display:flex; justify-content:space-between;">
                        <span>Giảm giá/Điểm:</span>
                        <span id="r_giamGia">0</span>
                    </div>
                    <hr>
                    <div style="display:flex; justify-content:space-between; font-weight:bold; font-size:16px; margin-top:5px; margin-bottom:5px;">
                        <span>THANH TOÁN:</span>
                        <span id="r_tongPhaiTra">0</span>
                    </div>
                    <div style="display:flex; justify-content:space-between;">
                        <span>Tiền nhận:</span>
                        <span id="r_tienKhachDua">0</span>
                    </div>
                    <div style="display:flex; justify-content:space-between;">
                        <span>Tiền thối:</span>
                        <span id="r_tienThoi">0</span>
                    </div>
                </div>
                <hr>
                <div style="text-align:center; font-size:11px; margin-top:15px; color:#555;">
                    Bản sao được trích xuất từ hệ thống.
                </div>
            </div>
            <div class="text-center mt-3 pb-4">
                <button type="button" class="btn btn-light fw-bold px-4 rounded-pill shadow-sm" data-bs-dismiss="modal">Đóng Bản Sao</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- JAVASCRIPT XỬ LÝ GIAO DIỆN -->
<script>
    // --- HỆ THỐNG TOAST ---
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

    // --- XỬ LÝ LẤY CHI TIẾT HÓA ĐƠN QUA AJAX ---
    const orderModal = new bootstrap.Modal(document.getElementById('orderDetailModal'));
    const appBasePath = document.getElementById('appContextPath').value;

    function viewOrderReceipt(maDH) {
        document.getElementById('r_maDH').innerText = "Đang tải...";
        document.getElementById('r_items').innerHTML = '<tr><td class="text-center py-3"><div class="spinner-border text-warning" role="status"></div></td></tr>';
        ['r_nhanVien', 'r_khach', 'r_ngay', 'r_pttt', 'r_tongTienHang', 'r_giamGia', 'r_tongPhaiTra', 'r_tienKhachDua', 'r_tienThoi'].forEach(id => {
            document.getElementById(id).innerText = "...";
        });

        orderModal.show();

        fetch(appBasePath + '/admin?action=get-receipt&maDH=' + maDH)
            .then(res => {
                if(!res.ok) throw new Error("Máy chủ trả về trạng thái lỗi: " + res.status);
                return res.text();
            })
            .then(text => {
                try {
                    let data = JSON.parse(text);

                    if(data.error) {
                        document.getElementById('r_items').innerHTML = `<tr><td class="text-center text-danger py-4 fw-bold"><i class="bi bi-x-circle fs-2 d-block mb-2"></i>\${data.error}</td></tr>`;
                        document.getElementById('r_maDH').innerText = "Lỗi Dữ Liệu";
                        return;
                    }

                    document.getElementById('r_maDH').innerText = data.maDH;
                    document.getElementById('r_nhanVien').innerText = data.nhanVien;
                    document.getElementById('r_khach').innerText = data.khachHang || 'Khách vãng lai';
                    document.getElementById('r_ngay').innerText = data.ngay;
                    document.getElementById('r_pttt').innerText = data.phuongThuc;

                    let tbody = document.getElementById('r_items');
                    tbody.innerHTML = '';

                    if(!data.items || data.items.length === 0) {
                        tbody.innerHTML = '<tr><td class="text-center py-2">Không có chi tiết.</td></tr>';
                    } else {
                        data.items.forEach(item => {
                            let tr = document.createElement('tr');
                            tr.innerHTML = `<td colspan="2" style="font-weight:bold; padding-top: 5px;">\${item.soLuong} x \${item.tenMon}</td>`;
                            tbody.appendChild(tr);

                            let trDetails = document.createElement('tr');
                            trDetails.innerHTML = `<td colspan="2" style="padding-left:10px; color:#444; font-size:11px;">(Size \${item.size} | \${item.da} Đá | \${item.duong} Đường)</td>`;
                            tbody.appendChild(trDetails);

                            if(item.toppings) {
                                item.toppings.forEach(tp => {
                                    let trTp = document.createElement('tr');
                                    trTp.innerHTML = `<td style="padding-left:15px; color:#444; font-size:11px;">+ \${tp.sl} x \${tp.ten}</td><td></td>`;
                                    tbody.appendChild(trTp);
                                });
                            }

                            let trPrice = document.createElement('tr');
                            let priceFormatted = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(item.giaChot * item.soLuong);
                            trPrice.innerHTML = `<td></td><td style="text-align:right; font-weight:bold; padding-bottom: 5px;">\${priceFormatted}</td>`;
                            tbody.appendChild(trPrice);
                        });
                    }

                    const fmtCur = (num) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(num);
                    document.getElementById('r_tongTienHang').innerText = fmtCur(data.tongTienHang);
                    document.getElementById('r_giamGia').innerText = "-" + fmtCur(data.tienGiamGia);
                    document.getElementById('r_tongPhaiTra').innerText = fmtCur(data.tongPhaiTra);
                    document.getElementById('r_tienKhachDua').innerText = fmtCur(data.tienKhachDua);
                    document.getElementById('r_tienThoi').innerText = fmtCur(data.tienKhachDua - data.tongPhaiTra);

                } catch(e) {
                    console.error("Lỗi parse JSON:", text);
                    document.getElementById('r_items').innerHTML = '<tr><td class="text-center text-danger py-4 fw-bold">Dữ liệu từ máy chủ bị hỏng!<br><small>Kiểm tra dữ liệu đặc biệt.</small></td></tr>';
                    document.getElementById('r_maDH').innerText = "Lỗi Định Dạng";
                }
            })
            .catch(err => {
                console.error("Lỗi fetch:", err);
                document.getElementById('r_items').innerHTML = `<tr><td class="text-center text-danger py-4 fw-bold">Mất kết nối máy chủ!<br><small>\${err.message}</small></td></tr>`;
            });
    }

    // Biểu đồ
    document.addEventListener("DOMContentLoaded", function() {
        const labelsString = '${requestScope.chartLabels != null ? requestScope.chartLabels : "[]"}';
        const dataValuesString = '${requestScope.chartValues != null ? requestScope.chartValues : "[]"}';

        let labels = [];
        let dataValues = [];
        try {
            if (!labelsString.startsWith("$")) { labels = JSON.parse(labelsString); }
            if (!dataValuesString.startsWith("$")) { dataValues = JSON.parse(dataValuesString); }
        } catch (e) {
            console.error("Lỗi đọc dữ liệu biểu đồ:", e);
        }

        if (labels.length > 0) {
            const ctx = document.getElementById('revenueChart').getContext('2d');
            let gradient = ctx.createLinearGradient(0, 0, 0, 400);
            gradient.addColorStop(0, 'rgba(217, 119, 6, 0.8)');
            gradient.addColorStop(1, 'rgba(217, 119, 6, 0.1)');

            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Doanh thu (VNĐ)',
                        data: dataValues,
                        backgroundColor: gradient,
                        borderColor: '#D97706',
                        borderWidth: 1,
                        borderRadius: 8,
                        barPercentage: 0.5
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            backgroundColor: '#0F172A',
                            titleFont: { family: 'Plus Jakarta Sans', size: 13 },
                            bodyFont: { family: 'Plus Jakarta Sans', size: 14, weight: 'bold' },
                            padding: 12,
                            cornerRadius: 8,
                            callbacks: {
                                label: function(context) {
                                    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(context.raw);
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            grid: { borderDash: [1], color: '#E2E8F0', drawBorder: false },
                            ticks: {
                                font: { family: 'Plus Jakarta Sans' },
                                color: '#64748B',
                                callback: function(value) {
                                    if(value >= 1000000) return (value / 1000000) + 'M';
                                    if(value >= 1000) return (value / 1000) + 'k';
                                    return value;
                                }
                            }
                        },
                        x: {
                            grid: { display: false, drawBorder: false },
                            ticks: { font: { family: 'Plus Jakarta Sans' }, color: '#64748B' }
                        }
                    }
                }
            });
        } else {
            let canvasParent = document.getElementById('revenueChart').parentElement;
            canvasParent.innerHTML = '<div class="text-center text-muted py-5"><i class="bi bi-graph-down text-light fs-1 d-block mb-2"></i><span class="fw-medium">Chưa có đủ dữ liệu giao dịch để vẽ biểu đồ.</span></div>';
        }
    });
</script>
</body>
</html>