import 'package:flutter/material.dart';
import '../features/home/home_page.dart';
import '../features/pets/pets_page.dart';
import '../features/pets/pet_details_page.dart';
import '../features/favorites/favorites_page.dart';
import '../features/adoption/adoption_history_page.dart';

/// App route names
class AppRoutes {
  static const String home = '/';
  static const String pets = '/pets';
  static const String petDetails = '/pet-details';
  static const String favorites = '/favorites';
  static const String adoptionHistory = '/adoption-history';
}

/// App route generator
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
          settings: settings,
        );

      case AppRoutes.pets:
        return MaterialPageRoute(
          builder: (_) => const PetsPage(),
          settings: settings,
        );

      case AppRoutes.petDetails:
        final petId = settings.arguments as String?;
        if (petId == null) {
          return _errorRoute('Pet ID is required');
        }
        return MaterialPageRoute(
          builder: (_) => PetDetailsPage(petId: petId),
          settings: settings,
        );

      case AppRoutes.favorites:
        return MaterialPageRoute(
          builder: (_) => const FavoritesPage(),
          settings: settings,
        );

      case AppRoutes.adoptionHistory:
        return MaterialPageRoute(
          builder: (_) => const AdoptionHistoryPage(),
          settings: settings,
        );

      default:
        return _errorRoute('Route not found: ${settings.name}');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder:
          (_) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
