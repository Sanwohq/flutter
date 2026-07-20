import 'package:flutter/material.dart';

import 'checkout_options.dart';
import 'checkout_page.dart';
import 'checkout_result.dart';
import 'engine.dart';
import 'event.dart';
import 'provider.dart';

/// The main Sanwo payment SDK entry point.
///
/// Create an instance with a provider and public key, then call [checkout]
/// to start a payment flow.
///
/// ```dart
/// final sanwo = Sanwo(
///   provider: SanwoProviders.paystack,
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
/// ```
class Sanwo {
  /// Creates a new [Sanwo] instance.
  ///
  /// [provider] defines which payment provider to use.
  /// [publicKey] is your provider's public/publishable key.
  Sanwo({
    required this.provider,
    required this.publicKey,
  });

  /// The payment provider definition.
  final SanwoProviderDefinition provider;

  /// The public key for the payment provider.
  final String publicKey;

  /// Internal event emitter.
  final EventEmitter _emitter = EventEmitter();

  /// Registers a listener for a specific [event].
  ///
  /// ```dart
  /// sanwo.on(SanwoEvent.success, (data) {
  ///   print('Payment succeeded: ${data.reference}');
  /// });
  /// ```
  void on(SanwoEvent event, SanwoEventCallback callback) {
    _emitter.on(event, callback);
  }

  /// Removes a listener for a specific [event].
  void off(SanwoEvent event, SanwoEventCallback callback) {
    _emitter.off(event, callback);
  }

  /// Removes all event listeners.
  void removeAllListeners() {
    _emitter.removeAllListeners();
  }

  /// Starts a checkout flow by navigating to the checkout page.
  ///
  /// Returns a [CheckoutResult] when the payment flow completes.
  ///
  /// [context] is required to push the checkout page onto the navigator.
  /// [options] configures the checkout (amount, currency, customer, etc.).
  ///
  /// ```dart
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
  Future<CheckoutResult> checkout({
    required BuildContext context,
    required CheckoutOptions options,
  }) async {
    // Build template parameters.
    final params = SanwoEngine.buildTemplateParams(
      options: options,
      publicKey: publicKey,
      provider: provider,
    );

    // Render the HTML template.
    final html = SanwoEngine.renderTemplate(
      template: provider.template,
      params: params,
    );

    // Navigate to the checkout page and await the result.
    final result = await Navigator.of(context).push<CheckoutResult>(
      MaterialPageRoute(
        builder: (_) => CheckoutPage(
          html: html,
          providerName: provider.displayName,
          emitter: _emitter,
          onLoad: options.onLoad,
          onError: options.onError,
        ),
      ),
    );

    // If the user dismissed the page without a result (e.g., system back),
    // treat it as a cancellation.
    return result ?? const CheckoutResult(status: CheckoutStatus.cancelled);
  }
}
