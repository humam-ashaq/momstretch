import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class AuthService {
  static final box = GetStorage();
  static const baseUrl = 'http://127.0.0.1:5000'; // Ganti IP server kamu

  static Future<Map<String, dynamic>> register(String email, String password, String nama) async {
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
      return {'success': false, 'message': json.decode(response.body)['message']};
    }
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
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
      box.write('token', data['token']);
      box.write('nama', data['nama']);
      return {'success': true, 'message': 'Login berhasil'};
    } else {
      return {'success': false, 'message': json.decode(response.body)['message']};
    }
  }

  static void logout() {
    box.erase(); // Bersihkan semua data
  }

  static bool isLoggedIn() {
    return box.hasData('token');
  }
}
