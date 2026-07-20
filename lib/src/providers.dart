import 'provider.dart';
import 'templates/paystack.dart';
import 'templates/flutterwave.dart';

/// Built-in payment provider definitions.
///
/// Access providers via static properties, e.g. `SanwoProviders.paystack`.
class SanwoProviders {
  SanwoProviders._();

  /// Paystack payment provider.
  ///
  /// Paystack accepts amounts in minor units (kobo for NGN, cents for USD).
  static const SanwoProviderDefinition paystack = SanwoProviderDefinition(
    id: 'paystack',
    name: 'paystack',
    displayName: 'Paystack',
    template: paystackTemplate,
    amountInMinorUnit: true,
    supportedCurrencies: ['NGN', 'GHS', 'ZAR', 'USD', 'KES'],
    supportedCountries: ['NG', 'GH', 'ZA', 'US', 'KE'],
  );

  /// Flutterwave payment provider.
  ///
  /// Flutterwave accepts amounts in major units (naira for NGN, dollars for USD),
  /// so the engine converts from minor units automatically.
  static const SanwoProviderDefinition flutterwave = SanwoProviderDefinition(
    id: 'flutterwave',
    name: 'flutterwave',
    displayName: 'Flutterwave',
    template: flutterwaveTemplate,
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

  /// All built-in providers.
  static const List<SanwoProviderDefinition> all = [paystack, flutterwave];

  /// Looks up a provider by its [id].
  ///
  /// Returns `null` if no provider with the given ID exists.
  static SanwoProviderDefinition? byId(String id) {
    for (final provider in all) {
      if (provider.id == id) {
        return provider;
      }
    }
    return null;
  }
}
