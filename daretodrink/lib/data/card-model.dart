class CardModel {
  int? id;
  String text;
  String? subText;
  Level? level;
  CardType? type;
  int? amount;

  CardModel(
    this.text,
    this.type, {
    this.id,
    this.subText,
    this.level,
    this.amount,
  });

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
      toReturn["type"] = type!.asEnumString();
    }

    return toReturn;
  }
}

enum CardType { dare, generic }

extension CardTypeExtension on CardType {
  static CardType fromString(String value) {
    switch (value) {
      case "DARE":
        return CardType.dare;
      case "GENERIC":
        return CardType.generic;
      default:
        return CardType.dare;
    }
  }

  static CardType fromInt(int value) {
    switch (value) {
      case 1:
        return CardType.dare;
      case 2:
        return CardType.generic;
      default:
        return CardType.dare;
    }
  }

  String asEnumString() {
    switch (this) {
      case CardType.dare:
        return "DARE";
      case CardType.generic:
        return "GENERIC";
      default:
        return "";
    }
  }

  String asString() {
    switch (this) {
      case CardType.dare:
        return "Dare";
      case CardType.generic:
        return "Wild card";
      default:
        return "";
    }
  }

  int toInt() {
    switch (this) {
      case CardType.dare:
        return 1;
      case CardType.generic:
        return 2;
      default:
        return 1;
    }
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
