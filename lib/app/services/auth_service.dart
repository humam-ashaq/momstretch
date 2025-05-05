import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  static final box = GetStorage();
  static final baseUrl = dotenv.env['BASE_URL'] ?? '';
  static final apiKey = dotenv.env['API_KEY'] ?? '';

  static Map<String, String> getHeaders({bool withAuth = false}) {
    final headers = {
      'Content-Type': 'application/json',
      'x-api-key': apiKey,
    };
    if (withAuth) {
      final token = box.read('token');
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  static Future<Map<String, dynamic>> register(
      String email, String password, String nama) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: getHeaders(),
      body: json.encode({
        'email': email,
        'password': password,
        'nama': nama,
      }),
    );

    if (response.statusCode == 201) {
      return {'success': true, 'message': 'Registrasi berhasil'};
    } else {
      return {
        'success': false,
        'message': json.decode(response.body)['message']
      };
    }
  }

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: getHeaders(),
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await box.write('token', data['token']);
      await box.write('nama', data['nama']);
      return {'success': true, 'message': 'Login berhasil'};
    } else {
      return {
        'success': false,
        'message': json.decode(response.body)['message']
      };
    }
  }

  static Future<Map<String, dynamic>> getProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: getHeaders(withAuth: true),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {'success': true, 'data': data};
    } else {
      return {
        'success': false,
        'message': json.decode(response.body)['message']
      };
    }
  }

  static Future<Map<String, dynamic>> updateProfile(
      String usia, String fotoProfil) async {
    final response = await http.put(
      Uri.parse('$baseUrl/profile'),
      headers: getHeaders(withAuth: true),
      body: json.encode({
        'usia': usia,
        'foto_profil': fotoProfil,
      }),
    );

    if (response.statusCode == 200) {
      return {
        'success': true,
        'message': json.decode(response.body)['message']
      };
    } else {
      return {
        'success': false,
        'message': json.decode(response.body)['message']
      };
    }
  }

  static void logout() {
    box.remove('token');
  }

  static bool isLoggedIn() {
    return box.hasData('token');
  }
}
