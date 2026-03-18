import '../../../core/common/result.dart';
import '../../models/user_model.dart';
import '../interfaces/user_datasource.dart';

/// Remote datasource disabled in offline-only build.
/// All methods return Failure with UnsupportedError so any accidental
/// usage will fail-fast and clearly indicate remote services are
/// intentionally disabled.
class UserRemoteDatasourceImpl extends UserDatasource {
  UserRemoteDatasourceImpl();

  @override
  Future<Result<String>> createUser(UserModel user) async {
    return Result.failure(
      error: UnsupportedError(
        'Remote datasources disabled in offline-only build',
      ),
    );
  }

  @override
  Future<Result<void>> updateUser(UserModel user) async {
    return Result.failure(
      error: UnsupportedError(
        'Remote datasources disabled in offline-only build',
      ),
    );
  }

  @override
  Future<Result<void>> deleteUser(String id) async {
    return Result.failure(
      error: UnsupportedError(
        'Remote datasources disabled in offline-only build',
      ),
    );
  }

  @override
  Future<Result<UserModel?>> getUser(String id) async {
    return Result.failure(
      error: UnsupportedError(
        'Remote datasources disabled in offline-only build',
      ),
    );
  }
}
