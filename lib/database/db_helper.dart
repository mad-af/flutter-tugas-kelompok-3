import 'dart:io';

import 'package:crud_sqlite_flutter/model/item_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  Future<Database> init() async {
    Directory directory = await getApplicationCacheDirectory();

    final path = join(directory.path, "items.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
        """
        CREATE TABLE ITEMS(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        itemName TEXT,
        itemPrice TEXT,
        itemImage TEXT)
        """,
      );
    });
  }

  Future<int> addItem(ItemModel itemModel) async {
    final db = await init();

    return db.insert("items", itemModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<ItemModel>> fetchItems() async {
    final db = await init();

    final maps = await db.query("items");

    return List.generate(maps.length, (index) {
      return ItemModel(
        id: maps[index]['id'] as int,
        itemName: maps[index]['itemName'].toString(),
        itemImage: maps[index]['itemImage'].toString(),
        itemPrice: maps[index]['itemPrice'].toString(),
      );
    });
  }

  Future<int> deleteItem(int id) async {
    final db = await init();

    int result = await db.delete("items", where: "id = ?", whereArgs: [id]);

    return result;
  }

  Future<int> updateUser(int? id, ItemModel itemModel) async {
    final db = await init();

    int result = await db
        .update("items", itemModel.toMap(), where: "id = ?", whereArgs: [id]);

    return result;
  }
}
