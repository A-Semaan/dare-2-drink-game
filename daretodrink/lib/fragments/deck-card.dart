import 'package:daretodrink/data/card-model.dart';
import 'package:daretodrink/fragments/dare-2-drink-footer.dart';
import 'package:daretodrink/globals.dart';
import 'package:daretodrink/theme/theme.dart';
import 'package:flutter/material.dart';

class DeckCard extends StatefulWidget {
  final CardModel card;
  DeckCard({Key? key, required this.card}) : super(key: key);

  @override
  State<DeckCard> createState() => Deck_CardState();
}

class Deck_CardState extends State<DeckCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          side: BorderSide(color: MyTheme.getThemeData().primaryColor),
          borderRadius: applicationProperties.borderRadius),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.card.text,
                    textAlign: TextAlign.center,
                    style: MyTheme.getThemeData().textTheme.titleLarge,
                  ),
                  Text(
                    widget.card.subText ?? "",
                    textAlign: TextAlign.center,
                    style: MyTheme.getThemeData().textTheme.bodySmall,
                  ),
                  Text(" ~ Or ~ ",
                      textAlign: TextAlign.center,
                      style: _addColotToTextStyle(
                          MyTheme.getThemeData().textTheme.headlineMedium!,
                          Colors.red)),
                  Text(
                    "Drink " + _getAmount(widget.card.amount!),
                    textAlign: TextAlign.center,
                    style: MyTheme.getThemeData().textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            const Dare2DrinkFooter(),
          ],
        ),
      ),
    );
  }

  String _getAmount(int? amount) {
    if (amount == null) {
      return "";
    }
    switch (amount) {
      default:
        return amount.toString() + " shots";
    }
  }

  TextStyle _addColotToTextStyle(TextStyle style, Color color) {
    style = style.copyWith(color: color);
    return style;
  }
}
