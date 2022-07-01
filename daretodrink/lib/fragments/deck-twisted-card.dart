import 'package:daretodrink/data/application-properties.dart';
import 'package:daretodrink/data/card-model.dart';
import 'package:daretodrink/fragments/dare-2-drink-footer.dart';
import 'package:daretodrink/fragments/twisted-card-label.dart';
import 'package:daretodrink/fragments/wild-card-label.dart';
import 'package:daretodrink/globals.dart';
import 'package:daretodrink/theme/theme.dart';
import 'package:flutter/material.dart';

class DeckTwistedCard extends StatefulWidget {
  const DeckTwistedCard({
    Key? key,
  }) : super(key: key);

  @override
  State<DeckTwistedCard> createState() => DeckTwistedCardState();
}

class DeckTwistedCardState extends State<DeckTwistedCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: MyTheme.twistedColor,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: MyTheme.getThemeData().primaryColor),
          borderRadius: ApplicationProperties.instance.borderRadius),
      child: const Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: TwistedCardLabel(),
          )),
    );
  }
}
