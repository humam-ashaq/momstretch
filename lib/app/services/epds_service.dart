import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'auth_service.dart'; // Impor auth_service untuk menggunakan getHeaders

class EpdsService {
  // Ambil baseUrl dari environment variables, sama seperti di AuthService
  static final String _baseUrl = dotenv.env['BASE_URL'] ?? '';

  /// Mengambil riwayat skor EPDS untuk pengguna yang sedang login.
  /// Pengguna diidentifikasi melalui token otentikasi.
  ///
  /// Melempar Exception jika terjadi kegagalan.
  static Future<List<int>> fetchHistory() async {
    final uri = Uri.parse('$_baseUrl/api/epds/history');
    
    try {
      final response = await http.get(
        uri,
        // Gunakan header dari AuthService dengan otentikasi
        headers: AuthService.getHeaders(withAuth: true),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        return List<int>.from(jsonResponse);
      } else {
        // Lemparkan error untuk ditangani oleh controller
        throw Exception('Gagal memuat riwayat EPDS');
      }
    } catch (e) {
      // Tangani kesalahan jaringan atau lainnya
      throw Exception('Terjadi kesalahan jaringan: $e');
    }
  }

  /// Menyimpan hasil skor EPDS baru untuk pengguna yang sedang login.
  ///
  /// Mengembalikan Map yang berisi status 'success' (bool) dan 'message' (String).
  static Future<Map<String, dynamic>> saveResult(int score) async {
    final uri = Uri.parse('$_baseUrl/api/epds');
    
    try {
      final response = await http.post(
        uri,
        headers: AuthService.getHeaders(withAuth: true),
        // Body tidak perlu lagi berisi userId, karena sudah ada di token
        body: jsonEncode({
          'score': score,
        }),
      );

      if (response.statusCode == 201) {
        return {'success': true, 'message': 'Hasil berhasil disimpan'};
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Gagal menyimpan hasil'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan jaringan saat menyimpan hasil.'
      };
    }
  }
}