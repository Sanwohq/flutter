# Sanwo Flutter

Sanwo payment SDK for Flutter — one interface for every payment provider.

## Installation

Add `sanwo_flutter` and a provider package to your `pubspec.yaml`:

```yaml
dependencies:
  sanwo_flutter: ^0.1.0
  sanwo_paystack: ^0.1.0   # or sanwo_flutterwave
```

Then run:

```bash
flutter pub get
```

## Platform Setup

### Android

Add internet permission to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

Set the minimum SDK version in `android/app/build.gradle`:

```groovy
android {
    defaultConfig {
        minSdkVersion 20
    }
}
```

### iOS

No additional setup required.

## Quick Start

```dart
import 'package:sanwo_flutter/sanwo_flutter.dart';
import 'package:sanwo_paystack/sanwo_paystack.dart';

// Create an instance with your provider and public key
final sanwo = Sanwo(
  provider: paystackProvider,
  publicKey: 'pk_test_...',
);

// Listen for events (optional)
sanwo.on(SanwoEvent.success, (event) {
  print('Success: ${event.reference}');
});

// Start checkout from a button handler
final result = await sanwo(
  context: context,
  options: CheckoutOptions(
    amount: 500000, // 5000 NGN in kobo
    currency: 'NGN',
    customer: CheckoutCustomer(email: 'user@example.com'),
    onLoad: () => print('Checkout loaded'),
    onError: (error) => print('Error: $error'),
  ),
);

// Handle the result
if (result.status == CheckoutStatus.successful) {
  print('Payment successful! Reference: ${result.reference}');
} else if (result.status == CheckoutStatus.cancelled) {
  print('Payment cancelled');
} else if (result.status == CheckoutStatus.failed) {
  print('Payment failed: ${result.message}');
}
```

## Provider Packages

Provider templates are distributed as separate packages to keep the core SDK lightweight. Install only the providers you need.

| Package              | Provider     | Amount Unit                       |
|---------------------|--------------|-----------------------------------|
| `sanwo_paystack`    | Paystack     | Minor (kobo)                      |
| `sanwo_flutterwave` | Flutterwave  | Major (naira) — auto-converted    |

### Paystack

```dart
import 'package:sanwo_flutter/sanwo_flutter.dart';
import 'package:sanwo_paystack/sanwo_paystack.dart';

final sanwo = Sanwo(
  provider: paystackProvider,
  publicKey: 'pk_test_...',
);

final result = await sanwo(
  context: context,
  options: CheckoutOptions(
    amount: 500000, // 5000 NGN in kobo
    currency: 'NGN',
    customer: CheckoutCustomer(
      email: 'user@example.com',
      firstName: 'John',
      lastName: 'Doe',
    ),
    channels: ['card', 'bank'],
    metadata: {'order_id': '12345'},
  ),
);
```

### Flutterwave

```dart
import 'package:sanwo_flutter/sanwo_flutter.dart';
import 'package:sanwo_flutterwave/sanwo_flutterwave.dart';

final sanwo = Sanwo(
  provider: flutterwaveProvider,
  publicKey: 'FLWPUBK_TEST-...',
);

final result = await sanwo(
  context: context,
  options: CheckoutOptions(
    amount: 500000, // 5000 NGN in kobo — auto-converted to 5000 naira
    currency: 'NGN',
    customer: CheckoutCustomer(
      email: 'user@example.com',
      firstName: 'John',
      lastName: 'Doe',
      phone: '08012345678',
    ),
    customizations: {
      'title': 'My Store',
      'logo': 'https://example.com/logo.png',
    },
  ),
);
```

## Amount Handling

All amounts are specified in **minor units** (e.g., kobo for NGN, cents for USD). The SDK automatically converts amounts for providers that expect major units.

| Currency Type | Divisor | Examples |
|--------------|---------|----------|
| 2-decimal    | 100     | NGN, USD, EUR, GBP |
| 0-decimal    | 1       | JPY, KRW, VND |
| 3-decimal    | 1000    | BHD, KWD, OMR |

## Events

You can listen for payment events using the `on` method:

```dart
sanwo.on(SanwoEvent.success, (data) => print('Success: $data'));
sanwo.on(SanwoEvent.cancelled, (data) => print('Cancelled'));
sanwo.on(SanwoEvent.failed, (data) => print('Failed: ${data.message}'));
sanwo.on(SanwoEvent.loaded, (data) => print('Loaded'));
sanwo.on(SanwoEvent.closed, (data) => print('Closed'));
```

## CheckoutResult

Calling the `Sanwo` instance returns a `CheckoutResult` with:

| Property        | Type             | Description                    |
|----------------|------------------|--------------------------------|
| `status`       | `CheckoutStatus` | `successful`, `cancelled`, or `failed` |
| `reference`    | `String?`        | Payment reference              |
| `transactionId`| `String?`        | Provider transaction ID        |
| `message`      | `String?`        | Status or error message        |
| `data`         | `Map`            | Raw provider response data     |

## License

Apache 2.0 — see [LICENSE](LICENSE) for details.
