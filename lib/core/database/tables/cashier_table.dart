import 'package:drift/drift.dart';
import 'user_table.dart';

/// Cashier table - represents cashier shifts or cashier-specific metadata
/// Can be merged with Users table if not needed separately
class Cashiers extends Table {
  TextColumn get id => text()(); // UUID, can be same as User id
  TextColumn get name => text()();
  @ReferenceName('userCashiers')
  TextColumn get userId => text().references(Users, #id).nullable()(); // Link to User if separate
  BoolColumn get isAvailable => boolean().withDefault(const Constant(true))();
  IntColumn get totalTransactions =>
      integer().withDefault(const Constant(0))(); // Denormalized count
  IntColumn get totalSalesAmount => integer().withDefault(
    const Constant(0),
  )(); // Sum of all transactions (in cents)
  @ReferenceName('createdByCashiers')
  TextColumn get createdById => text().references(Users, #id).nullable()(); // Admin who created this cashier account
  TextColumn get createdAt => text()(); // ISO 8601
  TextColumn get updatedAt => text()(); // ISO 8601
  TextColumn get lastActivityAt =>
      text().nullable()(); // Last transaction or activity timestamp

  @override
  String get tableName => 'cashiers';

  @override
  Set<Column> get primaryKey => {id};

  // @override
  // List<Index> get indexes => [
  //   Index('idx_cashiers_name', {name}),
  //   Index('idx_cashiers_is_available', {isAvailable}),
  //   Index('idx_cashiers_created_at', {createdAt}),
  //   Index('idx_cashiers_last_activity_at', {lastActivityAt}),
  // ];
}
