import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Commented: Removed all Firebase imports
// Previously: cloud_firestore, firebase_auth, firebase_crashlytics,
// firebase_storage, google_sign_in
// Replaced with: drift-based local datasources and logger package

import '../../core/database/app_database.dart';
import '../../core/services/info/device_info_service.dart';
import '../../core/services/printer/printer_service.dart';
import '../../core/services/connectivity/ping_service.dart';
import '../../core/services/logger/error_logger_service.dart';
// Commented: Removed PingService (internet_connection_checker_plus)
// All operations are local-only, no connectivity checks needed

// Local-only datasources (SQLite-based, fully offline)
// Commented: Replaces remote Firebase datasources with SQLite tables
import '../../data/datasources/local/product_local_datasource_impl.dart';
import '../../data/datasources/local/transaction_local_datasource_impl.dart';
import '../../data/datasources/local/user_local_datasource_impl.dart';
import '../../data/datasources/local/queued_action_local_datasource_impl.dart';
import '../../data/datasources/local/cashier_local_datasource_impl.dart';
import '../../data/datasources/interfaces/product_datasource.dart';
import '../../data/datasources/interfaces/transaction_datasource.dart';
import '../../data/datasources/interfaces/user_datasource.dart';
import '../../data/datasources/interfaces/queued_action_datasource.dart';

// Remote datasource stubs (offline-only implementations)
import '../../data/datasources/remote/auth_remote_datasource_impl.dart';
import '../../data/datasources/remote/product_remote_datasource_impl.dart';
import '../../data/datasources/remote/storage_remote_datasource_impl.dart';
import '../../data/datasources/remote/transaction_remote_datasource_impl.dart';
import '../../data/datasources/remote/user_remote_datasource_impl.dart';
import '../../data/datasources/remote/cashier_remote_datasource_impl.dart';

// Repositories
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../data/repositories/queued_action_repository_impl.dart';
import '../../data/repositories/storage_repository_impl.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/repositories/cashier_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/repositories/queued_action_repository.dart';
import '../../domain/repositories/storage_repository.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/cashier_repository.dart';

// Presentation Providers - Commented out during refactoring
// import '../../presentation/providers/account/account_provider.dart';
// import '../../presentation/providers/account/printer_settings_provider.dart';

import '../../presentation/providers/theme/theme_provider.dart';
import '../../presentation/providers/session/session_provider.dart';
import '../../presentation/providers/account/account_provider.dart';
import '../../presentation/providers/account/printer_settings_provider.dart';
import '../../presentation/providers/auth/auth_provider.dart';
import '../../presentation/providers/home/home_provider.dart';
import '../../presentation/providers/main/main_provider.dart';
import '../../presentation/providers/products/product_detail_provider.dart';
import '../../presentation/providers/products/product_form_provider.dart';
import '../../presentation/providers/products/products_provider.dart';
import '../../presentation/providers/products/product_category_provider.dart';
import '../../presentation/providers/transactions/transaction_detail_provider.dart';
import '../../presentation/providers/transactions/transactions_provider.dart';
import '../../presentation/providers/cashier/cashier_provider.dart';
import '../routes/app_routes.dart';

// ============================================================================
// STARTUP OVERRIDES
// ============================================================================

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError(
    'sharedPreferencesProvider must be overridden at app startup.',
  ),
);

// ============================================================================
// CORE SERVICES
// ============================================================================

// Commented: Removed PingService (connectivity checking)
// All app operations are local and offline-first

final loggerProvider = Provider<Logger>((ref) => Logger());

final pingServiceProvider = Provider<PingService>((ref) => PingService());

final errorLoggerProvider = Provider<ErrorLoggerService>(
  (ref) => ErrorLoggerService(),
);

final deviceInfoPluginProvider = Provider<DeviceInfoPlugin>(
  (ref) => DeviceInfoPlugin(),
);

final deviceInfoServiceProvider = Provider<DeviceInfoService>(
  (ref) => DeviceInfoService(ref.watch(deviceInfoPluginProvider)),
);

