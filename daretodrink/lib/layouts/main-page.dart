import 'package:daretodrink/data/application-properties.dart';
import 'package:daretodrink/fragments/level-selector.dart';
import 'package:daretodrink/globals.dart';
import 'package:daretodrink/layouts/settings-page.dart';
import 'package:daretodrink/theme/theme.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/background.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: size.height * 0.1),
        child: Stack(children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Transform.rotate(
                  angle: -math.pi / 8,
                  child: SizedBox(
                    width: 120,
                    height: 50,
                    child: TextButton(
                      style: Theme.of(context).textButtonTheme.style,
                      onPressed: () async {
                        await showDialog(
                            context: context,
                            builder: (context) {
                              AlertDialog dialog = AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: ApplicationProperties
                                        .instance.borderRadius),
                                content: const LevelSelector(),
                                title: Text(
                                  "Select Level",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                              );
                              return dialog;
                            });
                      },
                      child: Text(
                        "Start",
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 110.0, left: 30.0),
                child: SizedBox(
                  width: 200,
                  height: 50,
                  child: Transform.rotate(
                    angle: -math.pi / 8,
                    child: OutlinedButton(
                        style: Theme.of(context)
                            .outlinedButtonTheme
                            .style!
                            .copyWith(
                                foregroundColor:
                                    MaterialStateProperty.resolveWith(
                                        (states) => Colors.black),
                                side: MaterialStateProperty.resolveWith(
                                  (states) => const BorderSide(
                                    color: Colors.black,
                                  ),
                                )),
                        onPressed: () {
                          _showRulesDialog();
                        },
                        child: const Text("State The Rules")),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50.0, right: 30.0),
                child: SizedBox(
                  width: 200,
                  height: 50,
                  child: Transform.rotate(
                    angle: -math.pi / 8,
                    child: OutlinedButton(
                        style: Theme.of(context)
                            .outlinedButtonTheme
                            .style!
                            .copyWith(
                                foregroundColor:
                                    MaterialStateProperty.resolveWith(
                                        (states) => MyTheme.secondaryColor),
                                side: MaterialStateProperty.resolveWith(
                                  (states) => const BorderSide(
                                    color: MyTheme.secondaryColor,
                                  ),
                                )),
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: ((context) {
                            return SettingsPage();
                          })));
                        },
                        child: const Text("Settings")),
                  ),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }

  _showRulesDialog() {
    Size _size = MediaQuery.of(context).size;
    showDialog(
        context: context,
        builder: (context) {
          AlertDialog dialog = AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: ApplicationProperties.instance.borderRadius),
              title: const Text("The Rules"),
              content: SizedBox(
                height: _size.height * 0.5,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: RichText(
                    text: const TextSpan(children: [
                      TextSpan(
                          text: "Description:\n\n",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: "This is a simple Drink or Dare game, you receive a dare, you can choose to do the dare " +
                              "or drink the equivalent amount of shots for that dare.\n" +
                              "Swipe right if you choose to do the dare and swipe left otherwise.\n" +
                              "At a random swipe, a popup (Wild Card) will show asking you to do what it says.\n\n"),
                      TextSpan(
                          text: "The Rules are as follow:\n\n",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: "- The developper is not responsible for any loss of virginities, drunk drivers, angry girlfriends," +
                              "nuclear war, or breakups.\n" +
                              "- Any dare can be done in a private room ;)\n" +
                              "- Any ties in any condition can be settled with a coin flip. " +
                              "(I.E. closest player with opposite sex are the same on your sides)\n" +
                              "- Any given time in a dare can be extended to as long as the dare receivers want. However, " +
                              "a given time cannot be shrunk.\n" +
                              "- If you fail to end the dare at a time less than the one given YOU MUST RESTART.\n" +
                              "- If there are any couples in this game, you both agree to do the dares that you get otherwise, fuck you, " +
                              "you don't have to play\n" +
                              "- Ofc, play responsibly and drink responsibly... and all the shit your parents would tell ya *rolls eyes*")
                    ]),
                  ),
                ),
              ));

          return dialog;
        });
  }
}
