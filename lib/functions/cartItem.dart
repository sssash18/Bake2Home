class CartItemMap{
  String itemName,photoUrl,itemCategory;
  int quantity;
  double size,price;
  String flavour,color;
  List<String> notes;
  CartItemMap({
    this.quantity,
    this.size,
    this.itemName,
    this.notes,
    this.price,
    this.photoUrl,
    this.flavour,
    this.color,
    this.itemCategory
  });

}