import 'package:drift/drift.dart';

import '../../../core/common/result.dart';
import '../../../core/database/app_database.dart';
import '../../models/cashier_model.dart';

abstract class CashierLocalDataSource {
  Future<Result<List<CashierModel>>> getAllCashiers(String userId);
  Future<Result<void>> insertCashier(CashierModel cashier);
  Future<Result<void>> updateCashier(CashierModel cashier);
  Future<Result<void>> deleteCashier(String id);
}

class CashierLocalDataSourceImpl implements CashierLocalDataSource {
  final AppDatabase _appDatabase;

  CashierLocalDataSourceImpl(this._appDatabase);

  @override
  Future<Result<List<CashierModel>>> getAllCashiers(String userId) async {
    try {
      final res =
          await (_appDatabase.select(_appDatabase.cashiers)
                ..where(
                  (c) =>
                      c.isAvailable.equals(true) & c.createdById.equals(userId),
                )
                ..orderBy([(t) => OrderingTerm(expression: t.name)]))
              .get();

      return Result.success(
        data: res
            .map(
              (r) => CashierModel.fromJson({
                'id': r.id,
                'name': r.name,
                'is_active': r.isAvailable ? 1 : 0,
                'created_by_id': r.createdById,
                'created_at': r.createdAt,
                'updated_at': r.updatedAt,
              }),
            )
            .toList(),
      );
    } catch (e) {
      return Result.failure(error: e);
    }
  }

  @override
  Future<Result<void>> insertCashier(CashierModel cashier) async {
    try {
      await _appDatabase
          .into(_appDatabase.cashiers)
          .insert(
            CashiersCompanion(
              id: Value(
                cashier.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
              ),
              name: Value(cashier.name),
              isAvailable: Value(cashier.isAvailable),
              createdById: Value(cashier.createdById),
              createdAt: Value(
                cashier.createdAt ?? DateTime.now().toIso8601String(),
              ),
              updatedAt: Value(
                cashier.updatedAt ?? DateTime.now().toIso8601String(),
              ),
            ),
            mode: InsertMode.insertOrReplace,
          );

      return Result.success(data: null);
    } catch (e) {
      return Result.failure(error: e);
    }
  }

  @override
  Future<Result<void>> updateCashier(CashierModel cashier) async {
    try {
      await (_appDatabase.update(
        _appDatabase.cashiers,
      )..where((t) => t.id.equals(cashier.id ?? ''))).write(
        CashiersCompanion(
          name: Value(cashier.name),
          isAvailable: Value(cashier.isAvailable),
          updatedAt: Value(
            cashier.updatedAt ?? DateTime.now().toIso8601String(),
          ),
        ),
      );

      return Result.success(data: null);
    } catch (e) {
      return Result.failure(error: e);
    }
  }

  @override
  Future<Result<void>> deleteCashier(String id) async {
    try {
      await (_appDatabase.update(
        _appDatabase.cashiers,
      )..where((t) => t.id.equals(id))).write(
        CashiersCompanion(
          isAvailable: Value(false),
          updatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

      return Result.success(data: null);
    } catch (e) {
      return Result.failure(error: e);
    }
  }
}
