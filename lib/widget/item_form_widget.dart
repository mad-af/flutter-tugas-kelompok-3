import 'dart:io';
import 'package:crud_sqlite_flutter/model/item_model.dart';
import 'package:crud_sqlite_flutter/provider/item_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class ItemFormWidget extends StatefulWidget {
  final ItemModel itemModel;

  const ItemFormWidget(this.itemModel, {super.key});

  @override
  State<ItemFormWidget> createState() => _ItemFormWidgetState();
}

class _ItemFormWidgetState extends State<ItemFormWidget> {
  final formKey = GlobalKey<FormState>();

  final _itemNameController = TextEditingController();
  final _itemPriceController = TextEditingController();
  ItemModel newItemModel = ItemModel();

  @override
  void initState() {
    super.initState();

    newItemModel = widget.itemModel;

    if (newItemModel.id != null) {
      _itemNameController.text = newItemModel.itemName;
      _itemPriceController.text = newItemModel.itemPrice;
      temporaryImagePath = newItemModel.itemImage;
    }
  }

  final _picker = ImagePicker();
  File? localImage;
  String? temporaryImagePath;

  Future<void> _pickImage(String source) async {
    ImageSource imageSource =
        source == "camera" ? ImageSource.camera : ImageSource.gallery;

    XFile? pickedImage = await _picker.pickImage(source: imageSource);

    if (pickedImage != null) {
      final directory = await getApplicationDocumentsDirectory();

      File myImage = File(pickedImage.path);

      // copy image to a permanent directory
      localImage = await myImage.copy("${directory.path}/${pickedImage.name}");

      setState(() {
        temporaryImagePath = pickedImage.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemListProvider>(context, listen: false);

    return Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.only(
              top: 10,
              right: 10,
              bottom: 10 + MediaQuery.of(context).viewInsets.bottom,
              left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // It set size to minumum
            children: [
              const SizedBox(height: 12.0),
              TextFormField(
                validator: (itemName) {
                  if (itemName == null || itemName.isEmpty) {
                    return "Fill item name.";
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.interpreter_mode),
                    label: Text("Item Name"),
                    border: OutlineInputBorder()),
                controller: _itemNameController,
              ),
              const SizedBox(height: 12.0),
              TextFormField(
                controller: _itemPriceController,
                validator: (itemName) {
                  if (itemName == null || itemName.isEmpty) {
                    return "Fill item price.";
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.price_change),
                    label: Text("Item Price:"),
                    border: OutlineInputBorder()),
              ),
              const SizedBox(height: 18.0),
              const Text(
                "Add Image",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Add Image.."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _pickImage("camera");
                            },
                            child: const Text("Camera"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _pickImage("Gallery");
                            },
                            child: const Text("Gallery"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 150.0,
                    height: 150.0,
                    child: Stack(
                      children: [
                        Image(
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            image: (temporaryImagePath != null &&
                                    (!temporaryImagePath!.contains("https")))
                                ? FileImage(File(temporaryImagePath!))
                                : NetworkImage(newItemModel.itemImage)
                                    as ImageProvider),
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.black26,
                        ),
                        const Center(
                          child: Text(
                            "ADD IMAGES",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.of(context).pop();

                      if (newItemModel.id != null) {
                        newItemModel = ItemModel(
                          id: newItemModel.id,
                          itemName: _itemNameController.text,
                          itemImage: localImage != null
                              ? localImage!.path
                              : newItemModel.itemImage,
                          itemPrice: _itemPriceController.text,
                        );

                        itemProvider.updateItem(newItemModel);
                      } else {
                        newItemModel = ItemModel(
                          itemName: _itemNameController.text,
                          itemImage: localImage != null
                              ? localImage!.path
                              : newItemModel.itemImage,
                          itemPrice: _itemPriceController.text,
                        );

                        itemProvider.addItem(newItemModel);
                      }
                    }
                  },
                  child: Text(
                    newItemModel.id != null ? "UPDATE" : "ADD",
                    style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
