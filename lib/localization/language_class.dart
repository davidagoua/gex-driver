class Language {
  final int id;
  final String name;
  final String flag;
  final String languageCode;

  Language(this.id, this.name, this.flag, this.languageCode);

  static List<Language> languageList() {
    return <Language>[
      Language(1, 'English', '🇺🇸', 'en'),
      Language(2, 'Spanish', 'ES', 'es'),
      Language(3, 'Arabic', 'AE', 'ar'),
//*   If you are adding new language then uncomment below code
//    Language(4, 'LANGUAGE_NAME', 'LANGUAGE_FLAG', 'LANGUAGE_CODE'),      
    ];
  }
}