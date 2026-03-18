import 'package:flutter/foundation.dart';

import '../../../core/common/result.dart';
import '../../../core/utilities/console_logger.dart';
import '../../../domain/entities/user_entity.dart' show UserEntity;
import '../../../domain/entities/user_entity.dart' as entity;
import '../../../domain/repositories/user_repository.dart';
import '../../../domain/usecases/user_usecases.dart';

/// Offline-first AuthProvider - No Google Sign-In required
/// Automatically creates and authenticates a default local admin user
class AuthProvider extends ChangeNotifier {
  final UserRepository userRepository;

  // Default admin user constants
  static const String _defaultAdminId = 'local-admin';
  static const String _defaultAdminEmail = 'admin@posapp.local';
  static const String _defaultAdminName = 'Admin';

  AuthProvider({required this.userRepository}) {
    initialize();
  }

  bool isAuthenticated = false;
  bool isChecking = true;

  UserEntity? _user;
  UserEntity? get user => _user;

  /// Initialize by creating/loading the default local admin user
  /// No network call - fully offline
  Future<void> initialize() async {
    try {
      cl('[AuthProvider] Starting initialization...');
      isChecking = true;
      notifyListeners();

      // Try to get existing default admin user
      cl('[AuthProvider] Looking for existing admin user...');
      final existingUserRes = await GetUserUsecase(
        userRepository,
      ).call(_defaultAdminId);
      cl(
        '[AuthProvider] GetUser result: success=${existingUserRes.isSuccess}, data=${existingUserRes.data}',
      );

      if (existingUserRes.isSuccess && existingUserRes.data != null) {
        // Use existing admin user
        _user = existingUserRes.data;
        cl('[AuthProvider] Loaded existing local admin user: ${_user?.name}');
      } else {
        // Create default admin user for first-time use
        cl('[AuthProvider] Creating default admin user...');
        final newUser = UserEntity(
          id: _defaultAdminId,
          email: _defaultAdminEmail,
          name: _defaultAdminName,
          authProvider: entity.AuthProvider.local,
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
        );

        final createRes = await CreateUserUsecase(userRepository).call(newUser);
        cl(
          '[AuthProvider] CreateUser result: success=${createRes.isSuccess}, error=${createRes.error}',
        );
        if (createRes.isSuccess) {
          _user = newUser;
          cl(
            '[AuthProvider] Created default local admin user: ${newUser.name}',
          );
        } else {
          cl(
            '[AuthProvider] Failed to create default admin: ${createRes.error}',
          );
        }
      }
    } catch (e, stackTrace) {
      cl('[AuthProvider] ERROR during initialization: $e');
      cl('[AuthProvider] StackTrace: $stackTrace');
      rethrow; // Re-throw so Riverpod catches it and shows proper error
    } finally {
      isChecking = false;
      isAuthenticated = _user != null;
      cl(
        '[AuthProvider] Initialization complete: isAuthenticated=$isAuthenticated',
      );
      notifyListeners();
    }
  }

  /// Sign-in is now automatic - no user action required
  /// This method is kept for compatibility but does nothing
  Future<Result<String>> signIn() async {
    // Auto-authenticated during initialization
    if (_user != null) {
      return Result.success(data: _user!.id);
    }
    return Result.failure(error: 'Authentication not initialized');
  }

  /// Sign-out clears the current user but will be re-created on next init
  Future<Result<void>> signOut() async {
    _user = null;
    isAuthenticated = false;
    notifyListeners();
    return Result.success(data: null);
  }
}
