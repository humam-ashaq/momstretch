import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mom_stretch/app/data/app_colors.dart';
import 'package:mom_stretch/app/services/auth_service.dart';
import '../../../routes/app_pages.dart';
import '../../../services/article_service.dart';

class HomeController extends GetxController {
  final ArticleService _articleService = ArticleService();

  var nama = ''.obs;
  var homeArticles = <ArticleListItem>[].obs;
  var isLoadingArticles = false.obs;
  var articleErrorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
    fetchHomeArticles();
  }
  
  Future<void> fetchProfile() async {
    final result = await AuthService.getProfile();
    if (result['success']) {
      final data = result['data'];
      nama.value = data['nama'] ?? '';
    }
  }

  // Fetch 3 artikel terbaru untuk ditampilkan di home
  Future<void> fetchHomeArticles() async {
    try {
      isLoadingArticles.value = true;
      articleErrorMessage.value = '';
      
      final result = await _articleService.getArticles(limit: 3);
      homeArticles.value = result;
      
    } catch (e) {
      articleErrorMessage.value = e.toString();
      print('Error fetching home articles: $e');
    } finally {
      isLoadingArticles.value = false;
    }
  }

   // Refresh artikel di home
  Future<void> refreshHomeArticles() async {
    await fetchHomeArticles();
  }

  void onExploreStretching() {
    Get.toNamed('/stretching');
  }

  void onReadNowPressed(ArticleListItem article) {
    Get.toNamed(Routes.ARTICLE_DETAIL, arguments: article);
  }

  void onViewAllPressed() {
    Get.toNamed('/article');
  }

  Widget buildArticleCard(ArticleListItem article) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: article.imageUrl != null && article.imageUrl!.isNotEmpty
                ? Image.network(
                    article.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                  )
                : Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(
                        Icons.article,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
          ),
        ),
        Positioned(
          bottom: 24,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  shadows: [
                    Shadow(
                      blurRadius: 4.0,
                      color: Colors.black54,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => onReadNowPressed(article),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.forthColor,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Baca Sekarang', style: TextStyle(
                  color: AppColors.primaryColor
                ),),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget untuk menampilkan loading state artikel
  Widget buildLoadingArticleCard() {
    return Container(
      width: double.infinity,
      height: 200,
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  // Widget untuk menampilkan error state artikel
  Widget buildErrorArticleCard() {
    return Container(
      width: double.infinity,
      height: 200,
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 8),
          Text(
            'Gagal memuat artikel',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: refreshHomeArticles,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Coba Lagi',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
