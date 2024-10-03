import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../../models/article_model.dart';

class DBService {
  static Database? _database;

  // Singleton pattern
  DBService._privateConstructor();

  static final DBService instance = DBService._privateConstructor();

  // Getter for the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the database if it doesn't exist
    _database = await _initDB('news.db');
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Open the database, creating it if it doesn't exist
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Create the articles table
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE articles(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        source TEXT,
        author TEXT,
        title TEXT,
        description TEXT,
        url TEXT UNIQUE,
        urlToImage TEXT,
        publishedAt TEXT,
        content TEXT
      )
    ''');
  }

  // Insert a single article
  Future<int> insertArticle(Articles article) async {
    final db = await database;
    return await db.insert(
      'articles',
      article.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Insert multiple articles using batch
  Future<void> insertArticles(List<Articles> articles) async {
    final db = await database;
    Batch batch = db.batch();
    for (var article in articles) {
      batch.insert(
        'articles',
        article.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  // Retrieve all articles, ordered by publishedAt descending
  Future<List<Articles>> getArticles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('articles', orderBy: 'publishedAt DESC');

    return List.generate(maps.length, (i) {
      return Articles.fromMap(maps[i]);
    });
  }

  // Retrieve a single article by URL
  Future<Articles?> getArticleByUrl(String url) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'articles',
      where: 'url = ?',
      whereArgs: [url],
    );

    if (maps.isNotEmpty) {
      return Articles.fromMap(maps.first);
    }
    return null;
  }

  // Update an existing article
  Future<int> updateArticle(Articles article) async {
    final db = await database;
    return await db.update(
      'articles',
      article.toMap(),
      where: 'id = ?',
      whereArgs: [article.id],
    );
  }

  // Delete an article by ID
  Future<int> deleteArticle(int id) async {
    final db = await database;
    return await db.delete(
      'articles',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Clear all articles
  Future<void> clearArticles() async {
    final db = await database;
    await db.delete('articles');
  }

  // Close the database
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
