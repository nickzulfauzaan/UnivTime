import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:univtime/utils/theme.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  int _selectedView = 0;
  
  Map<String, dynamic> timetableData = {};
  List<String> categories = [];
  
  String? selectedCategory;
  String? selectedYear;
  String? selectedSemester;
  
  List<String> years = [];
  List<String> semesters = [];
  List<String> selectedCourses = [];
  
  List<Appointment> appointments = [];

  @override
  void initState() {
    super.initState();
    _loadTimetableData();
    _loadEvents();
  }

  Future<void> _loadTimetableData() async {
    try {
      final String response = await rootBundle.loadString('assets/courseplanning.json');
      final Map<String, dynamic> data = json.decode(response);
      
      setState(() {
        timetableData = data;
        categories = data.keys.toList();
      });
    } catch (e) {
      developer.log("Error loading JSON: $e", name: 'TimetableScreen');
    }
  }

  Future<void> _loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('events');
    if (data != null) {
      appointments = data.map((s) => _deserializeEvent(s)).whereType<Appointment>().toList();
      setState(() {});
    }
  }

  Appointment? _deserializeEvent(String s) {
    final parts = s.split('|');
    if (parts.length != 4) return null;
    return Appointment(
      startTime: DateTime.parse(parts[1]),
      endTime: DateTime.parse(parts[2]),
      subject: parts[0],
      color: Color(int.parse(parts[3])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'Schedule',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showFilterDialog,
            icon: const Icon(Icons.filter_list),
            color: AppColors.textSecondary,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildViewSelector(),
          Expanded(
            child: timetableData.isEmpty
                ? Center(child: CircularProgressIndicator(color: AppColors.primary))
                : _buildCalendar(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: _showAddDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildViewSelector() {
    final views = ['Week', 'Month', 'List'];
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: views.asMap().entries.map((entry) {
          final index = entry.key;
          final label = entry.value;
          final isSelected = _selectedView == index;
          
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedView = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCalendar() {
    CalendarView view;
    switch (_selectedView) {
      case 0:
        view = CalendarView.week;
        break;
      case 1:
        view = CalendarView.month;
        break;
      default:
        view = CalendarView.schedule;
    }

    return Container(
      margin: const EdgeInsets.all(16),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: SfCalendar(
        view: view,
        firstDayOfWeek: 1,
        dataSource: _getDataSource(),
        timeSlotViewSettings: TimeSlotViewSettings(
          nonWorkingDays: <int>[DateTime.saturday, DateTime.sunday],
        ),
        backgroundColor: AppColors.surface,
        headerStyle: CalendarHeaderStyle(
          textStyle: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          backgroundColor: AppColors.surface,
        ),
        viewHeaderStyle: ViewHeaderStyle(
          dayTextStyle: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        cellBorderColor: AppColors.divider,
        todayHighlightColor: AppColors.primary,
        selectionDecoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          border: Border.all(color: AppColors.primary, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        todayTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
        appointmentBuilder: (context, details) {
          final appointment = details.appointments.first;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: appointment.color,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              appointment.subject.split(' - ').first,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          );
        },
        onTap: (details) {
          if (details.targetElement == CalendarElement.appointment && 
              details.appointments?.isNotEmpty == true) {
            _showAppointmentDetails(details.appointments!.first);
          }
        },
      ),
    );
  }

  CalendarDataSource _getDataSource() {
    final allAppointments = [...appointments];
    
    if (selectedCourses.isNotEmpty && selectedCategory != null && 
        selectedYear != null && selectedSemester != null) {
      for (final courseCode in selectedCourses) {
        final courseDetails = timetableData[selectedCategory!][selectedYear!][selectedSemester!][courseCode];
        final classSessions = courseDetails?["classSessions"] ?? [];
        
        for (final session in classSessions) {
          final day = session["day"];
          final startHour = int.parse(session["start_time"].split(":")[0]);
          final startMinute = int.parse(session["start_time"].split(":")[1]);
          final endHour = int.parse(session["end_time"].split(":")[0]);
          final endMinute = int.parse(session["end_time"].split(":")[1]);
          
          DateTime nextOccurrence = DateTime.now();
          while (nextOccurrence.weekday != _getDayOfWeek(day)) {
            nextOccurrence = nextOccurrence.add(const Duration(days: 1));
          }
          
          final startTime = DateTime(
            nextOccurrence.year, nextOccurrence.month, nextOccurrence.day, 
            startHour, startMinute,
          );
          final endTime = DateTime(
            nextOccurrence.year, nextOccurrence.month, nextOccurrence.day,
            endHour, endMinute,
          );
          
          allAppointments.add(Appointment(
            startTime: startTime,
            endTime: endTime,
            subject: '$courseCode - ${courseDetails?["COURSE_TITLE"] ?? courseCode}',
            color: AppColors.primary,
          ));
        }
      }
    }
    
    return MeetingDataSource(allAppointments);
  }

  int _getDayOfWeek(String day) {
    switch (day.toLowerCase()) {
      case "sunday": return 0;
      case "monday": return 1;
      case "tuesday": return 2;
      case "wednesday": return 3;
      case "thursday": return 4;
      case "friday": return 5;
      case "saturday": return 6;
      default: return 0;
    }
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add to Schedule'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.book, color: AppColors.primary),
              title: const Text('Add Course'),
              onTap: () {
                Navigator.pop(ctx);
                _showAddCourseDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.event, color: AppColors.warning),
              title: const Text('Add Event'),
              onTap: () {
                Navigator.pop(ctx);
                _showAddEventDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCourseDialog() async {
    selectedCategory = null;
    selectedYear = null;
    selectedSemester = null;
    selectedCourses = [];
    
    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Add Course'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDropdown(
                  value: selectedCategory,
                  items: categories,
                  hint: 'Category',
                  onChanged: (v) {
                    setState(() {
                      selectedCategory = v;
                      years = timetableData[v!].keys.toList();
                      selectedYear = null;
                      semesters = [];
                      selectedSemester = null;
                      selectedCourses = [];
                    });
                  },
                ),
                if (selectedCategory != null) ...[
                  const SizedBox(height: 12),
                  _buildDropdown(
                    value: selectedYear,
                    items: years,
                    hint: 'Year',
                    onChanged: (v) {
                      setState(() {
                        selectedYear = v;
                        semesters = timetableData[selectedCategory!][v!].keys.toList();
                        selectedSemester = null;
                        selectedCourses = [];
                      });
                    },
                  ),
                ],
                if (selectedYear != null) ...[
                  const SizedBox(height: 12),
                  _buildDropdown(
                    value: selectedSemester,
                    items: semesters,
                    hint: 'Semester',
                    onChanged: (v) {
                      setState(() {
                        selectedSemester = v;
                        selectedCourses = timetableData[selectedCategory!][selectedYear!][v!].keys.toList();
                      });
                    },
                  ),
                ],
                if (selectedSemester != null) ...[
                  const SizedBox(height: 16),
                  const Text('Select Courses:', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  ...selectedCourses.map((code) => CheckboxListTile(
                    title: Text(code),
                    value: selectedCourses.contains(code),
                    onChanged: (val) {
                      setState(() {
                        if (val == true) {
                          selectedCourses.add(code);
                        } else {
                          selectedCourses.remove(code);
                        }
                      });
                    },
                  )),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: selectedCourses.isNotEmpty ? () {
                _saveSelectedCourses();
                Navigator.pop(ctx);
              } : null,
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(hint),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }

  void _showAddEventDialog() {
    final nameController = TextEditingController();
    DateTime? selectedDate = DateTime.now();
    TimeOfDay? startTime = TimeOfDay.now();
    TimeOfDay? endTime = TimeOfDay.now();
    Color selectedColor = AppColors.warning;
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Event'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration:  InputDecoration(
                  labelText: 'Event Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.divider),
                ),
                title: const Text('Date'),
                subtitle: Text("${selectedDate!.toLocal()}".split(' ')[0]),
                leading: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) selectedDate = picked;
                },
              ),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: _buildTimePicker('Start', startTime, (t) => startTime = t)),
                const SizedBox(width: 12),
                Expanded(child: _buildTimePicker('End', endTime, (t) => endTime = t)),
              ]),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: nameController.text.isNotEmpty ? () {
              final start = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, 
                startTime!.hour, startTime!.minute);
              final end = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day,
                endTime!.hour, endTime!.minute);
              
              final apt = Appointment(
                startTime: start, endTime: end,
                subject: nameController.text,
                color: selectedColor,
              );
              
              setState(() => appointments.add(apt));
              _saveEvents();
              Navigator.pop(ctx);
            } : null,
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker(String label, TimeOfDay? time, void Function(TimeOfDay) onTap) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.divider),
      ),
      title: Text(label),
      subtitle: Text(time?.format(context) ?? 'Select'),
      leading: Icon(label == 'Start' ? Icons.play_arrow : Icons.stop),
      onTap: () async {
        final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
        if (picked != null) onTap(picked);
      },
    );
  }

  void _showAppointmentDetails(Appointment apt) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(apt.subject),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(children: [
              const Icon(Icons.access_time, size: 18),
              const SizedBox(width: 8),
              Text('${TimeOfDay.fromDateTime(apt.startTime).format(context)} - ${TimeOfDay.fromDateTime(apt.endTime).format(context)}'),
            ]),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => appointments.remove(apt));
              _saveEvents();
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Filter'),
        content: const Text('Filter options coming soon'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _saveSelectedCourses() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('selectedCourses', selectedCourses);
    setState(() {});
  }

  void _saveEvents() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('events', appointments.map((a) => 
      '${a.subject}|${a.startTime}|${a.endTime}|${a.color.value}'
    ).toList());
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
