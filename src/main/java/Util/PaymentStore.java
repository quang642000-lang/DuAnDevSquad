package Util;

import java.util.concurrent.ConcurrentHashMap;

public class PaymentStore {
    // Lưu mã giao dịch Webhook gửi tới. VD: "TEA12345" -> true
    public static final ConcurrentHashMap<String, Boolean> transactions = new ConcurrentHashMap<>();
}