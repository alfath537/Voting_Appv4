import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/feedback_model.dart';
import '../models/vote_result.dart';

class VoteDB {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'voting_app.db');

    _db = await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE votes(
            title TEXT PRIMARY KEY,
            totalVotes INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE feedbacks(
            id TEXT PRIMARY KEY,
            movieTitle TEXT,
            feedback TEXT,
            rating REAL,
            timestamp TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE feedbacks ADD COLUMN movieTitle TEXT');
        }
      },
    );

    return _db!;
  }

  // ================== VOTES ==================
  static Future<void> saveResults(Map<String, int> map) async {
    final db = await database;
    final batch = db.batch();
    map.forEach((title, total) {
      batch.insert(
        'votes',
        {'title': title, 'totalVotes': total},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
    await batch.commit(noResult: true);
  }

  static Future<List<VoteResult>> getAllResults() async {
    final db = await database;
    final rows = await db.query('votes', orderBy: 'totalVotes DESC');
    return rows.map((r) => VoteResult.fromMap(r)).toList();
  }

  // ================== FEEDBACK ==================
  static Future<void> insertFeedback(FeedbackModel f) async {
    final db = await database;
    await db.insert(
      'feedbacks',
      f.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<FeedbackModel>> getAllFeedbacks() async {
    final db = await database;
    final rows = await db.query('feedbacks', orderBy: 'timestamp DESC');
    return rows.map((r) => FeedbackModel.fromMap(r)).toList();
  }

  static Future<List<FeedbackModel>> getFeedbackByMovie(String movieTitle) async {
    final db = await database;
    final rows = await db.query(
      'feedbacks',
      where: 'movieTitle = ?',
      whereArgs: [movieTitle],
      orderBy: 'timestamp DESC',
    );
    return rows.map((r) => FeedbackModel.fromMap(r)).toList();
  }

  // ================== STREAM REAL-TIME ==================
  static Stream<List<FeedbackModel>> feedbackStream({String? movieTitle}) async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      if (movieTitle != null) {
        yield await getFeedbackByMovie(movieTitle);
      } else {
        yield await getAllFeedbacks();
      }
    }
  }
}
