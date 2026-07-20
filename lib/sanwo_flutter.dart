/// Sanwo payment SDK for Flutter.
///
/// A universal payment SDK that provides a single interface for
/// multiple payment providers (Paystack, Flutterwave, and more).
///
/// ## Quick start
///
/// ```dart
/// import 'package:sanwo_flutter/sanwo_flutter.dart';
/// import 'package:sanwo_paystack/sanwo_paystack.dart';
///
/// final sanwo = Sanwo(
///   provider: paystackProvider,
///   publicKey: 'pk_test_...',
/// );
///
/// final result = await sanwo.checkout(
///   context: context,
///   options: CheckoutOptions(
///     amount: 500000,
///     currency: 'NGN',
///     customer: CheckoutCustomer(email: 'user@example.com'),
///   ),
/// );
///
/// if (result.status == CheckoutStatus.successful) {
///   print('Paid! Ref: ${result.reference}');
/// }
/// ```
library;

export 'src/sanwo.dart' show Sanwo;
export 'src/checkout_options.dart' show CheckoutOptions, CheckoutCustomer;
export 'src/checkout_result.dart' show CheckoutResult, CheckoutStatus;
export 'src/event.dart' show SanwoEvent, SanwoEventData, SanwoEventCallback;
export 'src/provider.dart' show SanwoProviderDefinition;
export 'src/engine.dart' show SanwoEngine;
