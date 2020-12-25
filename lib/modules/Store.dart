class Store {
  String id;
  String arName;
  String enName;
  String arDescription;
  String enDescription;
  String createdAt;
  String logo;
  String status;

  Store({this.id, this.arName , this.enName , this.arDescription , this.enDescription , this.createdAt , this.logo , this.status});

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'] as String,
      arName: json['ar-name'] as String,
      enName: json['en-name'] as String,
      arDescription: json['ar-des'] as String,
      enDescription: json['en-des'] as String,
      createdAt: json['created-at'] as String,
      logo: json['logo'] as String,
      status: json['status'] as String,
    );
  }
}
