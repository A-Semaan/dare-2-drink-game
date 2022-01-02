import 'package:daretodrink/data/card-model.dart';
import 'package:daretodrink/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LevelSelector extends StatefulWidget {
  const LevelSelector({Key? key}) : super(key: key);

  @override
  _LevelSelectorState createState() => _LevelSelectorState();
}

class _LevelSelectorState extends State<LevelSelector> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      children: [
        Card(
          child: ListTile(
            style: Theme.of(context).listTileTheme.style,
            title: const Text(
              "Beginner",
              textAlign: TextAlign.center,
            ),
            onTap: () async {
              List<CardModel> cards =
                  await dbManager.getCardsAndGenericsForLevel(Level.beginner);
            },
          ),
        ),
        Card(
          child: ListTile(
            style: Theme.of(context).listTileTheme.style,
            title: const Text("Intermediate", textAlign: TextAlign.center),
            onTap: () async {
              List<CardModel> cards = await dbManager
                  .getCardsAndGenericsForLevel(Level.intermediate);
              print(cards);
            },
          ),
        ),
        Card(
          child: ListTile(
            style: Theme.of(context).listTileTheme.style,
            title: const Text("Horny MFs", textAlign: TextAlign.center),
            onTap: () async {
              List<CardModel> cards =
                  await dbManager.getCardsAndGenericsForLevel(Level.hornyMFs);
            },
          ),
        ),
      ],
    );
  }
}
