import 'package:daretodrink/helpers/shared-preferences-helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplicationSettings {
  //Singleton
  static final ApplicationSettings _instance = ApplicationSettings._internal();

  static ApplicationSettings get instance => ApplicationSettings._instance;

  ApplicationSettings._internal();

  //Properties

  int _wildCardChance = 0;

  bool? _stonedEnabled;

  bool? _twistedEnabledByDefault;

  int get wildCardChance {
    if (_wildCardChance != 0) {
      return _wildCardChance;
    }

    int? chance = SharedPreferencesHelper.instance
        .read<int>(ApplicationSettingsEnum.wildCardChance.asString());

    _wildCardChance = chance ?? 30;

    return _wildCardChance;
  }

  set wildCardChance(int value) {
    SharedPreferencesHelper.instance
        .save(ApplicationSettingsEnum.wildCardChance.asString(), value);
    _wildCardChance = value;
  }

  bool get stonedEnabled {
    if (_stonedEnabled != null) {
      return _stonedEnabled!;
    }

    bool? enabled = SharedPreferencesHelper.instance
        .read<bool>(ApplicationSettingsEnum.stonedEnabled.asString());

    _stonedEnabled = enabled ?? false;

    return _stonedEnabled!;
  }

  set stonedEnabled(bool value) {
    SharedPreferencesHelper.instance
        .save(ApplicationSettingsEnum.stonedEnabled.asString(), value);
    _stonedEnabled = value;
  }

  bool get twistedEnabledByDefault {
    if (_twistedEnabledByDefault != null) {
      return _twistedEnabledByDefault!;
    }

    bool? enabled = SharedPreferencesHelper.instance
        .read<bool>(ApplicationSettingsEnum.twistedEnabledByDefault.asString());

    _twistedEnabledByDefault = enabled ?? false;

    return _twistedEnabledByDefault!;
  }

  set twistedEnabledByDefault(bool value) {
    SharedPreferencesHelper.instance.save(
        ApplicationSettingsEnum.twistedEnabledByDefault.asString(), value);
    _twistedEnabledByDefault = value;
  }

  int get twistedCardChance => 7;

  String get databaseVersion => "1.1";

  String activeDatabaseVersion = "";
}

enum ApplicationSettingsEnum {
  wildCardChance,
  stonedEnabled,
  twistedEnabledByDefault
}

extension ApplicationSettingsEnumExtension on ApplicationSettingsEnum {
  String asString() {
    switch (this) {
      case ApplicationSettingsEnum.wildCardChance:
        return "WildCardChance";
      case ApplicationSettingsEnum.stonedEnabled:
        return "stonedEnabled";
      case ApplicationSettingsEnum.twistedEnabledByDefault:
        return "twistedEnabledByDefault";
      default:
        return "";
    }
  }
}
