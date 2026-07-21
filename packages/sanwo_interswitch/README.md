# sanwo_interswitch

Interswitch provider for the [Sanwo](https://github.com/Sanwohq/flutter) payment SDK.

## Installation

```yaml
dependencies:
  sanwo_flutter: ^0.1.0
  sanwo_interswitch: ^0.1.0
```

## Usage

```dart
import 'package:sanwo_flutter/sanwo_flutter.dart';
import 'package:sanwo_interswitch/sanwo_interswitch.dart';

final sanwo = Sanwo(
  provider: interswitchProvider,
  publicKey: 'your_merchant_code',
);

final result = await sanwo(
  context: context,
  options: CheckoutOptions(
    amount: 100000,
    currency: 'NGN',
    customer: CheckoutCustomer(email: 'customer@example.com'),
    sanwoProviderOptions: {
      'payItemId': 'your_pay_item_id',
      'siteRedirectUrl': 'https://yoursite.com',
    },
  ),
);
```

See the [main SDK documentation](https://github.com/Sanwohq/flutter) for full details.
