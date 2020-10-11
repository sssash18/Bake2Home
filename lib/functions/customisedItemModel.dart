class CustomisedItemModel {
  bool availability,veg;
  String itemId;
  String itemName;
  double ingPrice;
  String photoUrl;
  double minTime;
  String itemCategory;
  String itemType;
  String recipe;
  List<String> ingredients, flavours;
  Map<String, dynamic> variants;
  CustomisedItemModel(
      {this.availability,
      this.itemId,
      this.ingPrice,
      this.ingredients,
      this.itemName,
      this.minTime,
      this.photoUrl,
      this.recipe,
      this.flavours,
      this.itemCategory,
      this.itemType,
      this.veg,
      this.variants});
}
