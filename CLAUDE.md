# Sanwo Flutter SDK

## Project Overview
Sanwo Flutter is the Flutter/Dart SDK for Sanwo, a universal payment SDK. It provides a single interface for multiple payment providers (Paystack, Flutterwave).

## Architecture
- Provider templates are bundled as Dart string constants in `lib/src/templates/`
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
1. Create template in `lib/src/templates/<provider>.dart`
2. Add `SanwoProviderDefinition` in `lib/src/providers.dart`
3. Template must use `{{sanwoBridge}}` and `{{params}}` placeholders
4. Template must call `sanwoCallback(event, data)` for events
