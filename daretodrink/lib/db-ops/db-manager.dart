import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBManager {
  //Singleton
  static final DBManager _instance = DBManager._internal();

  DBManager._internal();

  factory DBManager() {
    return _instance;
  }

  //properties

  late Database db;

  init() async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, "dare2drink.db");

      // Only copy if the database doesn't exist
      FileSystemEntityType type = await FileSystemEntity.type(path);
      if (type == FileSystemEntityType.notFound) {
        // Load database from asset and copy
        ByteData data = await rootBundle.load(join('assets', 'dare2drink.db'));
        List<int> bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

        // Save copied asset to documents
        await File(path).writeAsBytes(bytes);
      }
    } catch (ex) {
      print(ex);
    }
  }

  connectToDataBase() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String databasePath = join(appDocDir.path, 'dare2drink.db');
    db = await openDatabase(databasePath);
    await openDatabase("./assets/dare2drink.db");
  }
}
