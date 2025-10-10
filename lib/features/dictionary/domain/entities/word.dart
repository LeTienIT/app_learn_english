class Word {
  int? id;
  String english;
  String vietnamese;
  String? example;
  bool favorite;
  String? languageType;
  Word({this.id,required this.english, required this.vietnamese, this.example, this.favorite=false, this.languageType = "en-vi",});
}