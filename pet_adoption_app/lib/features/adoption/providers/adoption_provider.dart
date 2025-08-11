import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class AdoptionState {
  final Set<String> adoptedPetIds;
  final bool isLoading;

  const AdoptionState({this.adoptedPetIds = const {}, this.isLoading = false});

  AdoptionState copyWith({Set<String>? adoptedPetIds, bool? isLoading}) {
    return AdoptionState(
      adoptedPetIds: adoptedPetIds ?? this.adoptedPetIds,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  bool isPetAdopted(String petId) {
    return adoptedPetIds.contains(petId);
  }
}

class AdoptionNotifier extends StateNotifier<AdoptionState> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _adoptedPetsKey = 'adopted_pets';

  AdoptionNotifier() : super(const AdoptionState()) {
    _loadAdoptedPets();
  }

  Future<void> _loadAdoptedPets() async {
    state = state.copyWith(isLoading: true);

    try {
      final adoptedPetsJson = await _storage.read(key: _adoptedPetsKey);
      if (adoptedPetsJson != null) {
        final List<dynamic> adoptedPetsList = json.decode(adoptedPetsJson);
        final Set<String> adoptedPetIds =
            adoptedPetsList.cast<String>().toSet();
        state = state.copyWith(adoptedPetIds: adoptedPetIds, isLoading: false);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> adoptPet(String petId) async {
    final updatedAdoptedPets = Set<String>.from(state.adoptedPetIds)
      ..add(petId);

    try {
      final adoptedPetsJson = json.encode(updatedAdoptedPets.toList());
      await _storage.write(key: _adoptedPetsKey, value: adoptedPetsJson);

      state = state.copyWith(adoptedPetIds: updatedAdoptedPets);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> unadoptPet(String petId) async {
    final updatedAdoptedPets = Set<String>.from(state.adoptedPetIds)
      ..remove(petId);

    try {
      final adoptedPetsJson = json.encode(updatedAdoptedPets.toList());
      await _storage.write(key: _adoptedPetsKey, value: adoptedPetsJson);

      state = state.copyWith(adoptedPetIds: updatedAdoptedPets);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> clearAllAdoptions() async {
    try {
      await _storage.delete(key: _adoptedPetsKey);
      state = state.copyWith(adoptedPetIds: {});
    } catch (e) {
      // Handle error
    }
  }
}

final adoptionProvider = StateNotifierProvider<AdoptionNotifier, AdoptionState>(
  (ref) {
    return AdoptionNotifier();
  },
);

final isPetAdoptedProvider = Provider.family<bool, String>((ref, petId) {
  return ref.watch(adoptionProvider).isPetAdopted(petId);
});
