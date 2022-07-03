import 'package:daretodrink/data/application-properties.dart';
import 'package:daretodrink/data/card-model.dart';
import 'package:daretodrink/data/dare-card-model.dart';
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
            ? MyTheme.twistedColor
            : null;

    Color? _orColor = widget.card.type == CardType.generic
        ? MyTheme.getThemeData().primaryColor
        : MyTheme.secondaryColor;

    List<Widget> _widgets = [
      AutoSizeText(
        widget.card.text,
        maxLines: 8,
        overflow: TextOverflow.clip,
        textAlign: TextAlign.center,
        style: MyTheme.getThemeData().textTheme.titleLarge,
      ),
    ];

    if(widget.card.type!=CardType.twisted){
      DareCardModel _card = widget.card as DareCardModel;
      _widgets.addAll([AutoSizeText(
        _card.subText ?? "",
        maxLines: 4,
        textAlign: TextAlign.center,
        overflow: TextOverflow.clip,
        style: MyTheme.getThemeData().textTheme.bodyMedium,
      ),
      Text(" ~ Or ~ ",
          textAlign: TextAlign.center,
          style: _addColotToTextStyle(
              MyTheme.getThemeData().textTheme.headlineMedium!, _orColor)),
      Text(
        _card.amount == null || _card.amount == 0
            ? "Fuck You"
            : "Drink " + _getAmount(_card.amount!),
        textAlign: TextAlign.center,
        style: MyTheme.getThemeData().textTheme.headlineMedium,
      ),]);
    }

    return Card(
      color: _color,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: MyTheme.getThemeData().primaryColor),
          borderRadius: ApplicationProperties.instance.borderRadius),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: widget.card.type == CardType.twisted
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceBetween,
                children: _widgets,
              ),
            ),
            Dare2DrinkFooter(
                type: widget.card.type == CardType.twisted
                ? FooterType.Twisted
                : widget.card.type == CardType.dare
                    ? FooterType.Dare2Drink_Gold
                    : FooterType.Dare2Drink_Default),
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
