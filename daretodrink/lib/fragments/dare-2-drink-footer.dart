import 'package:daretodrink/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class Dare2DrinkFooter extends StatelessWidget {
  const Dare2DrinkFooter({Key? key}) : super(key: key);

  static final TextStyle _style =
      MyTheme.getThemeData().textTheme.displaySmall!;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 70.0),
      child: Text(
        "Dare 2 Drink",
        style: GoogleFonts.getFont('Handlee', textStyle: _style),
      ),
    );
  }
}
