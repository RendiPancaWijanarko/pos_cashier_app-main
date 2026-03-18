# QUICK COMPLETION CHECKLIST - Offline-First POS Refactor

**Status: 70% Complete | Estimated time to finish: 3 hours**

---

## Phase 1: Repository Files (30 minutes)

```bash
# Step 1: Move new repository implementations to replace old ones
mv lib/data/repositories/product_repository_impl_new.dart lib/data/repositories/product_repository_impl.dart
mv lib/data/repositories/transaction_repository_impl_new.dart lib/data/repositories/transaction_repository_impl.dart
mv lib/data/repositories/user_repository_impl_new.dart lib/data/repositories/user_repository_impl.dart

# Step 2: Edit these files to add concrete implementations:
nano lib/data/repositories/auth_repository_impl.dart
nano lib/data/repositories/cashier_repository_impl.dart
nano lib/data/repositories/storage_repository_impl.dart
```

**What to put in those 3 files:** See OFFLINE_FIRST_REFACTOR_GUIDE.md "STEP 1" section

---

## Phase 2: Delete Obsolete Code (15 minutes)

```bash
# Delete all Firebase datasources
rm -rf lib/data/datasources/remote/

# Delete connectivity service
rm -rf lib/core/services/connectivity/

# Delete offline queue (no longer needed)
rm lib/data/models/queued_action_model.dart
rm lib/data/datasources/local/queued_action_local_datasource_impl.dart
rm lib/data/repositories/queued_action_repository_impl.dart
rm lib/domain/repositories/queued_action_repository.dart
rm lib/domain/usecases/*queued*

# Delete Firebase service
rm lib/core/services/logger/error_logger_service.dart
rm lib/firebase_options.dart
```

**Verify:** No files still importing Firebase or connectivity:

```bash
grep -r "firebase_" lib/
grep -r "connectivity_plus" lib/
grep -r "PingService" lib/
# Should return: NOTHING
```

---

## Phase 3: UI Updates (1 hour)

### Task 3A: Remove Connectivity Checks

```bash
# Find all files using pingService or connectivity
grep -r "pingService\|isConnected\|offline\|Online/Offline" lib/presentation/ lib/app/
```

**For each match, remove the related logic:**

```dart
// REMOVE this:
if (pingService.isConnected) { ... }
await pingService.checkConnectivity()
showSnackBar('You are offline')
enableButton = pingService.isConnected

// These widgets/builders can often be deleted
CircularProgressIndicator()  // (for local DB queries - they're instant)
Connectivity banners
SyncStatus indicators
```

**Key files to check:**

- [ ] lib/presentation/providers/main/main_provider.dart
- [ ] lib/presentation/providers/home/home_provider.dart
- [ ] lib/presentation/providers/products/product_form_provider.dart
- [ ] lib/presentation/providers/account/account_provider.dart
- [ ] lib/presentation/screens/home_screen.dart
- [ ] Any BLoC/Cubit with connectivity logic

### Task 3B: Update Image Handling

```bash
# Find all cached_network_image and firebase_storage references
grep -r "CachedNetworkImage\|cached_network_image\|FirebaseStorage" lib/
```

**Replace with:**

```dart
// OLD:
CachedNetworkImage(imageUrl: productModel.imageUrl)
FirebaseStorage.instance.ref().child(path)

// NEW:
Image.asset('assets/images/placeholder.png')
// OR for DB-stored images:
Image.memory(base64Decode(product.imageData))
```

**Steps:**

1. Add placeholder image to `assets/images/placeholder.png`
2. Update pubspec.yaml:
   ```yaml
   flutter:
     assets:
       - assets/images/
   ```
3. Find-replace all `CachedNetworkImage` → `Image.asset()`
4. When saving new product images, encode as base64

---

## Phase 4: Build & Verify (1 hour)

### Step 4A: Clean Build

```bash
cd /path/to/pos_cashier_app

flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs

# If build_runner fails, run:
flutter pub add dev:build_runner
flutter pub add dev:drift_dev
dart run build_runner build
```

### Step 4B: Check for Lingering Firebase/HTTP

```bash
# These should ALL return nothing:
grep -r "import.*firebase_" lib/
grep -r "import.*google_sign_in" lib/
grep -r "import.*connectivity" lib/
grep -r "import.*http" lib/
grep -r "import.*cached_network_image" lib/
grep -r "Firebase\." lib/
grep -r "GoogleSignIn\." lib/
grep -r "http://" lib/

# Run analyzer
flutter analyze
```

