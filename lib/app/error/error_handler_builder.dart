import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/widgets/app_error_widget.dart';
// Commented: Error logging and routing removed during Firebase elimination
// import '../../core/services/logger/error_logger_service.dart';
// import '../../core/utilities/console_logger.dart';
// import '../di/app_providers.dart';
// import '../routes/app_routes.dart';
// import '../routes/params/error_screen_param.dart';

class ErrorHandlerBuilder extends ConsumerStatefulWidget {
  final Widget? child;

  const ErrorHandlerBuilder({super.key, this.child});

  @override
  ErrorHandlerBuilderState createState() => ErrorHandlerBuilderState();
}

class ErrorHandlerBuilderState extends ConsumerState<ErrorHandlerBuilder> {
  // Commented: Error logging service removed (Firebase Crashlytics)
  // AppRoutes get _appRoutes => ref.read(appRoutesProvider);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Set up custom widget error
      ErrorWidget.builder =
          (error) => AppErrorWidget(error: error, textOnly: true);

      // Called whenever the Flutter framework catches an error
      FlutterError.onError = onFlutterError;

      // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
      PlatformDispatcher.instance.onError = onPlatformError;
    });
  }

  // Flutter error handling logic
  void onFlutterError(FlutterErrorDetails flutterError) {
    // Commented: Error logging service removed - Firebase Crashlytics
    // _errorLoggerService.log(error: flutterError);
    debugPrintStack(stackTrace: flutterError.stack);
    debugPrint('Flutter Error: ${flutterError.exception}');

    // Commented: Route error handler removed - to be reimplemented
    // if (!mounted) return;
    // if (_appRoutes.router.routeInformationProvider.value.uri.path != '/error') {
    //   _appRoutes.router.go('/error', extra: ErrorScreenParam(flutterError: flutterError));
    // }
  }

  // Platform error handling logic
  bool onPlatformError(Object error, StackTrace stackTrace) {
    // Commented: Error logging service removed - Firebase Crashlytics
    // _errorLoggerService.log(error: error, stackTrace: stackTrace);
    debugPrint('Platform Error: $error');
    debugPrintStack(stackTrace: stackTrace);

    // Commented: Route error handler removed - to be reimplemented
    // if (!mounted) return false;
    // if (_appRoutes.router.routeInformationProvider.value.uri.path != '/error') {
    //   _appRoutes.router.go(
    //     '/error',
    //     extra: ErrorScreenParam(error: error, stackTrace: stackTrace),
    //   );
    // }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(top: false, child: widget.child ?? const SizedBox.shrink());
  }
}
