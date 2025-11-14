import 'package:flutter/material.dart';
import 'package:trackance/core/constants/app_constants.dart';
import 'package:trackance/core/services/razorpay_payment_service.dart';

class PaymentInitiationScreen extends StatefulWidget {
  final Function(double amount, String paymentMethod) onPaymentComplete;

  const PaymentInitiationScreen({required this.onPaymentComplete, super.key});

  @override
  State<PaymentInitiationScreen> createState() =>
      _PaymentInitiationScreenState();
}

class _PaymentInitiationScreenState extends State<PaymentInitiationScreen> {
  late TextEditingController _amountController;
  String? _selectedMethod;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Make Payment'),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAmountSection(),
              const SizedBox(height: AppSpacing.xl),
              _buildPaymentMethodsSection(),
              const SizedBox(height: AppSpacing.xl),
              _buildPayButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter Amount',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border, width: 2),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixText: '₹ ',
              prefixStyle: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              hintText: '0.00',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodsSection() {
    const methods = [
      {
        'id': 'upi',
        'name': 'UPI',
        'icon': '📱',
        'description': 'Google Pay, PhonePe, BHIM',
      },
      {
        'id': 'card',
        'name': 'Debit/Credit Card',
        'icon': '💳',
        'description': 'Visa, Mastercard, RuPay',
      },
      {
        'id': 'qr',
        'name': 'Scan QR Code',
        'icon': '📲',
        'description': 'Scan merchant QR code',
      },
      {
        'id': 'cash',
        'name': 'Cash',
        'icon': '💵',
        'description': 'Pay in cash',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Payment Method',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.md),
        ...methods.map((method) => _buildPaymentMethodCard(method)).toList(),
      ],
    );
  }

  Widget _buildPaymentMethodCard(Map<String, String> method) {
    final isSelected = _selectedMethod == method['id'];

    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = method['id']),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          color: isSelected
              ? AppColors.primary.withOpacity(0.05)
              : AppColors.surface,
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Center(
                child: Text(
                  method['icon']!,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method['name']!,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    method['description']!,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 16),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isProcessing ? null : _processPayment,
        child: _isProcessing
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : const Text(
                'Proceed to Payment',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  void _processPayment() async {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter an amount')));
      return;
    }

    if (_selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a payment method')),
      );
      return;
    }

    final amount = double.parse(_amountController.text);

    if (_selectedMethod == 'qr' || _selectedMethod == 'cash') {
      _handleSimulatedPayment(amount);
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final paymentService = RazorpayPaymentService();

      final success = await paymentService.initiatePayment(
        amount: amount,
        description: 'Payment via Trackance',
        email: 'user@trackance.app',
        phone: '+919999999999',
        onSuccess: (response) {
          print('Payment successful: $response');
          setState(() => _isProcessing = false);
          widget.onPaymentComplete(amount, _selectedMethod!);
        },
        onError: (error) {
          print('Payment failed: $error');
          setState(() => _isProcessing = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Payment failed: ${error['message'] ?? 'Unknown error'}',
              ),
            ),
          );
        },
      );

      if (!success) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to open payment gateway')),
        );
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _handleSimulatedPayment(double amount) {
    setState(() => _isProcessing = true);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isProcessing = false);
        widget.onPaymentComplete(amount, _selectedMethod!);
      }
    });
  }
}
