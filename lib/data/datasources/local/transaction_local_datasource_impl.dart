import 'package:drift/drift.dart';

import '../../../core/common/result.dart';
import '../../../core/database/app_database.dart';
import '../../models/transaction_model.dart';
import '../../models/user_model.dart';
import '../interfaces/transaction_datasource.dart';

class TransactionLocalDatasourceImpl extends TransactionDatasource {
  final AppDatabase _appDatabase;

  TransactionLocalDatasourceImpl(this._appDatabase);

  @override
  Future<Result<int>> createTransaction(TransactionModel transaction) async {
    try {
      final transactionId = await _appDatabase.transaction(() async {
        await _appDatabase
            .into(_appDatabase.transactions)
            .insert(
              TransactionsCompanion(
                id: Value(transaction.id),
                paymentMethod: Value(transaction.paymentMethod),
                customerName: Value(transaction.customerName),
                description: Value(transaction.description),
                createdById: Value(transaction.createdById),
                receivedAmount: Value(transaction.receivedAmount),
                returnAmount: Value(transaction.returnAmount),
                totalAmount: Value(transaction.totalAmount),
                totalOrderedProducts: Value(transaction.totalOrderedProduct),
                cashierName: Value(transaction.cashierName),
                createdAt: Value(
                  transaction.createdAt ?? DateTime.now().toIso8601String(),
                ),
                updatedAt: Value(
                  transaction.updatedAt ?? DateTime.now().toIso8601String(),
                ),
              ),
              mode: InsertMode.insertOrReplace,
            );

        if (transaction.orderedProducts?.isNotEmpty ?? false) {
          for (var orderedProduct in transaction.orderedProducts!) {
            orderedProduct.transactionId = transaction.id;

            await _appDatabase
                .into(_appDatabase.orderedProducts)
                .insert(
                  OrderedProductsCompanion(
                    id: Value(orderedProduct.id),
                    transactionId: Value(orderedProduct.transactionId),
                    productId: Value(orderedProduct.productId),
                    quantity: Value(orderedProduct.quantity),
                    name: Value(orderedProduct.name),
                    imageData: Value(orderedProduct.imageUrl),
                    price: Value(orderedProduct.price),
                    createdAt: Value(
                      orderedProduct.createdAt ??
                          DateTime.now().toIso8601String(),
                    ),
                    updatedAt: Value(
                      orderedProduct.updatedAt ??
                          DateTime.now().toIso8601String(),
                    ),
                  ),
                  mode: InsertMode.insertOrReplace,
                );

            final rawProduct =
                await (_appDatabase.select(_appDatabase.products)
                      ..where((p) => p.id.equals(orderedProduct.productId)))
                    .getSingleOrNull();
            if (rawProduct == null) continue;

            final sold = rawProduct.sold + orderedProduct.quantity;

            await (_appDatabase.update(_appDatabase.products)
                  ..where((p) => p.id.equals(rawProduct.id)))
                .write(ProductsCompanion(sold: Value(sold)));
          }
        }

        return transaction.id;
      });

      return Result.success(data: transactionId);
    } catch (e) {
      return Result.failure(error: e);
    }
  }

  @override
  Future<Result<void>> updateTransaction(TransactionModel transaction) async {
    try {
      await _appDatabase.transaction(() async {
        await (_appDatabase.update(
          _appDatabase.transactions,
        )..where((t) => t.id.equals(transaction.id))).write(
          TransactionsCompanion(
            paymentMethod: Value(transaction.paymentMethod),
            customerName: Value(transaction.customerName),
            description: Value(transaction.description),
            createdById: Value(transaction.createdById),
            receivedAmount: Value(transaction.receivedAmount),
            returnAmount: Value(transaction.returnAmount),
            totalAmount: Value(transaction.totalAmount),
            totalOrderedProducts: Value(transaction.totalOrderedProduct),
            cashierName: Value(transaction.cashierName),
            updatedAt: Value(
              transaction.updatedAt ?? DateTime.now().toIso8601String(),
            ),
          ),
        );

        if (transaction.orderedProducts?.isNotEmpty ?? false) {
          for (var orderedProduct in transaction.orderedProducts!) {
            await (_appDatabase.update(
              _appDatabase.orderedProducts,
            )..where((op) => op.id.equals(orderedProduct.id))).write(
              OrderedProductsCompanion(
                quantity: Value(orderedProduct.quantity),
                name: Value(orderedProduct.name),
                imageData: Value(orderedProduct.imageUrl),
                price: Value(orderedProduct.price),
                updatedAt: Value(
                  orderedProduct.updatedAt ?? DateTime.now().toIso8601String(),
                ),
              ),
            );

            final rawProduct =
                await (_appDatabase.select(_appDatabase.products)
                      ..where((p) => p.id.equals(orderedProduct.productId)))
                    .getSingleOrNull();
            if (rawProduct == null) continue;

            final sold = rawProduct.sold + orderedProduct.quantity;

            await (_appDatabase.update(_appDatabase.products)
                  ..where((p) => p.id.equals(rawProduct.id)))
                .write(ProductsCompanion(sold: Value(sold)));
          }
        }
      });

      return Result.success(data: null);
    } catch (e) {
      return Result.failure(error: e);
    }
  }

