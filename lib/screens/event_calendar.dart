import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventCalendar extends StatefulWidget {
  const EventCalendar({super.key});

  @override
  State<EventCalendar> createState() => _EventCalendarState();
}

class _AddAppointmentDialog extends StatefulWidget {
  final Function(String, DateTime, TimeOfDay, TimeOfDay, Color) onSave;

  const _AddAppointmentDialog({required this.onSave});

  @override
  _AddAppointmentDialogState createState() => _AddAppointmentDialogState();
}

class _AddAppointmentDialogState extends State<_AddAppointmentDialog> {
  String appointmentName = '';
  DateTime? selectedDate = DateTime.now();
  TimeOfDay? selectedStartTime = TimeOfDay.now();
  TimeOfDay? selectedEndTime = TimeOfDay.now();
  Color selectedColor = Colors.green; // Default color

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Class'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Details'),
              onChanged: (value) {
                setState(() {
                  appointmentName = value;
                });
              },
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text('Select Date'),
              subtitle: Text(
                selectedDate != null
                    ? "${selectedDate!.toLocal()}".split(' ')[0]
                    : 'No date selected',
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text('Select Start Time'),
              subtitle: Text(
                selectedStartTime != null
                    ? selectedStartTime!.format(context)
                    : 'No time selected',
              ),
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  setState(() {
                    selectedStartTime = pickedTime;
                  });
                }
              },
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text('Select End Time'),
              subtitle: Text(
                selectedEndTime != null
                    ? selectedEndTime!.format(context)
                    : 'No time selected',
              ),
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  setState(() {
                    selectedEndTime = pickedTime;
                  });
                }
              },
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text('Select Color'),
              subtitle: GestureDetector(
                onTap: () async {
                  Color? pickedColor = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Pick a color'),
                        content: SingleChildScrollView(
                          child: BlockPicker(
                            pickerColor: selectedColor,
                            onColorChanged: (Color color) {
                              Navigator.of(context).pop(color);
                            },
                          ),
                        ),
                      );
                    },
                  );
                  if (pickedColor != null) {
                    setState(() {
                      selectedColor = pickedColor;
                    });
                  }
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: selectedColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Save the appointment using the callback function
            if (selectedDate != null &&
                selectedStartTime != null &&
                selectedEndTime != null) {
              widget.onSave(
                appointmentName,
                selectedDate!,
                selectedStartTime!,
                selectedEndTime!,
                selectedColor,
              );
              Navigator.of(context).pop(); // Close the dialog
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}

class _EventCalendarState extends State<EventCalendar> {
  List<Appointment> appointments = [];
  TimeOfDay? selectedStartTime = TimeOfDay.now();
  TimeOfDay? selectedEndTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    // Load appointments when the widget initializes
    _loadAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SfCalendar(
            view: CalendarView.week,
            firstDayOfWeek: 1,
            dataSource: MeetingDataSource(appointments),
            timeSlotViewSettings: TimeSlotViewSettings(
              nonWorkingDays: <int>[DateTime.saturday, DateTime.sunday],
            ),
            backgroundColor: Colors.white,
            headerStyle: CalendarHeaderStyle(
              textStyle: TextStyle(
                color: Colors.blue[700],
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              backgroundColor: Colors.white,
            ),
            cellBorderColor: Colors.grey[300],
            appointmentTextStyle: TextStyle(
              color: Colors.black87,
              fontSize: 14.0,
            ),
            todayHighlightColor: Colors.blue.withValues(alpha: 0.3),
            selectionDecoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              border: Border.all(color: Colors.blue, width: 2.0),
              borderRadius: BorderRadius.circular(5.0),
            ),
            todayTextStyle: TextStyle(
              color: Colors.blue,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
            onTap: (CalendarTapDetails details) {
              if (details.targetElement == CalendarElement.appointment) {
                if (details.appointments?.isNotEmpty ?? false) {
                  _showRemoveAppointmentDialog(details.appointments![0]);
                }
              }
            },
          ),
          Positioned(
            bottom: 75,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: () {
                _showAddAppointmentDialog();
              },
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddAppointmentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _AddAppointmentDialog(
          onSave: (name, date, startTime, endTime, color) {
            // Save the appointment using SharedPreferences
            saveAppointment(name, date, startTime, endTime, color);
            // Save the updated list of appointments
            _saveAppointments();
          },
        );
      },
    );
  }

  void _showRemoveAppointmentDialog(Appointment appointment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove Class'),
          content: Text('Do you want to remove this class?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Remove the appointment and save the updated list
                removeAppointment(appointment);
                _saveAppointments();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  void removeAppointment(Appointment appointment) {
    setState(() {
      appointments.remove(appointment);
    });
  }

  // void _signOut() async {
  //   await _googleSignInProvider.logout();

  //   // Other sign-out logic if needed

  //   Navigator.of(context).pushReplacement(
  //     MaterialPageRoute(builder: (context) => WelcomeScreen()),
  //   );
  // }

  void saveAppointment(
    String name,
    DateTime date,
    TimeOfDay startTime,
    TimeOfDay endTime,
    Color color,
  ) {
    final DateTime appointmentStartTime = DateTime(
      date.year,
      date.month,
      date.day,
      startTime.hour,
      startTime.minute,
    );

    final DateTime appointmentEndTime = DateTime(
      date.year,
      date.month,
      date.day,
      endTime.hour,
      endTime.minute,
    );

    setState(() {
      appointments.add(Appointment(
        startTime: appointmentStartTime,
        endTime: appointmentEndTime,
        subject: name,
        color: color,
      ));
    });
  }

  // Load appointments from SharedPreferences
  void _loadAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? serializedAppointments =
        prefs.getStringList('appointments');
    if (serializedAppointments != null) {
      appointments = serializedAppointments
          .map((String serialized) => _deserializeAppointment(serialized))
          .toList();
      setState(() {});
    }
  }

  // Save appointments to SharedPreferences
  void _saveAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> serializedAppointments = appointments
        .map((Appointment appointment) => _serializeAppointment(appointment))
        .toList();
    prefs.setStringList('appointments', serializedAppointments);
  }

  // Convert Appointment to a serializable map
  String _serializeAppointment(Appointment appointment) {
    return '${appointment.subject}|${appointment.startTime}|${appointment.endTime}|${appointment.color.toARGB32()}';
  }

  // Create Appointment from a serialized map
  Appointment _deserializeAppointment(String serialized) {
    final List<String> parts = serialized.split('|');
    return Appointment(
      startTime: DateTime.parse(parts[1]),
      endTime: DateTime.parse(parts[2]),
      subject: parts[0],
        color: Color(int.parse(parts[3])),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
