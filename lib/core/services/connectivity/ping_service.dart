import 'dart:async';

/// Offline-only stub: Provides connectivity interface without actual network operations.
/// Always reports disconnected status since the app operates in zero-connectivity environments.
class PingService {
  final List<Function(bool isConnected)> _connectionStatusListeners = [];

  /// Always returns false - app is fully offline
  Future<bool> get isConnected async => false;

  /// No-op for offline-only build
  Future<void> startPing({
    String host = '8.8.8.8',
    int? count,
    int interval = 1,
    int maxPingLatencyTolerance = 400,
    int pingLatencyToleranceCount = 3,
    int maxLines = 100,
  }) async {
    // Notify listeners with disconnected status
    for (var listener in _connectionStatusListeners) {
      try {
        listener(false);
      } catch (_) {}
    }
  }

  /// Register a connection status listener
  void addConnectionStatusListener(Function(bool isConnected) listener) {
    if (_connectionStatusListeners.contains(listener)) return;
    _connectionStatusListeners.add(listener);
    listener(false);
  }

  /// Unregister a connection status listener
  void removeConnectionStatusListener(Function(bool isConnected) listener) {
    _connectionStatusListeners.remove(listener);
  }

  /// Unregister all connection status listeners
  void clearConnectionStatusListeners() {
    _connectionStatusListeners.clear();
  }

  /// No-op for offline-only build
  void stopPing() {}

  /// No-op for offline-only build
  void dispose() {
    clearConnectionStatusListeners();
  }
}
