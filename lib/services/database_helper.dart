import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  // create db
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('restaurant.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createReservation);
  }

  // create table
  Future _createReservation(Database db, int version) async {
    await db.execute('''
    CREATE TABLE reservations (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      session_id TEXT,
      name TEXT,
      address TEXT,
      phone TEXT,
      email TEXT,
      guests INTEGER,
      reservation_date TEXT,
      reservation_time TEXT,
      duration TEXT,
      additional_requests TEXT,
      selected_package_name TEXT,
      selected_package_price REAL,
      selected_additional_items TEXT
    )
    ''');
  }

  // show all data in database
  Future<List<Map<String, dynamic>>> getAllReservations() async {
    final db = await instance.database;
    return await db.query('reservations');
  }

  // insert reservation data
  Future<int> insertReservation(Map<String, dynamic> reservationData) async {
    final db = await instance.database;
    return await db.insert('reservations', reservationData);
  }

  // update reservation data
  Future<int> updateReservation(
    String sessionId,
    Map<String, dynamic> data,
  ) async {
    final db = await database;
    return await db.update(
      'reservations',
      data,
      where: 'session_id = ?',
      whereArgs: [sessionId],
    );
  }

  // fetch reservation data by session
  Future<Map<String, dynamic>?> fetchReservation(String sessionId) async {
    final db = await database;
    final result = await db.query(
      'reservations',
      where: 'session_id = ?',
      whereArgs: [sessionId],
    );

    return result.isNotEmpty ? result.first : null;
  }

  // update reservation data with package related things
  Future<bool> updateReservationPackage(
    String sessionId,
    String selectedPackageName,
    double selectedPackagePrice,
    String selectedAdditionalItems,
  ) async {
    final db = await database;
    final rowsAffected = await db.update(
      'reservations',
      {
        'selected_package_name': selectedPackageName,
        'selected_package_price': selectedPackagePrice,
        'selected_additional_items': selectedAdditionalItems,
      },
      where: 'session_id = ?',
      whereArgs: [sessionId],
    );
    return rowsAffected > 0;
  }

  // delete database
  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'restaurant.db');
    await deleteDatabase(path);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
