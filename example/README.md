# Adjust Flutter Example App

A comprehensive demonstration application showcasing the full functionality of the Adjust Flutter SDK. This app provides interactive examples of all major SDK features and serves as a reference implementation.

## Features

- **Event Tracking**: Demonstrate simple, revenue, callback, and partner events
- **Device Information**: Access Google AdID, Adjust identifier, IDFA, and attribution data
- **SDK Management**: Toggle SDK state and check enabled status
- **Real-time Callbacks**: Live demonstration of attribution, session, and event callbacks
- **Modern UI**: Beautiful, intuitive interface following Adjust design guidelines

## Getting Started

1. **Prerequisites**: Ensure Flutter is installed and configured
2. **Install Dependencies**: Run `flutter pub get` in this directory
3. **Run the App**: Use `flutter run` to start the example application
4. **Explore Features**: Tap buttons to test different SDK functionalities

## App Structure

- **Event Tracking Section**: Test different types of events with various parameters
- **Device Information Section**: Retrieve device-specific identifiers and attribution
- **SDK Control Section**: Manage SDK state and verify functionality

## SDK Configuration

The app is configured with:
- **App Token**: `2fm9gkqubvpc` (sandbox environment)
- **Environment**: Sandbox mode for safe testing
- **Log Level**: Verbose logging for detailed insights
- **Callbacks**: Comprehensive callback setup for all event types

## Event Tokens

The following test event tokens are configured:
- **Simple Event**: `g3mfiw` - Basic event tracking
- **Revenue Event**: `a4fd35` - Event with revenue data
- **Callback Event**: `34vgg9` - Event with callback parameters  
- **Partner Event**: `w788qs` - Event with partner parameters

## Usage Examples

### Track a Simple Event
```dart
final event = AdjustEvent('g3mfiw');
Adjust.trackEvent(event);
```

### Track Revenue Event
```dart
final event = AdjustEvent('a4fd35');
event.setRevenue(100.0, 'EUR');
event.transactionId = 'DummyTransactionId';
Adjust.trackEvent(event);
```

### Get Attribution Data
```dart
Adjust.getAttribution().then((attribution) {
  // Handle attribution data
});
```

## Callbacks

The app demonstrates all available callback types:
- **Attribution Callback**: Triggered when attribution data changes
- **Session Success/Failure**: Monitor session tracking status
- **Event Success/Failure**: Track event delivery status
- **Deferred Deeplinks**: Handle deferred deeplink scenarios
- **SKAN Updates**: iOS StoreKit Ad Network updates

## Testing

Use this app to:
- Verify SDK integration in your development environment
- Test different event tracking scenarios
- Understand callback behavior and data structure
- Validate attribution and device identifier retrieval
