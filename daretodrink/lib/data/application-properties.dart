import 'package:flutter/cupertino.dart';

class ApplicationProperties {
  //Singleton
  ApplicationProperties._internal();

  static final ApplicationProperties _instance =
      ApplicationProperties._internal();

  static ApplicationProperties get instance => ApplicationProperties._instance;

  //properties
  final BorderRadius borderRadius = BorderRadius.circular(10);
}
