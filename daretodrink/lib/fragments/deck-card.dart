import 'package:daretodrink/data/application-properties.dart';
import 'package:daretodrink/data/card-model.dart';
import 'package:daretodrink/fragments/dare-2-drink-footer.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:daretodrink/theme/theme.dart';
import 'package:flutter/material.dart';

class DeckCard extends StatefulWidget {
  final CardModel card;
  const DeckCard({Key? key, required this.card}) : super(key: key);

  @override
  State<DeckCard> createState() => DeckCardState();
}

class DeckCardState extends State<DeckCard> {
  @override
  Widget build(BuildContext context) {
    Color? _color = widget.card.type == CardType.generic 
      ? MyTheme.secondaryColor 
      : widget.card.type == CardType.twisted
        ?MyTheme.twistedColor
        :null;

    return Card(
      color:_color,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: MyTheme.getThemeData().primaryColor),
          borderRadius: ApplicationProperties.instance.borderRadius),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoSizeText(
                    widget.card.text,
                    maxLines: 8,
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.center,
                    style: MyTheme.getThemeData().textTheme.titleLarge,
                  ),
                  AutoSizeText(
                    widget.card.subText ?? "",
                    maxLines: 4,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    style: MyTheme.getThemeData().textTheme.bodyMedium,
                  ),
                  Text(" ~ Or ~ ",
                      textAlign: TextAlign.center,
                      style: _addColotToTextStyle(
                          MyTheme.getThemeData().textTheme.headlineMedium!,
                          widget.card.type == CardType.generic
                              ? MyTheme.getThemeData().primaryColor
                              : MyTheme.secondaryColor)),
                  Text(
                    widget.card.amount == null || widget.card.amount == 0
                        ? "Fuck You"
                        : "Drink " + _getAmount(widget.card.amount!),
                    textAlign: TextAlign.center,
                    style: MyTheme.getThemeData().textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            Dare2DrinkFooter(type: widget.card.type == CardType.dare? FooterType.Dare2Drink_Gold: FooterType.Dare2Drink_Gold),
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
