import 'package:crud_sqlite_flutter/model/item_model.dart';
import 'package:crud_sqlite_flutter/provider/item_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/modal_bottom_sheet.dart';
import '../widget/item_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final modal = ModalBottomSheet();

  @override
  Widget build(BuildContext context) {
    Future<List<ItemModel>> getItemList() async {
      List<ItemModel> itemList =
          await Provider.of<ItemListProvider>(context).getItemList();

      return itemList;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "SQLITE CRUD",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<ItemModel>>(
        future: getItemList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          } else {
            final List<ItemModel> itemlist = snapshot.data!;

            return itemlist.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'No Item Available',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: itemlist.length,
                    itemBuilder: (context, index) => ItemWidget(
                      itemModel: itemlist[index],
                    ),
                  );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          modal.showBottomSheet(context, ItemModel());
        },
        backgroundColor: Colors.blueAccent,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
