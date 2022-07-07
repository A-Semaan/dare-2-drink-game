import 'package:daretodrink/data/application_settings.dart';
import 'package:daretodrink/helpers/package-info-helper.dart';
import 'package:daretodrink/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum FooterType {
  Dare2Drink_Default,
  Dare2Drink_Gold,
  Dare2Drink_WithVersion,
  Twisted,
}

class Dare2DrinkFooter extends StatelessWidget {
  final FooterType type;
  const Dare2DrinkFooter({Key? key, this.type = FooterType.Dare2Drink_Default})
      : super(key: key);

  static final TextStyle _style =
      MyTheme.getThemeData().textTheme.displaySmall!;

  @override
  Widget build(BuildContext context) {
    List<TextSpan> spans = [];

    if (type == FooterType.Twisted) {
      spans.add(TextSpan(
          text: "Twisted",
          style: GoogleFonts.getFont('Handlee',
              textStyle: _style.copyWith(
                  color: MyTheme.secondaryColor))));
    } else {
      bool isGold = type == FooterType.Dare2Drink_Gold;
      spans.add(TextSpan(
          text: "Dare 2 Drink",
          style: GoogleFonts.getFont('Handlee',
              textStyle: _style.copyWith(
                  color: isGold
                      ? MyTheme.secondaryColor
                      : MyTheme.getThemeData().primaryColor))));

      if (type == FooterType.Dare2Drink_WithVersion) {
        spans.add(TextSpan(
            text: "  v " + PackageInfoHelper.instance.version + ", DB v "+ApplicationSettings.instance.activeDatabaseVersion,
            style: GoogleFonts.getFont('Handlee',
                textStyle: _style.copyWith(color: MyTheme.secondaryColor))));
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 70.0),
      child: RichText(text: TextSpan(children: spans)),
    );
  }
}
