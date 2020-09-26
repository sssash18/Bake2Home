class Shop {
  String shopId,
      shopName,
      shopAddress,
      merchantName,
      bio,
      tagline,
      profilePhoto,
      coverPhoto,
      experience,
      contact,token;
  int numOrders, ingPrice;
  double rating,advance;
  bool cod;
  List<String> reviews;
  Map<String, dynamic> cookTime, items;

  Shop({
    this.shopId,
    this.shopName,
    this.shopAddress,
    this.merchantName,
    this.contact,
    this.bio,
    this.tagline,
    this.profilePhoto,
    this.coverPhoto,
    this.cookTime,
    this.experience,
    this.numOrders,
    this.items,
    this.rating,
    this.ingPrice,
    this.token,
    this.advance,
    this.cod,
    this.reviews
  });
}
