import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final box = GetStorage();
  static final baseUrl = dotenv.env['BASE_URL'] ?? '';
  static final apiKey = dotenv.env['API_KEY'] ?? '';

  // Initialize GoogleSignIn instance
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

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
      print('Register error: $e');
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
      print('Login error: $e');
      return {'success': false, 'message': 'Terjadi kesalahan saat login'};
    }
  }

  static Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      print('Starting Google Sign In...');

      // Sign out first to ensure clean state
      await _googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();

      // Start Google Sign In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      print('googleUser result: $googleUser');

      if (googleUser == null) {
        print('Google sign in cancelled by user');
        return {'success': false, 'message': 'Login Google dibatalkan'};
      }

      print('Google user signed in: ${googleUser.email}');

      // Get authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        print('Google auth tokens are null');
        return {'success': false, 'message': 'Gagal mendapatkan token Google'};
      }

      print('Google auth tokens obtained');

      // Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      print('Signing in to Firebase...');
      // final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // final user = userCredential.user;
      UserCredential? userCredential;
      User? user;

      try {
        userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        user = userCredential.user;
      } catch (firebaseError) {
        print('Firebase signInWithCredential error: $firebaseError');

        // ALTERNATIF: Coba gunakan current user jika sign in gagal tapi user sudah ada
        user = FirebaseAuth.instance.currentUser;

        if (user == null) {
          print('Firebase user is null after error');
          return {
            'success': false,
            'message': 'Login Firebase gagal: $firebaseError'
          };
        } else {
          print(
              'Using current Firebase user after sign in error: ${user.email}');
        }
      }

      if (user == null) {
        print('Firebase user is null');
        return {'success': false, 'message': 'Login Firebase gagal'};
      }

      print('Firebase user signed in: ${user.email}');

      // Get Firebase ID token with force refresh
      print('Getting Firebase ID token...');
      // final firebaseToken = await user.getIdToken(true);
      String? firebaseToken;

      try {
        firebaseToken = await user.getIdToken(true);
      } catch (tokenError) {
        print('Error getting Firebase token: $tokenError');

        // Coba tanpa force refresh
        try {
          firebaseToken = await user.getIdToken(false);
        } catch (tokenError2) {
          print('Error getting Firebase token (retry): $tokenError2');
          return {
            'success': false,
            'message': 'Gagal mendapatkan token Firebase'
          };
        }
      }

      if (firebaseToken == null || firebaseToken.isEmpty) {
        print('Firebase ID token is empty');
        return {
          'success': false,
          'message': 'Gagal mendapatkan token Firebase'
        };
      }

      {
        print('Firebase user: ${user.email}');
        print('Firebase ID Token length: ${firebaseToken.length}');
        print('Base URL: $baseUrl');
        print('API Key set: ${apiKey.isNotEmpty}');
      }

      // Test koneksi ke backend terlebih dahulu
      try {
        print('Testing backend connection...');
        final testResponse = await http.get(
          Uri.parse('$baseUrl/'),
          headers: {'x-api-key': apiKey},
        ).timeout(const Duration(seconds: 10));
        print('Backend test status: ${testResponse.statusCode}');
      } catch (e) {
        print('Backend connection test failed: $e');
        return {
          'success': false,
          'message':
              'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.'
        };
      }

      // Send token to backend dengan headers yang benar
      print('Sending OAuth request to backend...');

      {
        print('Request URL: $baseUrl/login_oauth');
        print('Request headers: ${getHeaders()}');
      }

      final response = await http
          .post(
        Uri.parse('$baseUrl/login_oauth'),
        headers: getHeaders(),
        body: json.encode({'firebase_token': firebaseToken}),
      )
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception(
              'Request timeout - Server tidak merespons dalam 30 detik');
        },
      );

      {
        print('Response status: ${response.statusCode}');
        print('Response headers: ${response.headers}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['token'] == null || data['nama'] == null) {
          print('Token or nama is null in response');
          return {'success': false, 'message': 'Respons server tidak valid'};
        }

        await box.write('token', data['token']);
        await box.write('nama', data['nama']);

        print('Google login successful');
        return {'success': true, 'message': 'Login Google berhasil'};
      } else if (response.statusCode == 403) {
        print('API Key validation failed');
        return {'success': false, 'message': 'Konfigurasi API tidak valid'};
      } else if (response.statusCode >= 500) {
        print('Server error: ${response.statusCode}');
        return {
          'success': false,
          'message': 'Server sedang mengalami masalah. Coba lagi nanti.'
        };
      } else {
        try {
          final errorData = jsonDecode(response.body);
          final msg = errorData['message'] ?? 'Login backend gagal';
          print('Backend error: $msg');
          return {'success': false, 'message': msg};
        } catch (e) {
          print('Failed to parse error response: $e');
          return {
            'success': false,
            'message': 'Terjadi kesalahan pada server (${response.statusCode})'
          };
        }
      }
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth error: ${e.code} - ${e.message}');

      String errorMessage;
      switch (e.code) {
        case 'account-exists-with-different-credential':
          errorMessage = 'Akun sudah ada dengan metode login yang berbeda';
          break;
        case 'invalid-credential':
        case 'user-not-found':
          errorMessage = 'Login gagal. Periksa akun Google Anda.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Login Google tidak diaktifkan';
          break;
        case 'user-disabled':
          errorMessage = 'Akun pengguna dinonaktifkan';
          break;
        case 'network-request-failed':
          errorMessage = 'Periksa koneksi internet Anda';
          break;
        default:
          errorMessage = 'Terjadi kesalahan saat login dengan Google';
      }

      return {'success': false, 'message': errorMessage};
    } on http.ClientException catch (e) {
      print('HTTP Client error: $e');
      return {'success': false, 'message': 'Tidak dapat terhubung ke server'};
    } on FormatException catch (e) {
      print('JSON Format error: $e');
      return {'success': false, 'message': 'Format respons server tidak valid'};
    } catch (e) {
      print('Google login error: $e');

      // Handle timeout specifically
      if (e.toString().contains('timeout') ||
          e.toString().contains('TimeoutException')) {
        return {
          'success': false,
          'message': 'Koneksi timeout. Periksa koneksi internet dan coba lagi.'
        };
      }

      // Handle network errors
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return {
          'success': false,
          'message':
              'Tidak dapat terhubung ke server. Periksa koneksi internet.'
        };
      }

      return {
        'success': false,
        'message': 'Terjadi kesalahan tidak terduga. Silakan coba lagi.'
      };
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
      print('Get profile error: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan saat mengambil profil'
      };
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
      print('Update profile error: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan saat memperbarui profil'
      };
    }
  }

  static Future<void> logout() async {
    try {
      box.remove('token');
      box.remove('nama');

      // Sign out from Google and Firebase
      await _googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Logout error: $e');
    }
  }

  static bool isLoggedIn() {
    return box.hasData('token');
  }
}
