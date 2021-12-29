import 'package:flutter/cupertino.dart';

class ApplicationProperties {
  //Singleton
  ApplicationProperties._internal();

  static final ApplicationProperties _instance =
      ApplicationProperties._internal();

  factory ApplicationProperties() {
    return _instance;
  }

  //properties
  final BorderRadius borderRadius = BorderRadius.circular(10);
}
