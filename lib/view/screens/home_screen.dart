import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../controller/newsarticle_controller.dart';
import 'details_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late final NewsController newsController;

  @override
  void initState() {
    super.initState();
    // Initialize the controller
    newsController = Get.find<NewsController>();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Set based on your design (e.g., 360x690 for mobile)
      minTextAdapt: true,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('News Reader'),
            leading: Padding(
              padding: EdgeInsets.all(8.w), // Responsive padding
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/placeholder.png'),
                radius: 20.r, // Responsive radius
              ),
            ),
          ),
          body: Obx(() {
            if (newsController.status.value == Status.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (newsController.status.value == Status.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      newsController.errorMessage.value,
                      style: TextStyle(fontSize: 18.sp), // Responsive font size
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.h), // Responsive spacing
                    ElevatedButton(
                      onPressed: () {
                        newsController.retry();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: () => newsController.fetchArticles(),
                child: ListView.builder(
                  itemCount: newsController.articles.length,
                  itemBuilder: (context, index) {
                    final article = newsController.articles[index];
                    return Card(
                      margin: EdgeInsets.symmetric(
                        horizontal: 10.w, // Responsive horizontal margin
                        vertical: 5.h, // Responsive vertical margin
                      ),
                      child: ListTile(
                        leading: article.urlToImage != null
                            ? CachedNetworkImage(
                          imageUrl: article.urlToImage!,
                          width: 100.w, // Responsive width
                          height: 100.h, // Responsive height
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Image.asset('assets/placeholder.png'),
                          errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                        )
                            : Image.asset(
                          'assets/placeholder.png',
                          width: 100.w,
                          height: 100.h,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          article.title ?? 'No Title',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp, // Responsive font size
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5.h), // Responsive spacing
                            Text(article.description ?? 'No Description'),
                            SizedBox(height: 5.h), // Responsive spacing
                            Text(
                              article.publishedAt != null
                                  ? DateTime.parse(article.publishedAt!)
                                  .toLocal()
                                  .toString()
                                  : 'No Date',
                              style: TextStyle(
                                  fontSize: 12.sp, // Responsive font size
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                        onTap: () {
                          Get.to(() => DetailScreen(article: article));
                        },
                      ),
                    );
                  },
                ),              );
            }
          }),
        );
      },
    );
  }
}

