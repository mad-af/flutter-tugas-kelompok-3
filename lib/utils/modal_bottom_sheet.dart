import 'package:crud_sqlite_flutter/model/item_model.dart';
import 'package:flutter/material.dart';
import '../widget/item_form_widget.dart';

class ModalBottomSheet {
  void showBottomSheet(BuildContext context, ItemModel itemModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return ItemFormWidget(itemModel);
      },
    );
  }
}
