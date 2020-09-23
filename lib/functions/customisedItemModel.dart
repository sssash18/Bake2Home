class CustomisedItemModel {
  bool availability;
  String itemId;
  String itemName;
  double ingPrice;
  String photoUrl;
  String recipe;
  List<String> ingredients,flavours;
  Map<String, dynamic> variants;
  CustomisedItemModel(
      {this.availability,
      this.itemId,
      this.ingPrice,
      this.ingredients,
      this.itemName,
      this.photoUrl,
      this.recipe,
      this.flavours,
      this.variants});
}
