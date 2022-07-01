import 'package:daretodrink/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TwistedCardLabel extends StatelessWidget {
  const TwistedCardLabel({
    Key? key,
  }) : super(key: key);

  static final TextStyle _style =
      MyTheme.getThemeData().textTheme.displayLarge!;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 70.0),
      child: Text("Twisted Card",
          style: GoogleFonts.getFont('Handlee',
              textStyle: _style.copyWith(color: MyTheme.secondaryColor))),
    );
  }
}
