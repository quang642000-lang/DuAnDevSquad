/* =================================================================
   HỆ THỐNG JAVASCRIPT DÙNG CHUNG - DỰ ÁN TEA POS
   ================================================================= */

let confirmActionCallback = null;
let jsConfirmModalObj = null;

// SỰ KIỆN KHI TRANG LOAD XONG
document.addEventListener("DOMContentLoaded", function() {

    // 1. Khởi tạo Modal Xác nhận chung
    let confirmModalEl = document.getElementById('jsConfirmModal');
    if (confirmModalEl) {
        jsConfirmModalObj = new bootstrap.Modal(confirmModalEl);
        let btnYes = document.getElementById('jsConfirmYesBtn');
        if (btnYes) {
            btnYes.addEventListener('click', function() {
                if (typeof confirmActionCallback === 'function') {
                    confirmActionCallback();
                    confirmActionCallback = null; // Reset callback sau khi gọi
                }
                jsConfirmModalObj.hide();
            });
        }
    }

    // 2. Xử lý Active Menu và Trạng thái Sidebar (Chỉ chạy nếu trang có Menu)
    let sidebarMenu = document.getElementById("main-sidebar-menu");
    if (sidebarMenu) {
        let currentPath = window.location.pathname;
        let menuItems = document.querySelectorAll("#main-sidebar-menu .menu-item[data-path]");

        // Active nút đang bấm
        for (let i = 0; i < menuItems.length; i++) {
            let path = menuItems[i].getAttribute("data-path");
            if (path && currentPath.indexOf(path) !== -1) {
                menuItems[i].classList.add("active");
            }
        }

        // Khôi phục trạng thái Thu gọn (Collapsed) từ LocalStorage
        if (window.innerWidth >= 992 && localStorage.getItem('sidebarState') === 'collapsed') {
            let sidebar = document.getElementById('sidebar');
            if (sidebar) {
                sidebar.classList.add('collapsed');
            }
            let mainContent = document.querySelector('.main-content');
            if (mainContent) {
                mainContent.classList.add('expanded');
            }
        }
    }
});

// --- CÁC HÀM GỌI MODAL XÁC NHẬN ---
function showConfirmAction(title, text, callback) {
    let titleEl = document.getElementById('jsConfirmTitle');
    let textEl = document.getElementById('jsConfirmText');

    if (titleEl) titleEl.innerText = title;
    if (textEl) textEl.innerText = text;

    confirmActionCallback = callback;
    if (jsConfirmModalObj) {
        jsConfirmModalObj.show();
    } else {
        console.warn("Lỗi: Modal xác nhận (jsConfirmModal) chưa được khởi tạo trên trang này.");
    }
}

function showConfirmLink(title, text, url) {
    showConfirmAction(title, text, function() {
        window.location.href = url;
    });
}

function showConfirmForm(event, formElement, title, text) {
    event.preventDefault();
    showConfirmAction(title, text, function() {
        formElement.submit();
    });
}

// --- HÀM XỬ LÝ THU GỌN / MỞ RỘNG SIDEBAR ---
function toggleSidebar() {
    let sidebar = document.getElementById('sidebar');
    let mainContent = document.querySelector('.main-content');
    let overlay = document.getElementById('sidebarOverlay');

    if (window.innerWidth >= 992) {
        // Trên Desktop: Thu ra đóng vào
        if (sidebar) {
            sidebar.classList.toggle('collapsed');
        }
        if (mainContent) {
            mainContent.classList.toggle('expanded');
        }
        // Lưu thói quen người dùng vào bộ nhớ đệm trình duyệt
        if (sidebar) {
            localStorage.setItem('sidebarState', sidebar.classList.contains('collapsed') ? 'collapsed' : 'expanded');
        }
    } else {
        // Trên Mobile: Trượt Menu ngang
        if (sidebar) {
            sidebar.classList.toggle('show');
        }
        if (overlay) {
            overlay.classList.toggle('show');
        }
    }
}

// --- HÀM HIỂN THỊ THÔNG BÁO (TOAST) GÓC MÀN HÌNH ---
function showToast(message, type = 'success') {
    // 1. Tìm hoặc tạo vùng chứa Toast (Container)
    let toastContainer = document.getElementById('toast-container');
    if (!toastContainer) {
        toastContainer = document.createElement('div');
        toastContainer.id = 'toast-container';
        toastContainer.className = 'toast-container position-fixed top-0 end-0 p-3';
        toastContainer.style.zIndex = '1055';
        document.body.appendChild(toastContainer);
    }

    // 2. Xác định màu sắc và Icon dựa trên type (success, danger, warning)
    let bgClass = 'bg-success';
    let iconClass = 'bi-check-circle-fill';

    if (type === 'danger' || type === 'error') {
        bgClass = 'bg-danger';
        iconClass = 'bi-x-circle-fill';
    } else if (type === 'warning') {
        bgClass = 'bg-warning text-dark';
        iconClass = 'bi-exclamation-triangle-fill';
    } else if (type === 'info') {
        bgClass = 'bg-info text-dark';
        iconClass = 'bi-info-circle-fill';
    }

    // 3. Khởi tạo cấu trúc HTML cho Toast
    let toastId = 'toast_' + Date.now();
    let toastHtml = `
        <div id="${toastId}" class="toast align-items-center text-white ${bgClass} border-0 shadow-lg" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body fw-bold d-flex align-items-center" style="font-size: 0.95rem;">
                    <i class="bi ${iconClass} me-2 fs-5"></i>
                    <span>${message}</span>
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>
    `;

    // 4. Render Toast và hiển thị bằng Bootstrap API
    toastContainer.insertAdjacentHTML('beforeend', toastHtml);
    let toastEl = document.getElementById(toastId);
    let bsToast = new bootstrap.Toast(toastEl, { delay: 4000 }); // Hiển thị trong 4 giây

    bsToast.show();

    // 5. Dọn dẹp DOM (Xóa mã HTML của Toast) sau khi đã ẩn
    toastEl.addEventListener('hidden.bs.toast', function () {
        toastEl.remove();
    });
}