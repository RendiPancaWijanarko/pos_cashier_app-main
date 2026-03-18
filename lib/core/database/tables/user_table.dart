import 'package:drift/drift.dart';

/// User table storing all users (cashiers, admins, managers)
/// Replaced Firebase Auth with local SQLite storage
class Users extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get name => text()();
  TextColumn get gender => text().nullable()();
  TextColumn get birthdate => text().nullable()(); // ISO 8601 date string
  TextColumn get imageData =>
      text().nullable()(); // Base64 encoded image or path
  TextColumn get role => text().withDefault(
    const Constant('cashier'),
  )(); // 'admin', 'manager', 'cashier'
  TextColumn get authProvider => text()
      .nullable()(); // e.g., 'google', 'local' (for reference only - no auth calls made)
  TextColumn get createdAt => text()(); // ISO 8601
  TextColumn get updatedAt => text()(); // ISO 8601
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  String get tableName => 'users';

  @override
  Set<Column> get primaryKey => {id};
}

/// Indexes for frequently queried columns
// class UserNameIndex extends Index {
//   @override
//   String get name => 'idx_users_name';
//   @override
//   List<Column> get columns => [users.name];
// }

// class UserEmailIndex extends Index {
//   @override
//   String get name => 'idx_users_email';
//   @override
//   List<Column> get columns => [users.email];
// }

// class UserPhoneIndex extends Index {
//   @override
//   String get name => 'idx_users_phone';
//   @override
//   List<Column> get columns => [users.phone];
// }

// class UserCreatedAtIndex extends Index {
//   @override
//   String get name => 'idx_users_created_at';
//   @override
//   List<Column> get columns => [users.createdAt];
// }
