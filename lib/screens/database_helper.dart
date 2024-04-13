import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path =
        join(await getDatabasesPath(), 'expenses.db'); // Path lokasi database
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE expenses(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        amount REAL,
        description TEXT,
        date TEXT
      )
    '''); // Membuat tabel untuk menyimpan pengeluaran
  }

  Future<int> insertExpense(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(
        'expenses', row); // Menambahkan pengeluaran baru ke database
  }

  Future<List<Map<String, dynamic>>> getAllExpenses() async {
    Database db = await instance.database;
    return await db
        .query('expenses'); // Mengambil semua data pengeluaran dari database
  }

  Future<List<Map<String, dynamic>>> getExpensesByDate(String date) async {
    Database db = await instance.database;
    return await db.query('expenses', where: 'date = ?', whereArgs: [
      date
    ]); // Mengambil pengeluaran berdasarkan tanggal dari database
  }

  Future<List<Map<String, dynamic>>> getExpensesByMonth(String month) async {
    Database db = await instance.database;
    return await db.query('expenses', where: 'date LIKE ?', whereArgs: [
      '$month%'
    ]); // Mengambil pengeluaran berdasarkan bulan dari database
  }

  Future<int> updateExpense(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['id'];
    return await db.update('expenses', row,
        where: 'id = ?',
        whereArgs: [id]); // Memperbarui pengeluaran di database
  }

  Future<int> deleteExpense(int id) async {
    Database db = await instance.database;
    return await db.delete('expenses',
        where: 'id = ?',
        whereArgs: [id]); // Menghapus pengeluaran dari database
  }
}
