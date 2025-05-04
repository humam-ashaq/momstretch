import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class AuthService {
  static final box = GetStorage();
  static const baseUrl =
      'https://externally-popular-adder.ngrok-free.app'; // Ganti IP server kamu

  static Future<Map<String, dynamic>> register(
      String email, String password, String nama) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
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
      headers: {'Content-Type': 'application/json'},
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
    final token = box.read('token');
    print("Token di getProfile: $token"); // Debugging
    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
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
    final token = box.read('token');
    final response = await http.put(
      Uri.parse('$baseUrl/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
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
    box.remove('token'); // Bersihkan semua data
  }

  static bool isLoggedIn() {
    return box.hasData('token');
  }
}
