class Country {
  String id;
  String arName;
  String enName;
  String flag;

  Country({this.id, this.arName , this.enName , this.flag});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] as String,
      arName: json['ar-name'] as String,
      enName: json['en-name'] as String,
      flag: json['flag'] as String,
    );
  }
}
