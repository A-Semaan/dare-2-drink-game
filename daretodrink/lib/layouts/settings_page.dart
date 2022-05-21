import 'package:daretodrink/data/application_settings.dart';
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
        title: const Text("Settings"),
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
              title: Text("Wild Card Chance"),
              subtitle: Slider(
                  min: 10,
                  max: 100,
                  divisions: 9,
                  value: _wildCardChance.toDouble(),
                  onChanged: (newValue) {
                    setState(() {
                      _wildCardChance = newValue.toInt();
                    });
                  }),
            )
          ],
        ),
      ),
    );
  }
}
