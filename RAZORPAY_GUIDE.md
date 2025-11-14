# Razorpay Integration Guide

## Overview
This app integrates Razorpay for real payment processing with test mode support for development.

## Test Mode Setup (No Real Money)

### 1. Test API Keys (Already Configured)
The app comes with test API keys:
- **Key ID**: `rzp_test_1DP5mmOlF5G5ag`
- **Key Secret**: `SkJYODJHajBjdDVsSjAwTDJJNWRRcg==`

These are safe for development and no real charges occur.

### 2. Test Payment Details

#### Test Debit/Credit Cards
| Type | Card Number | Exp | CVV | Result |
|------|-------------|-----|-----|--------|
| Visa Success | 4111 1111 1111 1111 | 12/25 | 123 | ✓ Success |
| Visa Failure | 4000 0000 0000 0002 | 12/25 | 123 | ✗ Failure |
| Mastercard | 5555 5555 5555 4444 | 12/25 | 123 | ✓ Success |

#### Test UPI IDs
- `success@razorpay` → Success
- `failure@razorpay` → Failure
- `otp@razorpay` → OTP required

#### Test PhonePe/Google Pay
Any test card works with simulated apps.

### 3. Using Test Mode

1. Run the app:
```bash
flutter run
```

2. Go to "Make Payment"
3. Enter any amount (e.g., ₹100)
4. Select "UPI" or "Debit/Credit Card"
5. Fill payment details:
   - Email: any@example.com (default: user@trackance.app)
   - Phone: any number (default: +919999999999)
6. Complete payment with test details above

### 4. Verify Test Transactions

Test transactions appear in:
- Razorpay Dashboard (test mode): https://dashboard.razorpay.com/app/invoices
- You'll see mock transaction ID like `pay_xxxxx` (test)

## Moving to Production

### Step 1: Create Razorpay Account
1. Go to https://razorpay.com
2. Sign up and complete KYC verification
3. Get approval (24-48 hours)

### Step 2: Get Live API Keys
1. Login to https://dashboard.razorpay.com
2. Go to Settings → API Keys
3. Copy Live Key ID & Secret

### Step 3: Update App Configuration
File: `lib/core/services/razorpay_payment_service.dart`

```dart
// Change from TEST to LIVE
static const String testKeyId = 'rzp_live_YOUR_LIVE_KEY';      // ← Update
static const String testKeySecret = 'YOUR_LIVE_SECRET';         // ← Update
```

### Step 4: Build Release APK/IPA
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

### Step 5: Submit to App Stores
- Google Play Store
- Apple App Store

**⚠️ WARNING**: Live keys will charge real money. Test thoroughly first!

## Implementation Details

### File: `lib/core/services/razorpay_payment_service.dart`

```dart
class RazorpayPaymentService {
  Future<bool> initiatePayment({
    required double amount,                    // In rupees
    required String description,               // Payment purpose
    required String email,                     // Customer email
    required String phone,                     // Customer phone
    required Function(Map<String, dynamic>) onSuccess,
    required Function(Map<String, dynamic>) onError,
  }) async {
    // amount * 100 = paise (₹100 → 10000)
    // Opens Razorpay checkout
  }
}
```

### Payment Flow in `payment_initiation_screen.dart`

```dart
1. User enters amount & selects payment method
2. _processPayment() called
3. For UPI/Card → RazorpayPaymentService.initiatePayment()
4. For QR/Cash → _handleSimulatedPayment() (2s delay)
5. On success → Payment details popup
6. User enters category, person, notes
7. Transaction saved to Hive
8. Back to dashboard
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "Payment gateway not opening" | Check internet connection |
| "Invalid API key" | Verify keys in razorpay_payment_service.dart |
| "Amount too low" | Minimum ₹1 for test |
| "Test transaction not showing" | Wait 2-3 seconds, refresh dashboard |
| "Payment failed with error" | Check error message in app |

## Testing Checklist

- [ ] Test amount validation (empty, zero, negative)
- [ ] Test all payment methods
- [ ] Test test card success flow
- [ ] Test test card failure flow  
- [ ] Test UPI success/failure
- [ ] Test successful transaction saving
- [ ] Test form validation after payment
- [ ] Test transaction appears in dashboard
- [ ] Test transaction deletion
- [ ] Test category-wise budget calculation

## Security Notes

⚠️ **For Production Only**:
1. Never commit live API keys to git
2. Use environment variables or secure config
3. Implement proper error logging (don't log sensitive data)
4. Validate amounts server-side
5. Implement SSL certificate pinning
6. Store payment IDs, not card details
7. Implement PCI DSS compliance
8. Add fraud detection

## References

- Razorpay Docs: https://razorpay.com/docs
- Flutter Plugin: https://pub.dev/packages/razorpay_flutter
- Test Environment: https://razorpay.com/docs/payments/test-mode/

---

**Current Mode**: TEST (Safe for Development)
**Real Charges**: ❌ Disabled
**Test Transactions**: ✓ Supported
