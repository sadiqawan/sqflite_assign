import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_assign/models/student_model.dart';
import 'package:sqflite_assign/util/const_file.dart';

class DatabaseHelper {
  // database
  DatabaseHelper._privateConstructor(); // Name constructor to create instance of database
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  // getter for database

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS
    // to store database

    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}/student.db';

    // open/ create database at a given path
    var studentsDatabase = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );

    return studentsDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''Create TABLE $tableStudent (
                  $colId INTEGER PRIMARY KEY AUTOINCREMENT,
                  $colName TEXT,
                  $colEmail TEXT UNIQUE,
                  $colMobile TEXT,
                  $colCourse TEXT,
                  $colUni TEXT
                   );

    ''');
  }
  // insert
  Future<int> saveStudent(Student student) async {
    // add student to table

    Database db = await instance.database;

    // String insertQuery = '''
    // INSERT INTO $tableStudent
    //   ( $colName, $colEmail, $colMobile, $colCourse, $colUni )
    //   VALUES ( ?, ?, ?, ?, ? )
    // ''';

    //int result = await db.rawInsert(insertQuery, [student.name, student.email, student.mobile, student.course, student.uni ]);

    int result = await db.insert(tableStudent, student.toMap());

    return result;
  }

}
