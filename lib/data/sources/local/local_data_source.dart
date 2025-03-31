import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract interface class LocalDataSource {
  Future<Map<String, dynamic>?> getUserData(String uid);
  Future<List<Map<String, dynamic>>> getAllUsersDataExcept(String currentUid);
  Future<void> saveUserData({
    required String uid,
    required String username,
    String? imageUrl,
  });
}

class LocalDataSourceImpl implements LocalDataSource {
  LocalDataSourceImpl(this.db);

  final Database db;

  @override
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    final result = await db.query(
      'usersCache',
      where: 'uid = ?',
      whereArgs: [uid],
    );
    return result.isNotEmpty ? result.first : null;
  }

  @override
  Future<List<Map<String, dynamic>>> getAllUsersDataExcept(
      String currentUid) async {
    final result = await db.query(
      'usersCache',
      where: 'uid != ?',
      whereArgs: [currentUid],
    );
    return result;
  }

  @override
  Future<void> saveUserData({
    required String uid,
    required String username,
    String? imageUrl,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await db.insert(
      'usersCache',
      {
        'uid': uid,
        'username': username,
        'imageUrl': imageUrl,
        'lastUpdated': now,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<Database> setupDependencies() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'localDatabase.db');

    final database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE usersCache (
            uid TEXT PRIMARY KEY,
            username TEXT,
            imageUrl TEXT,
            lastUpdated INTEGER
          )
        ''');
      },
    );

    return database;
  }
}