final printerServiceProvider = Provider<PrinterService>(
  (ref) => PrinterService(ref.watch(sharedPreferencesProvider)),
);

// Commented: Removed ErrorLoggerService(firebaseCrashlytics)
// Replaced with local logger package
// All data stays local - no remote error reporting

// ============================================================================
// DATABASE
// ============================================================================

final appDatabaseProvider = Provider<AppDatabase>(
  (ref) => AppDatabase.instance,
);

// ============================================================================
// LOCAL DATASOURCES (Drift-based, fully offline)
// Commented: Replaces Firebase remote datasources
// All operations are immediate and stored in local SQLite
// ============================================================================

final productLocalDatasourceProvider = Provider<ProductDatasource>(
  (ref) => ProductLocalDatasourceImpl(ref.watch(appDatabaseProvider)),
);

final transactionLocalDatasourceProvider = Provider<TransactionDatasource>(
  (ref) => TransactionLocalDatasourceImpl(ref.watch(appDatabaseProvider)),
);

final userLocalDatasourceProvider = Provider<UserDatasource>(
  (ref) => UserLocalDatasourceImpl(ref.watch(appDatabaseProvider)),
);

final cashierLocalDatasourceProvider = Provider<CashierLocalDataSource>(
  (ref) => CashierLocalDataSourceImpl(ref.watch(appDatabaseProvider)),
);

final queuedActionLocalDatasourceProvider = Provider<QueuedActionDatasource>(
  (ref) => QueuedActionLocalDatasourceImpl(),
);

// Remote datasource providers (offline stubs)
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSourceImpl>(
  (ref) => AuthRemoteDataSourceImpl(),
);

final storageRemoteDataSourceProvider = Provider<StorageRemoteDataSourceImpl>(
  (ref) => StorageRemoteDataSourceImpl(),
);

final productRemoteDatasourceProvider = Provider<ProductRemoteDatasourceImpl>(
  (ref) => ProductRemoteDatasourceImpl(),
);

final transactionRemoteDatasourceProvider =
    Provider<TransactionRemoteDatasourceImpl>(
      (ref) => TransactionRemoteDatasourceImpl(),
    );

final userRemoteDatasourceProvider = Provider<UserRemoteDatasourceImpl>(
  (ref) => UserRemoteDatasourceImpl(),
);

final cashierRemoteDatasourceProvider = Provider<CashierRemoteDatasourceImpl>(
  (ref) => CashierRemoteDatasourceImpl(),
);

// Commented: Removed remote datasource providers entirely
// Previously: authRemoteDataSourceProvider, productRemoteDatasourceProvider,
// transactionRemoteDatasourceProvider, userRemoteDatasourceProvider,
// cashierRemoteDatasourceProvider, storageRemoteDataSourceProvider
// All now use local drift-based datasources only

// ============================================================================
// REPOSITORIES (Local-only, no connectivity checks)
// Commented: All repositories now use only local datasources
// No Firebase calls, no remote sync, no offline queue
// All data is immediate and persistent
// ============================================================================

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    authRemoteDataSource: ref.watch(authRemoteDataSourceProvider),
    pingService: ref.watch(pingServiceProvider),
  ),
);

final storageRepositoryProvider = Provider<StorageRepository>(
  (ref) => StorageRepositoryImpl(
    pingService: ref.watch(pingServiceProvider),
    storageRemoteDataSource: ref.watch(storageRemoteDataSourceProvider),
    queuedActionLocalDatasource:
        ref.watch(queuedActionLocalDatasourceProvider) as dynamic,
  ),
);

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepositoryImpl(
    pingService: ref.watch(pingServiceProvider),
    productLocalDatasource:
        ref.watch(productLocalDatasourceProvider) as dynamic,
    productRemoteDatasource: ref.watch(productRemoteDatasourceProvider),
    queuedActionLocalDatasource:
        ref.watch(queuedActionLocalDatasourceProvider) as dynamic,
  ),
);

