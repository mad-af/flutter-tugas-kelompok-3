class ItemModel {
  int? id;
  final String itemName;
  final String itemImage;
  final String itemPrice;

  ItemModel(
      {this.id,
      this.itemImage =
          "https://images.unsplash.com/photo-1610832958506-aa56368176cf?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      this.itemName = "",
      this.itemPrice = ""});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "itemName": itemName,
      "itemImage": itemImage,
      "itemPrice": itemPrice
    };
  }
}
