import 'package:drift/drift.dart';
import 'user_table.dart';

/// Transaction table - stores all POS transactions
/// Replaced Firestore Transaction collection with local SQLite
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get paymentMethod =>
      text()(); // 'cash', 'card', 'check', 'cheque', etc.
  TextColumn get customerName => text().nullable()(); // Search field
  TextColumn get customerPhone => text().nullable()();
  TextColumn get customerEmail => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get createdById =>
      text().references(Users, #id)(); // FK to Users (cashier who created this)
  IntColumn get receivedAmount =>
      integer()(); // Amount paid by customer (in cents)
  IntColumn get returnAmount =>
      integer().withDefault(const Constant(0))(); // Change given back
  IntColumn get totalAmount => integer()(); // Total sale amount
  IntColumn get totalOrderedProducts =>
      integer()(); // Count of items in transaction
  TextColumn get cashierName =>
      text().nullable()(); // Denormalized from User for speed
  TextColumn get status => text().withDefault(
    const Constant('completed'),
  )(); // 'pending', 'completed', 'voided', 'refunded'
  TextColumn get receiptNumber =>
      text().nullable().unique()(); // Receipt tracking number
  TextColumn get createdAt => text()(); // ISO 8601 - search/filter index
  TextColumn get updatedAt => text()(); // ISO 8601
  TextColumn get voidedAt =>
      text().nullable()(); // When/if transaction was voided
  TextColumn get voidReason => text().nullable()(); // Reason for void/return

  @override
  String get tableName => 'transactions';

  // @override
  // List<Index> get indexes => [
  //   Index('idx_transactions_created_by_id', {createdById}),
  //   Index('idx_transactions_created_at', {createdAt}),
  //   Index('idx_transactions_customer_name', {customerName}),
  //   Index('idx_transactions_customer_phone', {customerPhone}),
  //   Index('idx_transactions_status', {status}),
  //   Index('idx_transactions_payment_method', {paymentMethod}),
  //   Index('idx_transactions_receipt_number', {receiptNumber}),
  // ];
}
