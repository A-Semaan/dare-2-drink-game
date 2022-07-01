import 'package:daretodrink/data/card-model.dart';

class TwistedCardModel extends CardModel {
  final bool repeatable;

  TwistedCardModel(
    String text,
    this.repeatable, {
    int? id,
  }):super(text,CardType.twisted,id: id);

  Map<String, dynamic> toMap() {
    Map<String, dynamic> toReturn = {
      "text": text,
      "repeatable": repeatable,
    };

    if (id != null) {
      toReturn["id"] = id;
    }
    return toReturn;
  }

}
