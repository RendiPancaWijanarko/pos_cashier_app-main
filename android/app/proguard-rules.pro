-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn com.yalantis.ucrop.**
-dontwarn com.yalantis.ucrop.**

# Keep UCrop download task references (optional, offline variant)
-keep class com.yalantis.ucrop.** { *; }

# ============================================================================
# DRIFT / SQLITE3 RULES
# ============================================================================
# Keep all drift classes
-keep class com.drift.** { *; }
-keep class io.drift.** { *; }
-keep class drift.** { *; }

# Keep sqlite3 classes
-keep class com.sqlite3.** { *; }
-keep class sqlite3.** { *; }
-keep class org.sqlite.** { *; }

# Keep generated drift code
-keep class * extends com.drift.Database { *; }
-keep class * extends com.drift.Table { *; }
-keep class * extends com.drift.GeneratedDatabase { *; }
-keep class * implements com.drift.TableInfo { *; }

# Keep drift type mappings
-keep class com.drift.DriftSqlType { *; }
-keep class com.drift.SqlType { *; }
-keep class com.drift.TypeMapping { *; }

# Keep drift columns
-keep class com.drift.GeneratedColumn { *; }
-keep class * extends com.drift.Column { *; }

# Keep drift companions
-keep class * extends com.drift.UpdateCompanion { *; }
-keep class * extends com.drift.DataClass { *; }

# Keep drift query executors
-keep class com.drift.QueryExecutor { *; }
-keep class com.drift.NativeDatabase { *; }
-keep class com.drift.LazyDatabase { *; }

# Keep Kotlin metadata for drift
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes Exceptions
-keepattributes InnerClasses
-keepattributes EnclosingMethod
-keepattributes RuntimeVisibleAnnotations
-keepattributes RuntimeInvisibleAnnotations
-keepattributes RuntimeVisibleParameterAnnotations
-keepattributes RuntimeInvisibleParameterAnnotations

# Keep all classes in the database package
-keep class **.database.** { *; }
-keep class **.tables.** { *; }

# ============================================================================
# FLUTTER EMBEDDING RULES
# ============================================================================
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# ============================================================================
# PATH PROVIDER RULES
# ============================================================================
-keep class com.baseflow.pathprovider.** { *; }

# ============================================================================
# GOOGLE PLAY CORE (deferred components) - Required by Flutter
# ============================================================================
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task

# ============================================================================
# GENERAL FLUTTER RULES
# ============================================================================
-keep class com.google.** { *; }
-keep class android.** { *; }
-keep class androidx.** { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep Parcelable implementations
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Keep Serializable implementations
-keep class * implements java.io.Serializable { *; }

# Keep enum classes
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep R class references
-keepclassmembers class **.R$* {
    public static <fields>;
}
