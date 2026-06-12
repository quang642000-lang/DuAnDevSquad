const formatCurrency = (number) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(number);
let cart = JSON.parse(sessionStorage.getItem('tea_pos_cart')) || [];
let currentVoucher = null;
let currentProductVariants = [];
let customerPoints = 0;
let isUsingPoints = false;
let customPointsToUse = 0;
let checkPaymentInterval = null;
let editingCartId = null;
let optionModal = null;
let qrModal = null;

// HÀM CHỐNG XSS
function escapeHTML(str) {
    if(!str) return '';
    return str.replace(/[&<>'"]/g, function(tag) {
        const chars = { '&': '&amp;', '<': '&lt;', '>': '&gt;', "'": '&#39;', '"': '&quot;' };
        return chars[tag] || tag;
    });
}

document.addEventListener("DOMContentLoaded", function() {
    optionModal = new bootstrap.Modal(document.getElementById('optionModal'));
    qrModal = new bootstrap.Modal(document.getElementById('qrModal'));
    let receiptElement = document.getElementById('receiptModal');
    if(receiptElement) {
        sessionStorage.removeItem('tea_pos_cart');
        cart = [];
        let myModal = new bootstrap.Modal(receiptElement);
        myModal.show();
        setTimeout(() => { printReceipt(); }, 500);
        fetch(appBasePath + '/ban-hang?action=clear-bill').catch(e => console.log(e));
    } else {
        renderCart();
    }
});

function printReceipt() {
    const receiptContent = document.getElementById('printable-receipt-content').innerHTML;
    const iframe = document.createElement('iframe');
    iframe.style.position = 'absolute';
    iframe.style.top = '-9999px';
    iframe.style.left = '-9999px';
    document.body.appendChild(iframe);
    const doc = iframe.contentWindow.document;
    const style = `<style>@page { margin: 0; } body { font-family: 'Courier New', Courier, monospace; margin: 0; padding: 5mm; width: 70mm; color: #000; } table { width: 100%; border-collapse: collapse; } hr { border-top: 1px dashed #000; opacity: 1; margin: 8px 0; background: none; }</style>`;
    doc.open();
    doc.write('<html><head>' + style + '</head><body>' + receiptContent + '</body></html>');
    doc.close();
    iframe.onload = function() {
        iframe.contentWindow.focus();
        iframe.contentWindow.print();
        setTimeout(() => { document.body.removeChild(iframe); }, 2000);
    };
}

function openOptionsModal(maSP, tenSP) {
    editingCartId = null;
    document.getElementById('btn-confirm-modal').innerHTML = '<i class="bi bi-cart-plus me-2"></i> THÊM VÀO ĐƠN';
    let decodedTenSP = tenSP.replace(/&amp;/g, '&').replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#034;/g, '"').replace(/&#039;/g, "'");
    document.getElementById('modalProductName').innerText = decodedTenSP;
    currentProductVariants = window.allVariants.filter(v => v.maSP === maSP);
    if (currentProductVariants.length === 0) {
        showToast("Sản phẩm này chưa được thiết lập Size để bán!", "danger");
        return;
    }
    let sizeHtml = '';
    currentProductVariants.forEach(function(v, index) {
        let checked = index === 0 ? "checked" : "";
        sizeHtml += `<input type='radio' class='btn-check' name='modalSizeRadio' id='size_${v.maBT}' value='${v.maBT}' ${checked}>
                     <label class='btn btn-outline-primary fw-bold rounded-3 px-3 py-2' for='size_${v.maBT}'>Size ${escapeHTML(v.size)} <br> <small class='text-dark'>${formatCurrency(v.price)}</small></label>`;
    });
    document.getElementById('sizeContainer').innerHTML = sizeHtml;
    document.querySelectorAll('input[id^="tp_qty_"]').forEach(function(inp) { inp.value = 0; });
    document.getElementById('modalDa').value = '100%';
    document.getElementById('modalDuong').value = '100%';
    optionModal.show();
}

