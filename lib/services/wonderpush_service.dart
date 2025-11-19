import 'package:flutter/foundation.dart';
import 'package:wonderpush_flutter/wonderpush_flutter.dart';

/// Lightweight wrapper that keeps the WonderPush SDK in sync with the app state.
class WonderPushService implements WonderPushDelegate {
  WonderPushService._();

  static final WonderPushService instance = WonderPushService._();

  static bool _initialized = false;

  /// Initializes the WonderPush SDK and registers a delegate for logging / debugging.
  static Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    if (kDebugMode) {
      await WonderPush.setLogging(true);
    }

    // Register a delegate so we can react to background notifications later.
    WonderPush.setDelegate(instance);
    _initialized = true;
  }

  /// Subscribes the current installation to WonderPush notifications.
  static Future<void> subscribe() async {
    await initialize();
    await WonderPush.subscribeToNotifications();
  }

  /// Unsubscribes the current installation from WonderPush notifications.
  static Future<void> unsubscribe() async {
    await initialize();
    await WonderPush.unsubscribeFromNotifications();
  }

  @override
  void onNotificationReceived(Map<String, dynamic> notification) {
    if (kDebugMode) {
      debugPrint('WonderPush notification received: $notification');
    }
  }

  @override
  void onNotificationOpened(
    Map<String, dynamic> notification,
    int buttonIndex,
  ) {
    if (kDebugMode) {
      debugPrint(
        'WonderPush notification opened (button $buttonIndex): $notification',
      );
    }
  }
}

