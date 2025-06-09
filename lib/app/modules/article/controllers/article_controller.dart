import 'package:get/get.dart';
import '../../../services/article_service.dart';

class ArticleController extends GetxController {
  final ArticleService _articleService = ArticleService();
  
  // Observable variables
  var articles = <ArticleListItem>[].obs;
  var selectedArticle = Rx<ArticleDetail?>(null);
  var isLoading = false.obs;
  var isLoadingDetail = false.obs;
  var errorMessage = ''.obs;
  var detailErrorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchArticles();
  }

  // Fetch list artikel
  Future<void> fetchArticles() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final result = await _articleService.getArticles(limit: 10);
      
      // Ambil hanya 10 artikel terbaru
      articles.value = result;
      
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Fetch detail artikel
  Future<void> fetchArticleDetail(String articleId) async {
    try {
      isLoadingDetail.value = true;
      detailErrorMessage.value = '';
      selectedArticle.value = null;
      
      final result = await _articleService.getArticleDetail(articleId);
      selectedArticle.value = result;
      
    } catch (e) {
      detailErrorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingDetail.value = false;
    }
  }

  // Refresh artikel
  Future<void> refreshArticles() async {
    await fetchArticles();
  }

  // Clear selected article
  void clearSelectedArticle() {
    selectedArticle.value = null;
    detailErrorMessage.value = '';
  }

  // Get article by ID from list
  ArticleListItem? getArticleById(String id) {
    try {
      return articles.firstWhere((article) => article.id == id);
    } catch (e) {
      return null;
    }
  }
}