**Expected:** No errors, no unused imports

### Step 4C: Build for Platform

```bash
# Android
flutter build apk --debug
# OR
flutter build appbundle --debug

# iOS
flutter build ios --debug

# Windows
flutter build windows --debug

# Web (if needed)
flutter build web --release
```

---

## Phase 5: Airplane Mode Test (30 minutes)

**On Android Device:**

1. Settings → Network → Airplane Mode → ON
2. Also disable WiFi + Bluetooth
3. Open app
4. Test each feature:
   - [ ] View products list - instant load
   - [ ] Search products - instant
   - [ ] View product details
   - [ ] Create new product
   - [ ] Browse categories
   - [ ] Create transaction
   - [ ] Add items to cart
   - [ ] Complete sale
   - [ ] View receipt
   - [ ] Print receipt (if printer connected)
   - [ ] Export as CSV
   - [ ] View transaction history
   - [ ] Search transactions
   - [ ] Void transaction (with stock restore)
   - [ ] View/create users
   - [ ] View sales reports
   - [ ] View app settings
5. **No errors, no network timeouts, all features work**
6. Disable Airplane Mode
7. **App still works identically**
8. Close and reopen app
9. **All data persists**

**On iOS Device:**

1. Settings → Airplane Mode → ON
2. Follow same tests as Android

**On Windows:**

1. Settings → System → Airplane Mode → ON
2. Follow same tests

**Expected Result:**
✅ **The app functions IDENTICALLY with or without internet**

---

## Final Checklist - Before Deploying

- [ ] No Firebase imports anywhere in codebase
- [ ] No google_sign_in imports
- [ ] No connectivity_plus/internet_connection_checker imports
- [ ] No http/dio imports
- [ ] No cached_network_image imports
- [ ] No pingService references
- [ ] No QueuedAction references
- [ ] flutter analyze returns 0 issues
- [ ] dart run build_runner build succeeds
- [ ] App builds for target platform(s)
- [ ] Airplane Mode test passes completely
- [ ] All database tables created on first launch
- [ ] All queries complete in <200ms
- [ ] CSV export works
- [ ] JSON export works
- [ ] Receipt generation works
- [ ] Stock deduction works
- [ ] Transaction void restores stock
- [ ] Audit logs written
- [ ] UI is clean (no "offline" indicators)

---

## Troubleshooting

**"Cannot find symbol: FirebaseFirestore"**
→ Delete Firebase imports from files using pubspec.yaml list

**"build_runner: command not found"**
→ `dart pub global activate build_runner`

**"app_database.g.dart not found"**
→ Run: `dart run build_runner build`

**App crashes at startup**
→ Check: main.dart has `await AppDatabase.instance.init()`

**Images show as blank**
→ Check: pubspec.yaml includes `assets: - assets/images/`
→ Check: Image.asset() path matches file name

**Airplane Mode test fails**
→ Check: No `await Future.delayed()` after database operations
→ Check: No firebase imports in providers
→ Check: No http calls anywhere

---

## Success Metrics

When complete:

- ✅ Zero Firebase dependencies
- ✅ Zero HTTP dependencies
- ✅ Zero connectivity checks
- ✅ 100% offline capable
- ✅ All data local (SQLite)
- ✅ Instant response times
- ✅ Atomic transactions
- ✅ Complete audit trail
- ✅ Airplane Mode: PASS

---

## Time Estimate Breakdown

| Phase     | Task                               | Time         |
| --------- | ---------------------------------- | ------------ |
| 1         | Move & complete repositories       | 30 min       |
| 2         | Delete obsolete code               | 15 min       |
| 3A        | Remove connectivity checks from UI | 30 min       |
| 3B        | Fix image handling                 | 20 min       |
| 4A        | Clean build & verify               | 20 min       |
| 4B        | Lint/analyze cleanup               | 10 min       |
| 4C        | Platform builds                    | 15 min       |
| 5         | Airplane Mode testing              | 30 min       |
| **TOTAL** |                                    | **~3 hours** |

---

**Last Updated:** March 2026
**Status:** Ready for final phase
**Next:** Start with Phase 1
