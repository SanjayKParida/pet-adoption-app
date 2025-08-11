import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_adoption_app/core/theme/app_theme.dart';
import '../pets/pets_page.dart';
import '../favorites/favorites_page.dart';
import '../adoption/adoption_history_page.dart';
import '../../core/theme/theme_provider.dart';

/// Main home page with bottom navigation
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;

  // Pages for each tab
  final List<Widget> _pages = [
    const PetsPage(),
    const FavoritesPage(),
    const AdoptionHistoryPage(),
  ];

  // Navigation items
  final List<BottomNavigationBarItem> _navigationItems = [
    const BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Pets'),
    const BottomNavigationBarItem(
      icon: Icon(Icons.favorite_outline),
      label: 'Favorites',
    ),
    const BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor:
            AppTheme.darkTheme.bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor: Colors.grey,
        items: _navigationItems,
        elevation: 8,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => themeNotifier.toggleTheme(),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        child: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
      ),
    );
  }
}
