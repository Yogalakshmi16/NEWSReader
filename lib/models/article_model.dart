import 'dart:convert';

// Helper functions for JSON serialization/deserialization
NewsArticleModel newsArticleModelFromJson(String str) => NewsArticleModel.fromJson(json.decode(str));

String newsArticleModelToJson(NewsArticleModel data) => json.encode(data.toJson());

class Articles {
  int? id; // Database primary key
  Source? source;
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  String? publishedAt;
  String? content;

  Articles({
    this.id,
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  // Factory constructor to create an Articles instance from JSON
  factory Articles.fromJson(Map<String, dynamic> json) => Articles(
        source: json["source"] != null ? Source.fromJson(json["source"]) : null,
        author: json["author"],
        title: json["title"],
        description: json["description"],
        url: json["url"],
        urlToImage: json["urlToImage"],
        publishedAt: json["publishedAt"],
        content: json["content"],
      );

  // Factory constructor to create an Articles instance from a Map (e.g., from DB)
  factory Articles.fromMap(Map<String, dynamic> map) => Articles(
        id: map["id"],
        source: map["source"] != null
            ? Source.fromJson(json.decode(map["source"]))
            : null,
        author: map["author"],
        title: map["title"],
        description: map["description"],
        url: map["url"],
        urlToImage: map["urlToImage"],
        publishedAt: map["publishedAt"],
        content: map["content"],
      );

  // Convert Articles instance to JSON
  Map<String, dynamic> toJson() => {
        "source": source?.toJson(),
        "author": author,
        "title": title,
        "description": description,
        "url": url,
        "urlToImage": urlToImage,
        "publishedAt": publishedAt,
        "content": content,
      };

  // **NEW**: Convert Articles instance to Map (for DB insertion)
  Map<String, dynamic> toMap() => {
        "id": id,
        "source": json.encode(source?.toJson()),
        "author": author,
        "title": title,
        "description": description,
        "url": url,
        "urlToImage": urlToImage,
        "publishedAt": publishedAt,
        "content": content,
      };
}

class Source {
  String? id;
  String? name;

  Source({
    this.id,
    this.name,
  });

  // Factory constructor to create a Source instance from JSON
  factory Source.fromJson(Map<String, dynamic> json) => Source(
        id: json["id"],
        name: json["name"],
      );

  // Convert Source instance to JSON
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class NewsArticleModel {
  String? status;
  int? totalResults;
  List<Articles>? articles;

  NewsArticleModel({
    this.status,
    this.totalResults,
    this.articles,
  });

  // Factory constructor to create NewsArticleModel from JSON
  factory NewsArticleModel.fromJson(Map<String, dynamic> json) =>
      NewsArticleModel(
        status: json["status"],
        totalResults: json["totalResults"],
        articles: json["articles"] == null
            ? null
            : List<Articles>.from(json["articles"]
                .map((x) => x == null ? null : Articles.fromJson(x))),
      );

  // Convert NewsArticleModel instance to JSON
  Map<String, dynamic> toJson() => {
        "status": status,
        "totalResults": totalResults,
        "articles": articles == null
            ? null
            : List<dynamic>.from(articles!.map((x) => x.toJson())),
      };
}
