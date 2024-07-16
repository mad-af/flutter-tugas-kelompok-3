import 'dart:io';
import 'package:crud_sqlite_flutter/model/item_model.dart';
import 'package:crud_sqlite_flutter/provider/item_list_provider.dart';
import 'package:crud_sqlite_flutter/utils/modal_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class ItemWidget extends StatelessWidget {
  final ItemModel itemModel;
  final modal = ModalBottomSheet();

  ItemWidget({super.key, required this.itemModel});

  bool get hasLocalImage {
    bool hasLocalImage = File(itemModel.itemImage).existsSync();
    return hasLocalImage;
  }

  ImageProvider backgroundImage(bool hasLocalImage) {
    if (hasLocalImage) {
      var bytes = File(itemModel.itemImage).readAsBytesSync();
      return MemoryImage(bytes);
    } else {
      return NetworkImage(itemModel.itemImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemListProvider>(context, listen: false);
    return Slidable(
      endActionPane: ActionPane(motion: ScrollMotion(), children: [
        SlidableAction(
          onPressed: (context) {
            modal.showBottomSheet(context, itemModel);
          },
          spacing: 1,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          borderRadius: BorderRadius.circular(4.0),
          icon: Icons.edit,
          label: "Edit",
        ),
        SlidableAction(
          onPressed: (context) {
            itemProvider.deleteUser(itemModel.id!);
          },
          spacing: 1,
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          borderRadius: BorderRadius.circular(4.0),
          icon: Icons.edit,
          label: "Delete",
        )
      ]),
      child: Card(
        elevation: 20.0,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image(
                  image: backgroundImage(hasLocalImage),
                  fit: BoxFit.fill,
                  width: 80,
                  height: 80,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itemModel.itemName,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.black26),
                ),
                Text(
                  "Rp. ${itemModel.itemPrice}",
                  style: TextStyle(fontSize: 14.0, color: Colors.blueAccent),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
