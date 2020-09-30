class CartItemMap {
  String itemName, photoUrl, itemCategory;
  int quantity;
  double size, price;
  int minTime;
  String flavour, color;
  List<String> notes;
  CartItemMap(
      {this.quantity,
      this.size,
      this.minTime,
      this.itemName,
      this.notes,
      this.price,
      this.photoUrl,
      this.flavour,
      this.color,
      this.itemCategory});
}
