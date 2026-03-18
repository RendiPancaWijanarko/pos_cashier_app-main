import 'package:drift/drift.dart';
import 'transaction_table.dart';
import 'user_table.dart';

/// Receipt table - stores generated receipt data
/// Allows offline receipt generation and reprinting
class Receipts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get transactionId =>
      integer().unique().references(Transactions, #id)();
  TextColumn get receiptNumber => text().unique()();
  TextColumn get receiptHTML => text().nullable()(); // HTML representation
  TextColumn get receiptPlainText =>
      text().nullable()(); // Plain text for thermal printer
  TextColumn get receiptJSON =>
      text()(); // Full receipt data as JSON for reprint capability
  BoolColumn get isPrinted => boolean().withDefault(const Constant(false))();
  IntColumn get printCount =>
      integer().withDefault(const Constant(0))(); // How many times reprinted
  TextColumn get createdAt => text()();
  TextColumn get lastPrintedAt => text().nullable()();

  @override
  String get tableName => 'receipts';

  // @override
  // List<Index> get indexes => [
  //   Index('idx_receipts_transaction_id', {transactionId}),
  //   Index('idx_receipts_receipt_number', {receiptNumber}),
  //   Index('idx_receipts_created_at', {createdAt}),
  // ];
}

/// AuditLog table - tracks all database modifications for compliance and debugging
/// Helps identify data corruption or unauthorized changes
class AuditLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get auditTableName => text()(); // 'products', 'transactions', etc.
  TextColumn get operation => text()(); // 'INSERT', 'UPDATE', 'DELETE'
  IntColumn get recordId =>
      integer().nullable()(); // ID of affected record (if applicable)
  TextColumn get recordIdText =>
      text().nullable()(); // For tables with text PKs
  TextColumn get changes =>
      text().nullable()(); // JSON: {old: {...}, new: {...}}
  TextColumn get userId =>
      text().nullable().references(Users, #id)(); // Who made the change
  TextColumn get reason => text()
      .nullable()(); // Reason for change (e.g., void reason, correction note)
  TextColumn get createdAt =>
      text()(); // ISO 8601 - This is the critical timestamp
  TextColumn get deviceInfo =>
      text().nullable()(); // Device identifier for audit trail

  @override
  String get tableName => 'audit_logs';

  // @override
  // List<Index> get indexes => [
  //   Index('idx_audit_logs_table_operation', {tableName, operation}),
  //   Index('idx_audit_logs_created_at', {createdAt}),
  //   Index('idx_audit_logs_user_id', {userId}),
  //   Index('idx_audit_logs_record_id', {recordId}),
  // ];
}
