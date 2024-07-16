import 'package:crud_sqlite_flutter/database/db_helper.dart';
import 'package:crud_sqlite_flutter/model/item_model.dart';
import 'package:flutter/cupertino.dart';

class ItemListProvider with ChangeNotifier {
  final db = DbHelper();

  Future<List<ItemModel>> getItemList() async {
    List<ItemModel> _itemList = await db.fetchItems();

    return _itemList;
  }

  Future<void> addItem(ItemModel itemModel) async {
    await db.addItem(itemModel);
    notifyListeners();
  }

  Future<void> updateItem(ItemModel itemModel) async {
    await db.updateUser(itemModel.id, itemModel);
    notifyListeners();
  }

  Future<void> deleteUser(int itemId) async {
    await db.deleteItem(itemId);
    notifyListeners();
  }
}
