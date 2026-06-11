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