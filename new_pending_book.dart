import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String tableName = "pendingBook";
final String Column_id = "id";
final String Column_name = "bookName";
final String Column_date = "lastDate";

class BookModel {
  final String bookName;
  final String lastDate;
  int id;

  BookModel({this.bookName, this.lastDate, this.id});

  Map<String, dynamic> toMap() {
    return {
      Column_name: this.bookName,
      Column_date: this.lastDate,
    };
  }
}

class bookHelper {
  Database db;

  bookHelper() {
    initDatabase();
  }

  Future<void> initDatabase() async {
    db = await openDatabase(
      join(await getDatabasesPath(), "my_db.db"),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE $tableName($Column_id INTEGER PRIMARY KEY AUTOINCREMENT, $Column_name TEXT , $Column_date TEXT)");
      },
      version: 1,
    );
  }

  Future<void> insertTask(BookModel book) async {
    try {
      db.insert(tableName, book.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print(e);
    }
  }

  Future<List<BookModel>> getAllBooks() async {
    final List<Map<String, dynamic>> books = await db.query(tableName);
    return List.generate(books.length, (i) {
      return BookModel(
          id: books[i][Column_id],
          bookName: books[i][Column_name],
          lastDate: books[i][Column_date]);
    });
  }
}
