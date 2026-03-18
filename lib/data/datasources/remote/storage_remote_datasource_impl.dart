import '../../../core/common/result.dart';
import '../interfaces/storage_datasource.dart';

/// Remote storage disabled in offline-only build.
class StorageRemoteDataSourceImpl implements StorageDataSource {
  StorageRemoteDataSourceImpl();

  @override
  Future<Result<String>> uploadUserPhoto(String imgPath) async {
    return Result.failure(
      error: UnsupportedError('Remote storage disabled in offline-only build'),
    );
  }

  @override
  Future<Result<String>> uploadProductImage(String imgPath) async {
    return Result.failure(
      error: UnsupportedError('Remote storage disabled in offline-only build'),
    );
  }
}
