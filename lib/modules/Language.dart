class Language {
  final int id;
  final String name;
  final String code;

  Language(this.id, this.name, this.code);

  static List<Language> languageList() {
    return <Language>[
      Language(1, 'English', 'en'),
      Language(2, 'العربية', 'ar'),
    ];
  }
}
