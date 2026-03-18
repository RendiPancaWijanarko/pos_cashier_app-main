import 'package:drift/drift.dart';

/// Product Category table
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  TextColumn get createdAt =>
      text().withDefault(Constant(DateTime.now().toIso8601String()))();
  TextColumn get updatedAt =>
      text().withDefault(Constant(DateTime.now().toIso8601String()))();

  @override
  String get tableName => 'categories';
}

/// Index for category name lookups
// class CategoryNameIndex extends Index {
//   @override
//   String get name => 'idx_categories_name';
//   @override
//   List<Column> get columns => [categories.name];
// }
