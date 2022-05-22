import 'package:daretodrink/data/card-model.dart';
import 'package:daretodrink/db-ops/db-manager.dart';
import 'package:daretodrink/globals.dart';
import 'package:daretodrink/layouts/card-deck-page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LevelSelector extends StatefulWidget {
  const LevelSelector({Key? key}) : super(key: key);

  @override
  _LevelSelectorState createState() => _LevelSelectorState();
}

class _LevelSelectorState extends State<LevelSelector> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Beginner",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
              onPressed: () async {
                _getCardsAndRedirect(Level.beginner);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: OutlinedButton(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Intermediate",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
              onPressed: () async {
                _getCardsAndRedirect(Level.intermediate);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: OutlinedButton(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Horny MFs",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
              onPressed: () async {
                _getCardsAndRedirect(Level.hornyMFs);
              },
            ),
          ),
        ],
      ),
    );
  }

  _getCardsAndRedirect(Level level) async {
    List<CardModel> cards =
        await DBManager.instance.getCardsAndGenericsForLevel(level);
    if (cards.isEmpty) {
      Fluttertoast.showToast(msg: "This mode does not have any dares");
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return CardDeckPage(cards);
    }));
  }
}
