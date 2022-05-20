import 'package:daretodrink/helpers/shared_preferences_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplicationSettings {
  //Singleton
  static final ApplicationSettings _instance = ApplicationSettings._internal();

  static ApplicationSettings get instance => ApplicationSettings._instance;

  ApplicationSettings._internal();

  //Properties

  int _wildCardChance = 0;

  int get wildCardChance {
    if (_wildCardChance != 0) {
      return _wildCardChance;
    }

    int? chance = SharedPreferencesHelper.instance
        .read(ApplicationSettingsEnum.wildCardChance.asString());

    _wildCardChance = chance ?? 40;

    return _wildCardChance;
  }

  set wildCardChance(int value) {
    SharedPreferencesHelper.instance
        .save(ApplicationSettingsEnum.wildCardChance.asString(), value);
  }
}

enum ApplicationSettingsEnum { wildCardChance }

extension ApplicationSettingsEnumExtension on ApplicationSettingsEnum {
  String asString() {
    switch (this) {
      case ApplicationSettingsEnum.wildCardChance:
        return "WildCardChance";
      default:
        return "";
    }
  }
}
