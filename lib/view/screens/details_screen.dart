import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:newsreader/models/article_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailScreen extends StatefulWidget {
  final Articles article;

  const DetailScreen({super.key, required this.article});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  String formatDate(String dateStr) {
    DateTime dateTime = DateTime.parse(dateStr);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Ensure this matches your design
      minTextAdapt: true,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Article Details'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.article.urlToImage != null
                    ? CachedNetworkImage(
                  imageUrl: widget.article.urlToImage!,
                  width: double.infinity,
                  height: 200.h, // Responsive height
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Image.asset('assets/placeholder.png'),
                  errorWidget: (context, url, error) =>
                  const Icon(Icons.error),
                )
                    : Image.asset(
                  'assets/placeholder.png',
                  width: double.infinity,
                  height: 200.h,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: EdgeInsets.all(16.w), // Responsive padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.article.title ?? 'No Title',
                        style: TextStyle(
                          fontSize: 24.sp, // Responsive font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.h), // Responsive spacing
                      Text(
                        widget.article.publishedAt != null
                            ? formatDate(widget.article.publishedAt!)
                            : 'No Date',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.sp, // Responsive font size
                        ),
                      ),
                      SizedBox(height: 20.h), // Responsive spacing
                      Text(
                        widget.article.content ?? 'No Content Available',
                        style: TextStyle(
                          fontSize: 16.sp, // Responsive font size
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

