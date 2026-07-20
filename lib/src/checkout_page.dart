import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'checkout_result.dart';
import 'event.dart';

/// A full-screen page that hosts the payment checkout WebView.
///
/// This page renders the pre-built HTML template in a WebView, listens
/// for messages from the JavaScript bridge, and returns a [CheckoutResult]
/// when the payment flow completes.
class CheckoutPage extends StatefulWidget {
  /// Creates a new [CheckoutPage].
  const CheckoutPage({
    super.key,
    required this.html,
    required this.providerName,
    this.emitter,
    this.onLoad,
    this.onError,
  });

  /// The rendered HTML to load in the WebView.
  final String html;

  /// The display name of the payment provider (shown in the AppBar).
  final String providerName;

  /// Optional event emitter for broadcasting events.
  final EventEmitter? emitter;

  /// Callback when the checkout finishes loading.
  final void Function()? onLoad;

  /// Callback when an error occurs.
  final void Function(String error)? onError;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasPopped = false;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..addJavaScriptChannel(
        'messageHandler',
        onMessageReceived: _onMessageReceived,
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) {
              setState(() => _isLoading = false);
            }
          },
          onWebResourceError: (error) {
            final message = error.description;
            widget.onError?.call(message);
            widget.emitter?.emit(
              SanwoEvent.failed,
              SanwoEventData(message: message),
            );
          },
        ),
      )
      ..loadHtmlString(widget.html);
  }

  void _onMessageReceived(JavaScriptMessage message) {
    try {
      final decoded = jsonDecode(message.message);
      if (decoded is! Map<String, dynamic>) return;
      if (decoded['type'] != 'sanwo') return;

      final eventName = decoded['event'] as String?;
      if (eventName == null) return;

      final rawData = decoded['data'];
      final data = rawData is Map<String, dynamic>
          ? rawData
          : <String, dynamic>{};

      final event = parseEvent(eventName);
      if (event == null) return;

      final eventData = SanwoEventData.fromMap(data);

      // Emit the event to listeners.
      widget.emitter?.emit(event, eventData);

      // Handle specific events.
      switch (event) {
        case SanwoEvent.loaded:
          widget.onLoad?.call();
          break;

        case SanwoEvent.success:
          _popWithResult(CheckoutResult(
            status: CheckoutStatus.successful,
            reference: eventData.reference,
            transactionId: eventData.transactionId,
            message: eventData.message,
            data: data,
          ));
          break;

        case SanwoEvent.cancelled:
        case SanwoEvent.closed:
          _popWithResult(const CheckoutResult(
            status: CheckoutStatus.cancelled,
          ));
          break;

        case SanwoEvent.failed:
          widget.onError?.call(eventData.message ?? 'Unknown error');
          _popWithResult(CheckoutResult(
            status: CheckoutStatus.failed,
            message: eventData.message,
            data: data,
          ));
          break;
      }
    } catch (_) {
      // Ignore malformed messages.
    }
  }

  void _popWithResult(CheckoutResult result) {
    if (_hasPopped || !mounted) return;
    _hasPopped = true;
    Navigator.of(context).pop(result);
  }

  void _onClose() {
    widget.emitter?.emit(
      SanwoEvent.closed,
      const SanwoEventData(),
    );
    _popWithResult(const CheckoutResult(status: CheckoutStatus.cancelled));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _onClose();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.providerName),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _onClose,
          ),
          elevation: 0,
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
