import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/background.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        TextButton(
          style: Theme.of(context).textButtonTheme.style,
          onPressed: () {},
          child: const Text(
            "Start",
            style: TextStyle(color: Colors.white),
          ),
        ),
        OutlinedButton(
            style: Theme.of(context).outlinedButtonTheme.style,
            onPressed: () {},
            child: const Text("State The Rules")),
        OutlinedButton(
            style: Theme.of(context).outlinedButtonTheme.style,
            onPressed: () {},
            child: const Text("Settings"))
      ]),
    );
  }
}
