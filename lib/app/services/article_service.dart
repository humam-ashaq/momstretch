import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'auth_service.dart';

class ArticleService {
  static final baseUrl = dotenv.env['BASE_URL'] ?? '';
  static final apiKey = dotenv.env['API_KEY'] ?? '';
  
  // Headers untuk request
  static Map<String, String> getHeaders({bool withAuth = false}) {
    final headers = {
      'Content-Type': 'application/json',
      'x-api-key': apiKey,
    };

    if (withAuth) {
      final token = AuthService.getToken();

      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      } else {
        print('WARNING: Token is null!'); // Debug
      }
    }

    return headers;
  }

  // Model untuk Article List
  static List<ArticleListItem> parseArticleList(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<ArticleListItem>((json) => ArticleListItem.fromJson(json)).toList();
  }

  // Model untuk Article Detail
  static ArticleDetail parseArticleDetail(String responseBody) {
    return ArticleDetail.fromJson(json.decode(responseBody));
  }

  // Get list artikel
  Future<List<ArticleListItem>> getArticles({int? limit}) async {
    try {
      // Buat URL dengan parameter limit jika ada
      String url = '$baseUrl/articles';
      if (limit != null) {
        url += '?limit=$limit';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: getHeaders(withAuth: true),
      );

      if (response.statusCode == 200) {
        return parseArticleList(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('Tidak ada artikel ditemukan');
      } else {
        throw Exception('Gagal memuat artikel: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error saat mengambil artikel: $e');
    }
  }

  // Get detail artikel berdasarkan ID
  Future<ArticleDetail> getArticleDetail(String articleId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/article/$articleId'),
        headers: getHeaders(withAuth: true),
      );

      if (response.statusCode == 200) {
        return parseArticleDetail(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('Artikel tidak ditemukan');
      } else if (response.statusCode == 400) {
        throw Exception('ID artikel tidak valid');
      } else {
        throw Exception('Gagal memuat detail artikel: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error saat mengambil detail artikel: $e');
    }
  }

  static Future<VisualizationData?> getVisualizationData() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/visualization'),
        headers: {
          'Content-Type': 'application/json',
          'X-API-Key': apiKey, // Sesuaikan dengan header yang dibutuhkan backend
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return VisualizationData.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('No summary found');
      } else {
        throw Exception('Failed to load visualization data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching visualization data: $e');
    }
  }
}

// Model untuk item di list artikel
class ArticleListItem {
  final String id;
  final String title;
  final String? imageUrl;
  final String monthYear;

  ArticleListItem({
    required this.id,
    required this.title,
    this.imageUrl,
    required this.monthYear,
  });

  factory ArticleListItem.fromJson(Map<String, dynamic> json) {
    return ArticleListItem(
      id: json['_id'] as String,
      title: json['title'] as String,
      imageUrl: json['image_url'] as String?,
      monthYear: json['month_year'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'image_url': imageUrl,
      'month_year': monthYear,
    };
  }
}

// Model untuk detail artikel
class ArticleDetail {
  final String title;
  final String content;
  final String? imageUrl;
  final String monthYear;

  ArticleDetail({
    required this.title,
    required this.content,
    this.imageUrl,
    required this.monthYear,
  });

  factory ArticleDetail.fromJson(Map<String, dynamic> json) {
    return ArticleDetail(
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrl: json['image_url'] as String?,
      monthYear: json['month_year'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'month_year': monthYear,
    };
  }
}

class VisualizationData {
  final List<TopWord> topWords;
  final List<MonthlyPostCount> monthlyPostCount;

  VisualizationData({
    required this.topWords,
    required this.monthlyPostCount,
  });

  factory VisualizationData.fromJson(Map<String, dynamic> json) {
    return VisualizationData(
      topWords: (json['top_words'] as List)
          .map((item) => TopWord.fromJson(item))
          .toList(),
      monthlyPostCount: (json['monthly_post_count'] as List)
          .map((item) => MonthlyPostCount.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'top_words': topWords.map((item) => item.toJson()).toList(),
      'monthly_post_count': monthlyPostCount.map((item) => item.toJson()).toList(),
    };
  }
}

class TopWord {
  final String word;
  final int count;

  TopWord({
    required this.word,
    required this.count,
  });

  factory TopWord.fromJson(Map<String, dynamic> json) {
    return TopWord(
      word: json['word'] as String,
      count: json['count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'count': count,
    };
  }
}

class MonthlyPostCount {
  final String month;
  final int count;

  MonthlyPostCount({
    required this.month,
    required this.count,
  });

  factory MonthlyPostCount.fromJson(Map<String, dynamic> json) {
    return MonthlyPostCount(
      month: json['month'] as String,
      count: json['count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'count': count,
    };
  }
}