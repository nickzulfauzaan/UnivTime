import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:univtime/Model/Local/ClassTableModel.dart';
import '../Utility/Global.dart';
import 'Response/ClassTablesModel.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = 'simdb.db';
  static const _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
  CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    birthday TEXT,
    academyName TEXT,
    userNo TEXT,
    entranceYear TEXT,
    clsName TEXT,
    userType TEXT,
    token TEXT
  )
''');
    await db.execute('''
  CREATE TABLE grades (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    curriculumAttributes TEXT,
    courseName TEXT,
    courseNature TEXT,
    examinationNature TEXT,
    kcbh TEXT,
    credit REAL,
    cj0708id TEXT,
    fraction TEXT
  )
''');
    await db.execute('''
  CREATE TABLE courses (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date TEXT,
    classWeek TEXT,
    teacherName TEXT,
    weekNoteDetail TEXT,
    buttonCode TEXT,
    xkrs INTEGER,
    ktmc TEXT,
    classTime TEXT,
    classroomNub TEXT,
    jx0408id TEXT,
    buildingName TEXT,
    courseName TEXT,
    isRepeatCode TEXT,
    jx0404id TEXT,
    weekDay TEXT,
    classroomName TEXT,
    startTime TEXT,
    endTIme TEXT,
    location TEXT,
    fzmc TEXT,
    classWeekDetails TEXT,
    coursesNote INTEGER
  )
''');
    await db.execute('''
  CREATE TABLE socialgrades (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date TEXT,
    courseName TEXT,
    socialExaminationGradeName TEXT,
    skcjid TEXT,
    writtenTestScore TEXT,
    admissionTicketNumber TEXT,
    practiceScore TEXT,
    overallResult TEXT
  )
''');
    await db.execute('''
  CREATE TABLE exams (
    id INTEGER PRIMARY KEY AUTOINCREMENT ,
    courseName TEXT,
    examinationPlace TEXT,
    time TEXT
  )
''');
  }

  void insertClassTable(ClassTablesModel data, int week) async {
    Database db = await instance.database;
    if (data.data == null || data.data!.first.courses == null) {
      return;
    }

    for (var element in data.data!.first.courses!) {
      final weekday = int.parse(element.weekDay ?? "1");
      final date =
          Global.termStart.add(Duration(days: (week - 1) * 7 + weekday - 1));
      Map<String, dynamic> row = {
        'date': DateFormat('yyyy-MM-dd').format(date),
        'classWeek': element.classWeek,
        'teacherName': element.teacherName,
        'weekNoteDetail': element.weekNoteDetail,
        'buttonCode': element.buttonCode,
        'xkrs': element.xkrs,
        'ktmc': element.ktmc,
        'classTime': element.classTime,
        'classroomNub': element.classroomNub,
        'jx0408id': element.jx0408id,
        'buildingName': element.buildingName,
        'courseName': element.courseName,
        'isRepeatCode': element.isRepeatCode,
        'jx0404id': element.jx0404id,
        'weekDay': element.weekDay,
        'classroomName': element.classroomName,
        'startTime': element.startTime,
        'endTime': element.endTIme,
        'location': element.location,
        'fzmc': element.fzmc,
        'classWeekDetails': element.classWeekDetails,
        'coursesNote': element.coursesNote
      };
      await db.insert('courses', row);
    }
  }

  void clearClassTable() async {
    Database db = await instance.database;
    await db.delete('courses');
  }

  Future<List<ClassTableModel>> getClassTable() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('courses');
    return List.generate(maps.length, (i) {
      return ClassTableModel.fromJson(maps[i]);
    });
  }
}
