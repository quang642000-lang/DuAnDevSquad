<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Xác Thực OTP</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body class="bg-light d-flex align-items-center vh-100">
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-4">
            <div class="card shadow-sm border-0 rounded-3">
                <div class="card-header bg-primary text-white text-center py-3">
                    <h4 class="mb-0 fw-bold"><i class="bi bi-shield-check"></i> XÁC THỰC OTP</h4>
                </div>
                <div class="card-body p-4">
                    <div class="alert alert-success small text-center mb-4">
                        Mã OTP gồm 6 chữ số đã được gửi đến email:<br>
                        <strong>${sessionScope.reset_email}</strong>
                    </div>

                    <c:if test="${not empty requestScope.error}">
                        <div class="alert alert-danger shadow-sm"><i class="bi bi-exclamation-triangle-fill"></i> ${requestScope.error}</div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/auth" method="post">
                        <!-- Action để kiểm tra OTP -->
                        <input type="hidden" name="action" value="verify-otp">

                        <div class="mb-4">
                            <label class="form-label fw-bold">Nhập Mã OTP</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-123"></i></span>
                                <input type="text" class="form-control text-center fw-bold fs-4 tracking-widest" name="otpInput" placeholder=" _ _ _ _ _ _ " required pattern="\d{6}" maxlength="6">
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary w-100 fw-bold py-2">
                            Xác Nhận & Tiếp Tục <i class="bi bi-arrow-right-circle"></i>
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>