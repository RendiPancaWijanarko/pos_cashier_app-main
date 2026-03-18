import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/di/app_providers.dart';
import '../welcome/welcome_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final mainProvider = ref.read(mainControllerProvider);
      await mainProvider.initMainProvider();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoaded = ref.watch(
      mainControllerProvider.select((p) => p.isLoaded),
    );
    // Display RootScreen when data is being load
    if (!isLoaded) {
      return const WelcomeScreen();
    }

    // Note: With offline-first auth, user should always be available
    // as AuthProvider auto-creates a local admin user on first launch

    final location = GoRouterState.of(context).uri.path;

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_checkout_outlined),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_customize_outlined),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_rounded),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Pengaturan',
          ),
        ],
        currentIndex: _calculateSelectedIndex(location),
        onTap: (int idx) => _onItemTapped(idx),
      ),
    );
  }

  int _calculateSelectedIndex(String location) {
    if (location.startsWith('/home')) {
      return 0;
    }

    if (location.startsWith('/products')) {
      return 1;
    }

    if (location.startsWith('/transactions')) {
      return 2;
    }

    if (location.startsWith('/account')) {
      return 3;
    }

    return 0;
  }

  void _onItemTapped(int index) {
    final router = ref.read(appRoutesProvider).router;

    switch (index) {
      case 0:
        router.go('/home');
      case 1:
        router.go('/products');
      case 2:
        router.go('/transactions');
      case 3:
        router.go('/account');
    }
  }
}
