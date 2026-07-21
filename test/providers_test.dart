import 'package:flutter_test/flutter_test.dart';
import 'package:sanwo_flutter/sanwo_flutter.dart';
import 'package:sanwo_paystack/sanwo_paystack.dart';
import 'package:sanwo_flutterwave/sanwo_flutterwave.dart';
import 'package:sanwo_stripe/sanwo_stripe.dart';
import 'package:sanwo_paypal/sanwo_paypal.dart';
import 'package:sanwo_razorpay/sanwo_razorpay.dart';
import 'package:sanwo_monnify/sanwo_monnify.dart';
import 'package:sanwo_interswitch/sanwo_interswitch.dart';

void main() {
  /// Shared tests applied to every provider definition.
  void runProviderTests({
    required SanwoProviderDefinition provider,
    required String expectedId,
    required String expectedName,
    required String expectedDisplayName,
    required bool expectedAmountInMinorUnit,
  }) {
    test('id is "$expectedId"', () {
      expect(provider.id, expectedId);
    });

    test('name is "$expectedName"', () {
      expect(provider.name, expectedName);
    });

    test('displayName is "$expectedDisplayName"', () {
      expect(provider.displayName, expectedDisplayName);
    });

    test('amountInMinorUnit is $expectedAmountInMinorUnit', () {
      expect(provider.amountInMinorUnit, expectedAmountInMinorUnit);
    });

    test('supportedCurrencies is non-empty', () {
      expect(provider.supportedCurrencies, isNotEmpty);
    });

    test('supportedCountries is non-empty', () {
      expect(provider.supportedCountries, isNotEmpty);
    });

    test('template contains {{sanwoBridge}} placeholder', () {
      expect(provider.template, contains('{{sanwoBridge}}'));
    });

    test('template contains {{params}} placeholder', () {
      expect(provider.template, contains('{{params}}'));
    });

    test('template calls sanwoCallback for success', () {
      expect(provider.template, contains("sanwoCallback('success'"));
    });

    test('template calls sanwoCallback for error', () {
      expect(provider.template, contains("sanwoCallback('error'"));
    });

    test('template calls sanwoCallback for cancelled', () {
      expect(provider.template, contains("sanwoCallback('cancelled'"));
    });

    test('template calls sanwoCallback for loaded', () {
      expect(provider.template, contains("sanwoCallback('loaded'"));
    });

    test('toString includes displayName', () {
      expect(
        provider.toString(),
        equals('SanwoProviderDefinition($expectedDisplayName)'),
      );
    });
  }

  // ---------------------------------------------------------------------------
  // Paystack
  // ---------------------------------------------------------------------------
  group('PaystackProvider', () {
    runProviderTests(
      provider: paystackProvider,
      expectedId: 'paystack',
      expectedName: 'paystack',
      expectedDisplayName: 'Paystack',
      expectedAmountInMinorUnit: true,
    );

    test('template calls sanwoCallback for closed', () {
      expect(paystackProvider.template, contains("sanwoCallback('closed'"));
    });

    test('success callback includes reference and transaction_id', () {
      expect(paystackProvider.template, contains('reference: response.reference'));
      expect(paystackProvider.template, contains('transaction_id: response.trans'));
    });
  });

  // ---------------------------------------------------------------------------
  // Flutterwave
  // ---------------------------------------------------------------------------
  group('FlutterwaveProvider', () {
    runProviderTests(
      provider: flutterwaveProvider,
      expectedId: 'flutterwave',
      expectedName: 'flutterwave',
      expectedDisplayName: 'Flutterwave',
      expectedAmountInMinorUnit: false,
    );

    test('success callback includes reference and transaction_id', () {
      expect(flutterwaveProvider.template, contains('reference: response.tx_ref'));
      expect(
        flutterwaveProvider.template,
        contains('transaction_id: response.transaction_id'),
      );
    });

    test('description maps to customizations, not payment_options', () {
      // The bug was: description -> config.payment_options. It should NOT do that.
      expect(
        flutterwaveProvider.template,
        isNot(contains('config.payment_options = params.description')),
      );
    });

    test('paymentOptions still maps to payment_options', () {
      expect(
        flutterwaveProvider.template,
        contains('config.payment_options = params.paymentOptions'),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // Stripe
  // ---------------------------------------------------------------------------
  group('StripeProvider', () {
    runProviderTests(
      provider: stripeProvider,
      expectedId: 'stripe',
      expectedName: 'stripe',
      expectedDisplayName: 'Stripe',
      expectedAmountInMinorUnit: true,
    );

    test('success callback includes reference and transaction_id', () {
      expect(stripeProvider.template, contains('reference: paymentIntent.id'));
      expect(stripeProvider.template, contains('transaction_id: paymentIntent.id'));
    });
  });

  // ---------------------------------------------------------------------------
  // PayPal
  // ---------------------------------------------------------------------------
  group('PayPalProvider', () {
    runProviderTests(
      provider: paypalProvider,
      expectedId: 'paypal',
      expectedName: 'paypal',
      expectedDisplayName: 'PayPal',
      expectedAmountInMinorUnit: false,
    );

    test('success callback includes reference and transaction_id', () {
      expect(paypalProvider.template, contains('reference: data.orderID'));
      expect(paypalProvider.template, contains('transaction_id: data.orderID'));
    });
  });

  // ---------------------------------------------------------------------------
  // Razorpay
  // ---------------------------------------------------------------------------
  group('RazorpayProvider', () {
    runProviderTests(
      provider: razorpayProvider,
      expectedId: 'razorpay',
      expectedName: 'razorpay',
      expectedDisplayName: 'Razorpay',
      expectedAmountInMinorUnit: true,
    );

    test('success callback includes reference and transaction_id', () {
      expect(
        razorpayProvider.template,
        contains('reference: response.razorpay_payment_id'),
      );
      expect(
        razorpayProvider.template,
        contains('transaction_id: response.razorpay_payment_id'),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // Monnify
  // ---------------------------------------------------------------------------
  group('MonnifyProvider', () {
    runProviderTests(
      provider: monnifyProvider,
      expectedId: 'monnify',
      expectedName: 'monnify',
      expectedDisplayName: 'Monnify',
      expectedAmountInMinorUnit: false,
    );

    test('success callback includes reference and transaction_id', () {
      expect(
        monnifyProvider.template,
        contains('reference: response.paymentReference'),
      );
      expect(
        monnifyProvider.template,
        contains('transaction_id: response.transactionReference'),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // Interswitch
  // ---------------------------------------------------------------------------
  group('InterswitchProvider', () {
    runProviderTests(
      provider: interswitchProvider,
      expectedId: 'interswitch',
      expectedName: 'interswitch',
      expectedDisplayName: 'Interswitch',
      expectedAmountInMinorUnit: true,
    );

    test('success callback includes reference', () {
      expect(
        interswitchProvider.template,
        contains('reference: response.txnref'),
      );
    });
  });
}