function confirmAddToCart() {
    let selectedSizeRadio = document.querySelector('input[name="modalSizeRadio"]:checked');
    if (!selectedSizeRadio) {
        showToast("Vui lòng chọn Size món nước!", "warning");
        return;
    }
    let maBT = selectedSizeRadio.value;
    let selectedVariant = currentProductVariants.find(v => v.maBT === maBT);
    let tenGoc = document.getElementById('modalProductName').innerText;
    let ten = tenGoc + " (Size " + selectedVariant.size + ")";
    let gia = selectedVariant.price;
    let da = document.getElementById('modalDa').value;
    let duong = document.getElementById('modalDuong').value;
    let toppings = [];
    let extraToppingPrice = 0;
    document.querySelectorAll('input[id^="tp_qty_"]').forEach(function(inp) {
        let qty = parseInt(inp.value);
        if (qty > 0) {
            let id = inp.getAttribute('data-id');
            let name = inp.getAttribute('data-name');
            let price = parseInt(inp.getAttribute('data-price'));
            toppings.push({ id: id, name: name, price: price, qty: qty });
            extraToppingPrice += (price * qty);
        }
    });
    let cartId = maBT + "_" + da + "_" + duong;
    if (toppings.length > 0) cartId += "_" + toppings.map(function(t) { return t.id + "-" + t.qty; }).join('_');
    let qtyToSet = 1;
    if (editingCartId) {
        let oldItemIndex = cart.findIndex(i => i.cartId === editingCartId);
        if (oldItemIndex > -1) {
            qtyToSet = cart[oldItemIndex].soLuong;
            cart.splice(oldItemIndex, 1);
        }
        editingCartId = null;
    }
    let existingItem = cart.find(item => item.cartId === cartId);
    if (existingItem) {
        existingItem.soLuong += qtyToSet;
    } else {
        cart.push({ cartId: cartId, maSP: selectedVariant.maSP, tenGoc: tenGoc, maBT: maBT, ten: ten, giaChot: gia + extraToppingPrice, soLuong: qtyToSet, da: da, duong: duong, toppings: toppings });
    }
    optionModal.hide();
    checkVoucherValid();
    renderCart();
}

function renderCart() {
    sessionStorage.setItem('tea_pos_cart', JSON.stringify(cart));
    const container = document.getElementById('cart-items-container');
    container.innerHTML = '';
    if (cart.length === 0) {
        container.innerHTML = `<div class='text-center text-muted mt-5' id='empty-cart-msg'><i class='bi bi-cart-x text-secondary opacity-25' style='font-size: 4rem;'></i><p class='mt-3 fw-medium'>Chưa có món nào được chọn</p></div>`;
        document.getElementById('btn-checkout').disabled = true;
        removeVoucher(true, true);
        document.getElementById('display_tongTienHang').innerText = "0 ₫";
        document.getElementById('display_tienGiamGia').innerText = "- 0 ₫";
        document.getElementById('display_tongPhaiTra').innerText = "0 ₫";
        document.getElementById('input_tongTienHang').value = 0;
        document.getElementById('input_tienGiamGia').value = 0;
        document.getElementById('input_tongPhaiTra').value = 0;
        document.getElementById('row_giamDiem').style.setProperty('display', 'none', 'important');
        isUsingPoints = false;
        if(document.getElementById('toggleDiem')) document.getElementById('toggleDiem').checked = false;
        handlePaymentMethodChange();
        return;
    }
    document.getElementById('btn-checkout').disabled = false;
    let tongTienHang = 0, tienGiamGia = 0, tienGiamDiem = 0, diemThucTeSuDung = 0;
    cart.forEach(function(item) {
        tongTienHang += item.giaChot * item.soLuong;
        let tpStr = "";
        if (item.toppings) {
            // TÍCH HỢP FIX XSS ĐỂ ĐẢM BẢO AN TOÀN
            tpStr = item.toppings.map(t => `<span class='badge bg-warning bg-opacity-10 text-dark border border-warning border-opacity-50 me-1 mb-1'>+${escapeHTML(t.name)} (x${t.qty})</span>`).join('');
        }
        let itemHtml = `<div class='p-3 border-bottom bg-white'><div class='d-flex justify-content-between align-items-start'><div class='flex-grow-1 pe-2'><h6 class='mb-1 fw-bold text-dark'>${escapeHTML(item.ten)}</h6><div class='small text-muted mb-2 fw-medium'>Đá: ${escapeHTML(item.da)} &bull; Đường: ${escapeHTML(item.duong)}</div><div class='d-flex flex-wrap'>${tpStr}</div></div><div class='text-end'><h6 class='mb-1 fw-bold text-danger'>${formatCurrency(item.giaChot * item.soLuong)}</h6><small class='text-muted'>${formatCurrency(item.giaChot)}/ly</small></div></div><div class='d-flex justify-content-between align-items-center mt-3'><div><a href='javascript:void(0)' class='text-primary small text-decoration-none me-3 fw-bold' onclick="editCartItem('${item.cartId}')"><i class='bi bi-pencil-square'></i> Sửa</a><a href='javascript:void(0)' class='text-danger small text-decoration-none fw-bold' onclick="updateQty('${item.cartId}', -999)"><i class='bi bi-trash'></i> Xóa</a></div><div class='btn-group btn-group-sm shadow-sm'><button type='button' class='btn btn-light border fw-bold px-3' onclick="updateQty('${item.cartId}', -1)"><i class='bi bi-dash-lg'></i></button><span class='btn btn-white border fw-bold px-3 text-primary' style='pointer-events: none; background: #fff;'>${item.soLuong}</span><button type='button' class='btn btn-light border fw-bold px-3' onclick="updateQty('${item.cartId}', 1)"><i class='bi bi-plus-lg'></i></button></div></div></div>`;
        container.insertAdjacentHTML('beforeend', itemHtml);
    });
    if (currentVoucher) {
        tienGiamGia = currentVoucher.loai === 'Phần Trăm' ? (tongTienHang * currentVoucher.giaTri) / 100 : currentVoucher.giaTri;
        if(tienGiamGia > tongTienHang) tienGiamGia = tongTienHang;
        document.getElementById('input_maKM').value = currentVoucher.id;
    }
    let tienSauVoucher = tongTienHang - tienGiamGia;
    if (isUsingPoints && customerPoints > 0) {
        let maxPointsCanUse = Math.floor(tienSauVoucher / 1000);
        diemThucTeSuDung = (customPointsToUse > maxPointsCanUse) ? maxPointsCanUse : customPointsToUse;
        tienGiamDiem = diemThucTeSuDung * 1000;
        document.getElementById('row_giamDiem').style.setProperty('display', 'flex', 'important');
        document.getElementById('display_giamDiem').innerText = "- " + formatCurrency(tienGiamDiem);
    } else {
        document.getElementById('row_giamDiem').style.setProperty('display', 'none', 'important');
    }
    let tongPhaiTra = tienSauVoucher - tienGiamDiem;
    document.getElementById('display_tongTienHang').innerText = formatCurrency(tongTienHang);
    document.getElementById('display_tienGiamGia').innerText = "- " + formatCurrency(tienGiamGia);
    document.getElementById('display_tongPhaiTra').innerText = formatCurrency(tongPhaiTra);
    document.getElementById('input_tongTienHang').value = tongTienHang;
    document.getElementById('input_tienGiamGia').value = tienGiamGia;
    document.getElementById('input_diemSuDung').value = diemThucTeSuDung;
    document.getElementById('input_tongPhaiTra').value = tongPhaiTra;
    handlePaymentMethodChange();
}

