import 'package:crud_apps/db_helper/database_connection.dart';
import 'package:sqflite/sqflite.dart';

class Repository {
  late DatabaseConnection _databaseConnection;
  

  Repository() {
    _databaseConnection = DatabaseConnection();
  }
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _databaseConnection.setDatabase();
      // await _performDatabaseMigration(_database!, 1, 2);
      return _database;
    }
  }

// Future<void> _performDatabaseMigration(Database database, int oldVersion, int newVersion) async {
//     if (oldVersion < 2) {
//       // Perform migration logic for version 2 (if needed)
//       await database.execute('''
//         ALTER TABLE users
//         ADD COLUMN address TEXT
//       ''');
//     }
//     // Add more migration logic for other versions as needed
//   }

  Future<int?> insertData(String table, Map<String, dynamic> data) async {
    var connection = await database;
    return await connection?.insert(table, data);
  }

  Future<List<Map<String, dynamic>>?> readData(String table) async {
    var connection = await database;
    return await connection?.query(table);
  }

  Future<List<Map<String, dynamic>>?> readDataById(
      String table, int itemId) async {
    var connection = await database;
    return await connection?.query(table, where: 'id=?', whereArgs: [itemId]);
  }

  
  Future<int?> updateData(String table, Map<String, dynamic> data) async {
    var connection = await database;
    return await connection?.update(
      table,
      data,
      where: 'id=?',
      whereArgs: [data['id']],
    );
  }

  Future<int?> deleteDataById(String table, int itemId) async {
    var connection = await database;
    return await connection?.rawDelete("DELETE FROM $table WHERE id = $itemId");
  }
}
