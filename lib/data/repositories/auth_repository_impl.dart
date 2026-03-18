import '../../../../core/common/result.dart';
import '../../core/services/connectivity/ping_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_datasource_impl.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSourceImpl authRemoteDataSource;
  final PingService pingService;

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.pingService,
  });

  @override
  Future<Result<UserEntity>> signInWithGoogle() async {
    try {
      if (!await pingService.isConnected) {
        return Result.failure(
          error: 'Offline mode: authentication unavailable',
        );
      }

      final res = await authRemoteDataSource.signInWithGoogle();
      if (res.isFailure) return Result.failure(error: res.error!);

      return Result.success(data: res.data!.toEntity());
    } catch (e) {
      return Result.failure(error: e);
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      if (!await pingService.isConnected) {
        return Result.failure(error: 'Offline mode: sign-out unavailable');
      }

      final res = await authRemoteDataSource.signOut();
      if (res.isFailure) return Result.failure(error: res.error!);

      return Result.success(data: null);
    } catch (e) {
      return Result.failure(error: e);
    }
  }

  @override
  Future<Result<UserEntity?>> getCurrentUser() async {
    try {
      if (!await pingService.isConnected) {
        // Offline: return null current user instead of attempting network call
        return Result.success(data: null);
      }

      final res = await authRemoteDataSource.getCurrentUser();
      if (res.isFailure) return Result.failure(error: res.error!);

      return Result.success(data: res.data?.toEntity());
    } catch (e) {
      return Result.failure(error: e);
    }
  }
}
