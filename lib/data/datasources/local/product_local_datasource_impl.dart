import 'package:drift/drift.dart';

import '../../../core/common/result.dart';
import '../../../core/database/app_database.dart';
import '../../models/product_model.dart';
import '../../models/category_model.dart';
import '../interfaces/product_datasource.dart';

class ProductLocalDatasourceImpl extends ProductDatasource {
  final AppDatabase _appDatabase;

  ProductLocalDatasourceImpl(this._appDatabase);

  @override
  Future<Result<int>> createProduct(ProductModel product) async {
    try {
      final id = await _appDatabase
          .into(_appDatabase.products)
          .insert(
            ProductsCompanion(
              id: Value(product.id),
              categoryId: Value(product.categoryId),
              createdById: Value(product.createdById),
              name: Value(product.name),
              imageData: Value(product.imageUrl),
              isAvailable: Value(product.isAvailable),
              sold: Value(product.sold),
              price: Value(product.price),
              description: Value(product.description),
              createdAt: Value(
                product.createdAt ?? DateTime.now().toIso8601String(),
              ),
              updatedAt: Value(
                product.updatedAt ?? DateTime.now().toIso8601String(),
              ),
            ),
            mode: InsertMode.insertOrReplace,
          );

      return Result.success(data: id);
    } catch (e) {
      return Result.failure(error: e);
    }
  }

  @override
  Future<Result<void>> updateProduct(ProductModel product) async {
    try {
      await (_appDatabase.update(
        _appDatabase.products,
      )..where((tbl) => tbl.id.equals(product.id))).write(
        ProductsCompanion(
          categoryId: Value(product.categoryId),
          createdById: Value(product.createdById),
          name: Value(product.name),
          imageData: Value(product.imageUrl),
          isAvailable: Value(product.isAvailable),
          sold: Value(product.sold),
          price: Value(product.price),
          description: Value(product.description),
          updatedAt: Value(
            product.updatedAt ?? DateTime.now().toIso8601String(),
          ),
        ),
      );

      return Result.success(data: null);
    } catch (e) {
      return Result.failure(error: e);
    }
  }

  @override
  Future<Result<void>> deleteProduct(int id) async {
    try {
      await (_appDatabase.delete(
        _appDatabase.products,
      )..where((t) => t.id.equals(id))).go();
      return Result.success(data: null);
    } catch (e) {
      return Result.failure(error: e);
    }
  }

  @override
  Future<Result<ProductModel?>> getProduct(int id) async {
    try {
      final res = await (_appDatabase.select(
        _appDatabase.products,
      )..where((t) => t.id.equals(id))).getSingleOrNull();
      if (res == null) return Result.success(data: null);

      final map = {
        'id': res.id,
        'categoryId': res.categoryId,
        'createdById': res.createdById,
        'name': res.name,
        'imageUrl': res.imageData,
        'isAvailable': res.isAvailable,
        'sold': res.sold,
        'price': res.price,
        'description': res.description,
        'createdAt': res.createdAt,
        'updatedAt': res.updatedAt,
      };

      return Result.success(data: ProductModel.fromJson(map));
    } catch (e) {
      return Result.failure(error: e);
    }
  }

  Future<Result<List<CategoryModel>>> getCategories() async {
    try {
      final res = await _appDatabase.select(_appDatabase.categories).get();
      final categories = res
          .map((e) => CategoryModel.fromJson({'id': e.id, 'name': e.name}))
          .toList();
      return Result.success(data: categories);
    } catch (e) {
      return Result.failure(error: e);
    }
  }

  @override
  Future<Result<List<ProductModel>>> getAllUserProducts(String userId) async {
    try {
      final res = await (_appDatabase.select(
        _appDatabase.products,
      )..where((t) => t.createdById.equals(userId))).get();
      return Result.success(
        data: res
            .map(
              (r) => ProductModel.fromJson({
                'id': r.id,
                'categoryId': r.categoryId,
                'createdById': r.createdById,
                'name': r.name,
                'imageUrl': r.imageData,
                'isAvailable': r.isAvailable,
                'sold': r.sold,
                'price': r.price,
                'description': r.description,
                'createdAt': r.createdAt,
                'updatedAt': r.updatedAt,
              }),
            )
            .toList(),
      );
    } catch (e) {
      return Result.failure(error: e);
    }
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
    try {
      var query = _appDatabase.select(_appDatabase.products)
        ..where((t) => t.createdById.equals(userId));

      if (contains != null && contains.isNotEmpty) {
        query = query..where((t) => t.name.like('%$contains%'));
      }

      if (categoryId != null) {
        query = query..where((t) => t.categoryId.equals(categoryId));
      }

      if (offset != null) {
        query.limit(limit, offset: offset);
      } else {
        query.limit(limit);
      }

      final res = await query.get();

      return Result.success(
        data: res
            .map(
              (r) => ProductModel.fromJson({
                'id': r.id,
                'categoryId': r.categoryId,
                'createdById': r.createdById,
                'name': r.name,
                'imageUrl': r.imageData,
                'isAvailable': r.isAvailable,
                'sold': r.sold,
                'price': r.price,
                'description': r.description,
                'createdAt': r.createdAt,
                'updatedAt': r.updatedAt,
              }),
            )
            .toList(),
      );
    } catch (e) {
      return Result.failure(error: e);
    }
  }

  Future<Result<int>> createCategory(CategoryModel category) async {
    try {
      final id = await _appDatabase
          .into(_appDatabase.categories)
          .insert(
            CategoriesCompanion(
              name: Value(category.name),
              createdAt: Value(DateTime.now().toIso8601String()),
              updatedAt: Value(DateTime.now().toIso8601String()),
            ),
          );
      return Result.success(data: id);
    } catch (e) {
      return Result.failure(error: e);
    }
  }

  Future<Result<void>> updateCategory(CategoryModel category) async {
    try {
      await (_appDatabase.update(_appDatabase.categories)
            ..where((t) => t.id.equals(category.id ?? -1)))
          .write(CategoriesCompanion(name: Value(category.name)));
      return Result.success(data: null);
    } catch (e) {
      return Result.failure(error: e);
    }
  }

  Future<Result<void>> deleteCategory(int id) async {
    try {
      await (_appDatabase.delete(
        _appDatabase.categories,
      )..where((t) => t.id.equals(id))).go();
      return Result.success(data: null);
    } catch (e) {
      return Result.failure(error: e);
    }
  }
}
