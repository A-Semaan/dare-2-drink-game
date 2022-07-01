import 'dart:io';

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

  late Database db;

  Future init() async {
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
        File file = File(path);
        await file.writeAsBytes(bytes);
      }
    } catch (ex) {
      print(ex);
    }
  }

  Future connectToDataBase() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String databasePath = join(appDocDir.path, 'dare2drink.db');
    db = await openDatabase(databasePath);
    await openDatabase("./assets/dare2drink.db");
  }

  Future<int> insertCardIntoSideDares(DareCardModel card) async {
    return await db.insert("side_dares", card.toMap());
  }

  Future<int> updateSideDare(DareCardModel card) async {
    return await db.update("side_dares", card.toMap(),
        where: "_id = ?", whereArgs: [card.id]);
  }

  Future<int> deleteSideDare(DareCardModel card) async {
    return await db
        .delete("side_dares", where: "_id = ?", whereArgs: [card.id]);
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
    List<Map<String, Object?>> result = await db.query(table);
    cards.addAll(result.map((e) => DareCardModel(
        getString(e["text"])!, getEnum<CardType>(e["type"])!,
        id: getInt(e["_id"]),
        amount: getInt(e["amount"]),
        subText: getString(e["subtext"]),
        level: level)));

    //get cards from side dares
    List<Map<String, Object?>> result2 = await db
        .query("side_dares", where: "level = ?", whereArgs: [level.toInt()]);
    cards.addAll(result2.map((e) => DareCardModel(
        getString(e["text"])!, getEnum<CardType>(e["type"])!,
        id: getInt(e["_id"]),
        amount: getInt(e["amount"]),
        subText: getString(e["subtext"]),
        level: level)));

    return cards;
  }

  Future<List<DareCardModel>> getAllSideDaresAndGenerics() async {
    List<DareCardModel> cards = [];

    //get cards from side dares
    List<Map<String, Object?>> result2 = await db.query(
      "side_dares",
    );
    cards.addAll(result2.map((e) => DareCardModel(
        getString(e["text"])!, getEnum<CardType>(e["type"])!,
        id: getInt(e["_id"]),
        amount: getInt(e["amount"]),
        subText: getString(e["subtext"]),
        level: getEnum<Level>(e["level"]))));

    return cards;
  }

  Future<List<TwistedCardModel>> getTwistedDares() async {
    List<TwistedCardModel> cards = [];

    //get cards from side dares
    List<Map<String, Object?>> result2 = await db.query(
      "twisted",
    );
    cards.addAll(result2.map((e) => TwistedCardModel(
        getString(e["text"])!,
        getBool(e["repeatable"])!,
        id: getInt(e["_id"]),)));

    return cards;
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
