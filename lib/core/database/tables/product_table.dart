import 'package:drift/drift.dart';
import 'category_table.dart';
import 'user_table.dart';

/// Products table - replaced Firebase Firestore with local SQLite
/// Images are now stored as base64 data or bundled assets
class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId =>
      integer().nullable().references(Categories, #id)();
  TextColumn get createdById =>
      text().references(Users, #id)(); // FK to Users table
  TextColumn get name => text()();
  TextColumn get imageData =>
      text().nullable()(); // Base64 encoded image data (replaces imageUrl)
  TextColumn get imagePath => text().nullable()(); // Local asset path fallback
  BoolColumn get isAvailable => boolean().withDefault(const Constant(true))();
  IntColumn get sold => integer().withDefault(const Constant(0))();
  IntColumn get price =>
      integer()(); // Price in cents (or smallest currency unit)
  IntColumn get stock =>
      integer().withDefault(const Constant(0))(); // Current stock level
  TextColumn get description => text().nullable()();
  TextColumn get sku =>
      text().nullable().unique()(); // Stock keeping unit for inventory tracking
  TextColumn get createdAt => text()(); // ISO 8601
  TextColumn get updatedAt => text()(); // ISO 8601

  @override
  String get tableName => 'products';

  // @override
  // List<Index> get indexes => [
  //   Index('idx_products_name', {name}),
  //   Index('idx_products_category_id', {categoryId}),
  //   Index('idx_products_created_by_id', {createdById}),
  //   Index('idx_products_is_available', {isAvailable}),
  //   Index('idx_products_created_at', {createdAt}),
  //   Index('idx_products_sku', {sku}),
  // ];
}