function clearCart() {
    if(cart.length === 0) return;
    showConfirmAction("Xóa Giỏ Hàng", "Bạn có chắc chắn muốn xóa toàn bộ giỏ hàng hiện tại?", function() {
        cart = [];
        sessionStorage.removeItem('tea_pos_cart');
        document.getElementById('tienKhachDua').value = '';
        document.getElementById('sdtKhachHang').value = '';
        document.getElementById('tenKhachHang').value = '';
        document.getElementById('customerInfoPanel').style.display = 'none';
        customerPoints = 0; isUsingPoints = false; customPointsToUse = 0;
        renderCart();
    });
}

function updateQty(cartId, change) {
    let idx = cart.findIndex(i => i.cartId === cartId);
    if (idx > -1) {
        cart[idx].soLuong += change;
        if (cart[idx].soLuong <= 0) cart.splice(idx, 1);
    }
    checkVoucherValid();
    isUsingPoints ? calculateCustomPoints() : renderCart();
}

function changeModalTpQty(id, amount) {
    let input = document.getElementById('tp_qty_' + id);
    let val = parseInt(input.value) + amount;
    if(val >= 0) input.value = val;
}

function checkAndApplyVoucher() {
    let codeInput = document.getElementById('inputVoucherCode').value.trim().toUpperCase();
    if (codeInput === '') { showToast("Vui lòng nhập mã giảm giá!", "danger"); return; }
    let found = window.availableVouchers.find(v => v.code === codeInput);
    if (found) {
        let tongTienHang = cart.reduce((sum, item) => sum + (item.giaChot * item.soLuong), 0);
        if (tongTienHang >= found.min) {
            currentVoucher = found;
            document.getElementById('activeVoucherInfo').style.display = 'block';
            document.getElementById('voucherLabel').innerText = escapeHTML(found.code);
            document.getElementById('inputVoucherCode').value = '';
            isUsingPoints ? calculateCustomPoints() : renderCart();
        } else {
            showToast('Đơn hàng chưa đạt mức tối thiểu ' + formatCurrency(found.min) + ' để áp dụng mã!', "danger");
        }
    } else {
        showToast("Mã không hợp lệ hoặc đã hết lượt dùng!", "danger");
    }
}

