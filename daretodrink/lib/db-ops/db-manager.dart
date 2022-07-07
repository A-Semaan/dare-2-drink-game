import 'dart:convert';
import 'dart:io';

import 'package:daretodrink/data/application_settings.dart';
import 'package:daretodrink/data/card-model.dart';
import 'package:daretodrink/data/dare-card-model.dart';
import 'package:daretodrink/data/twisted-card-model.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBManager {
  //Singleton
  DBManager._internal();

  static final DBManager _instance = DBManager._internal();

  static DBManager get instance => DBManager._instance;

  //properties

  Future init() async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, "dare2drink.db");

      // Only copy if the database doesn't exist
      FileSystemEntityType type = await FileSystemEntity.type(path);
      if (type == FileSystemEntityType.notFound) {
        await _executeCopyDb(path);
        ApplicationSettings.instance.activeDatabaseVersion = await getDatabaseVersion();
      }
      else{
        String dbVersion = await getDatabaseVersion();
        String internalDbVersion = ApplicationSettings.instance.databaseVersion;
        if(double.parse(dbVersion)<double.parse(internalDbVersion)){
          await _executeCopyDb(path);
        }
        ApplicationSettings.instance.activeDatabaseVersion = await getDatabaseVersion();
      }
    } catch (ex) {
      print(ex);
    }
  }

  _executeCopyDb(String path)async{
    // Load database from asset and copy
        ByteData data = await rootBundle.load(join('assets', 'dare2drink.db'));
        List<int> bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

        // Save copied asset to documents
        File file = File(path);
        await file.writeAsBytes(bytes);
  }

  Future<Database?> _connectToDataBase() async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String databasePath = join(appDocDir.path, 'dare2drink.db');
      return await openDatabase(databasePath);
    } catch (ex) {
      return null;
    }
  }

  Future<int?> insertCardIntoSideDares(DareCardModel card) async {
    return await _executeDbOperation<int>(
        <int>(Database? db) => {db!.insert("side_dares", card.toMap())});
  }

  Future<int?> updateSideDare(DareCardModel card) async {
    return await _executeDbOperation<int>(<int>(db) => {
          db.update("side_dares", card.toMap(),
              where: "_id = ?", whereArgs: [card.id])
        });
  }

  Future<int?> deleteSideDare(DareCardModel card) async {
    return await _executeDbOperation<int>(<int>(db) => {
          db.delete("side_dares", where: "_id = ?", whereArgs: [card.id])
        });
  }

  Future<List<DareCardModel>> getCardsAndGenericsForLevel(Level level) async {
    List<DareCardModel> cards = [];
    String table = "";
    switch (level) {
      case Level.beginner:
        table = "beginner";
        break;
      case Level.intermediate:
        table = "intermediate";
        break;
      case Level.hornyMFs:
        table = "Hmf";
        break;
    }

    //get cards from table
    List<Map<String, Object?>>? result =
        await _executeDbOperation<List<Map<String, Object?>>>(
            <List>(db) => {db.query(table)});
    if (result != null) {
      cards.addAll(result.map((e) => DareCardModel(
          getString(e["text"])!, getEnum<CardType>(e["type"])!,
          id: getInt(e["_id"]),
          amount: getInt(e["amount"]),
          subText: getString(e["subtext"]),
          level: level)));
    }

    //get cards from side dares
    List<Map<String, Object?>>? result2 =
        await _executeDbOperation<List<Map<String, Object?>>>(<List>(db) => {
              db.query("side_dares",
                  where: "level = ?", whereArgs: [level.toInt()])
            });
    if (result2 != null) {
      cards.addAll(result2.map((e) => DareCardModel(
          getString(e["text"])!, getEnum<CardType>(e["type"])!,
          id: getInt(e["_id"]),
          amount: getInt(e["amount"]),
          subText: getString(e["subtext"]),
          level: level)));
    }

    return cards;
  }

  Future<List<DareCardModel>> getAllSideDaresAndGenerics() async {
    List<DareCardModel> cards = [];

    //get cards from side dares
    List<Map<String, Object?>>? result2 =
        await _executeDbOperation<List<Map<String, Object?>>>(<List>(db) => {
              db.query(
                "side_dares",
              )
            });
    if (result2 != null) {
      cards.addAll(result2.map((e) => DareCardModel(
          getString(e["text"])!, getEnum<CardType>(e["type"])!,
          id: getInt(e["_id"]),
          amount: getInt(e["amount"]),
          subText: getString(e["subtext"]),
          level: getEnum<Level>(e["level"]))));
    }

    return cards;
  }

  Future<List<TwistedCardModel>> getTwistedDares() async {
    List<TwistedCardModel> cards = [];

    //get cards from side dares
    List<Map<String, Object?>>? result2 =
        await _executeDbOperation<List<Map<String, Object?>>>(<List>(db) => {
              db.query(
                "twisted",
              )
            });
    if (result2 != null) {
      cards.addAll(result2.map((e) => TwistedCardModel(
            getString(e["text"])!,
            getBool(e["repeatable"])!,
            id: getInt(e["_id"]),
          )));
    }

    return cards;
  }

  Future<String> getDatabaseVersion() async {
    try {
      List<Map<String, Object?>>? result =
          await _executeDbOperation<List<Map<String, Object?>>>(
              <List>(db) => {db.query("database_version", columns:["version"])});
      if (result == null || result.isEmpty) {
        return "1.0";
      } else {
        return result[0]["version"]!.toString();
      }
    } catch (ex) {
      return "1.0";
    }
  }

  Future<T?> _executeDbOperation<T>(Function<T>(Database) function) async {
    Database? db = await _connectToDataBase();
    try {
      if (db!.isOpen) {
        return function(db).toList()[0];
      }
      throw Exception("Database is not opened");
    } catch (ex) {
      return null;
    } finally {
      if (db!.isOpen) {
        db.close();
      }
    }
  }

  int? getInt(Object? object) {
    if (object == null) {
      return null;
    }
    return int.parse(getString(object)!);
  }

  String? getString(Object? object) {
    if (object == null) {
      return null;
    }
    return object.toString();
  }

  bool? getBool(Object? object) {
    if (object == null) {
      return null;
    }
    return getString(object)!.toLowerCase() == "true";
  }

  T? getEnum<T>(object) {
    if (T == CardType) {
      return CardTypeExtension.fromString(getString(object)!) as T;
    } else if (T == Level) {
      return LevelExtension.fromInt(getInt(object)!) as T;
    } else {
      return null;
    }
  }
}
