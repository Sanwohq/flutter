/// Customer information for checkout.
class CheckoutCustomer {
  /// Creates a new [CheckoutCustomer].
  const CheckoutCustomer({
    required this.email,
    this.firstName,
    this.lastName,
    this.phone,
  });

  /// Customer email address.
  final String email;

  /// Customer first name.
  final String? firstName;

  /// Customer last name.
  final String? lastName;

  /// Customer phone number.
  final String? phone;

  /// Converts this customer to a map for template rendering.
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      if (phone != null) 'phone': phone,
    };
  }
}

/// Configuration options for a checkout session.
class CheckoutOptions {
  /// Creates a new [CheckoutOptions].
  ///
  /// [amount] should be in minor units (e.g., kobo for NGN, cents for USD).
  const CheckoutOptions({
    required this.amount,
    required this.currency,
    required this.customer,
    this.reference,
    this.metadata,
    this.channels,
    this.label,
    this.description,
    this.plan,
    this.quantity,
    this.subaccount,
    this.splitCode,
    this.split,
    this.transactionCharge,
    this.invoiceLimit,
    this.paymentOptions,
    this.customizations,
    this.meta,
    this.subaccounts,
    this.paymentPlan,
    this.redirectUrl,
    this.method,
    this.extra,
    this.onLoad,
    this.onError,
  });

  /// Amount in minor units (e.g., 500000 kobo = 5000 NGN).
  final int amount;

  /// ISO 4217 currency code (e.g., 'NGN', 'USD').
  final String currency;

  /// Customer information.
  final CheckoutCustomer customer;

  /// A unique reference for this transaction.
  ///
  /// If not provided, one will be generated automatically.
  final String? reference;

  /// Additional metadata to attach to the transaction.
  final Map<String, dynamic>? metadata;

  /// Payment channels to enable (Paystack-specific).
  final List<String>? channels;

  /// Display label for the transaction (Paystack-specific).
  final String? label;

  /// Description of the transaction (Flutterwave-specific).
  final String? description;

  /// Subscription plan ID (Paystack-specific).
  final String? plan;

  /// Quantity for plan subscriptions (Paystack-specific).
  final int? quantity;

  /// Subaccount code (Paystack-specific).
  final String? subaccount;

  /// Split code (Paystack-specific).
  final String? splitCode;

  /// Split configuration (Paystack-specific).
  final Map<String, dynamic>? split;

  /// Transaction charge in minor units (Paystack-specific).
  final int? transactionCharge;

  /// Invoice limit (Paystack-specific).
  final int? invoiceLimit;

  /// Payment options (Flutterwave-specific).
  final String? paymentOptions;

  /// UI customizations (Flutterwave-specific).
  final Map<String, dynamic>? customizations;

  /// Additional meta information (Flutterwave-specific).
  final List<Map<String, dynamic>>? meta;

  /// Subaccounts for split payments (Flutterwave-specific).
  final List<Map<String, dynamic>>? subaccounts;

  /// Payment plan ID (Flutterwave-specific).
  final int? paymentPlan;

  /// Redirect URL after payment (Flutterwave-specific).
  final String? redirectUrl;

  /// Payment method (Paystack-specific, defaults to 'checkout').
  final String? method;

  /// Any additional provider-specific parameters.
  final Map<String, dynamic>? extra;

  /// Callback when the checkout UI finishes loading.
  final void Function()? onLoad;

  /// Callback when an error occurs during checkout.
  final void Function(String error)? onError;

  /// Converts these options to a map for template rendering.
  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'currency': currency,
      ...customer.toMap(),
      if (reference != null) 'reference': reference,
      if (metadata != null) 'metadata': metadata,
      if (channels != null) 'channels': channels,
      if (label != null) 'label': label,
      if (description != null) 'description': description,
      if (plan != null) 'plan': plan,
      if (quantity != null) 'quantity': quantity,
      if (subaccount != null) 'subaccount': subaccount,
      if (splitCode != null) 'splitCode': splitCode,
      if (split != null) 'split': split,
      if (transactionCharge != null) 'transactionCharge': transactionCharge,
      if (invoiceLimit != null) 'invoiceLimit': invoiceLimit,
      if (paymentOptions != null) 'paymentOptions': paymentOptions,
      if (customizations != null) 'customizations': customizations,
      if (meta != null) 'meta': meta,
      if (subaccounts != null) 'subaccounts': subaccounts,
      if (paymentPlan != null) 'paymentPlan': paymentPlan,
      if (redirectUrl != null) 'redirectUrl': redirectUrl,
      if (method != null) 'method': method,
      if (extra != null) ...extra!,
    };
  }
}