function removeVoucher(skipRender = false, silent = false) {
    currentVoucher = null;
    document.getElementById('input_maKM').value = '';
    document.getElementById('activeVoucherInfo').style.display = 'none';
    if(!skipRender) { isUsingPoints ? calculateCustomPoints() : renderCart(); }
}

function checkVoucherValid() {
    if(currentVoucher) {
        let tongTest = cart.reduce((sum, item) => sum + (item.giaChot * item.soLuong), 0);
        if(tongTest < currentVoucher.min) removeVoucher(true, true);
    }
}

function handlePaymentMethodChange() {
    let ptttSelect = document.getElementById('select_pttt');
    let ptttName = ptttSelect.options[ptttSelect.selectedIndex].text.toLowerCase();
    let tienKhachDuaInput = document.getElementById('tienKhachDua');
    let phaiTra = parseInt(document.getElementById('input_tongPhaiTra').value) || 0;
    if (ptttName.includes("tiền mặt") || ptttName.includes("cash")) {
        tienKhachDuaInput.readOnly = false;
        tienKhachDuaInput.classList.remove('bg-light');
        if(tienKhachDuaInput.value == phaiTra) tienKhachDuaInput.value = '';
    } else {
        tienKhachDuaInput.readOnly = true;
        tienKhachDuaInput.classList.add('bg-light');
        tienKhachDuaInput.value = phaiTra;
    }
    calculateChange();
}

function calculateChange() {
    let khachDua = parseInt(document.getElementById('tienKhachDua').value) || 0;
    let phaiTra = parseInt(document.getElementById('input_tongPhaiTra').value) || 0;
    let ptttSelect = document.getElementById('select_pttt');
    let ptttName = ptttSelect.options[ptttSelect.selectedIndex].text.toLowerCase();
    let container = document.getElementById('tienThuaContainer');
    if ((ptttName.includes("tiền mặt") || ptttName.includes("cash")) && khachDua >= phaiTra && phaiTra > 0) {
        container.style.display = 'block';
        document.getElementById('tienThuaLabel').innerText = formatCurrency(khachDua - phaiTra);
    } else {
        container.style.display = 'none';
    }
}

function validateCheckout(event) {
    event.preventDefault();
    let khachDua = parseInt(document.getElementById('tienKhachDua').value);
    let phaiTra = parseInt(document.getElementById('input_tongPhaiTra').value);
    if (!khachDua || khachDua < phaiTra) {
        showToast("Số tiền khách không đủ để thanh toán hóa đơn!", "danger");
        return false;
    }
    const h = document.getElementById('hidden-cart-inputs');
    h.innerHTML = '';
    cart.forEach(function(item, idx) {
        let inputs = `<input type='hidden' name='itemIndex[]' value='${idx}'><input type='hidden' name='tenMon_${idx}' value='${escapeHTML(item.ten)}'><input type='hidden' name='maBT_${idx}' value='${item.maBT}'><input type='hidden' name='soLuong_${idx}' value='${item.soLuong}'><input type='hidden' name='giaChot_${idx}' value='${item.giaChot}'><input type='hidden' name='da_${idx}' value='${escapeHTML(item.da)}'><input type='hidden' name='duong_${idx}' value='${escapeHTML(item.duong)}'>`;
        item.toppings.forEach(function(tp) { inputs += `<input type='hidden' name='toppings_${idx}[]' value='${tp.id}|${tp.qty}|${tp.price}|${escapeHTML(tp.name)}'>`; });
        h.insertAdjacentHTML('beforeend', inputs);
    });
    let ptttName = document.getElementById('select_pttt').options[document.getElementById('select_pttt').selectedIndex].text.toLowerCase();
    if (ptttName.includes("tiền mặt") || ptttName.includes("cash")) {
        showConfirmAction("Xác Nhận Thanh Toán", `Thu đủ ${formatCurrency(khachDua)} tiền mặt?`, () => document.getElementById('checkout-form').submit());
    } else {
        document.getElementById('qrAmount').innerText = formatCurrency(phaiTra);
        let transactionCode = "TEA" + new Date().getFullYear().toString().slice(-2) + String(new Date().getMonth() + 1).padStart(2, '0') + String(new Date().getDate()).padStart(2, '0') + Math.floor(1000 + Math.random() * 9000);
        document.getElementById('qrCodeDisplay').innerText = transactionCode;
        document.getElementById('qrImage').src = `https://img.vietqr.io/image/TPB-0346406405-compact2.png?amount=${phaiTra}&addInfo=${transactionCode}`;
        document.getElementById('qrSuccessOverlay').style.setProperty('display', 'none', 'important');
        document.getElementById('qrLoadingStatus').style.setProperty('display', 'flex', 'important');
        if (checkPaymentInterval) clearInterval(checkPaymentInterval);
        qrModal.show();
        checkPaymentInterval = setInterval(function() {
            fetch(appBasePath + '/api/check-payment?code=' + transactionCode).then(response => response.json()).then(data => {
                if (data.status === 'success') {
                    clearInterval(checkPaymentInterval);
                    document.getElementById('qrLoadingStatus').style.setProperty('display', 'none', 'important');
                    document.getElementById('qrSuccessOverlay').style.setProperty('display', 'flex', 'important');
                    setTimeout(() => { qrModal.hide(); document.getElementById('checkout-form').submit(); }, 1500);
                }
            });
        }, 3000);
    }
    return false;
}

