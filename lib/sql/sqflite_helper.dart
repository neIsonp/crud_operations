import 'dart:ffi';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite_study/models/event_model.dart';

class SqlHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute(""" CREATE TABLE events(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT,
      description TEXT,
      image TEXT,
      date TEXT
    )
""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'events.db',
      version: 1,
      onCreate: (db, version) async {
        await createTables(db);
      },
    );
  }

  static Future<int> createEvent(
      String title, String description, String image, String date) async {
    final db = await SqlHelper.db();

    final data = {
      'title': title,
      'description': description,
      'image': image,
      'date': date,
    };

    final id = await db.insert(
      'events',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );

    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SqlHelper.db();

    return db.query('events', orderBy: "id");
  }

  static Future<EventModel> getItem(int id) async {
    final db = await SqlHelper.db();

    final maps = await db.query('events', where: "id = ?", whereArgs: [id]);

    return EventModel.fromJson(maps[0]);
  }

  static Future<int> updateEvent(
    int id,
    String title,
    String description,
    String image,
    String date,
  ) async {
    final db = await SqlHelper.db();

    final data = {
      'title': title,
      'description': description,
      'image': image,
      'date': date,
    };

    final result =
        await db.update('events', data, where: "id = ?", whereArgs: [id]);

    return result;
  }

  static Future<void> deleteEvent(int id) async {
    final db = await SqlHelper.db();

    try {
      await db.delete('events', where: "id = ?", whereArgs: [id]);
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}
