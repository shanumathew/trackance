import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackance/presentation/screens/dashboard_screen.dart';
import 'package:trackance/presentation/screens/payment_initiation_screen.dart';
import 'package:trackance/presentation/widgets/payment_details_popup.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _showDashboard = true;

  @override
  Widget build(BuildContext context) {
    return _showDashboard
        ? Stack(
            children: [
              const DashboardScreen(),
              Positioned(
                bottom: 24,
                right: 24,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 12,
                  children: [
                    FloatingActionButton.extended(
                      heroTag: 'record_payment',
                      onPressed: () {
                        setState(() => _showDashboard = false);
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('New Payment'),
                    ),
                  ],
                ),
              ),
            ],
          )
        : PaymentInitiationScreen(
            onPaymentComplete: (amount, paymentMethod) {
              _showPaymentDetailsPopup(context, amount, paymentMethod);
            },
          );
  }

  void _showPaymentDetailsPopup(
    BuildContext context,
    double amount,
    String paymentMethod,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PaymentDetailsPopup(
        amount: amount,
        paymentMethod: paymentMethod,
        onSuccess: () {
          setState(() => _showDashboard = true);
          Navigator.pop(context);
        },
      ),
    );
  }
}
