import 'dart:ui';

// Commented: Removed Firebase imports entirely - app is fully offline-first
// Previously: cloud_firestore, firebase_core, firebase_auth, google_sign_in
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/app.dart';
import 'app/di/app_providers.dart';
import 'core/database/app_database.dart';

/// ProviderObserver to catch provider errors during initialization
base class AppProviderObserver extends ProviderObserver {
  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    debugPrint(
      '[ProviderObserver] Provider added: ${context.provider.name ?? context.provider.runtimeType}',
    );
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {
    debugPrint(
      '[ProviderObserver] Provider disposed: ${context.provider.name ?? context.provider.runtimeType}',
    );
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    debugPrint(
      '[ProviderObserver] Provider FAILED: ${context.provider.name ?? context.provider.runtimeType}',
    );
    debugPrint('[ProviderObserver] Error: $error');
    debugPrint('[ProviderObserver] StackTrace: $stackTrace');
  }
}

/// Error widget to display when the app fails to start
class StartupErrorWidget extends StatelessWidget {
  final Object error;
  final StackTrace? stackTrace;

  const StartupErrorWidget({super.key, required this.error, this.stackTrace});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 64,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Terjadi Kesalahan!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: $error',
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  if (stackTrace != null)
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          stackTrace.toString(),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white54,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() async {
  // Capture any asynchronous errors so we can log them when the app fails to start.
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    // Also print to console so it shows up in terminal output.
    debugPrint('FlutterError caught: ${details.exceptionAsString()}');
    debugPrint(details.stack.toString());
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('PlatformDispatcher error: $error');
    debugPrint(stack.toString());
    return true;
  };

  // Initialize binding
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Commented: Removed Firebase initialization entirely
    // Previously: await Firebase.initializeApp(...)
    // Now using drift (SQLite) - fully local and offline-first
    // No network call or server dependency

    // Initialize app local db
    debugPrint('Initializing database...');
    await AppDatabase.init();
    debugPrint('Database initialized successfully');

    // Commented: Removed FirebaseFirestore.clearPersistence()
    // Not needed - drift uses local SQLite only

    // Initialize date formatting
    debugPrint('Initializing date formatting...');
    await initializeDateFormatting('id_ID', null);
    debugPrint('Date formatting initialized');

    // Initialize shared preferences
    debugPrint('Initializing shared preferences...');
    final sharedPreferences = await SharedPreferences.getInstance();
    debugPrint('Shared preferences initialized');

    // Set/lock screen orientation
    debugPrint('Setting orientation...');
    await SystemChrome.setPreferredOrientations([]);
    debugPrint('Orientation set');

    // Set Default SystemUIOverlayStyle
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
      ),
    );

    debugPrint('Running app...');
    runApp(
      ProviderScope(
        observers: [AppProviderObserver()],
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
        child: const App(),
      ),
    );
  } catch (e, stackTrace) {
    // Log the error
    debugPrint('=== STARTUP ERROR ===');
    debugPrint('Error: $e');
    debugPrint('StackTrace: $stackTrace');

    // Show error widget instead of crashing
    runApp(StartupErrorWidget(error: e, stackTrace: stackTrace));
  }
}
