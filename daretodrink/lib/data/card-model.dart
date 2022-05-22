class CardModel {
  String text;
  String? subText;
  Level? level;
  CardType type;
  int? amount;

  CardModel(
    this.text,
    this.type, {
    this.subText,
    this.level,
    this.amount,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> toReturn = {
      "text": text,
      "type": type,
    };
    if (subText != null) {
      toReturn["subtext"] = subText;
    }
    if (level != null) {
      toReturn["level"] = level!.toInt();
    }
    if (amount != null) {
      toReturn["amount"] = amount!;
    }

    return toReturn;
  }
}

enum CardType { dare, generic }

enum Level { beginner, intermediate, hornyMFs }

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

  String asString() {
    switch (this) {
      case CardType.dare:
        return "DARE";
      case CardType.generic:
        return "GENERIC";
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
}
