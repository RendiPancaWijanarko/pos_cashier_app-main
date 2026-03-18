// Firebase is intentionally disabled for the offline-only build.
// This file provides a minimal placeholder so imports of
// `DefaultFirebaseOptions` do not force a dependency on `firebase_core`.

class DefaultFirebaseOptions {
  static dynamic get currentPlatform =>
      throw UnsupportedError('Firebase is disabled in offline build');
}
