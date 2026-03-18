import 'package:drift/drift.dart';

/// AppSettings table - stores application configuration and metadata
/// Replaces remote config from Firebase
class AppSettings extends Table {
  TextColumn get key => text()(); // Setting name/key
  TextColumn get value => text()(); // Setting value (JSON encoded if complex)
  TextColumn get dataType => text().withDefault(
    const Constant('string'),
  )(); // 'string', 'int', 'bool', 'json'
  TextColumn get description => text().nullable()();
  BoolColumn get isEditable => boolean().withDefault(const Constant(true))();
  TextColumn get updatedAt => text()(); // ISO 8601
  TextColumn get updatedBy => text().nullable()(); // User ID who last updated

  @override
  String get tableName => 'app_settings';

  // Commented: primaryKey getter not needed when using .primaryKey() on column
  // @override
  // Set<Column> get primaryKey => {key};

  // Temporarily removed - Drift index syntax needs review
  // @override
  // List<Index> get indexes => [
  //   Index('idx_app_settings_updated_at', {updatedAt}),
  // ];
}

/// Common app settings defaults
class AppSettingKeys {
  static const String taxRate = 'tax_rate'; // Tax percentage
  static const String storeName = 'store_name';
  static const String storeAddress = 'store_address';
  static const String storePhone = 'store_phone';
  static const String currency = 'currency'; // 'IDR', 'USD', etc.
  static const String receiptFooter =
      'receipt_footer'; // Custom footer for receipts
  static const String lastBackupDate = 'last_backup_date';
  static const String backupRetentionDays =
      'backup_retention_days'; // How long to keep backups
  static const String databaseVersion =
      'database_version'; // Track schema version for migrations
  static const String appVersion = 'app_version';
  static const String defaultLanguage = 'default_language'; // 'id', 'en', etc.
  static const String enableReceiptPrinting = 'enable_receipt_printing';
  static const String enableOfflineMode =
      'enable_offline_mode'; // Currently always true
}
