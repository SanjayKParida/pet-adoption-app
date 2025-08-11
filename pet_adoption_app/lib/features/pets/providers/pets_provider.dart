import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/pet_model.dart';
import '../../../services/pets_data_service.dart';
import '../../adoption/providers/adoption_provider.dart';

class PetsState {
  final List<PetModel> pets;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final String? selectedType;
  final int currentPage;
  final int itemsPerPage;
  final bool hasMorePets;

  const PetsState({
    this.pets = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.selectedType,
    this.currentPage = 1,
    this.itemsPerPage = 6,
    this.hasMorePets = true,
  });

  /// Create a copy with updated values
  PetsState copyWith({
    List<PetModel>? pets,
    bool? isLoading,
    String? error,
    String? searchQuery,
    String? selectedType,
    int? currentPage,
    int? itemsPerPage,
    bool? hasMorePets,
  }) {
    return PetsState(
      pets: pets ?? this.pets,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedType:
          selectedType, // Remove ?? this.selectedType to allow null values
      currentPage: currentPage ?? this.currentPage,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      hasMorePets: hasMorePets ?? this.hasMorePets,
    );
  }

  /// Get filtered pets based on search and type
  List<PetModel> get filteredPets {
    var filtered = pets;

    // Filter by type if selected
    if (selectedType != null) {
      filtered = filtered.where((pet) => pet.type == selectedType).toList();
    }

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (pet) =>
                    pet.name.toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ) ||
                    pet.breed.toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ) ||
                    pet.type.toLowerCase().contains(searchQuery.toLowerCase()),
              )
              .toList();
    }

    return filtered;
  }

  /// Get available pets (not adopted) - this will be computed with adoption state
  List<PetModel> get availablePets {
    return filteredPets.where((pet) => !pet.isAdopted).toList();
  }

  /// Get paginated available pets
  List<PetModel> get paginatedAvailablePets {
    final available = availablePets;

    // If filtering by specific type, show all matching pets (no pagination)
    if (selectedType != null) {
      return available;
    }

    // For "All" filter, apply pagination
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;

    if (startIndex >= available.length) {
      return [];
    }

    return available.sublist(
      startIndex,
      endIndex > available.length ? available.length : endIndex,
    );
  }

  /// Check if there are more pets to load
  bool get hasMorePetsToLoad {
    // Only show "Load More" for "All" filter
    if (selectedType != null) {
      return false;
    }

    final available = availablePets;
    return (currentPage * itemsPerPage) < available.length;
  }

  /// Get adopted pets
  List<PetModel> get adoptedPets {
    return pets.where((pet) => pet.isAdopted).toList();
  }
}

/// Notifier class to manage pets state
class PetsNotifier extends StateNotifier<PetsState> {
  PetsNotifier() : super(const PetsState()) {
    // Load pets when provider is created
    loadPets();
  }

  /// Load all pets from data service
  Future<void> loadPets() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final pets = await PetsDataService.getAllPetsWithDelay();
      state = state.copyWith(pets: pets, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load pets: $e',
      );
    }
  }

  /// Refresh pets data (for pull-to-refresh)
  Future<void> refreshPets() async {
    PetsDataService.clearCache(); // Clear cache to force reload
    await loadPets();
  }

  /// Update search query
  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query, currentPage: 1);
  }

  /// Update selected pet type filter
  void updateTypeFilter(String? type) {
    print('🔍 [DEBUG] updateTypeFilter called with type: $type');
    print('🔍 [DEBUG] Previous selectedType: ${state.selectedType}');
    print('🔍 [DEBUG] Previous currentPage: ${state.currentPage}');

    state = state.copyWith(selectedType: type, currentPage: 1);

    print('🔍 [DEBUG] New selectedType: ${state.selectedType}');
    print('🔍 [DEBUG] New currentPage: ${state.currentPage}');
    print('🔍 [DEBUG] filteredPets length: ${state.filteredPets.length}');
    print('🔍 [DEBUG] availablePets length: ${state.availablePets.length}');
    print(
      '🔍 [DEBUG] paginatedAvailablePets length: ${state.paginatedAvailablePets.length}',
    );
    print('🔍 [DEBUG] hasMorePetsToLoad: ${state.hasMorePetsToLoad}');
  }

  /// Clear all filters
  void clearFilters() {
    state = state.copyWith(searchQuery: '', selectedType: null, currentPage: 1);
  }

  /// Load more pets (pagination)
  void loadMorePets() {
    if (state.hasMorePetsToLoad) {
      state = state.copyWith(currentPage: state.currentPage + 1);
    }
  }

  /// Reset pagination
  void resetPagination() {
    state = state.copyWith(currentPage: 1);
  }

  /// Adopt a pet (update adoption status)
  Future<void> adoptPet(String petId) async {
    final pets = state.pets;
    final updatedPets =
        pets.map((pet) {
          if (pet.id == petId) {
            return pet.copyWith(isAdopted: true);
          }
          return pet;
        }).toList();

    state = state.copyWith(pets: updatedPets);

    // TODO: In real app, this would also update the backend/storage
    // For now, we'll handle persistence in a separate provider
  }

  /// Get pet by ID
  PetModel? getPetById(String id) {
    try {
      return state.pets.firstWhere((pet) => pet.id == id);
    } catch (e) {
      return null;
    }
  }
}

