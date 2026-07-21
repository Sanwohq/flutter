# sanwo_monnify

Monnify provider for the [Sanwo](https://github.com/Sanwohq/flutter) payment SDK.

## Installation

```yaml
dependencies:
  sanwo_flutter: ^0.1.0
  sanwo_monnify: ^0.1.0
```

## Usage

```dart
import 'package:sanwo_flutter/sanwo_flutter.dart';
import 'package:sanwo_monnify/sanwo_monnify.dart';

final sanwo = Sanwo(
  provider: monnifyProvider,
  publicKey: 'MK_TEST_...',
);

final result = await sanwo(
  context: context,
  options: CheckoutOptions(
    amount: 100000,
    currency: 'NGN',
    customer: CheckoutCustomer(email: 'customer@example.com'),
  ),
);
```

See the [main SDK documentation](https://github.com/Sanwohq/flutter) for full details.
