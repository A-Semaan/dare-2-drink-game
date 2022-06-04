import 'package:daretodrink/data/application-properties.dart';
import 'package:daretodrink/data/card-model.dart';
import 'package:daretodrink/fragments/dare-2-drink-footer.dart';
import 'package:daretodrink/fragments/wild-card-label.dart';
import 'package:daretodrink/globals.dart';
import 'package:daretodrink/theme/theme.dart';
import 'package:flutter/material.dart';

class DeckWildCard extends StatefulWidget {
  const DeckWildCard({
    Key? key,
  }) : super(key: key);

  @override
  State<DeckWildCard> createState() => DeckWildCardState();
}

class DeckWildCardState extends State<DeckWildCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: MyTheme.secondaryColor,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: MyTheme.getThemeData().primaryColor),
          borderRadius: ApplicationProperties.instance.borderRadius),
      child: const Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: WildCardLabel(),
          )),
    );
  }
}