final transactionRepositoryProvider = Provider<TransactionRepository>(
  (ref) => TransactionRepositoryImpl(
    pingService: ref.watch(pingServiceProvider),
    transactionLocalDatasource:
        ref.watch(transactionLocalDatasourceProvider) as dynamic,
    transactionRemoteDatasource: ref.watch(transactionRemoteDatasourceProvider),
    queuedActionLocalDatasource:
        ref.watch(queuedActionLocalDatasourceProvider) as dynamic,
  ),
);

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepositoryImpl(
    pingService: ref.watch(pingServiceProvider),
    userLocalDatasource: ref.watch(userLocalDatasourceProvider) as dynamic,
    userRemoteDatasource: ref.watch(userRemoteDatasourceProvider),
    queuedActionLocalDatasource:
        ref.watch(queuedActionLocalDatasourceProvider) as dynamic,
  ),
);

final queuedActionRepositoryProvider = Provider<QueuedActionRepository>(
  (ref) => QueuedActionRepositoryImpl(
    pingService: ref.watch(pingServiceProvider),
    queuedActionLocalDatasource:
        ref.watch(queuedActionLocalDatasourceProvider) as dynamic,
    userRemoteDatasource: ref.watch(userRemoteDatasourceProvider),
    transactionRemoteDatasource: ref.watch(transactionRemoteDatasourceProvider),
    productRemoteDatasource: ref.watch(productRemoteDatasourceProvider),
    cashierRemoteDatasource: ref.watch(cashierRemoteDatasourceProvider),
  ),
);

final cashierRepositoryProvider = Provider<CashierRepository>(
  (ref) => CashierRepositoryImpl(
    pingService: ref.watch(pingServiceProvider),
    cashierLocalDatasource: ref.watch(cashierLocalDatasourceProvider),
    cashierRemoteDatasource: ref.watch(cashierRemoteDatasourceProvider),
    queuedActionLocalDatasource:
        ref.watch(queuedActionLocalDatasourceProvider) as dynamic,
  ),
);

// // Commented: Removed queuedActionRepositoryProvider
// // All operations are now immediate and local
// // No deferred sync queue needed

// // ============================================================================
// // PRESENTATION PROVIDERS
// // ============================================================================

// final authControllerProvider = ChangeNotifierProvider<AuthProvider>(
//   (ref) => AuthProvider(
//     userRepository: ref.watch(userRepositoryProvider),
//     authRepository: ref.watch(authRepositoryProvider),
//     // Commented: Removed google_sign_in logic
//   ),
// );

// final productsControllerProvider = ChangeNotifierProvider<ProductsProvider>(
//   (ref) => ProductsProvider(
//     authProvider: ref.read(authControllerProvider),
//     productRepository: ref.watch(productRepositoryProvider),
//   ),
// );

// final categoryControllerProvider = ChangeNotifierProvider<CategoryController>(
//   (ref) => CategoryController(
//     ref.watch(productRepositoryProvider),
//   ),
// );

// final transactionsControllerProvider = ChangeNotifierProvider<TransactionsProvider>(
//   (ref) => TransactionsProvider(
//     authProvider: ref.read(authControllerProvider),
//     transactionRepository: ref.watch(transactionRepositoryProvider),
//   ),
// );

// final mainControllerProvider = ChangeNotifierProvider<MainProvider>(
//   (ref) => MainProvider(
//     deviceInforService: ref.watch(deviceInfoServiceProvider),
//     // Commented: Removed pingService (connectivity check)
//     authProvider: ref.read(authControllerProvider),
//     userRepository: ref.watch(userRepositoryProvider),
//     productRepository: ref.watch(productRepositoryProvider),
//     transactionRepository: ref.watch(transactionRepositoryProvider),
//     // Commented: Removed queuedActionRepository (offline queue)
//     productsProvider: ref.read(productsControllerProvider),
//     cashierRepository: ref.watch(cashierRepositoryProvider),
//   ),
// );

