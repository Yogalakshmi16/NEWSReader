import 'package:newsreader/services/apimanager/calling_api.dart';
import 'package:newsreader/view/utilities/print_logger.dart';
import '../../models/article_model.dart';
import '../../view/utilities/constant.dart';

class NewsArticleProvider {

  // https://newsapi.org/v2/everything?q=tesla&fromJson=2024-08-27&sortBy=publishedAt&apiKey=API_KEY

  static const String _apiKey = '11b9b6097527489a90f5619c3b2e917b';
  static const String _baseUrl = 'https://newsapi.org/v2';

  Future<List<Articles>?> getApiArticle() async {
    try {
      final response = await ApiManager.getAPICall('$_baseUrl/top-headlines?country=us&apiKey=$_apiKey');
      printToLog('ArticleList :: $response');

      final data = newsArticleModelFromJson(response);

      if (data.status!.toLowerCase() == "ok") {
        return data.articles;
      } else {
        Baseutilities.showToast(RequestConstant.anErrorOccurred);
        throw Exception('API returned status: ${data.status}');
      }
    } catch (error) {
      printToLog(error.toString());
      Baseutilities.showToast('${RequestConstant.anErrorOccurred} $error');
      throw Exception('Failed to load news: $error');
    }
  }
}



