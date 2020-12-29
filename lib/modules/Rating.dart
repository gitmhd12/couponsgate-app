class Rating {
  String id;
  String userId;
  String couponId;
  String type;
  String couponArName;
  String couponEnName;
  String createdAt;

  Rating({
    this.id,
    this.userId,
    this.couponId,
    this.type,
    this.couponArName,
    this.couponEnName,
    this.createdAt,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      couponId: json['coupon_id'] as String,
      type: json['type'] as String,
      couponArName: json['ar-name'] as String,
      couponEnName: json['en-name'] as String,
      createdAt: json['created_at'] as String,
    );
  }
}
