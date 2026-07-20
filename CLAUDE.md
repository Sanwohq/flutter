# Sanwo Flutter SDK

## Project Overview
Sanwo Flutter is the Flutter/Dart SDK for Sanwo, a universal payment SDK. It provides a single interface for multiple payment providers (Paystack, Flutterwave).

## Architecture
- The core SDK (`sanwo_flutter`) contains the engine, checkout flow, and `SanwoProviderDefinition` type
- Provider templates are distributed as separate packages under `packages/`:
  - `packages/sanwo_paystack/` — Paystack provider
  - `packages/sanwo_flutterwave/` — Flutterwave provider
- Each provider package exports a top-level `SanwoProviderDefinition` instance (e.g., `paystackProvider`)
- The engine (`lib/src/engine.dart`) renders templates by replacing `{{sanwoBridge}}` and `{{params}}` placeholders
- `checkout_page.dart` hosts a WebView that loads the rendered HTML
- A JavascriptChannel named `messageHandler` receives messages from the JS bridge
- Messages follow: `{ type: 'sanwo', event: 'success'|'cancelled'|'closed'|'error'|'loaded', data: {...} }`

## Key Commands
- `flutter pub get` — install dependencies
- `dart analyze` — run static analysis
- `flutter test` — run tests

## Code Conventions
- Dart null safety throughout
- Doc comments on all public APIs
- Follow `flutter_lints` rules
- Amounts are always in minor units at the API level; the engine converts for providers that need major units

## Adding a Provider
1. Create a new package under `packages/sanwo_<provider>/`
2. Add a `pubspec.yaml` with a dependency on `sanwo_flutter`
3. Export a `SanwoProviderDefinition` instance from `lib/sanwo_<provider>.dart`
4. Template must use `{{sanwoBridge}}` and `{{params}}` placeholders
5. Template must call `sanwoCallback(event, data)` for events
