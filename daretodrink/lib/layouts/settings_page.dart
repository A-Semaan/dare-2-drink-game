import 'package:daretodrink/data/application_settings.dart';
import 'package:daretodrink/fragments/dare-2-drink-footer.dart';
import 'package:daretodrink/helpers/package_info_helper.dart';
import 'package:daretodrink/layouts/personalized_dares.dart';
import 'package:daretodrink/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool get isSaveVisible {
    return ApplicationSettings.instance.wildCardChance != _wildCardChance;
  }

  late int _wildCardChance;

  @override
  void initState() {
    _wildCardChance = ApplicationSettings.instance.wildCardChance;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          "Settings",
          style: TextStyle(color: MyTheme.secondaryColor),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
          visible: isSaveVisible,
          child: FloatingActionButton.extended(
            label: const Text("Save"),
            icon: const Icon(Icons.save),
            onPressed: () {
              setState(() {
                ApplicationSettings.instance.wildCardChance = _wildCardChance;
              });
            },
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              minVerticalPadding: 20,
              title: const Text(
                "Wild Card Chance",
                style: MyTheme.listTileTitleTheme,
              ),
              subtitle: Slider(
                  label: _wildCardChance.toString(),
                  min: 10,
                  max: 100,
                  divisions: 9,
                  value: _wildCardChance.toDouble(),
                  onChanged: (newValue) {
                    setState(() {
                      _wildCardChance = newValue.toInt();
                    });
                  }),
            ),
            ListTile(
              minVerticalPadding: 20,
              title: const Text(
                "Personalized Dares",
                style: MyTheme.listTileTitleTheme,
              ),
              subtitle: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Add your own dares!",
                  style: MyTheme.listTileSubtitleTheme,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const PersonalizedDares()));
              },
            ),
            const ListTile(
              onTap: null,
              title: Center(child: Dare2DrinkFooter(withVersion: true)),
            ),
          ],
        ),
      ),
    );
  }
}