// final homeControllerProvider = ChangeNotifierProvider.autoDispose<HomeProvider>(
//   (ref) => HomeProvider(
//     authProvider: ref.read(authControllerProvider),
//     transactionRepository: ref.watch(transactionRepositoryProvider),
//     printerService: ref.watch(printerServiceProvider),
//     productsProvider: ref.read(productsControllerProvider),
//     sessionProvider: ref.read(sessionControllerProvider),
//   ),
// );

// final accountControllerProvider = ChangeNotifierProvider.autoDispose<AccountProvider>(
//   (ref) => AccountProvider(
//     authProvider: ref.read(authControllerProvider),
//     authRepository: ref.watch(authRepositoryProvider),
//     userRepository: ref.watch(userRepositoryProvider),
//     storageRepository: ref.watch(storageRepositoryProvider),
//     // Commented: Removed firebase storage operations
//   ),
// );

// final productFormControllerProvider = ChangeNotifierProvider.autoDispose<ProductFormProvider>(
//   (ref) => ProductFormProvider(
//     authProvider: ref.read(authControllerProvider),
//     productRepository: ref.watch(productRepositoryProvider),
//     storageRepository: ref.watch(storageRepositoryProvider),
//     productsProvider: ref.read(productsControllerProvider),
//     // Commented: Removed firebase storage for images
//     // Images are now bundled assets or stored in SQLite as BlobColumn
//   ),
// );

// final productDetailControllerProvider = ChangeNotifierProvider.autoDispose<ProductDetailProvider>(
//   (ref) => ProductDetailProvider(
//     productRepository: ref.watch(productRepositoryProvider),
//   ),
// );

// final transactionDetailControllerProvider = ChangeNotifierProvider.autoDispose<TransactionDetailProvider>(
//   (ref) => TransactionDetailProvider(
//     transactionRepository: ref.watch(transactionRepositoryProvider),
//   ),
// );

// final themeControllerProvider = ChangeNotifierProvider<ThemeProvider>(
//   (ref) => ThemeProvider(ref.watch(sharedPreferencesProvider)),
// );

// final printerSettingsControllerProvider = ChangeNotifierProvider.autoDispose<PrinterSettingsProvider>(
//   (ref) => PrinterSettingsProvider(
//     printerService: ref.watch(printerServiceProvider),
//     sharedPreferences: ref.watch(sharedPreferencesProvider),
//   ),
// );

// final cashiersControllerProvider = ChangeNotifierProvider<CashiersProvider>((ref) {
//   return CashiersProvider(
//     authProvider: ref.read(authControllerProvider),
//     cashierRepository: ref.watch(cashierRepositoryProvider),
//   );
// });

// final sessionControllerProvider = ChangeNotifierProvider<SessionProvider>((ref) {
//   final prefs = ref.watch(sharedPreferencesProvider);
//   return SessionProvider(sharedPreferences: prefs);
// });

// // ============================================================================
// // ROUTES
// // ============================================================================

// final appRoutesProvider = Provider<AppRoutes>(
//   (ref) => AppRoutes(
//     ref.read(authControllerProvider),
//     ref.read(sessionControllerProvider),
//   ),
// );

// Commented: All refactoring in progress
// - Removed Firebase entirely (cloud_firestore, firebase_auth, firebase_storage, etc.)
// - Removed connectivity checking (internet_connection_checker_plus, connectivity_plus, PingService)
// - Removed Google Sign-In
// - Removed offline sync queue (queuedActionRepository)
// - Database configured for 100% offline-first using SQLite + drift
// - Next: Fix repositories to work with local-only architecture

// Temporary placeholder providers (being refactored)
final themeControllerProvider = ChangeNotifierProvider<ThemeProvider>(
  (ref) => ThemeProvider(ref.watch(sharedPreferencesProvider)),
);

final appRoutesProvider = Provider<AppRoutes>(
  (ref) => AppRoutes(
    ref.read(authControllerProvider),
    ref.read(sessionControllerProvider),
  ),
);

