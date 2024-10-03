import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/article_model.dart';
import 'dart:io';
import '../services/localstorage_database/db_services.dart';
import '../services/provider/api_services.dart';

enum Status {loading, success, error}

class NewsController extends GetxController {
  final NewsArticleProvider apiService;
  final DBService dbService;

  NewsController({required this.apiService, required this.dbService});

  var articles = <Articles>[].obs;
  var allArticleList = <Articles>[].obs;

  var status = Status.loading.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    try {
      status.value = Status.loading;

      // Check connectivity
      var connectivityResult = await Connectivity().checkConnectivity();
      if (ConnectivityResult.none == connectivityResult) {
        // No internet, load from DB
        await loadArticlesFromDB();
        return;
      }

      // Fetch from API
      List<Articles>? fetchedArticles = await apiService.getApiArticle();

      if (fetchedArticles != null && fetchedArticles.isNotEmpty) {
        // Update the allArticleList
        allArticleList.assignAll(fetchedArticles);

        // Filter articles with non-null urlToImage
        var filteredArticles = allArticleList.where((article) => article.urlToImage != null).toList();

        articles.assignAll(filteredArticles);
        status.value = Status.success;

        // Save to local DB
        await dbService.clearArticles();
        await dbService.insertArticles(fetchedArticles);
      } else {
        status.value = Status.error;
        errorMessage.value = 'No articles found.';
      }
    } on SocketException {
      // Handle offline by loading from DB
      await loadArticlesFromDB();
    } catch (e) {
      status.value = Status.error;
      errorMessage.value = 'Failed to load news. Please try again.';
      if (kDebugMode) {
        print('Error fetching articles: $e');
      } // Optional: For debugging
    }
  }

  Future<void> loadArticlesFromDB() async {
    try {
      List<Articles> cachedArticles = await dbService.getArticles();
      if (cachedArticles.isNotEmpty) {
        // Optionally, you can filter cached articles similarly
        var filteredCached = cachedArticles
            .where((article) => article.urlToImage != null)
            .toList();

        articles.assignAll(filteredCached);
        status.value = Status.success;
      } else {
        status.value = Status.error;
        errorMessage.value = 'No Internet Connection and No Cached Data';
      }
    } catch (e) {
      status.value = Status.error;
      errorMessage.value = 'Failed to load cached news.';
      if (kDebugMode) {
        print('Error loading cached articles: $e');
      } // Optional: For debugging
    }
  }

  // Retry fetching articles
  void retry() {
    fetchArticles();
  }
}


