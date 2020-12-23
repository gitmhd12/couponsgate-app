class Country {
  String id;
  String arName;
  String enName;

  Country({this.id, this.arName , this.enName});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] as String,
      arName: json['ar-name'] as String,
      enName: json['en-name'] as String,
    );
  }
}
