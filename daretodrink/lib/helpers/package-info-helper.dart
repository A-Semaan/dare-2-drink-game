import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoHelper extends PackageInfo {
  static late PackageInfo _packageInfo;
  static PackageInfo get instance => _packageInfo;

  PackageInfoHelper(
      {required String appName,
      required String packageName,
      required String version,
      required String buildNumber})
      : super(
            appName: appName,
            packageName: packageName,
            version: version,
            buildNumber: buildNumber);

  static init() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  /// The app name. `CFBundleDisplayName` on iOS, `application/label` on Android.
  String get appName => _packageInfo.appName;

  /// The package name. `bundleIdentifier` on iOS, `getPackageName` on Android.
  String get packageName => _packageInfo.packageName;

  /// The package version. `CFBundleShortVersionString` on iOS, `versionName` on Android.
  String get version => _packageInfo.version;

  /// The build number. `CFBundleVersion` on iOS, `versionCode` on Android.
  String get buildNumber => _packageInfo.buildNumber;

  /// The build signature. Empty string on iOS, signing key signature (hex) on Android.
  String get buildSignature => _packageInfo.buildSignature;
}
