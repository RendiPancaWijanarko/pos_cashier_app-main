/// Offline-only variant of ExternalLauncher.
/// This blocks any `http`/`https` launches to ensure the
/// application never attempts network access. Non-network
/// intents (for example, deep links with custom schemes) are
/// explicitly not supported in this offline build.
class ExternalLauncher {
  ExternalLauncher._();

  static void openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) throw Exception('Invalid URL: $url');

    if (uri.scheme == 'http' || uri.scheme == 'https' || uri.scheme.isEmpty) {
      throw Exception('Offline mode: opening web links is disabled.');
    }

    // For other schemes we decline to open external resources
    // in offline mode to guarantee zero network use.
    throw Exception('Offline mode: external URL schemes are disabled.');
  }

  static void openWhatsApp({
    required String phone,
    required String message,
  }) async {
    throw Exception('Offline mode: WhatsApp integration is disabled.');
  }

  static Future<void> openMap(double latitude, double longitude) async {
    throw Exception('Offline mode: map/geo navigation is disabled.');
  }
}
