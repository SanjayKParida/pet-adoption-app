import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/pet_model.dart';

class PetsDataService {
  static List<PetModel>? _cachedPets;

  // Get API configuration from environment variables
  static String get _baseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:3001';
  static String get _apiEndpoint => dotenv.env['API_ENDPOINT'] ?? '/api/pets';

  /// Loads pets from API
  static Future<List<PetModel>> getAllPets() async {
    if (_cachedPets != null) {
      return _cachedPets!;
    }

    try {
      // Make HTTP request to API
      final response = await http.get(
        Uri.parse('$_baseUrl$_apiEndpoint'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        // Convert JSON to PetModel objects
        final List<dynamic> petsJson = jsonData['pets'];

        _cachedPets =
            petsJson.map((petJson) => PetModel.fromJson(petJson)).toList();
        return _cachedPets!;
      } else {
        debugPrint('Error loading pets data: HTTP ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        return [];
      }
    } catch (e, stackTrace) {
      debugPrint('Error loading pets data: $e');
      debugPrint('Stack trace: $stackTrace');
      return [];
    }
  }

  /// Simulates API delay for realistic behavior
  static Future<List<PetModel>> getAllPetsWithDelay() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return getAllPets();
  }

  /// Get pet by ID
  static Future<PetModel?> getPetById(String id) async {
    final pets = await getAllPets();
    try {
      return pets.firstWhere((pet) => pet.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Filter pets by type
  static Future<List<PetModel>> getPetsByType(String type) async {
    final pets = await getAllPets();
    return pets
        .where((pet) => pet.type.toLowerCase() == type.toLowerCase())
        .toList();
  }

  /// Search pets by name
  static Future<List<PetModel>> searchPets(String query) async {
    final pets = await getAllPets();
    if (query.isEmpty) return pets;

    return pets
        .where(
          (pet) =>
              pet.name.toLowerCase().contains(query.toLowerCase()) ||
              pet.breed.toLowerCase().contains(query.toLowerCase()) ||
              pet.type.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  /// Clear cache (useful for testing)
  static void clearCache() {
    _cachedPets = null;
  }
}
