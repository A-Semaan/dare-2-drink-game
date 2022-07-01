abstract class CardModel {
  int? id;
  String text;
  CardType type;

  CardModel(this.text,this.type,{this.id});
}

enum CardType { dare, generic, twisted }

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
