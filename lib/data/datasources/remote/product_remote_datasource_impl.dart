import '../../../core/common/result.dart';
import '../../models/product_model.dart';
import '../interfaces/product_datasource.dart';

/// Remote product datasource disabled in offline-only build.
class ProductRemoteDatasourceImpl extends ProductDatasource {
  ProductRemoteDatasourceImpl();

  @override
  Future<Result<int>> createProduct(ProductModel product) async {
    return Result.failure(
      error: UnsupportedError(
        'Remote datasources disabled in offline-only build',
      ),
    );
  }

  @override
  Future<Result<void>> updateProduct(ProductModel product) async {
    return Result.failure(
      error: UnsupportedError(
        'Remote datasources disabled in offline-only build',
      ),
    );
  }

  @override
  Future<Result<void>> deleteProduct(int id) async {
    return Result.failure(
      error: UnsupportedError(
        'Remote datasources disabled in offline-only build',
      ),
    );
  }

  @override
  Future<Result<ProductModel?>> getProduct(int id) async {
    return Result.failure(
      error: UnsupportedError(
        'Remote datasources disabled in offline-only build',
      ),
    );
  }

  @override
  Future<Result<List<ProductModel>>> getAllUserProducts(String userId) async {
    return Result.failure(
      error: UnsupportedError(
        'Remote datasources disabled in offline-only build',
      ),
    );
  }

  @override
  Future<Result<List<ProductModel>>> getUserProducts(
    String userId, {
    String orderBy = 'createdAt',
    String sortBy = 'DESC',
    int limit = 10,
    int? offset,
    String? contains,
    int? categoryId,
  }) async {
    return Result.failure(
      error: UnsupportedError(
        'Remote datasources disabled in offline-only build',
      ),
    );
  }
}
