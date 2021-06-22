import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'message_model.dart';


class DatabaseHelper {

  static final _databaseName = "app_inbox.db";
  static final _databaseVersion = 1;

  static final table = 'noti';

  static final columnId = 'id';
  static final columnUUId = 'uuid';
  static final columnTitle = 'title';
  static final columnDesc = 'description';
  static final columnIsRead = 'is_read';
  static final columnOtp = 'otp';
  static final columnImage = 'image';
  static final columnPromotionPageUrl = 'promotionPageUrl';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnUUId VARCHAR NOT NULL,
            $columnTitle VARCHAR NOT NULL,
            $columnDesc VARCHAR NOT NULL,
            $columnIsRead INTEGER,
            $columnOtp VARCHAR NOT NULL,
            $columnImage VARCHAR NOT NULL,
            $columnPromotionPageUrl VARCHAR NOT NULL
          )
          ''');
  }

  Future<int> insert(FirebaseMessageModel notiMessage) async {
    Database? db = await instance.database;
    var res = await db!.insert(table, notiMessage.toMap());
    return res;
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? db = await instance.database;
    var res = await db!.query(table, orderBy: "$columnId DESC");
    return res;
  }

  Future<List<FirebaseMessageModel>> getAllMessages() async{
    List<FirebaseMessageModel> messageList = <FirebaseMessageModel>[];
      print('getting message from database');
      await queryAllRows().then((value) {
        value.forEach((element) {
          messageList.add(
              FirebaseMessageModel(
                uuid: element['uuid'],
                title: element["title"],
                description: element["description"],
                isRead: element['is_read'],
                otp: element['otp'].toString(),
                image: element['image'],
                promotionPageUrl: element['promotionPageUrl'],
              )
          );
        });

      }
      ).catchError((error) {
        print(error);
      });
      return messageList;

  }

  Future<int?> getUnreadCount() async {
    Database? db = await instance.database;
    int? count = Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $table WHERE $columnIsRead =?', [0]));
    return count;
  }

  Future<int> delete(FirebaseMessageModel messageModel) async {
    Database? db = await instance.database;
    return await db!.delete(table, where: '$columnUUId = ?', whereArgs: [messageModel.uuid]);
  }

  Future<void> clearTable() async {
    Database? db = await instance.database;
    await db!.rawQuery("DELETE FROM $table");
  }

  Future<int> updateIsRead(FirebaseMessageModel message) async {
    print("messageuuid: " + message.uuid);
    final db = await database;
    var res = db!.rawUpdate(
        'UPDATE $table SET $columnIsRead = ?  WHERE $columnUUId = ?',
        [1, message.uuid]);
    return res;
  }


}
