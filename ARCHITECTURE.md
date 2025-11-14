# Trackance - Payment Tracking App

A production-ready Flutter payment tracking application with clean architecture, built-in analytics, budget management, and Razorpay payment integration.

## Architecture Overview

### Clean Architecture Layers

```
lib/
├── core/                          # Core functionality (independent of features)
│   ├── constants/
│   │   └── app_constants.dart    # Colors, spacing, typography
│   ├── services/
│   │   └── razorpay_payment_service.dart  # Payment gateway
│   └── utils/
│       ├── formatters.dart       # Date, number formatting
│       └── dummy_data_initializer.dart
│
├── data/                          # Data layer
│   ├── models/
│   │   ├── category_model.dart
│   │   ├── person_model.dart
│   │   ├── transaction_model.dart
│   │   ├── budget_model.dart
│   │   └── spending_summary.dart
│   ├── datasources/
│   │   ├── hive_init.dart
│   │   ├── transaction_data_source.dart
│   │   ├── category_data_source.dart
│   │   ├── person_data_source.dart
│   │   └── budget_data_source.dart
│   └── repositories/
│       ├── transaction_repository.dart
│       ├── category_repository.dart
│       ├── person_repository.dart
│       └── budget_repository.dart
│
├── domain/                        # Business logic layer
│   └── usecases/
│       ├── transaction_use_case.dart
│       └── analytics_use_case.dart
│
├── presentation/                  # UI layer
│   ├── providers/
│   │   ├── repository_providers.dart    # Dependency injection
│   │   ├── transaction_providers.dart   # State management
│   │   └── master_data_providers.dart
│   ├── screens/
│   │   ├── home_screen.dart            # Entry point / navigation
│   │   ├── payment_initiation_screen.dart
│   │   ├── dashboard_screen.dart
│   │   └── transactions_screen.dart
│   └── widgets/
│       ├── payment_details_popup.dart
│       ├── summary_card.dart
│       ├── budget_progress_card.dart
│       └── transaction_tile.dart
│
└── main.dart                      # App entry
```

## User Flow

1. **Home Screen** → Shows Dashboard or Payment Screen
2. **Payment Initiation Screen**
   - Enter amount
   - Select payment method (UPI, Card, QR, Cash)
   - For UPI/Card → Razorpay payment gateway
   - For QR/Cash → Simulated payment
3. **Payment Details Popup** (Post-payment)
   - Amount (pre-filled, read-only)
   - Payment Method (pre-filled, read-only)
   - Category selection (dropdown)
   - Person selection (dropdown)
   - Optional notes
4. **Dashboard** (After saving)
   - Summary: Today & This Month totals
   - Budget Status: Category-wise spending vs limits
   - Recent Transactions: Last 5 transactions
   - Long-press to delete
5. **View All Transactions** → Full transaction list with swipe-to-delete

## Data Models

### Transaction
```dart
class TransactionModel {
  String id;
  double amount;
  String categoryId;
  String personId;
  String paymentMethod;
  String notes;
  DateTime timestamp;    // When payment happened
  DateTime createdAt;    // When recorded
}
```

### Category
```dart
class CategoryModel {
  String id;
  String name;
  String icon;           // Emoji
  String color;          // Hex color
  int monthlyBudget;     // In rupees
}
```

### Budget Status (Calculated)
```dart
class BudgetStatus {
  double spent;
  double remaining;
  double percentage;     // 0-100
  bool isExceeded;
}
```

## State Management (Riverpod)

- **Providers**: Dependency injection for repositories & use cases
- **StateNotifiers**: TransactionNotifier, CategoriesNotifier, PersonsNotifier
- **FutureProviders**: monthlySummaryProvider, dailySummaryProvider

```dart
// Example: Adding a transaction triggers state refresh
ref.read(transactionsProvider.notifier).addTransaction(...)
```

## Database (Hive)

Local NoSQL storage with 4 boxes:
- **transactions**: All payment records
- **categories**: Category definitions (pre-loaded)
- **persons**: People paid to (pre-loaded)
- **budgets**: Monthly budget limits per category