/// Main pets provider - this is what you'll use in your UI
final petsProvider = StateNotifierProvider<PetsNotifier, PetsState>((ref) {
  return PetsNotifier();
});

/// Convenience providers for easy access to specific data
/// These are computed providers that automatically update when petsProvider changes

/// Get all pets
final allPetsProvider = Provider<List<PetModel>>((ref) {
  return ref.watch(petsProvider).pets;
});

/// Get filtered pets (based on search and type filter)
final filteredPetsProvider = Provider<List<PetModel>>((ref) {
  return ref.watch(petsProvider).filteredPets;
});

/// Get available pets (not adopted) with real adoption state
final availablePetsProvider = Provider<List<PetModel>>((ref) {
  final petsState = ref.watch(petsProvider);
  final adoptionState = ref.watch(adoptionProvider);

  return petsState.filteredPets
      .where((pet) => !adoptionState.isPetAdopted(pet.id))
      .toList();
});

/// Get adopted pets with real adoption state
final adoptedPetsProvider = Provider<List<PetModel>>((ref) {
  final petsState = ref.watch(petsProvider);
  final adoptionState = ref.watch(adoptionProvider);

  return petsState.filteredPets
      .where((pet) => adoptionState.isPetAdopted(pet.id))
      .toList();
});

/// Get paginated available pets with real adoption state
final paginatedAvailablePetsProvider = Provider<List<PetModel>>((ref) {
  final petsState = ref.watch(petsProvider);
  final adoptionState = ref.watch(adoptionProvider);

  print(
    '🔍 [DEBUG] paginatedAvailablePetsProvider - selectedType: ${petsState.selectedType}',
  );
  print(
    '🔍 [DEBUG] paginatedAvailablePetsProvider - currentPage: ${petsState.currentPage}',
  );

  // Get filtered pets first
  final filteredPets = petsState.filteredPets;
  print(
    '🔍 [DEBUG] paginatedAvailablePetsProvider - filteredPets length: ${filteredPets.length}',
  );

  // Filter out adopted pets
  final availablePets =
      filteredPets.where((pet) => !adoptionState.isPetAdopted(pet.id)).toList();
  print(
    '🔍 [DEBUG] paginatedAvailablePetsProvider - availablePets length: ${availablePets.length}',
  );

  // If filtering by specific type, show all matching pets (no pagination)
  if (petsState.selectedType != null) {
    print(
      '🔍 [DEBUG] paginatedAvailablePetsProvider - returning all availablePets (type filter)',
    );
    return availablePets;
  }

  // For "All" filter, apply pagination
  final startIndex = (petsState.currentPage - 1) * petsState.itemsPerPage;
  final endIndex = startIndex + petsState.itemsPerPage;
  print(
    '🔍 [DEBUG] paginatedAvailablePetsProvider - startIndex: $startIndex, endIndex: $endIndex',
  );

  if (startIndex >= availablePets.length) {
    print(
      '🔍 [DEBUG] paginatedAvailablePetsProvider - startIndex >= availablePets.length, returning empty list',
    );
    return [];
  }

  final result = availablePets.sublist(
    startIndex,
    endIndex > availablePets.length ? availablePets.length : endIndex,
  );
  print(
    '🔍 [DEBUG] paginatedAvailablePetsProvider - returning ${result.length} pets',
  );
  return result;
});

/// Check if there are more pets to load with real adoption state
final hasMorePetsToLoadProvider = Provider<bool>((ref) {
  final petsState = ref.watch(petsProvider);
  final adoptionState = ref.watch(adoptionProvider);

  print(
    '🔍 [DEBUG] hasMorePetsToLoadProvider - selectedType: ${petsState.selectedType}',
  );
  print(
    '🔍 [DEBUG] hasMorePetsToLoadProvider - currentPage: ${petsState.currentPage}',
  );

  // Get filtered pets first
  final filteredPets = petsState.filteredPets;

  // Filter out adopted pets
  final availablePets =
      filteredPets.where((pet) => !adoptionState.isPetAdopted(pet.id)).toList();

  print(
    '🔍 [DEBUG] hasMorePetsToLoadProvider - availablePets length: ${availablePets.length}',
  );
  print(
    '🔍 [DEBUG] hasMorePetsToLoadProvider - itemsPerPage: ${petsState.itemsPerPage}',
  );

  // Only show "Load More" for "All" filter
  if (petsState.selectedType != null) {
    print(
      '🔍 [DEBUG] hasMorePetsToLoadProvider - returning false (type filter)',
    );
    return false;
  }

  final hasMore =
      (petsState.currentPage * petsState.itemsPerPage) < availablePets.length;
  print('🔍 [DEBUG] hasMorePetsToLoadProvider - returning $hasMore');
  return hasMore;
});

/// Get loading state
final petsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(petsProvider).isLoading;
});

/// Get error state
final petsErrorProvider = Provider<String?>((ref) {
  return ref.watch(petsProvider).error;
});

/// Get specific pet by ID
final petByIdProvider = Provider.family<PetModel?, String>((ref, id) {
  return ref.watch(petsProvider.notifier).getPetById(id);
});
