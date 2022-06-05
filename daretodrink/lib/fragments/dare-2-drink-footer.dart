import 'package:daretodrink/helpers/package-info-helper.dart';
import 'package:daretodrink/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Dare2DrinkFooter extends StatelessWidget {
  final bool isDefault;
  final bool withVersion;
  const Dare2DrinkFooter(
      {Key? key, this.isDefault = false, this.withVersion = false})
      : super(key: key);

  static final TextStyle _style =
      MyTheme.getThemeData().textTheme.displaySmall!;

  @override
  Widget build(BuildContext context) {
    List<TextSpan> spans = [
      TextSpan(
          text: "Dare 2 Drink",
          style: GoogleFonts.getFont('Handlee',
              textStyle: _style.copyWith(
                  color: isDefault
                      ? MyTheme.secondaryColor
                      : MyTheme.getThemeData().primaryColor)))
    ];

    if (withVersion) {
      spans.add(TextSpan(
          text: "  v " + PackageInfoHelper.instance.version,
          style: GoogleFonts.getFont('Handlee',
              textStyle: _style.copyWith(color: MyTheme.secondaryColor))));
    }

    return Padding(
      padding: const EdgeInsets.only(top: 70.0),
      child: RichText(text: TextSpan(children: spans)),
    );
  }
}
