import '../../utilities/console_logger.dart';

/// Global error logging service for offline-only builds.
/// Crashlytics and remote error reporting are disabled to
/// guarantee zero outbound network activity. Errors are
/// recorded locally to console only.
class ErrorLoggerService {
  ErrorLoggerService();

  void log({
    required Object error,
    StackTrace? stackTrace,
    String? title,
    String? message,
    String? state,
  }) {
    // Always log to console. Do not perform any remote reporting.
    ce(error, title: title, message: message, state: state);
  }
}