  @override
  Future<Result<void>> deleteTransaction(int id) async {
    try {
      await _appDatabase.transaction(() async {
        final orderedProducts = await (_appDatabase.select(
          _appDatabase.orderedProducts,
        )..where((op) => op.transactionId.equals(id))).get();

        for (var op in orderedProducts) {
          final product = await (_appDatabase.select(
            _appDatabase.products,
          )..where((p) => p.id.equals(op.productId))).getSingleOrNull();
          if (product != null) {
            final revertedSold = product.sold - op.quantity;
            await (_appDatabase.update(_appDatabase.products)
                  ..where((p) => p.id.equals(product.id)))
                .write(ProductsCompanion(sold: Value(revertedSold)));
          }
        }

        await (_appDatabase.delete(
          _appDatabase.orderedProducts,
        )..where((op) => op.transactionId.equals(id))).go();
        await (_appDatabase.delete(
          _appDatabase.transactions,
        )..where((t) => t.id.equals(id))).go();
      });

      return Result.success(data: null);
    } catch (e) {
      return Result.failure(error: e);
    }
  }

  @override
  Future<Result<TransactionModel?>> getTransaction(int id) async {
    try {
      final transaction = await _appDatabase.transaction(() async {
        final rawTransaction = await (_appDatabase.select(
          _appDatabase.transactions,
        )..where((t) => t.id.equals(id))).getSingleOrNull();
        if (rawTransaction == null) return null;

        final orderedProducts = await (_appDatabase.select(
          _appDatabase.orderedProducts,
        )..where((op) => op.transactionId.equals(id))).get();

        final createdBy =
            await (_appDatabase.select(_appDatabase.users)
                  ..where((u) => u.id.equals(rawTransaction.createdById)))
                .getSingleOrNull();

        final tm = TransactionModel.fromJson({
          'id': rawTransaction.id,
          'paymentMethod': rawTransaction.paymentMethod,
          'customerName': rawTransaction.customerName,
          'description': rawTransaction.description,
          'createdById': rawTransaction.createdById,
          'orderedProducts': orderedProducts
              .map(
                (op) => {
                  'id': op.id,
                  'transactionId': op.transactionId,
                  'productId': op.productId,
                  'quantity': op.quantity,
                  'name': op.name,
                  'imageUrl': op.imageData,
                  'price': op.price,
                  'createdAt': op.createdAt,
                  'updatedAt': op.updatedAt,
                },
              )
              .toList(),
          'receivedAmount': rawTransaction.receivedAmount,
          'returnAmount': rawTransaction.returnAmount,
          'totalAmount': rawTransaction.totalAmount,
          'totalOrderedProduct': rawTransaction.totalOrderedProducts,
          'cashierName': rawTransaction.cashierName,
          'createdAt': rawTransaction.createdAt,
          'updatedAt': rawTransaction.updatedAt,
        });

        if (createdBy != null) {
          tm.createdBy = UserModel.fromJson({
            'id': createdBy.id,
            'email': createdBy.email,
            'phone': createdBy.phone,
            'name': createdBy.name,
            'gender': createdBy.gender,
            'birthdate': createdBy.birthdate,
            'image_data': createdBy.imageData,
            'auth_provider': createdBy.authProvider,
            'created_at': createdBy.createdAt,
            'updated_at': createdBy.updatedAt,
          });
        }

        return tm;
      });

      return Result.success(data: transaction);
    } catch (e) {
      return Result.failure(error: e);
    }
  }

