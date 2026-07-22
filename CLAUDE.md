# Sanwo Flutter SDK

## Project Overview

Sanwo Flutter is the Flutter/Dart SDK for Sanwo, a universal payment SDK. Provides a single interface for multiple payment providers.

## Architecture

- The core SDK (`sanwo_flutter`) contains the engine, checkout flow, and `SanwoProviderDefinition` type
- Provider templates are distributed as separate packages under `packages/`:
  - `packages/sanwo_paystack/` — Paystack provider
  - `packages/sanwo_flutterwave/` — Flutterwave provider
  - `packages/sanwo_razorpay/` — Razorpay provider
  - `packages/sanwo_monnify/` — Monnify provider
  - `packages/sanwo_interswitch/` — Interswitch provider
- Each provider package exports a top-level `SanwoProviderDefinition` instance (e.g., `paystackProvider`)
- The engine (`lib/src/engine.dart`) renders templates by replacing `{{sanwoBridge}}` and `{{params}}` placeholders
- `checkout_page.dart` hosts a WebView that loads the rendered HTML with `loadHtmlString(html, baseUrl: 'https://checkout.sanwohq.com')` — the baseUrl is required for CDN script loading to work in WKWebView
- A JavascriptChannel named `messageHandler` receives messages from the JS bridge
- Messages follow: `{ type: 'sanwo', event: 'success'|'cancelled'|'closed'|'error'|'loaded', data: {...} }`

## Build & Test

```bash
flutter pub get
dart analyze
flutter test
```

## CI/CD

### Release (`release.yml`)
- **Triggers**: push to main, push of `v*` tags, PRs to main
- **Jobs**:
  - `analyze` — `flutter pub get`, `dart analyze`, `flutter test` (runs on all triggers)
  - `publish` — Runs on main push or tag push. Publishes all 6 packages to **pub.dev**

### Publishing mechanism
- Uses **pub.dev OIDC** automated publishing (no tokens/secrets needed)
- Requires `dart-lang/setup-dart` action (for OIDC token exchange) BEFORE `subosito/flutter-action` (for Flutter SDK)
- The publish job uses GitHub Actions **environment: `publish`** — this must match the environment name configured on pub.dev
- Each package's pub.dev admin page must have "Automated publishing" configured with:
  - Repository: `Sanwohq/flutter`
  - Environment: `publish`
  - Allowed ref types: tags AND `main` branch

### Smart version checking
- Before publishing each package, CI checks the pub.dev API (`https://pub.dev/api/packages/{name}/versions/{version}`) to see if the version already exists
- If already published: skips (no error)
- If not published: publishes via `flutter pub publish --force`
- This prevents double-publish errors and handles partial failures gracefully

### How to publish a new version
1. Bump `version:` in `pubspec.yaml` for the core package AND all provider packages under `packages/`
2. Push to main — CI automatically publishes any packages with unpublished versions
3. No manual tagging required (though `v*` tags also trigger publishing)

### Important: all 6 packages must have versions bumped together
- `pubspec.yaml` (sanwo_flutter)
- `packages/sanwo_paystack/pubspec.yaml`
- `packages/sanwo_flutterwave/pubspec.yaml`
- `packages/sanwo_razorpay/pubspec.yaml`
- `packages/sanwo_monnify/pubspec.yaml`
- `packages/sanwo_interswitch/pubspec.yaml`

## Code Conventions

- Dart null safety throughout
- Doc comments on all public APIs
- Follow `flutter_lints` rules
- Amounts are always in minor units at the API level; the engine converts for providers that need major units
- Provider templates must use dynamic script loading (createElement + onload), not static `<script src>` tags — static tags cause race conditions in WebViews
- Callable pattern: `Sanwo` class has a `call()` method so `sanwo(context: ..., options: ...)` works directly

## Adding a Provider

1. Create a new package under `packages/sanwo_<provider>/`
2. Add a `pubspec.yaml` with a dependency on `sanwo_flutter: ^0.1.0`
3. Export a `SanwoProviderDefinition` instance from `lib/sanwo_<provider>.dart`
4. Template must use `{{sanwoBridge}}` and `{{params}}` placeholders
5. Template must call `sanwoCallback(event, data)` for events
6. Template must load CDN scripts dynamically (not via static `<script>` tags)
7. Add LICENSE and README.md (required by pub.dev)