function cancelQRPayment() { if (checkPaymentInterval) clearInterval(checkPaymentInterval); qrModal.hide(); }
function forceSubmitCheckout() { if (checkPaymentInterval) clearInterval(checkPaymentInterval); qrModal.hide(); document.getElementById('checkout-form').submit(); }

function checkCustomerPhone() {
    let phone = document.getElementById('sdtKhachHang').value;
    document.getElementById('toggleDiem').checked = false; isUsingPoints = false; customerPoints = 0; customPointsToUse = 0;
    if (phone.length >= 10) {
        fetch(appBasePath + '/ban-hang?action=check-phone&phone=' + phone).then(res => res.json()).then(data => {
            if (data.found) {
                document.getElementById('tenKhachHang').value = data.tenKH;
                document.getElementById('tenKhachHang').readOnly = true;
                document.getElementById('lblTenKH').innerText = data.tenKH;
                document.getElementById('lblDiem').innerText = data.diem;
                customerPoints = parseInt(data.diem);
                document.getElementById('customerInfoPanel').style.display = 'block';
                document.getElementById('newCustomerPanel').style.display = 'none';
            } else {
                document.getElementById('tenKhachHang').value = '';
                document.getElementById('tenKhachHang').readOnly = false;
                document.getElementById('customerInfoPanel').style.display = 'none';
                document.getElementById('newCustomerPanel').style.display = 'block';
            }
            renderCart();
        });
    } else {
        document.getElementById('tenKhachHang').readOnly = false;
        document.getElementById('customerInfoPanel').style.display = 'none';
        document.getElementById('newCustomerPanel').style.display = 'none';
        renderCart();
    }
}

function applyPoints() {
    isUsingPoints = document.getElementById('toggleDiem').checked;
    if(isUsingPoints) { document.getElementById('nhapDiemContainer').style.display = 'flex'; useMaxPoints(); }
    else { document.getElementById('nhapDiemContainer').style.display = 'none'; customPointsToUse = 0; document.getElementById('input_nhapDiemTay').value = 0; }
    renderCart();
}

function getMaxAllowedPoints() {
    let tongHang = cart.reduce((sum, item) => sum + (item.giaChot * item.soLuong), 0);
    let giamVoucher = 0;
    if (currentVoucher && tongHang >= currentVoucher.min) {
        giamVoucher = currentVoucher.loai === 'Phần Trăm' ? (tongHang * currentVoucher.giaTri) / 100 : currentVoucher.giaTri;
    }
    let maxPointsForBill = Math.floor((tongHang - giamVoucher) / 1000);
    return (customerPoints > maxPointsForBill) ? maxPointsForBill : customerPoints;
}

function calculateCustomPoints() {
    let inputVal = parseInt(document.getElementById('input_nhapDiemTay').value) || 0;
    let maxAllowed = getMaxAllowedPoints();
    if (inputVal > maxAllowed) inputVal = maxAllowed;
    document.getElementById('input_nhapDiemTay').value = inputVal;
    customPointsToUse = inputVal;
    renderCart();
}

function useMaxPoints() { document.getElementById('input_nhapDiemTay').value = getMaxAllowedPoints(); customPointsToUse = getMaxAllowedPoints(); renderCart(); }