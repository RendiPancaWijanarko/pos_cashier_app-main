import '../../../core/common/result.dart';
import '../../models/user_model.dart';
import '../interfaces/auth_datasource.dart';

/// Remote auth datasource disabled in offline-only build.
class AuthRemoteDataSourceImpl implements AuthDataSource {
  AuthRemoteDataSourceImpl();

  @override
  Future<Result<UserModel>> signInWithGoogle() async {
    return Result.failure(
      error: UnsupportedError('Remote auth disabled in offline-only build'),
    );
  }

  @override
  Future<Result<void>> signOut() async {
    return Result.failure(
      error: UnsupportedError('Remote auth disabled in offline-only build'),
    );
  }

  @override
  Future<Result<UserModel?>> getCurrentUser() async {
    return Result.failure(
      error: UnsupportedError('Remote auth disabled in offline-only build'),
    );
  }
}
