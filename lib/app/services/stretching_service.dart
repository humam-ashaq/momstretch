// import 'dart:convert';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'auth_service.dart';

// class StretchingService {
//   static final baseUrl = dotenv.env['BASE_URL'] ?? '';
//   static final apiKey = dotenv.env['API_KEY'] ?? '';

//   static Map<String, String> getHeaders({bool withAuth = false}) {
//     final headers = {
//       'Content-Type': 'application/json',
//       'x-api-key': apiKey,
//     };

//     if (withAuth) {
//       final token = AuthService.getToken();

//       if (token != null) {
//         headers['Authorization'] = 'Bearer $token';
//       } else {
//         print('WARNING: Token is null!'); // Debug
//       }
//     }

//     return headers;
//   }

//   Future<List<StretchingListItem>> getStretchings({int? limit}) async {
//     try {
//       // Buat URL dengan parameter limit jika ada
//       String url = '$baseUrl/stretchings';
//       if (limit != null) {
//         url += '?limit=$limit';
//       }

//       final response = await http.get(
//         Uri.parse(url),
//         headers: getHeaders(withAuth: true),
//       );

//       if (response.statusCode == 200) {
//         return parseArticleList(response.body);
//       } else if (response.statusCode == 404) {
//         throw Exception('Tidak ada artikel ditemukan');
//       } else {
//         throw Exception('Gagal memuat artikel: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error saat mengambil artikel: $e');
//     }
//   }
// }

// class StretchingListItem {
//   final String id;
//   final String title;
//   final String? imageUrl;
//   final String monthYear;

//   StretchingListItem({
//     required this.id,
//     required this.title,
//     this.imageUrl,
//     required this.monthYear,
//   });

//   factory StretchingListItem.fromJson(Map<String, dynamic> json) {
//     return StretchingListItem(
//       id: json['_id'] as String,
//       title: json['title'] as String,
//       imageUrl: json['image_url'] as String?,
//       monthYear: json['month_year'] as String,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'title': title,
//       'image_url': imageUrl,
//       'month_year': monthYear,
//     };
//   }
// }