No internet required for local operations.

## Payment Integration (Razorpay)

### Test Mode Details
- **Key ID**: `rzp_test_1DP5mmOlF5G5ag`
- **Test Cards**:
  - Success: `4111 1111 1111 1111` (Exp: 12/25, CVV: 123)
  - Failure: `4000 0000 0000 0002`
- **Test UPI**: `success@razorpay`
- **Amount**: Converted to paise (₹100 → 10000)

### Payment Methods
| Method | Behavior |
|--------|----------|
| UPI    | Opens Razorpay gateway |
| Card   | Opens Razorpay gateway |
| QR Code| Simulated (2s delay) |
| Cash   | Simulated (2s delay) |

## Analytics & Calculations

### AnalyticsUseCase
- Daily total spending
- Monthly total spending
- Yearly total spending
- Category-wise breakdown
- Person-wise breakdown
- Budget status calculation
- Predicted budget (3-month average × 1.2)

### Logic
```dart
// Monthly budget = average of last 3 months × 1.2 (buffer)
// Exceeded = spent > monthlyLimit
// Percentage = (spent / limit) × 100, clamped 0-100
```

## Setup Instructions

### 1. Prerequisites
```bash
flutter --version  # 3.10+
dart --version     # 3.9+
```

### 2. Install Dependencies
```bash
flutter pub get
dart run build_runner build
```

### 3. Run App
```bash
# Android
flutter run -d emulator-5554

# iOS
flutter run -d iPhone

# Web
flutter run -w
```

### 4. Razorpay Setup (Optional)
For real payments, replace keys in `lib/core/services/razorpay_payment_service.dart`:
```dart
static const String testKeyId = 'YOUR_KEY_ID';
static const String testKeySecret = 'YOUR_KEY_SECRET';
```

Get from: https://dashboard.razorpay.com/app/keys

## Testing

### Mock Data
- 8 default transactions (today, yesterday, 3/5 days ago)
- 7 categories with budgets
- 8 sample persons/merchants

### Test Cases
1. View dashboard summary
2. Make payment (each method)
3. Add transaction details
4. View transactions list
5. Delete transaction (swipe/long-press)
6. View budget status
7. Navigate between screens

## Key Features

✅ **Instant Recording**: Payment → Form → Dashboard in seconds
✅ **Smart Calculations**: Auto-calculate spending, budgets, predictions
✅ **Budget Alerts**: Visual indicators when spending exceeds limits
✅ **Multiple Payments**: UPI, Card, QR, Cash
✅ **Offline-First**: Works without internet (Hive storage)
✅ **Clean Architecture**: Testable, scalable, maintainable
✅ **Riverpod State**: Reactive UI updates
✅ **Production Ready**: Error handling, null safety, best practices

## Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_riverpod` | State management |
| `hive` | Local database |
| `razorpay_flutter` | Payment gateway |
| `intl` | Date/time formatting |
| `uuid` | Unique IDs |
| `fl_chart` | Analytics charts (future) |

## Folder Structure Best Practices

- **core**: Never imports from data/domain/presentation
- **data**: Only imports from core, exposes repositories
- **domain**: Imports from data, contains business logic
- **presentation**: Imports from domain, presentation layer
- No circular imports ✓

## Future Enhancements

1. UPI/Payment App Deeplinks
2. Analytics Dashboard with Charts
3. Budget Alerts & Notifications
4. Monthly Reports (PDF export)
5. Multi-currency Support
6. Cloud Sync (Firebase)
7. Expense Sharing Features
8. Receipt Image Attachment

## Production Checklist

- [ ] Replace Razorpay test keys with live keys
- [ ] Add proper error logging (Sentry/Firebase)
- [ ] Implement SSL certificate pinning
- [ ] Add app signing & build configuration
- [ ] Test on physical devices
- [ ] Performance profiling (DevTools)
- [ ] Add analytics (Google Analytics)
- [ ] Implement proper authentication
- [ ] Add data encryption for sensitive fields
- [ ] Create proper app store listings

## License

MIT License - Open Source

---

**Built with ❤️ using Flutter & Clean Architecture**
