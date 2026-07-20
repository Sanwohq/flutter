library sanwo_flutterwave;

import 'package:sanwo_flutter/sanwo_flutter.dart';

final flutterwaveProvider = SanwoProviderDefinition(
  id: 'flutterwave',
  name: 'flutterwave',
  displayName: 'Flutterwave',
  template: _template,
  amountInMinorUnit: false,
  supportedCurrencies: [
    'NGN',
    'GHS',
    'KES',
    'ZAR',
    'USD',
    'GBP',
    'EUR',
    'TZS',
    'UGX',
    'RWF',
    'XAF',
    'XOF',
  ],
  supportedCountries: [
    'NG',
    'GH',
    'KE',
    'ZA',
    'US',
    'GB',
    'TZ',
    'UG',
    'RW',
    'CM',
    'SN',
  ],
);

const _template = '''<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Sanwo Checkout</title>
</head>
<body onload="initPayment()" style="background-color:#fff;height:100vh">
  <script src="https://checkout.flutterwave.com/v3.js"></script>
  <script>
    {{sanwoBridge}}
    var params = {{params}};
    function initPayment() {
      try {
        var config = {
          public_key: params.publicKey,
          tx_ref: params.reference,
          amount: params.amount,
          currency: params.currency,
          customer: { email: params.email },
          callback: function(response) {
            sanwoCallback('success', {
              reference: response.tx_ref,
              transaction_id: String(response.transaction_id),
              flw_ref: response.flw_ref,
              message: response.status,
              raw: response
            });
          },
          onclose: function() { sanwoCallback('cancelled', {}); }
        };
        if (params.firstName || params.lastName) {
          config.customer.name = [params.firstName, params.lastName].filter(Boolean).join(' ');
        }
        if (params.phone) config.customer.phone_number = params.phone;
        if (params.description) config.payment_options = params.description;
        if (params.paymentOptions) config.payment_options = params.paymentOptions;
        if (params.customizations) config.customizations = params.customizations;
        if (params.meta) config.meta = params.meta;
        if (params.metadata) config.meta = params.metadata;
        if (params.subaccounts) config.subaccounts = params.subaccounts;
        if (params.paymentPlan) config.payment_plan = params.paymentPlan;
        if (params.redirectUrl) config.redirect_url = params.redirectUrl;
        sanwoCallback('loaded', {});
        FlutterwaveCheckout(config);
      } catch(e) {
        sanwoCallback('error', { message: e.message });
      }
    }
  </script>
</body>
</html>''';
