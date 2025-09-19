import 'package:hive/hive.dart';

part 'word_data.g.dart';

@HiveType(typeId: 0)
class WordData extends HiveObject{
  @HiveField(0)
  String english;

  @HiveField(1)
  String vietnamese;

  @HiveField(2)
  String? example;

  @HiveField(3)
  bool favorite;

  WordData({required this.english, required this.vietnamese, this.example, this.favorite=false});
}