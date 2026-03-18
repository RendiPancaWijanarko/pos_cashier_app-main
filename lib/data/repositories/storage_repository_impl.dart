import '../../../../core/common/result.dart';
import '../../core/services/connectivity/ping_service.dart';
import '../../domain/repositories/storage_repository.dart';
import '../datasources/remote/storage_remote_datasource_impl.dart';
import '../datasources/local/queued_action_local_datasource_impl.dart';
import '../models/queued_action_model.dart';

class StorageRepositoryImpl implements StorageRepository {
  final PingService pingService;
  final StorageRemoteDataSourceImpl storageRemoteDataSource;
  final QueuedActionLocalDatasourceImpl queuedActionLocalDatasource;

  StorageRepositoryImpl({
    required this.pingService,
    required this.storageRemoteDataSource,
    required this.queuedActionLocalDatasource,
  });

  @override
  Future<Result<String>> uploadUserPhoto(String imgPath) async {
    try {
      if (!await pingService.isConnected) {
        // Queue the upload for later; do not attempt network call now
        await queuedActionLocalDatasource.createQueuedAction(
          QueuedActionModel(
            id: DateTime.now().millisecondsSinceEpoch,
            repository: 'StorageRepositoryImpl',
            method: 'uploadUserPhoto',
            param: imgPath,
            isCritical: false,
            createdAt: DateTime.now().toIso8601String(),
          ),
        );

        return Result.failure(error: 'Offline mode: upload queued');
      }

      final res = await storageRemoteDataSource.uploadUserPhoto(imgPath);
      if (res.isFailure) return Result.failure(error: res.error!);

      return Result.success(data: res.data!);
    } catch (e) {
      return Result.failure(error: e);
    }
  }

  @override
  Future<Result<String>> uploadProductImage(String imgPath) async {
    try {
      if (!await pingService.isConnected) {
        // Queue the upload for later; do not attempt network call now
        await queuedActionLocalDatasource.createQueuedAction(
          QueuedActionModel(
            id: DateTime.now().millisecondsSinceEpoch,
            repository: 'StorageRepositoryImpl',
            method: 'uploadProductImage',
            param: imgPath,
            isCritical: false,
            createdAt: DateTime.now().toIso8601String(),
          ),
        );

        return Result.failure(error: 'Offline mode: upload queued');
      }

      final res = await storageRemoteDataSource.uploadProductImage(imgPath);
      if (res.isFailure) return Result.failure(error: res.error!);

      return Result.success(data: res.data!);
    } catch (e) {
      return Result.failure(error: e);
    }
  }
}