final sessionControllerProvider = ChangeNotifierProvider<SessionProvider>((
  ref,
) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SessionProvider(sharedPreferences: prefs);
});

final authControllerProvider = ChangeNotifierProvider<AuthProvider>(
  (ref) => AuthProvider(userRepository: ref.watch(userRepositoryProvider)),
);

final productsControllerProvider = ChangeNotifierProvider<ProductsProvider>(
  (ref) => ProductsProvider(
    authProvider: ref.read(authControllerProvider),
    productRepository: ref.watch(productRepositoryProvider),
  ),
);

final categoryControllerProvider = ChangeNotifierProvider<CategoryController>(
  (ref) => CategoryController(ref.watch(productRepositoryProvider)),
);

final transactionsControllerProvider =
    ChangeNotifierProvider<TransactionsProvider>(
      (ref) => TransactionsProvider(
        authProvider: ref.read(authControllerProvider),
        transactionRepository: ref.watch(transactionRepositoryProvider),
      ),
    );

final mainControllerProvider = ChangeNotifierProvider<MainProvider>(
  (ref) => MainProvider(
    deviceInforService: ref.watch(deviceInfoServiceProvider),
    pingService: ref.watch(pingServiceProvider),
    authProvider: ref.read(authControllerProvider),
    userRepository: ref.watch(userRepositoryProvider),
    productRepository: ref.watch(productRepositoryProvider),
    transactionRepository: ref.watch(transactionRepositoryProvider),
    queuedActionRepository: ref.watch(queuedActionRepositoryProvider),
    productsProvider: ref.read(productsControllerProvider),
    cashierRepository: ref.watch(cashierRepositoryProvider),
  ),
);

final homeControllerProvider = ChangeNotifierProvider.autoDispose<HomeProvider>(
  (ref) => HomeProvider(
    authProvider: ref.read(authControllerProvider),
    transactionRepository: ref.watch(transactionRepositoryProvider),
    printerService: ref.watch(printerServiceProvider),
    productsProvider: ref.read(productsControllerProvider),
    sessionProvider: ref.read(sessionControllerProvider),
  ),
);

final accountControllerProvider =
    ChangeNotifierProvider.autoDispose<AccountProvider>(
      (ref) => AccountProvider(
        authProvider: ref.read(authControllerProvider),
        userRepository: ref.watch(userRepositoryProvider),
        storageRepository: ref.watch(storageRepositoryProvider),
      ),
    );

final productFormControllerProvider =
    ChangeNotifierProvider.autoDispose<ProductFormProvider>(
      (ref) => ProductFormProvider(
        authProvider: ref.read(authControllerProvider),
        productRepository: ref.watch(productRepositoryProvider),
        storageRepository: ref.watch(storageRepositoryProvider),
        productsProvider: ref.read(productsControllerProvider),
      ),
    );

final productDetailControllerProvider =
    ChangeNotifierProvider.autoDispose<ProductDetailProvider>(
      (ref) => ProductDetailProvider(
        productRepository: ref.watch(productRepositoryProvider),
      ),
    );

final transactionDetailControllerProvider =
    ChangeNotifierProvider.autoDispose<TransactionDetailProvider>(
      (ref) => TransactionDetailProvider(
        transactionRepository: ref.watch(transactionRepositoryProvider),
      ),
    );

final printerSettingsControllerProvider =
    ChangeNotifierProvider.autoDispose<PrinterSettingsProvider>(
      (ref) => PrinterSettingsProvider(
        printerService: ref.watch(printerServiceProvider),
        sharedPreferences: ref.watch(sharedPreferencesProvider),
      ),
    );

final cashiersControllerProvider = ChangeNotifierProvider<CashiersProvider>((
  ref,
) {
  return CashiersProvider(
    authProvider: ref.read(authControllerProvider),
    cashierRepository: ref.watch(cashierRepositoryProvider),
  );
});