  @override
  Future<Result<List<TransactionModel>>> getAllUserTransactions(
    String userId,
  ) async {
    try {
      final transactions = await _appDatabase.transaction(() async {
        final rawTransactions = await (_appDatabase.select(
          _appDatabase.transactions,
        )..where((t) => t.createdById.equals(userId))).get();

        final list = <TransactionModel>[];

        for (var raw in rawTransactions) {
          final orderedProducts = await (_appDatabase.select(
            _appDatabase.orderedProducts,
          )..where((op) => op.transactionId.equals(raw.id))).get();
          final createdBy = await (_appDatabase.select(
            _appDatabase.users,
          )..where((u) => u.id.equals(raw.createdById))).getSingleOrNull();

          final tm = TransactionModel.fromJson({
            'id': raw.id,
            'paymentMethod': raw.paymentMethod,
            'customerName': raw.customerName,
            'description': raw.description,
            'createdById': raw.createdById,
            'orderedProducts': orderedProducts
                .map(
                  (op) => {
                    'id': op.id,
                    'transactionId': op.transactionId,
                    'productId': op.productId,
                    'quantity': op.quantity,
                    'name': op.name,
                    'imageUrl': op.imageData,
                    'price': op.price,
                    'createdAt': op.createdAt,
                    'updatedAt': op.updatedAt,
                  },
                )
                .toList(),
            'receivedAmount': raw.receivedAmount,
            'returnAmount': raw.returnAmount,
            'totalAmount': raw.totalAmount,
            'totalOrderedProduct': raw.totalOrderedProducts,
            'cashierName': raw.cashierName,
            'createdAt': raw.createdAt,
            'updatedAt': raw.updatedAt,
          });

          if (createdBy != null) {
            tm.createdBy = UserModel.fromJson({
              'id': createdBy.id,
              'email': createdBy.email,
              'phone': createdBy.phone,
              'name': createdBy.name,
              'gender': createdBy.gender,
              'birthdate': createdBy.birthdate,
              'image_data': createdBy.imageData,
              'auth_provider': createdBy.authProvider,
              'created_at': createdBy.createdAt,
              'updated_at': createdBy.updatedAt,
            });
          }

          list.add(tm);
        }

        return list;
      });

      return Result.success(data: transactions);
    } catch (e) {
      return Result.failure(error: e);
    }
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
    try {
      final transactions = await _appDatabase.transaction(() async {
        var query = _appDatabase.select(_appDatabase.transactions)
          ..where((t) => t.createdById.equals(userId));

        if (contains != null && contains.isNotEmpty) {
          query = query
            ..where(
              (t) =>
                  t.customerName.like('%$contains%') |
                  t.cashierName.like('%$contains%'),
            );
        }

        query.limit(limit, offset: offset);

        final rawTransactions = await query.get();

        final list = <TransactionModel>[];

        for (var raw in rawTransactions) {
          final orderedProducts = await (_appDatabase.select(
            _appDatabase.orderedProducts,
          )..where((op) => op.transactionId.equals(raw.id))).get();
          final createdBy = await (_appDatabase.select(
            _appDatabase.users,
          )..where((u) => u.id.equals(raw.createdById))).getSingleOrNull();

          final tm = TransactionModel.fromJson({
            'id': raw.id,
            'paymentMethod': raw.paymentMethod,
            'customerName': raw.customerName,
            'description': raw.description,
            'createdById': raw.createdById,
            'orderedProducts': orderedProducts
                .map(
                  (op) => {
                    'id': op.id,
                    'transactionId': op.transactionId,
                    'productId': op.productId,
                    'quantity': op.quantity,
                    'name': op.name,
                    'imageUrl': op.imageData,
                    'price': op.price,
                    'createdAt': op.createdAt,
                    'updatedAt': op.updatedAt,
                  },
                )
                .toList(),
            'receivedAmount': raw.receivedAmount,
            'returnAmount': raw.returnAmount,
            'totalAmount': raw.totalAmount,
            'totalOrderedProduct': raw.totalOrderedProducts,
            'cashierName': raw.cashierName,
            'createdAt': raw.createdAt,
            'updatedAt': raw.updatedAt,
          });

          if (createdBy != null) {
            tm.createdBy = UserModel.fromJson({
              'id': createdBy.id,
              'email': createdBy.email,
              'phone': createdBy.phone,
              'name': createdBy.name,
              'gender': createdBy.gender,
              'birthdate': createdBy.birthdate,
              'image_data': createdBy.imageData,
              'auth_provider': createdBy.authProvider,
              'created_at': createdBy.createdAt,
              'updated_at': createdBy.updatedAt,
            });
          }

          list.add(tm);
        }

        return list;
      });

      return Result.success(data: transactions);
    } catch (e) {
      return Result.failure(error: e);
    }
  }
}
