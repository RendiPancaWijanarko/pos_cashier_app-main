import 'package:drift/drift.dart';
import 'transaction_table.dart';
import 'product_table.dart';

/// OrderedProduct table - items within a transaction
/// Replaced Firestore OrderedProduct sub-collection with normalized table
class OrderedProducts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get transactionId => integer().references(Transactions, #id)();
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get quantity => integer()(); // Quantity purchased
  TextColumn get name =>
      text()(); // Denormalized product name from Product table snapshot
  TextColumn get imageData =>
      text().nullable()(); // Denormalized image snapshot
  IntColumn get price => integer()(); // Unit price at time of sale (in cents)
  IntColumn get subtotal => integer()(); // quantity * price
  TextColumn get sku => text().nullable()(); // Denormalized SKU for audit trail
  TextColumn get createdAt => text()(); // ISO 8601
  TextColumn get updatedAt => text()(); // ISO 8601

  @override
  String get tableName => 'ordered_products';

  // @override
  // List<Index> get indexes => [
  //   Index('idx_ordered_products_transaction_id', {transactionId}),
  //   Index('idx_ordered_products_product_id', {productId}),
  //   Index('idx_ordered_products_created_at', {createdAt}),
  // ];
}
