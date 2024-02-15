import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../widgets/header.dart';

class ManageTimetable extends StatefulWidget {
  const ManageTimetable({Key? key}) : super(key: key);

  @override
  State<ManageTimetable> createState() => _ManageTimetableState();
}

class _ManageTimetableState extends State<ManageTimetable> {
  Map<String, dynamic> timetableData = {};
  List<String> categories = [];

  String? selectedCategory;
  String? selectedYear;
  String? selectedSemester;

  List<String> years = [];
  List<String> semesters = [];
  List<String> selectedCourses = [];

  @override
  void initState() {
    super.initState();
    loadTimetableData();
  }

  Future<void> loadTimetableData() async {
    try {
      final String response =
          await rootBundle.loadString('assets/courseplanning.json');
      final Map<String, dynamic> data = json.decode(response);

      setState(() {
        timetableData = data;
        categories = data.keys.toList();
      });
    } catch (e) {
      print("Error loading JSON: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF12171D),
        title: Header(),
        automaticallyImplyLeading: false,
      ),
      body: timetableData.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : buildCalendar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show the dialog when the "Add" button is pressed
          showAddDialog(context);
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 50.0,
        ),
      ),
    );
  }

  Widget buildCalendar() {
    return SfCalendar(
      view: CalendarView.week,
      dataSource: _getCalendarDataSource(),
    );
  }

  Future<void> showAddDialog(BuildContext context) async {
    selectedCategory = null;
    selectedYear = null;
    selectedSemester = null;
    selectedCourses = [];

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: Text('Add Data'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButton<String>(
                      hint: Text('Select Category'),
                      value: selectedCategory,
                      items: categories
                          .map((category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                          years = timetableData[value!].keys.toList();
                          selectedYear = null;
                          semesters = [];
                          selectedSemester = null;
                          selectedCourses = [];
                        });
                      },
                    ),
                    if (selectedCategory != null)
                      DropdownButton<String>(
                        hint: Text('Select Year'),
                        value: selectedYear,
                        items: years
                            .map((year) => DropdownMenuItem(
                                  value: year,
                                  child: Text(year),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedYear = value;
                            semesters = timetableData[selectedCategory!][value!]
                                .keys
                                .toList();
                            selectedSemester = null;
                            selectedCourses = [];
                          });
                        },
                      ),
                    if (selectedYear != null)
                      DropdownButton<String>(
                        hint: Text('Select Semester'),
                        value: selectedSemester,
                        items: semesters
                            .map((semester) => DropdownMenuItem(
                                  value: semester,
                                  child: Text(semester),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedSemester = value;
                            selectedCourses = timetableData[selectedCategory!]
                                    [selectedYear!][value!]
                                .keys
                                .toList();
                          });
                        },
                      ),
                    if (selectedSemester != null)
                      Column(
                        children: [
                          Text('Selected Courses:'),
                          for (var courseCode in selectedCourses)
                            ListTile(
                              title: Text(courseCode),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Title: ${timetableData[selectedCategory!][selectedYear!][selectedSemester!][courseCode]["COURSE_TITLE"]}',
                                  ),
                                  Text(
                                    'Credits: ${timetableData[selectedCategory!][selectedYear!][selectedSemester!][courseCode]["CREDITS"]}',
                                  ),
                                  Text(
                                    'Occurrence: ${timetableData[selectedCategory!][selectedYear!][selectedSemester!][courseCode]["Occurrence"]}',
                                  ),
                                ],
                              ),
                            ),
                          ElevatedButton(
                            onPressed: () {
                              // Implement your add to timetable logic here
                              addToTimetable(selectedCourses);
                              Navigator.of(context).pop();
                            },
                            child: Text('Add to Timetable'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void addToTimetable(List<String> courses) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Save the selected courses to SharedPreferences
      prefs.setStringList('selectedCourses', courses);

      // Update the state with the new courses
      setState(() {
        selectedCourses = List.from(courses);
      });

      print('Adding courses to timetable: $selectedCourses');
    } catch (e) {
      print('Error saving data to SharedPreferences: $e');
    }
  }

  _DataSource _getCalendarDataSource() {
    List<Appointment> appointments = [];

    if (selectedCourses.isNotEmpty) {
      for (var courseCode in selectedCourses) {
        var courseDetails = timetableData[selectedCategory!][selectedYear!]
            [selectedSemester!][courseCode];
        List<dynamic> classSessions = courseDetails["class_sessions"] ?? [];

        for (var session in classSessions) {
          String day = session["day"];
          int startHour = int.parse(session["start_time"].split(":")[0]);
          int startMinute = int.parse(session["start_time"].split(":")[1]);
          int endHour = int.parse(session["end_time"].split(":")[0]);
          int endMinute = int.parse(session["end_time"].split(":")[1]);

          // Calculate DateTime for the next occurrence of the specified day
          DateTime nextOccurrence = DateTime.now();
          while (nextOccurrence.weekday != _getDayOfWeek(day)) {
            nextOccurrence = nextOccurrence.add(Duration(days: 1));
          }

          // Create DateTime objects for start and end times
          DateTime startTime = DateTime(nextOccurrence.year,
              nextOccurrence.month, nextOccurrence.day, startHour, startMinute);
          DateTime endTime = DateTime(nextOccurrence.year, nextOccurrence.month,
              nextOccurrence.day, endHour, endMinute);

          // Create appointment for each class session
          appointments.add(Appointment(
            startTime: startTime,
            endTime: endTime,
            subject: '$courseCode - ${courseDetails["COURSE_TITLE"]}',
            notes: 'Credits: ${courseDetails["CREDITS"]}',
          ));
        }
      }
    }

    return _DataSource(appointments);
  }

  DateTime _getDateTimeFromSession(
    String day,
    int hour,
    int minute,
  ) {
    DateTime now = DateTime.now();
    int currentWeekday = now.weekday;
    int daysUntilTarget = _getDayOfWeek(day) - currentWeekday;

    // If the target day has already passed this week, add 7 days
    if (daysUntilTarget <= 0) {
      daysUntilTarget += 7;
    }

    DateTime dateTime = DateTime.now().add(
      Duration(days: daysUntilTarget),
    );

    dateTime = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      hour,
      minute,
    );

    return dateTime;
  }

  int _getDayOfWeek(String day) {
    switch (day.toLowerCase()) {
      case "sunday":
        return 0;
      case "monday":
        return 1;
      case "tuesday":
        return 2;
      case "wednesday":
        return 3;
      case "thursday":
        return 4;
      case "friday":
        return 5;
      case "saturday":
        return 6;
      default:
        return 0; // Default to Sunday if day is not recognized
    }
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}

class _DynamicCalendarDataSource extends CalendarDataSource {
  _DynamicCalendarDataSource(List<Appointment> source) {
    appointments = source;
  }

  // Override updateAppointments to handle dynamic updates
  void updateAppointments(List<dynamic> newAppointments) {
    // ignore: unnecessary_null_comparison
    if (newAppointments != null) {
      // Add a null check before invoking clear
      appointments?.clear();
      appointments?.addAll(newAppointments);
      notifyListeners(CalendarDataSourceAction.reset, newAppointments);
    }
  }
}
