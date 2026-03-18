import 'package:flutter/foundation.dart';

import '../../data/models/product_model.dart';
import '../../data/models/category_model.dart';
import '../../data/models/cashier_model.dart';
import '../../data/models/transaction_model.dart';
import '../../data/models/user_model.dart';

class OfflineController extends ChangeNotifier {
  bool isLoaded = true;
  bool isHasInternet = false;
  bool isLoading = false;
  bool isLoadingMore = false;

  // Collections
  List<ProductModel> allProducts = [];
  List<CategoryModel> categories = [];
  List<CashierModel> allCashiers = [];
  List<TransactionModel> allTransactions = [];

  UserModel? user;

  // Product form temporary fields
  String name = '';
  int price = 0;
  String? description;
  String? sku;
  int stock = 0;
  bool isAvailable = true;
  dynamic imageFile;
  String? imageUrl;
  int? categoryId;

  // Simple no-op initializers / loaders
  Future<void> getAllProducts() async {
    isLoading = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 10));
    isLoading = false;
    notifyListeners();
  }

  ProductModel? getProductDetail(int id) {
    try {
      return allProducts.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> createProduct() async {
    // minimal stub: add a product-like placeholder
    final newId = DateTime.now().millisecondsSinceEpoch;
    allProducts.add(
      ProductModel(
        id: newId,
        categoryId: categoryId,
        createdById: user?.id ?? 'offline',
        name: name,
        imageUrl: imageUrl ?? '',
        isAvailable: isAvailable,
        sold: 0,
        price: price,
      ),
    );
    notifyListeners();
  }

  Future<void> updateProduct(int id) async {
    // no-op for stub
    notifyListeners();
  }

  Future<void> deleteProduct(int id) async {
    allProducts.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  void onChangedName(String v) {
    name = v;
    notifyListeners();
  }

  void onChangedPrice(int v) {
    price = v;
    notifyListeners();
  }

  void onChangedIsAvailable(bool v) {
    isAvailable = v;
    notifyListeners();
  }

  void onChangedDesc(String v) {
    description = v;
    notifyListeners();
  }

  void onChangedImage(dynamic v) {
    imageFile = v;
    notifyListeners();
  }

  void onChangedCategory(int? v) {
    categoryId = v;
    notifyListeners();
  }

  bool get isFormValid => name.isNotEmpty && price > 0;

  // Transactions / cashiers / categories stubs
  Future<void> getAllTransactions() async {
    isLoading = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 10));
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchCashiers() async {
    isLoading = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 10));
    isLoading = false;
    notifyListeners();
  }

  Future<void> addCashier(CashierModel c) async {
    allCashiers.add(c);
    notifyListeners();
  }

  Future<void> deleteCashier(String id) async {
    allCashiers.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  Future<void> getCategories() async {
    isLoading = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 10));
    isLoading = false;
    notifyListeners();
  }

  Future<void> addCategory(CategoryModel c) async {
    categories.add(c);
    notifyListeners();
  }

  Future<void> deleteCategory(int id) async {
    categories.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  // Session helpers
  void signOut() {
    user = null;
    notifyListeners();
  }
}
