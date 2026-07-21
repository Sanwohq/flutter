# sanwo_razorpay

Razorpay provider for the [Sanwo](https://github.com/Sanwohq/flutter) payment SDK.

## Installation

```yaml
dependencies:
  sanwo_flutter: ^0.1.0
  sanwo_razorpay: ^0.1.0
```

## Usage

```dart
import 'package:sanwo_flutter/sanwo_flutter.dart';
import 'package:sanwo_razorpay/sanwo_razorpay.dart';

final sanwo = Sanwo(
  provider: razorpayProvider,
  publicKey: 'rzp_test_...',
);

final result = await sanwo(
  context: context,
  options: CheckoutOptions(
    amount: 50000,
    currency: 'INR',
    customer: CheckoutCustomer(email: 'customer@example.com'),
  ),
);
```

See the [main SDK documentation](https://github.com/Sanwohq/flutter) for full details.
