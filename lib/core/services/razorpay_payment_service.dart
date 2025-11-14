import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayPaymentService {
  static final _instance = Razorpay();

  static const String testKeyId = 'rzp_test_1DP5mmOlF5G5ag';
  static const String testKeySecret = 'SkJYODJHajBjdDVsSjAwTDJJNWRRcg==';

  late Function(Map<String, dynamic>)? _onSuccess;
  late Function(Map<String, dynamic>)? _onError;

  RazorpayPaymentService() {
    _instance.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _instance.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _instance.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<bool> initiatePayment({
    required double amount,
    required String description,
    required String email,
    required String phone,
    required Function(Map<String, dynamic>) onSuccess,
    required Function(Map<String, dynamic>) onError,
  }) async {
    try {
      final options = {
        'key': testKeyId,
        'amount': (amount * 100).toInt(),
        'name': 'Trackance',
        'description': description,
        'prefill': {'contact': phone, 'email': email},
        'external': {
          'wallets': ['paytm'],
        },
      };

      _onSuccess = onSuccess;
      _onError = onError;

      _instance.open(options);
      return true;
    } catch (e) {
      print('Error opening payment gateway: $e');
      return false;
    }
  }

  void _handlePaymentSuccess(dynamic response) {
    print('Payment Success: $response');
    final Map<String, dynamic> data = {
      'paymentId': response.paymentId,
      'signature': response.signature,
    };
    _onSuccess?.call(data);
  }

  void _handlePaymentError(dynamic response) {
    print('Payment Error: ${response.code} - ${response.message}');
    final Map<String, dynamic> data = {
      'code': response.code,
      'message': response.message,
    };
    _onError?.call(data);
  }

  void _handleExternalWallet(dynamic response) {
    print('External Wallet: ${response.walletName}');
  }

  void dispose() {
    _instance.clear();
  }
}
