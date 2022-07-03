import 'package:daretodrink/data/card-model.dart';

class DareCardModel extends CardModel {
  String? subText;
  Level? level;
  int? amount;

  DareCardModel(
    String text,
    CardType type, {
    int? id,
    this.subText,
    this.level,
    this.amount,
  }) : super(text, type, id: id);

  Map<String, dynamic> toMap() {
    Map<String, dynamic> toReturn = {
      "text": text,
      "type": type,
    };

    if (id != null) {
      toReturn["id"] = id;
    }

    if (subText != null) {
      toReturn["subtext"] = subText;
    }
    if (level != null) {
      toReturn["level"] = level!.toInt();
    }
    if (amount != null) {
      toReturn["amount"] = amount!;
    }

    if (type != null) {
      toReturn["type"] = type.asEnumString();
    }

    return toReturn;
  }
}

enum Level { beginner, intermediate, hornyMFs }

extension LevelExtension on Level {
  static Level fromInt(int value) {
    switch (value) {
      case 1:
        return Level.beginner;
      case 2:
        return Level.intermediate;
      case 3:
        return Level.hornyMFs;
      default:
        return Level.beginner;
    }
  }

  int toInt() {
    switch (this) {
      case Level.beginner:
        return 1;
      case Level.intermediate:
        return 2;
      case Level.hornyMFs:
        return 3;
      default:
        return 1;
    }
  }

  String asString() {
    switch (this) {
      case Level.beginner:
        return "Beginner";
      case Level.intermediate:
        return "Intermediate";
      case Level.hornyMFs:
        return "Horny MFs";
      default:
        return "";
    }
  }
}
