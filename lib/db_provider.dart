import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
//import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBProvider {
  static final DBProvider _instance = DBProvider._internal();
  Database? _database;

  factory DBProvider() => _instance;

  DBProvider._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    DatabaseFactory factory = databaseFactoryFfi;
    
    String path = 'quadratic_calculations.db';
    
    if (!kIsWeb) {
      try {
        final dbPath = await getDatabasesPath();
        path = join(dbPath, 'quadratic_calculations.db');
      } catch (e) {
        print('Error getting database path: $e');
      }
    }
    
    try {
      return factory.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            await db.execute('''
              CREATE TABLE IF NOT EXISTS calculations(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                a REAL NOT NULL,
                b REAL NOT NULL,
                c REAL NOT NULL,
                result TEXT NOT NULL,
                created_at INTEGER NOT NULL
              )
            ''');
          },
        ),
      );
    } catch (e) {
      print('Error initializing database: $e');
      rethrow;
    }
  }

  Future<int> insertCalculation(Map<String, dynamic> calculation) async {
    try {
      final db = await database;
      return db.insert('calculations', calculation);
    } catch (e) {
      print('Error inserting calculation: $e');
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> getAllCalculations() async {
    try {
      final db = await database;
      return db.query(
        'calculations',
        orderBy: 'created_at DESC',
      );
    } catch (e) {
      print('Error getting calculations: $e');
      return [];
    }
  }
}