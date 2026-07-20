/// Definition of a payment provider.
class SanwoProviderDefinition {
  /// Creates a new [SanwoProviderDefinition].
  const SanwoProviderDefinition({
    required this.id,
    required this.name,
    required this.displayName,
    required this.template,
    required this.amountInMinorUnit,
    this.supportedCurrencies = const [],
    this.supportedCountries = const [],
  });

  /// Unique identifier for this provider (e.g., 'paystack').
  final String id;

  /// Provider name used in code (e.g., 'paystack').
  final String name;

  /// Human-readable display name (e.g., 'Paystack').
  final String displayName;

  /// The HTML template string with `{{sanwoBridge}}` and `{{params}}` placeholders.
  final String template;

  /// Whether this provider expects the amount in minor units.
  ///
  /// If `true`, the amount is passed as-is (e.g., Paystack uses kobo).
  /// If `false`, the engine will convert from minor units to major units
  /// (e.g., Flutterwave uses naira, so 500000 kobo becomes 5000 naira).
  final bool amountInMinorUnit;

  /// List of ISO 4217 currency codes supported by this provider.
  final List<String> supportedCurrencies;

  /// List of ISO 3166-1 alpha-2 country codes supported by this provider.
  final List<String> supportedCountries;

  @override
  String toString() => 'SanwoProviderDefinition($displayName)';
}
