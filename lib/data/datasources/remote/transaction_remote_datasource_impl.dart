import '../../../core/common/result.dart';
import '../interfaces/transaction_datasource.dart';
import '../../models/transaction_model.dart';

/// Remote transaction datasource disabled in offline-only build.
class TransactionRemoteDatasourceImpl extends TransactionDatasource {
  TransactionRemoteDatasourceImpl();

  @override
  Future<Result<int>> createTransaction(TransactionModel transaction) async {
    return Result.failure(
      error: UnsupportedError(
        'Remote datasources disabled in offline-only build',
      ),
    );
  }

  @override
  Future<Result<void>> updateTransaction(TransactionModel transaction) async {
    return Result.failure(
      error: UnsupportedError(
        'Remote datasources disabled in offline-only build',
      ),
    );
  }

  @override
  Future<Result<void>> deleteTransaction(int id) async {
    return Result.failure(
      error: UnsupportedError(
        'Remote datasources disabled in offline-only build',
      ),
    );
  }

  @override
  Future<Result<TransactionModel?>> getTransaction(int id) async {
    return Result.failure(
      error: UnsupportedError(
        'Remote datasources disabled in offline-only build',
      ),
    );
  }

  @override
  Future<Result<List<TransactionModel>>> getAllUserTransactions(
    String userId,
  ) async {
    return Result.failure(
      error: UnsupportedError(
        'Remote datasources disabled in offline-only build',
      ),
    );
  }

  @override
  Future<Result<List<TransactionModel>>> getUserTransactions(
    String userId, {
    String orderBy = 'createdAt',
    String sortBy = 'DESC',
    int limit = 10,
    int? offset,
    String? contains,
  }) async {
    return Result.failure(
      error: UnsupportedError(
        'Remote datasources disabled in offline-only build',
      ),
    );
  }
}
