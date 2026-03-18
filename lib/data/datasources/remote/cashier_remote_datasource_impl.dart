import '../../../core/common/result.dart';
import '../../models/cashier_model.dart';
import '../interfaces/cashier_datasource.dart';

/// Remote cashier datasource disabled in offline-only build.
class CashierRemoteDatasourceImpl extends CashierDatasource {
  CashierRemoteDatasourceImpl();

  @override
  Future<Result<List<CashierModel>>> getAllCashiers(String userId) async {
    return Result.failure(
      error: UnsupportedError(
        'Remote datasources disabled in offline-only build',
      ),
    );
  }

  @override
  Future<Result<void>> createCashier(CashierModel cashier) async {
    return Result.failure(
      error: UnsupportedError(
        'Remote datasources disabled in offline-only build',
      ),
    );
  }

  @override
  Future<Result<void>> updateCashier(CashierModel cashier) async {
    return Result.failure(
      error: UnsupportedError(
        'Remote datasources disabled in offline-only build',
      ),
    );
  }

  @override
  Future<Result<void>> deleteCashier(String id) async {
    return Result.failure(
      error: UnsupportedError(
        'Remote datasources disabled in offline-only build',
      ),
    );
  }
}
