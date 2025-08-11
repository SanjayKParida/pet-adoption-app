import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/pets_provider.dart';
import '../adoption/providers/adoption_provider.dart';
import '../favorites/providers/favorites_provider.dart';

/// Pets listing page
class PetsPage extends ConsumerStatefulWidget {
  const PetsPage({super.key});

  @override
  ConsumerState<PetsPage> createState() => _PetsPageState();
}

class _PetsPageState extends ConsumerState<PetsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final petsState = ref.watch(petsProvider);
    final petsNotifier = ref.read(petsProvider.notifier);
    final paginatedPets = ref.watch(paginatedAvailablePetsProvider);
    final hasMorePets = ref.watch(hasMorePetsToLoadProvider);
    final availablePets = ref.watch(availablePetsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🐾 Pet Adoption'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => petsNotifier.refreshPets(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '🔍 Search pets by name, breed, or type...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            petsNotifier.updateSearchQuery('');
                          },
                          tooltip: 'Clear search',
                        )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
              onChanged: (value) {
                petsNotifier.updateSearchQuery(value);
              },
            ),
          ),

          // Filter Chips
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('🐾 All'),
                    selected: petsState.selectedType == null,
                    onSelected: (_) => petsNotifier.updateTypeFilter(null),
                    selectedColor: Colors.white,
                    checkmarkColor: Colors.black,
                    labelStyle: TextStyle(
                      color:
                          petsState.selectedType == null ? Colors.black : null,
                      fontWeight:
                          petsState.selectedType == null
                              ? FontWeight.w600
                              : FontWeight.w500,
                    ),
                    avatar:
                        petsState.selectedType == null
                            ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.black,
                            )
                            : null,
                  ),
                  const SizedBox(width: 12),
                  FilterChip(
                    label: const Text('🐕 Dogs'),
                    selected: petsState.selectedType == 'Dog',
                    onSelected: (_) => petsNotifier.updateTypeFilter('Dog'),
                    selectedColor: Colors.white,
                    checkmarkColor: Colors.black,
                    labelStyle: TextStyle(
                      color:
                          petsState.selectedType == 'Dog' ? Colors.black : null,
                      fontWeight:
                          petsState.selectedType == 'Dog'
                              ? FontWeight.w600
                              : FontWeight.w500,
                    ),
                    avatar:
                        petsState.selectedType == 'Dog'
                            ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.black,
                            )
                            : null,
                  ),
                  const SizedBox(width: 12),
                  FilterChip(
                    label: const Text('🐱 Cats'),
                    selected: petsState.selectedType == 'Cat',
                    onSelected: (_) => petsNotifier.updateTypeFilter('Cat'),
                    selectedColor: Colors.white,
                    checkmarkColor: Colors.black,
                    labelStyle: TextStyle(
                      color:
                          petsState.selectedType == 'Cat' ? Colors.black : null,
                      fontWeight:
                          petsState.selectedType == 'Cat'
                              ? FontWeight.w600
                              : FontWeight.w500,
                    ),
                    avatar:
                        petsState.selectedType == 'Cat'
                            ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.black,
                            )
                            : null,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          const SizedBox(height: 16),

          // Content
          Expanded(child: _buildContent(petsState, petsNotifier)),
        ],
      ),
    );
  }

  Widget _buildContent(PetsState petsState, PetsNotifier petsNotifier) {
    final paginatedPets = ref.watch(paginatedAvailablePetsProvider);
    final hasMorePets = ref.watch(hasMorePetsToLoadProvider);
    final availablePets = ref.watch(availablePetsProvider);

    print('🔍 [DEBUG] _buildContent - selectedType: ${petsState.selectedType}');
    print(
      '🔍 [DEBUG] _buildContent - paginatedPets length: ${paginatedPets.length}',
    );
    print('🔍 [DEBUG] _buildContent - hasMorePets: $hasMorePets');
    print(
      '🔍 [DEBUG] _buildContent - availablePets length: ${availablePets.length}',
    );

    if (petsState.isLoading && petsState.pets.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading adorable pets...'),
          ],
        ),
      );
    }

    if (petsState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              petsState.error!,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => petsNotifier.loadPets(),
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (availablePets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.pets, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              petsState.searchQuery.isNotEmpty || petsState.selectedType != null
                  ? 'No pets match your search criteria'
                  : 'No pets available for adoption',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            if (petsState.searchQuery.isNotEmpty ||
                petsState.selectedType != null)
              TextButton(
                onPressed: () => petsNotifier.clearFilters(),
                child: const Text('Clear Filters'),
              ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => petsNotifier.refreshPets(),
      child: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.55,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: paginatedPets.length,
              itemBuilder: (context, index) {
                final pet = paginatedPets[index];
                return _buildPetCard(pet);
              },
            ),
          ),
          if (petsState.selectedType == null && hasMorePets)
            Container(
              margin: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => petsNotifier.loadMorePets(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.3),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.pets, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Load More Pets',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPetCard(pet) {
    final isAdopted = ref.watch(isPetAdoptedProvider(pet.id));
    return Card(
      elevation: 8,

      shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.pushNamed(context, '/pet-details', arguments: pet.id);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet Image with Hero Animation
            Expanded(
              flex: 3,
              child: Hero(
                tag: 'pet-image-${pet.id}',
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    color: Colors.grey[200],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        pet.imageUrls.isNotEmpty
                            ? Image.network(
                              pet.imageUrls.first,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.pets,
                                  size: 48,
                                  color: Colors.grey,
                                );
                              },
                            )
                            : const Icon(
                              Icons.pets,
                              size: 48,
                              color: Colors.grey,
                            ),
                        // Pet Type Badge
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  pet.type == 'Dog'
                                      ? Colors.orange
                                      : Colors.pink,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              pet.type,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        // Adopted Badge
                        if (isAdopted)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Adopted',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Pet Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'pet-name-${pet.id}',
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          pet.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      pet.breed,
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.7),
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    // Pet Age and Gender
                    Row(
                      children: [
                        Icon(
                          Icons.cake,
                          size: 12,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            '${pet.age} • ${pet.gender}',
                            style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.6),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Pet Price with Hero Animation
                    Hero(
                      tag: 'pet-price-${pet.id}',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '\$${pet.price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          Consumer(
                            builder: (context, ref, child) {
                              final isFavorite = ref.watch(
                                isFavoriteProvider(pet.id),
                              );
                              final favoritesNotifier = ref.read(
                                favoritesProvider.notifier,
                              );

                              return GestureDetector(
                                onTap:
                                    () => favoritesNotifier.toggleFavorite(
                                      pet.id,
                                    ),
                                child: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 16,
                                  color:
                                      isFavorite
                                          ? Colors.red
                                          : Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
