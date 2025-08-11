import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/pets_provider.dart';
import '../adoption/providers/adoption_provider.dart';
import '../favorites/providers/favorites_provider.dart';

/// Pet details page
class PetDetailsPage extends ConsumerWidget {
  final String petId;

  const PetDetailsPage({super.key, required this.petId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pet = ref.watch(petByIdProvider(petId));
    final isAdopted = ref.watch(isPetAdoptedProvider(petId));
    final adoptionNotifier = ref.read(adoptionProvider.notifier);

    if (pet == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Pet Details')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text('Pet not found', style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(pet.name),
        actions: [
          Consumer(
            builder: (context, ref, child) {
              final isFavorite = ref.watch(isFavoriteProvider(pet.id));
              final favoritesNotifier = ref.read(favoritesProvider.notifier);

              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_outline,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () => favoritesNotifier.toggleFavorite(pet.id),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet Image with Hero Animation
            Hero(
              tag: 'pet-image-${pet.id}',
              child: Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child:
                      pet.imageUrls.isNotEmpty
                          ? Image.network(
                            pet.imageUrls.first,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.pets,
                                size: 64,
                                color: Colors.grey,
                              );
                            },
                          )
                          : const Icon(
                            Icons.pets,
                            size: 64,
                            color: Colors.grey,
                          ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Pet Info with Hero Animation
            Hero(
              tag: 'pet-name-${pet.id}',
              child: Material(
                color: Colors.transparent,
                child: Text(
                  pet.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              '${pet.breed} • ${pet.age} • ${pet.gender}',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),

            // const SizedBox(height: 10),

            // Price with Hero Animation
            Hero(
              tag: 'pet-price-${pet.id}',
              child: Material(
                color: Colors.transparent,
                child: Text(
                  '\$${pet.price.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Description
            const Text(
              'About',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              pet.description,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),

            const SizedBox(height: 32),

            // Adopt Button
            if (!isAdopted)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    await adoptionNotifier.adoptPet(pet.id);
                    if (context.mounted) {
                      _showAdoptDialog(context, ref, pet);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    'Adopt Me',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'Already Adopted',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showAdoptDialog(BuildContext context, WidgetRef ref, pet) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adopt ${pet.name}?'),
          content: Text(
            'Are you sure you want to adopt ${pet.name}? This will cost \$${pet.price.toStringAsFixed(0)}.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Adopt the pet
                ref.read(petsProvider.notifier).adoptPet(pet.id);
                Navigator.of(context).pop();

                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Congratulations! You\'ve adopted ${pet.name}!',
                    ),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
              child: const Text('Adopt'),
            ),
          ],
        );
      },
    );
  }
}
