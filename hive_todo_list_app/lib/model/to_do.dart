
import 'package:hive_flutter/adapters.dart';
part 'to_do.g.dart';

@HiveType(typeId: 1)
class ToDo {
  @HiveField(0)
  final String contents;

  @HiveField(1)
  final String date;

  ToDo({
    required this.contents,
    required this.date,
  });

}