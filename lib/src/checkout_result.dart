/// The outcome status of a checkout session.
enum CheckoutStatus {
  /// Payment was completed successfully.
  successful,

  /// Payment was cancelled by the user.
  cancelled,

  /// An error occurred during payment.
  failed,
}

/// The result of a checkout session.
class CheckoutResult {
  /// Creates a new [CheckoutResult].
  const CheckoutResult({
    required this.status,
    this.reference,
    this.transactionId,
    this.message,
    this.data = const {},
  });

  /// The outcome status.
  final CheckoutStatus status;

  /// The payment reference (if successful).
  final String? reference;

  /// The transaction ID (if successful).
  final String? transactionId;

  /// A human-readable message.
  final String? message;

  /// The raw data from the payment provider.
  final Map<String, dynamic> data;

  @override
  String toString() {
    return 'CheckoutResult(status: $status, reference: $reference, '
        'transactionId: $transactionId, message: $message)';
  }
}
