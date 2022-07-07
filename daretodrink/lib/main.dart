import 'package:daretodrink/db-ops/db-manager.dart';
import 'package:daretodrink/globals.dart';
import 'package:daretodrink/helpers/package-info-helper.dart';
import 'package:daretodrink/helpers/shared-preferences-helper.dart';
import 'package:daretodrink/layouts/main-page.dart';
import 'package:daretodrink/theme/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays:  []);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: MyTheme.getThemeData(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    initResources();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _initAndConnect(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else if (!snapshot.hasData &&
                snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return const MainPage();
            } else {
              return const Center(
                child: Text("Something went wrong"),
              );
            }
          }),
    );
  }

  Future _initAndConnect() async {
    try {
      await DBManager.instance.init();
      return true;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  initResources() {
    SharedPreferencesHelper.instance.init();
    PackageInfoHelper.init();
  }
}
