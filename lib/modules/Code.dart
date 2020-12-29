class Code {
  String id;
  String userId;
  String couponId;
  String couponArName;
  String couponEnName;
  String createdAt;

  Code({
    this.id,
    this.userId,
    this.couponId,
    this.couponArName,
    this.couponEnName,
    this.createdAt,
  });

  factory Code.fromJson(Map<String, dynamic> json) {
    return Code(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      couponId: json['coupon_id'] as String,
      couponArName: json['ar-name'] as String,
      couponEnName: json['en-name'] as String,
      createdAt: json['created_at'] as String,
    );
  }
}
