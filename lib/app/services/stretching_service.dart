import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'auth_service.dart';

class StretchingService {
  static final baseUrl = dotenv.env['BASE_URL'] ?? '';
  static final apiKey = dotenv.env['API_KEY'] ?? '';

  static Map<String, String> getHeaders({bool withAuth = false}) {
    final headers = {
      'Content-Type': 'application/json',
      'x-api-key': apiKey,
    };
    if (withAuth) {
      final token = AuthService.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  // Get list stretching berdasarkan program
  Future<List<Stretching>> getStretchingList(String program) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/stretching?program=$program'),
        headers: getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> parsed = json.decode(response.body);
        return parsed.map((json) => Stretching.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat daftar stretching: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error saat mengambil daftar stretching: $e');
    }
  }

  // Get list movement berdasarkan jenis stretching
  Future<List<Movement>> getMovementList(String stretchingType) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/movement?stretching=${Uri.encodeComponent(stretchingType)}'),
        headers: getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> parsed = json.decode(response.body);
        return parsed.map((json) => Movement.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat daftar gerakan: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error saat mengambil daftar gerakan: $e');
    }
  }

  // Get detail movement by ID
  Future<MovementDetail> getMovementDetail(String movementId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/movement/$movementId'),
        headers: getHeaders(),
      );

      if (response.statusCode == 200) {
        return MovementDetail.fromJson(json.decode(response.body));
      } else {
        throw Exception('Gagal memuat detail gerakan: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error saat mengambil detail gerakan: $e');
    }
  }
}

// === MODELS ===

// Model untuk list stretching
class Stretching {
  final String id;
  final String stretching;
  final String? imageUrl;
  final String program;
  final String duration;
  final String stretchingDesc;

  Stretching({
    required this.id,
    required this.stretching,
    this.imageUrl,
    required this.program,
    required this.duration,
    required this.stretchingDesc,
  });

  factory Stretching.fromJson(Map<String, dynamic> json) {
    return Stretching(
      id: json['_id'],
      stretching: json['stretching'],
      imageUrl: json['imageUrl'],
      program: json['program'],
      duration: json['duration'],
      stretchingDesc: json['stretchingDesc'] ?? 'Deskripsi tidak tersedia.',
    );
  }
}

// Model untuk list movement
class Movement {
  final String id;
  final String movement;
  final String? imageUrl;

  Movement({required this.id, required this.movement, this.imageUrl});

  factory Movement.fromJson(Map<String, dynamic> json) {
    return Movement(
      id: json['_id'],
      movement: json['movement'],
      imageUrl: json['imageUrl'],
    );
  }
}


// Model untuk detail movement (termasuk videoId dan deskripsi)
class MovementDetail {
  final String movement;
  final String? imageUrl;
  final String? videoId;
  final String movementDesc;

  MovementDetail({
    required this.movement,
    this.imageUrl,
    this.videoId,
    required this.movementDesc,
  });

  factory MovementDetail.fromJson(Map<String, dynamic> json) {
    return MovementDetail(
      movement: json['movement'],
      imageUrl: json['imageUrl'],
      videoId: json['videoId'],
      movementDesc: json['movementDesc'],
    );
  }
}