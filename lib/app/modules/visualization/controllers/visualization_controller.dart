import 'package:get/get.dart';
import '../../../services/article_service.dart';

class VisualizationController extends GetxController {
  // Observable variables
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<VisualizationData?> visualizationData = Rx<VisualizationData?>(null);
  
  // Getters for easy access
  List<TopWord> get topWords => visualizationData.value?.topWords ?? [];
  List<MonthlyPostCount> get monthlyPostCount => visualizationData.value?.monthlyPostCount ?? [];
  
  @override
  void onInit() {
    super.onInit();
    fetchVisualizationData();
  }

  Future<void> fetchVisualizationData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final data = await ArticleService.getVisualizationData();
      
      if (data != null) {
        visualizationData.value = data;
      } else {
        errorMessage.value = 'Failed to load data';
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print('Error fetching visualization data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await fetchVisualizationData();
  }

  // Helper method to get formatted month name
  String getFormattedMonth(String monthStr) {
    try {
      final parts = monthStr.split('-');
      if (parts.length == 2) {
        final year = parts[0];
        final month = parts[1];
        
        final monthNames = [
          '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        ];
        
        final monthIndex = int.parse(month);
        if (monthIndex >= 1 && monthIndex <= 12) {
          return '${monthNames[monthIndex]} $year';
        }
      }
      return monthStr;
    } catch (e) {
      return monthStr;
    }
  }

  // Helper method to get color for charts
  List<int> getChartColors() {
    return [
      0xFF6366F1, // Indigo
      0xFF8B5CF6, // Violet
      0xFFA855F7, // Purple
      0xFFD946EF, // Fuchsia
      0xFFEC4899, // Pink
      0xFFF43F5E, // Rose
      0xFFF97316, // Orange
      0xFFEAB308, // Yellow
      0xFF84CC16, // Lime
      0xFF22C55E, // Green
    ];
  }

  // Method to clear data
  void clearData() {
    visualizationData.value = null;
    errorMessage.value = '';
  }

  // Method to check if data is available
  bool get hasData => visualizationData.value != null;
  
  // Method to get top N words (default 10)
  List<TopWord> getTopWords([int limit = 10]) {
    if (topWords.isEmpty) return [];
    return topWords.take(limit).toList();
  }

  // Method to get recent monthly data (default last 12 months)
  List<MonthlyPostCount> getRecentMonthlyData([int limit = 12]) {
    if (monthlyPostCount.isEmpty) return [];
    
    // Sort by month (assuming format YYYY-MM)
    final sortedData = List<MonthlyPostCount>.from(monthlyPostCount);
    sortedData.sort((a, b) => a.month.compareTo(b.month));
    
    // Get last N months
    return sortedData.reversed.take(limit).toList().reversed.toList();
  }

  // Method to get total posts count
  int get totalPostsCount {
    return monthlyPostCount.fold(0, (sum, item) => sum + item.count);
  }

  // Method to get total unique words
  int get totalWordsCount {
    return topWords.fold(0, (sum, item) => sum + item.count);
  }
}