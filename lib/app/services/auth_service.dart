import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final box = GetStorage();
  static final baseUrl = dotenv.env['BASE_URL'] ?? '';
  // static final baseUrl = "http://192.168.85.105:5000";
  static final apiKey = dotenv.env['API_KEY'] ?? '';
  // static final apiKey = "cukurukuk";

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
    try {
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
    } catch (e) {
      if (kDebugMode) print('Register error: $e');
      return {'success': false, 'message': 'Terjadi kesalahan saat registrasi'};
    }
  }

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
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
    } catch (e) {
      if (kDebugMode) print('Login error: $e');
      return {'success': false, 'message': 'Terjadi kesalahan saat login'};
    }
  }

  static Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      // Pastikan Google Sign In dikonfigurasi dengan benar
      if (kDebugMode) print('Starting Google Sign In...');
      
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        // Tambahkan konfigurasi jika diperlukan
        scopes: ['email', 'profile'],
      ).signIn();
      
      if (googleUser == null) {
        if (kDebugMode) print('Google sign in cancelled by user');
        return {'success': false, 'message': 'Login Google dibatalkan'};
      }

      if (kDebugMode) print('Google user signed in: ${googleUser.email}');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        if (kDebugMode) print('Google auth tokens are null');
        return {'success': false, 'message': 'Gagal mendapatkan token Google'};
      }

      if (kDebugMode) print('Google auth tokens obtained');

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in ke Firebase
      if (kDebugMode) print('Signing in to Firebase...');
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final user = userCredential.user;
      if (user == null) {
        if (kDebugMode) print('Firebase user is null');
        return {'success': false, 'message': 'Login Firebase gagal'};
      }

      if (kDebugMode) print('Firebase user signed in: ${user.email}');

      // Ambil token ID dari Firebase
      final firebaseToken = await user.getIdToken();
      
      if (firebaseToken == null || firebaseToken.isEmpty) {
        if (kDebugMode) print('Firebase ID token is null or empty');
        return {'success': false, 'message': 'Gagal mendapatkan token Firebase'};
      }

      if (kDebugMode) {
        print('Firebase user: ${user.email}');
        print('Firebase ID Token length: ${firebaseToken.length}');
      }

      // Validasi baseUrl dan apiKey
      if (baseUrl.isEmpty) {
        if (kDebugMode) print('Base URL is empty');
        return {'success': false, 'message': 'Konfigurasi server tidak ditemukan'};
      }

      if (apiKey.isEmpty) {
        if (kDebugMode) print('API Key is empty');
        return {'success': false, 'message': 'Konfigurasi API Key tidak ditemukan'};
      }

      // Kirim token ini ke backend
      if (kDebugMode) print('Sending request to backend: $baseUrl/login_oauth');
      
      final response = await http.post(
        Uri.parse('$baseUrl/login_oauth'),
        headers: getHeaders(),
        body: jsonEncode({'firebase_token': firebaseToken}),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['token'] == null || data['nama'] == null) {
          if (kDebugMode) print('Token or nama is null in response');
          return {'success': false, 'message': 'Respons server tidak valid'};
        }
        
        await box.write('token', data['token']);
        await box.write('nama', data['nama']);

        if (kDebugMode) print('Google login successful');
        return {'success': true, 'message': 'Login Google berhasil'};
      } else {
        final errorData = jsonDecode(response.body);
        final msg = errorData['message'] ?? 'Login backend gagal';
        if (kDebugMode) print('Backend error: $msg');
        return {'success': false, 'message': msg};
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) print('Firebase Auth error: ${e.code} - ${e.message}');
      return {'success': false, 'message': 'Error Firebase: ${e.message}'};
    } on http.ClientException catch (e) {
      if (kDebugMode) print('HTTP Client error: $e');
      return {'success': false, 'message': 'Koneksi ke server gagal'};
    } on FormatException catch (e) {
      if (kDebugMode) print('JSON Format error: $e');
      return {'success': false, 'message': 'Format respons server tidak valid'};
    } catch (e) {
      if (kDebugMode) print('Google login error: $e');
      return {'success': false, 'message': 'Terjadi kesalahan: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> getProfile() async {
    try {
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
    } catch (e) {
      if (kDebugMode) print('Get profile error: $e');
      return {'success': false, 'message': 'Terjadi kesalahan saat mengambil profil'};
    }
  }

  static Future<Map<String, dynamic>> updateProfile(
      String usia, String fotoProfil) async {
    try {
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
    } catch (e) {
      if (kDebugMode) print('Update profile error: $e');
      return {'success': false, 'message': 'Terjadi kesalahan saat memperbarui profil'};
    }
  }

  static void logout() {
    try {
      box.remove('token');
      box.remove('nama');
      // Sign out dari Google dan Firebase juga
      GoogleSignIn().signOut();
      FirebaseAuth.instance.signOut();
    } catch (e) {
      if (kDebugMode) print('Logout error: $e');
    }
  }

  static bool isLoggedIn() {
    return box.hasData('token');
  }
}