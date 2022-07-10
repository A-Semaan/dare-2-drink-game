import 'package:daretodrink/data/application_settings.dart';
import 'package:daretodrink/fragments/dare-2-drink-footer.dart';
import 'package:daretodrink/helpers/package-info-helper.dart';
import 'package:daretodrink/layouts/personalized-dares.dart';
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
            ListTile(
              minVerticalPadding: 20,
              title: const Text(
                "Wild Card Chance",
                style: MyTheme.listTileTitleTheme,
              ),
              subtitle: Row(
                children: [
                  Expanded(
                    child: Slider(
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
                  Text(
                    _wildCardChance.toString() + "%",
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              ),
            ),
            ListTile(
                minVerticalPadding: 20,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        "Stoned Mode",
                        style: MyTheme.listTileTitleTheme,
                      ),
                    ),
                    Switch(
                        value: ApplicationSettings.instance.stonedEnabled,
                        onChanged: (value) {
                          setState(() {
                            ApplicationSettings.instance.stonedEnabled = value;
                          });
                        })
                  ],
                ),
                subtitle: const Text(
                  "Stoned cards will be integrated in whichever level you select",
                  style: MyTheme.listTileSubtitleTheme,
                )),
            ListTile(
                minVerticalPadding: 20,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        "Twisted Mode Enabled By Default",
                        style: MyTheme.listTileTitleTheme,
                      ),
                    ),
                    Switch(
                        value: ApplicationSettings
                            .instance.twistedEnabledByDefault,
                        onChanged: (value) {
                          setState(() {
                            ApplicationSettings
                                .instance.twistedEnabledByDefault = value;
                          });
                        })
                  ],
                ),
                subtitle: const Text(
                  "Twisted cards will be enabled by default for Hmfs level",
                  style: MyTheme.listTileSubtitleTheme,
                )),
            ListTile(
              minVerticalPadding: 20,
              title: Text(
                "Submit a Dare, and be featured!",
                style: MyTheme.listTileTitleTheme
                    .copyWith(color: Colors.grey[600]),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Coming Soon!",
                  style: MyTheme.listTileSubtitleTheme
                      .copyWith(color: Colors.grey[700]),
                ),
              ),
              onTap: null,
            ),
            const ListTile(
              onTap: null,
              title: Center(
                  child: Dare2DrinkFooter(
                type: FooterType.Dare2Drink_WithVersion,
              )),
            ),
          ],
        ),
      ),
    );
  }
}
