class Favorite {
  String id;
  String userId;
  String couponId;
  String couponArName;
  String couponEnName;

  Favorite({
    this.id,
    this.userId,
    this.couponId,
    this.couponArName,
    this.couponEnName,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      couponId: json['coupon_id'] as String,
      couponArName: json['ar-name'] as String,
      couponEnName: json['en-name'] as String,
    );
  }
}
