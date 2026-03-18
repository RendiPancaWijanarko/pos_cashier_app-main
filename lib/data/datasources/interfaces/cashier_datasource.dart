import '../../../core/common/result.dart';
import '../../models/cashier_model.dart';

abstract class CashierDatasource {
  Future<Result<List<CashierModel>>> getAllCashiers(String userId);

  Future<Result<void>> createCashier(CashierModel cashier);

  Future<Result<void>> updateCashier(CashierModel cashier);

  Future<Result<void>> deleteCashier(String id);
}
