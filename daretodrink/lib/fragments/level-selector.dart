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
            onTap: () {},
          ),
        ),
        Card(
          child: ListTile(
            style: Theme.of(context).listTileTheme.style,
            title: const Text("Intermediate", textAlign: TextAlign.center),
            onTap: () {},
          ),
        ),
        Card(
          child: ListTile(
            style: Theme.of(context).listTileTheme.style,
            title: const Text("Horny MFs", textAlign: TextAlign.center),
            onTap: () {},
          ),
        ),
      ],
    );
  }
}
