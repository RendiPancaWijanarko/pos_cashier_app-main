import 'package:drift/drift.dart';
import '../../../core/common/result.dart';
import '../../../core/database/app_database.dart';
import '../../models/user_model.dart';
import '../interfaces/user_datasource.dart';

class UserLocalDatasourceImpl extends UserDatasource {
  final AppDatabase _appDatabase;

  UserLocalDatasourceImpl(this._appDatabase);

  @override
  Future<Result<String>> createUser(UserModel user) async {
    try {
      final createdAt = user.createdAt ?? DateTime.now().toIso8601String();
      final updatedAt = user.updatedAt ?? DateTime.now().toIso8601String();

      await _appDatabase
          .into(_appDatabase.users)
          .insert(
            UsersCompanion(
              id: Value(user.id),
              email: Value(user.email),
              phone: Value(user.phone),
              name: Value(user.name ?? ''),
              gender: Value(user.gender),
              birthdate: Value(user.birthdate),
              imageData: Value(user.imageUrl),
              role: const Value('admin'), // Default role for new users
              authProvider: Value(user.authProvider),
              createdAt: Value(createdAt),
              updatedAt: Value(updatedAt),
            ),
            mode: InsertMode.insertOrReplace,
          );

      return Result.success(data: user.id);
    } catch (e) {
      return Result.failure(error: e);
    }
  }

  @override
  Future<Result<void>> updateUser(UserModel user) async {
    try {
      await (_appDatabase.update(
        _appDatabase.users,
      )..where((tbl) => tbl.id.equals(user.id))).write(
        UsersCompanion(
          email: Value(user.email),
          phone: Value(user.phone),
          name: Value(user.name ?? ''),
          gender: Value(user.gender),
          birthdate: Value(user.birthdate),
          imageData: Value(user.imageUrl),
          authProvider: Value(user.authProvider),
          updatedAt: Value(user.updatedAt ?? DateTime.now().toIso8601String()),
        ),
      );

      return Result.success(data: null);
    } catch (e) {
      return Result.failure(error: e);
    }
  }

  @override
  Future<Result<void>> deleteUser(String id) async {
    try {
      await (_appDatabase.delete(
        _appDatabase.users,
      )..where((tbl) => tbl.id.equals(id))).go();

      return Result.success(data: null);
    } catch (e) {
      return Result.failure(error: e);
    }
  }

  @override
  Future<Result<UserModel?>> getUser(String id) async {
    try {
      final res = await (_appDatabase.select(
        _appDatabase.users,
      )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

      if (res == null) return Result.success(data: null);

      final map = {
        'id': res.id,
        'email': res.email,
        'phone': res.phone,
        'name': res.name,
        'gender': res.gender,
        'birthdate': res.birthdate,
        'image_data': res.imageData,
        'auth_provider': res.authProvider,
        'created_at': res.createdAt,
        'updated_at': res.updatedAt,
      };

      return Result.success(data: UserModel.fromJson(map));
    } catch (e) {
      return Result.failure(error: e);
    }
  }
}
