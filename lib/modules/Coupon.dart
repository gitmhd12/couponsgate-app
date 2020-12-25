class Coupon {
  String id;
  String arName;
  String enName;
  String arDescription;
  String enDescription;
  String createdAt;
  String store;
  String code;
  String copyCount;
  String status;
  String logo;

  Coupon({this.id,
    this.arName ,
    this.enName ,
    this.arDescription ,
    this.enDescription ,
    this.code ,
    this.copyCount ,
    this.createdAt ,
    this.store ,
    this.status,
    this.logo,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'] as String,
      arName: json['ar-name'] as String,
      enName: json['en-name'] as String,
      arDescription: json['ar-des'] as String,
      enDescription: json['en-des'] as String,
      code: json['code'] as String,
      copyCount: json['copy-count'] as String,
      createdAt: json['created-at'] as String,
      store: json['store'] as String,
      status: json['status'] as String,
      logo: json['logo'] as String,
    );
  }
}
