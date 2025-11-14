import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackance/core/constants/app_constants.dart';
import 'package:trackance/core/utils/formatters.dart';
import 'package:trackance/presentation/providers/master_data_providers.dart';
import 'package:trackance/presentation/providers/transaction_providers.dart';

class PaymentDetailsPopup extends ConsumerStatefulWidget {
  final double amount;
  final String paymentMethod;
  final VoidCallback onSuccess;

  const PaymentDetailsPopup({
    required this.amount,
    required this.paymentMethod,
    required this.onSuccess,
    super.key,
  });

  @override
  ConsumerState<PaymentDetailsPopup> createState() =>
      _PaymentDetailsPopupState();
}

class _PaymentDetailsPopupState extends ConsumerState<PaymentDetailsPopup> {
  late TextEditingController _notesController;
  String? _selectedCategory;
  String? _selectedPerson;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    final persons = ref.watch(personsProvider);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Payment Details',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              _buildAmountDisplay(),
              const SizedBox(height: AppSpacing.md),
              _buildPaymentMethodDisplay(),
              const SizedBox(height: AppSpacing.lg),
              _buildCategoryDropdown(categories),
              const SizedBox(height: AppSpacing.md),
              _buildPersonDropdown(persons),
              const SizedBox(height: AppSpacing.md),
              _buildNotesField(),
              const SizedBox(height: AppSpacing.lg),
              _buildActionButtons(ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountDisplay() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.primary),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Amount', style: Theme.of(context).textTheme.bodyMedium),
          Text(
            NumberUtils.formatCurrency(widget.amount),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodDisplay() {
    const methodIcons = {
      'upi': '📱 UPI',
      'card': '💳 Card',
      'qr': '📲 QR Code',
      'cash': '💵 Cash',
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Payment Method', style: Theme.of(context).textTheme.bodyMedium),
          Text(
            methodIcons[widget.paymentMethod] ?? widget.paymentMethod,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown(List<dynamic> categories) {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      hint: const Text('Select Category'),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      items: categories
          .map(
            (cat) => DropdownMenuItem(
              value: cat.id as String,
              child: Text('${cat.icon} ${cat.name}'),
            ),
          )
          .toList(),
      onChanged: (value) => setState(() => _selectedCategory = value),
    );
  }

  Widget _buildPersonDropdown(List<dynamic> persons) {
    return DropdownButtonFormField<String>(
      value: _selectedPerson,
      hint: const Text('Paid to Whom?'),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      items: persons
          .map(
            (person) => DropdownMenuItem(
              value: person.id as String,
              child: Text('${person.avatar} ${person.name}'),
            ),
          )
          .toList(),
      onChanged: (value) => setState(() => _selectedPerson = value),
    );
  }

  Widget _buildNotesField() {
    return TextField(
      controller: _notesController,
      maxLines: 2,
      decoration: InputDecoration(
        labelText: 'Notes (Optional)',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }

  Widget _buildActionButtons(WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: ElevatedButton(
            onPressed: () => _submitPayment(ref),
            child: const Text('Save'),
          ),
        ),
      ],
    );
  }

  void _submitPayment(WidgetRef ref) {
    if (_selectedCategory == null || _selectedPerson == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select category and person')),
      );
      return;
    }

    ref
        .read(transactionsProvider.notifier)
        .addTransaction(
          amount: widget.amount,
          categoryId: _selectedCategory!,
          personId: _selectedPerson!,
          paymentMethod: widget.paymentMethod,
          notes: _notesController.text,
        );

    Navigator.pop(context);
    widget.onSuccess();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment recorded successfully')),
    );
  }
}
