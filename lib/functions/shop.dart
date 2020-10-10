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
      contact,
      token;
  int numOrders, ingPrice, variety;
  double rating, advance;
  bool cod, pickup;
  List<String> reviews, recent;
  Map<String, dynamic> cookTime, items;

  Shop(
      {this.shopId,
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
      this.pickup,
      this.recent,
      this.numOrders,
      this.items,
      this.rating,
      this.ingPrice,
      this.token,
      this.advance,
      this.cod,
      this.reviews,
      this.variety});
}
