import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../pets/providers/pets_provider.dart';
import '../../../models/pet_model.dart';

/// State class to hold favorites data
class FavoritesState {
  final Set<String> favoritePetIds;
  final bool isLoading;

  const FavoritesState({
    this.favoritePetIds = const {},
    this.isLoading = false,
  });

  FavoritesState copyWith({Set<String>? favoritePetIds, bool? isLoading}) {
    return FavoritesState(
      favoritePetIds: favoritePetIds ?? this.favoritePetIds,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  /// Check if a pet is in favorites
  bool isFavorite(String petId) => favoritePetIds.contains(petId);

  /// Get favorites as list (for UI)
  List<String> get favoritesAsList => favoritePetIds.toList();
}

/// Notifier class to manage favorites state
class FavoritesNotifier extends StateNotifier<FavoritesState> {
  static const String _favoritesKey = 'favorite_pets';

  FavoritesNotifier() : super(const FavoritesState()) {
    _loadFavorites();
  }

  /// Load favorites from SharedPreferences
  Future<void> _loadFavorites() async {
    state = state.copyWith(isLoading: true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesList = prefs.getStringList(_favoritesKey) ?? [];

      state = state.copyWith(
        favoritePetIds: favoritesList.toSet(),
        isLoading: false,
      );
    } catch (e) {
      // Error loading favorites - continue with empty list
      state = state.copyWith(isLoading: false);
    }
  }

  /// Save favorites to SharedPreferences
  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_favoritesKey, state.favoritesAsList);
    } catch (e) {
      print("error occurred; $e");
    }
  }

  /// Add a pet to favorites
  Future<void> addToFavorites(String petId) async {
    if (!state.isFavorite(petId)) {
      final updatedFavorites = {...state.favoritePetIds, petId};
      state = state.copyWith(favoritePetIds: updatedFavorites);
      await _saveFavorites();
    }
  }

  /// Remove a pet from favorites
  Future<void> removeFromFavorites(String petId) async {
    if (state.isFavorite(petId)) {
      final updatedFavorites = {...state.favoritePetIds}..remove(petId);
      state = state.copyWith(favoritePetIds: updatedFavorites);
      await _saveFavorites();
    }
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(String petId) async {
    if (state.isFavorite(petId)) {
      await removeFromFavorites(petId);
    } else {
      await addToFavorites(petId);
    }
  }

  /// Clear all favorites
  Future<void> clearAllFavorites() async {
    state = state.copyWith(favoritePetIds: <String>{});
    await _saveFavorites();
  }
}

/// Main favorites provider
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, FavoritesState>((ref) {
      return FavoritesNotifier();
    });

/// Convenience providers

/// Check if specific pet is favorite
final isFavoriteProvider = Provider.family<bool, String>((ref, petId) {
  return ref.watch(favoritesProvider).isFavorite(petId);
});

/// Get all favorite pet IDs
final favoritePetIdsProvider = Provider<Set<String>>((ref) {
  return ref.watch(favoritesProvider).favoritePetIds;
});

/// Get actual favorite pets (combining with pets data)
final favoritePetsProvider = Provider<List<PetModel>>((ref) {
  final favoriteIds = ref.watch(favoritePetIdsProvider);
  final allPets = ref.watch(allPetsProvider);

  return allPets.where((pet) => favoriteIds.contains(pet.id)).toList();
});
