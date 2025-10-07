import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/ai_generation_request.dart';

class AIImageService {
  static const String _baseUrl = 'http://localhost:3000/api/ai';
  static const Duration _timeout = Duration(seconds: 30);

  // Générer une image à partir de texte
  static Future<AIGenerationResponse> generateFromText({
    required String projectId,
    required int stepId,
    required String prompt,
    String? seed,
    Map<String, dynamic> parameters = const {},
  }) async {
    final request = AIGenerationRequest(
      projectId: projectId,
      stepId: stepId,
      prompt: prompt,
      type: AIGenerationType.textToImage,
      parameters: parameters,
      seed: seed,
    );

    return await _makeRequest('/generate/text-to-image', request);
  }

  // Générer une image à partir d'une image de référence
  static Future<AIGenerationResponse> generateFromImage({
    required String projectId,
    required int stepId,
    required String prompt,
    required String referenceImageUrl,
    String? seed,
    Map<String, dynamic> parameters = const {},
  }) async {
    final request = AIGenerationRequest(
      projectId: projectId,
      stepId: stepId,
      prompt: prompt,
      referenceImageUrl: referenceImageUrl,
      type: AIGenerationType.imageToImage,
      parameters: parameters,
      seed: seed,
    );

    return await _makeRequest('/generate/image-to-image', request);
  }

  // Créer des variations d'une image
  static Future<AIGenerationResponse> generateVariation({
    required String projectId,
    required int stepId,
    required String referenceImageUrl,
    String? seed,
    Map<String, dynamic> parameters = const {},
  }) async {
    final request = AIGenerationRequest(
      projectId: projectId,
      stepId: stepId,
      prompt: '', // Pas de prompt pour les variations
      referenceImageUrl: referenceImageUrl,
      type: AIGenerationType.imageVariation,
      parameters: parameters,
      seed: seed,
    );

    return await _makeRequest('/generate/variation', request);
  }

  // Appliquer un style à une image
  static Future<AIGenerationResponse> applyStyle({
    required String projectId,
    required int stepId,
    required String contentImageUrl,
    required String styleImageUrl,
    Map<String, dynamic> parameters = const {},
  }) async {
    final request = AIGenerationRequest(
      projectId: projectId,
      stepId: stepId,
      prompt: 'Style transfer',
      referenceImageUrl: contentImageUrl,
      type: AIGenerationType.styleTransfer,
      parameters: {
        ...parameters,
        'styleImageUrl': styleImageUrl,
      },
    );

    return await _makeRequest('/generate/style-transfer', request);
  }

  // Obtenir le statut d'une génération
  static Future<AIGenerationResponse> getGenerationStatus(String generationId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/generation/$generationId'),
      headers: {'Content-Type': 'application/json'},
    ).timeout(_timeout);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return AIGenerationResponse.fromJson(data);
    } else {
      throw Exception('Erreur lors de la récupération du statut: ${response.statusCode}');
    }
  }

  // Annuler une génération
  static Future<bool> cancelGeneration(String generationId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/generation/$generationId'),
      headers: {'Content-Type': 'application/json'},
    ).timeout(_timeout);

    return response.statusCode == 200;
  }

  // Obtenir l'historique des générations
  static Future<List<AIGenerationResponse>> getGenerationHistory({
    String? projectId,
    int? stepId,
    int page = 1,
    int limit = 20,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (projectId != null) queryParams['projectId'] = projectId;
    if (stepId != null) queryParams['stepId'] = stepId.toString();

    final uri = Uri.parse('$_baseUrl/generations').replace(
      queryParameters: queryParams,
    );

    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    ).timeout(_timeout);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> generations = data['generations'];
      return generations.map((json) => AIGenerationResponse.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors de la récupération de l\'historique: ${response.statusCode}');
    }
  }

  // Méthode privée pour faire les requêtes
  static Future<AIGenerationResponse> _makeRequest(String endpoint, AIGenerationRequest request) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    ).timeout(_timeout);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      return AIGenerationResponse.fromJson(data);
    } else {
      final errorData = json.decode(response.body);
      throw Exception('Erreur lors de la génération: ${errorData['error'] ?? response.statusCode}');
    }
  }

  // Générer des images pour toutes les étapes d'un projet
  static Future<List<AIGenerationResponse>> generateProjectImages({
    required String projectId,
    required List<String> stepPrompts,
    String? referenceImageUrl,
    String? seed,
  }) async {
    final List<AIGenerationResponse> responses = [];
    String? currentSeed = seed;
    String? currentReference = referenceImageUrl;

    for (int i = 0; i < stepPrompts.length; i++) {
      try {
        AIGenerationResponse response;
        
        if (i == 0 || currentReference == null) {
          // Première image ou pas de référence
          response = await generateFromText(
            projectId: projectId,
            stepId: i,
            prompt: stepPrompts[i],
            seed: currentSeed,
          );
        } else {
          // Images suivantes basées sur la précédente
          response = await generateFromImage(
            projectId: projectId,
            stepId: i,
            prompt: stepPrompts[i],
            referenceImageUrl: currentReference,
            seed: currentSeed,
          );
        }

        responses.add(response);
        
        // Utiliser la nouvelle image comme référence pour la suivante
        currentReference = response.imageUrl;
        currentSeed = response.seed;
        
        // Attendre un peu entre les générations
        await Future.delayed(const Duration(seconds: 2));
      } catch (e) {
        print('Erreur lors de la génération de l\'étape $i: $e');
        // Continuer avec les autres étapes
      }
    }

    return responses;
  }
}
