import 'dart:convert';
import 'dart:math';

import 'checkout_options.dart';
import 'provider.dart';

/// The Sanwo template engine.
///
/// Handles template rendering, bridge generation, amount conversion,
/// and reference generation.
class SanwoEngine {
  SanwoEngine._();

  /// The JavaScript bridge function injected into payment templates.
  ///
  /// This function is called by payment provider scripts to send messages
  /// back to the Flutter side via the `messageHandler` JavascriptChannel.
  static const String bridge = '''
function sanwoCallback(event, data) {
  messageHandler.postMessage(JSON.stringify({ type: 'sanwo', event: event, data: data }));
}''';

  /// Renders a template by replacing placeholders with actual values.
  ///
  /// - `{{sanwoBridge}}` is replaced with the JavaScript bridge function.
  /// - `{{params}}` is replaced with the JSON-encoded parameters.
  static String renderTemplate({
    required String template,
    required Map<String, dynamic> params,
  }) {
    final paramsJson = jsonEncode(params);
    return template
        .replaceAll('{{sanwoBridge}}', bridge)
        .replaceAll('{{params}}', paramsJson);
  }

  /// Builds the template parameters map from checkout options.
  ///
  /// This merges the public key, reference, and all checkout options into
  /// a single map suitable for JSON serialization.
  static Map<String, dynamic> buildTemplateParams({
    required CheckoutOptions options,
    required String publicKey,
    required SanwoProviderDefinition provider,
  }) {
    final params = <String, dynamic>{
      'publicKey': publicKey,
      ...options.toMap(),
    };

    // Convert amount for providers that don't use minor units.
    if (!provider.amountInMinorUnit) {
      params['amount'] = fromMinorUnit(options.amount, options.currency);
    }

    // Ensure a reference is set.
    params['reference'] ??= generateReference();

    return params;
  }

  /// Converts an amount from minor units to major units based on the currency.
  ///
  /// For example, 500000 kobo (NGN, 2 decimals) becomes 5000.0 naira.
  /// Currencies with 0 decimal places (e.g., JPY) are returned as-is.
  /// Currencies with 3 decimal places (e.g., BHD) are divided by 1000.
  static num fromMinorUnit(int amount, String currency) {
    final decimals = _currencyDecimals(currency.toUpperCase());
    if (decimals == 0) {
      return amount;
    }
    return amount / _pow10(decimals);
  }

  /// Generates a unique payment reference.
  ///
  /// Format: `sanwo_<timestamp>_<random>`.
  static String generateReference() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = _randomHex(8);
    return 'sanwo_${timestamp}_$random';
  }

  /// Returns the number of decimal places for a given currency.
  static int _currencyDecimals(String currency) {
    // 0-decimal currencies
    const zeroDecimal = {
      'JPY',
      'KRW',
      'VND',
      'CLP',
      'PYG',
      'ISK',
      'UGX',
      'RWF',
    };

    // 3-decimal currencies
    const threeDecimal = {'BHD', 'KWD', 'OMR', 'TND', 'JOD'};

    if (zeroDecimal.contains(currency)) return 0;
    if (threeDecimal.contains(currency)) return 3;
    return 2;
  }

  /// Returns 10^n as an integer.
  static int _pow10(int n) {
    return pow(10, n).toInt();
  }

  /// Generates a random hexadecimal string of [length] characters.
  static String _randomHex(int length) {
    final random = Random.secure();
    final bytes = List<int>.generate(
      (length / 2).ceil(),
      (_) => random.nextInt(256),
    );
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}
