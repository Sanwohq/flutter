/// Sanwo payment event types.
enum SanwoEvent {
  /// Payment completed successfully.
  success,

  /// Payment was cancelled by the user.
  cancelled,

  /// The checkout UI was closed.
  closed,

  /// An error occurred during payment.
  failed,

  /// The checkout UI has finished loading.
  loaded,
}

/// Data associated with a Sanwo payment event.
class SanwoEventData {
  /// Creates a new [SanwoEventData] instance.
  const SanwoEventData({
    this.reference,
    this.transactionId,
    this.message,
    this.data = const {},
  });

  /// Creates [SanwoEventData] from a raw map (typically from JSON).
  factory SanwoEventData.fromMap(Map<String, dynamic> map) {
    return SanwoEventData(
      reference: map['reference'] as String?,
      transactionId: map['transaction_id'] as String?,
      message: map['message'] as String?,
      data: map,
    );
  }

  /// The payment reference.
  final String? reference;

  /// The transaction ID.
  final String? transactionId;

  /// A human-readable message.
  final String? message;

  /// The raw event data.
  final Map<String, dynamic> data;

  @override
  String toString() {
    return 'SanwoEventData(reference: $reference, transactionId: $transactionId, '
        'message: $message, data: $data)';
  }
}

/// Callback type for Sanwo events.
typedef SanwoEventCallback = void Function(SanwoEventData data);

/// A simple event emitter for Sanwo payment events.
class EventEmitter {
  final Map<SanwoEvent, List<SanwoEventCallback>> _listeners = {};

  /// Registers a [callback] for the given [event].
  void on(SanwoEvent event, SanwoEventCallback callback) {
    _listeners.putIfAbsent(event, () => []).add(callback);
  }

  /// Removes a [callback] for the given [event].
  void off(SanwoEvent event, SanwoEventCallback callback) {
    _listeners[event]?.remove(callback);
  }

  /// Emits an [event] with the given [data] to all registered listeners.
  void emit(SanwoEvent event, SanwoEventData data) {
    final callbacks = _listeners[event];
    if (callbacks != null) {
      for (final callback in List<SanwoEventCallback>.of(callbacks)) {
        callback(data);
      }
    }
  }

  /// Removes all listeners for all events.
  void removeAllListeners() {
    _listeners.clear();
  }
}

/// Maps a raw event string from JavaScript to a [SanwoEvent].
SanwoEvent? parseEvent(String eventName) {
  switch (eventName) {
    case 'success':
      return SanwoEvent.success;
    case 'cancelled':
      return SanwoEvent.cancelled;
    case 'closed':
      return SanwoEvent.closed;
    case 'error':
      return SanwoEvent.failed;
    case 'loaded':
      return SanwoEvent.loaded;
    default:
      return null;
  }
}
