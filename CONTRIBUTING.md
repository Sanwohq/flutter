# Contributing to Sanwo Flutter

Thank you for your interest in contributing to Sanwo Flutter! This document provides guidelines for contributing.

## Getting Started

1. Fork the repository
2. Clone your fork locally
3. Create a new branch for your feature or fix
4. Make your changes
5. Run `dart analyze` to check for issues
6. Submit a pull request

## Development Setup

```bash
# Install dependencies
flutter pub get

# Run analysis
dart analyze

# Run tests
flutter test
```

## Adding a New Provider

To add a new payment provider:

1. Create a template file in `lib/src/templates/` with the provider's HTML template
2. Add the provider definition in `lib/src/providers.dart`
3. Export any new public types from `lib/sanwo_flutter.dart`

### Template Format

Templates must include two placeholders:
- `{{sanwoBridge}}` — replaced with the JavaScript bridge function
- `{{params}}` — replaced with JSON-encoded parameters

The template should call `sanwoCallback(event, data)` to communicate with the Flutter side. Supported events:
- `'success'` — payment completed successfully
- `'cancelled'` — user cancelled the payment
- `'closed'` — checkout UI was closed
- `'error'` — an error occurred
- `'loaded'` — checkout UI finished loading

## Code Style

- Follow the Dart style guide
- Use `dart analyze` to check for issues
- Write doc comments for all public APIs

## Pull Request Process

1. Ensure your code passes `dart analyze` with no issues
2. Update the CHANGELOG.md with your changes
3. Submit your PR against the `main` branch
