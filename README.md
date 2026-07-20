# Sanwo Flutter

Sanwo payment SDK for Flutter — one interface for every payment provider.

## Installation

Add `sanwo_flutter` to your `pubspec.yaml`:

```yaml
dependencies:
  sanwo_flutter: ^0.1.0
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

// Create an instance with your provider and public key
final sanwo = Sanwo(
  provider: SanwoProviders.paystack,
  publicKey: 'pk_test_...',
);

// Listen for events (optional)
sanwo.on(SanwoEvent.success, (event) {
  print('Success: ${event.reference}');
});

// Start checkout from a button handler
final result = await sanwo.checkout(
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

## Supported Providers

| Provider     | ID             | Amount Unit  |
|-------------|----------------|--------------|
| Paystack    | `paystack`     | Minor (kobo) |
| Flutterwave | `flutterwave`  | Major (naira) — auto-converted |

### Paystack

```dart
final sanwo = Sanwo(
  provider: SanwoProviders.paystack,
  publicKey: 'pk_test_...',
);

final result = await sanwo.checkout(
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
final sanwo = Sanwo(
  provider: SanwoProviders.flutterwave,
  publicKey: 'FLWPUBK_TEST-...',
);

final result = await sanwo.checkout(
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

The `checkout` method returns a `CheckoutResult` with:

| Property        | Type             | Description                    |
|----------------|------------------|--------------------------------|
| `status`       | `CheckoutStatus` | `successful`, `cancelled`, or `failed` |
| `reference`    | `String?`        | Payment reference              |
| `transactionId`| `String?`        | Provider transaction ID        |
| `message`      | `String?`        | Status or error message        |
| `data`         | `Map`            | Raw provider response data     |

## License

Apache 2.0 — see [LICENSE](LICENSE) for details.
