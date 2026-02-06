import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:univtime/screens/campus_map.dart';
import 'package:univtime/screens/checklist.dart';
import '../screens/event_calendar.dart';
import '../screens/home_screen.dart';
import '../screens/manage_timetable.dart';
import '../screens/search_module.dart';

class BottomNavigationFunction extends StatefulWidget {
  const BottomNavigationFunction({super.key});

  @override
  BottomNavigationFunctionState createState() => BottomNavigationFunctionState();
}

class BottomNavigationFunctionState extends State<BottomNavigationFunction> {
  int selectedTab = 0;
  Widget currentPage = Container();
  late HomeScreen homeScreen;
  late SearchModule searchModule;
  late ManageTimetable manageTimetable;
  late CampusMap campusMap;
  late Checklist checklist;
  late EventCalendar eventCalendar;
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    homeScreen = HomeScreen();
    searchModule = SearchModule();
    manageTimetable = ManageTimetable();
    campusMap = CampusMap();
    checklist = Checklist();
    eventCalendar = EventCalendar();
    pages = [
      homeScreen,
      searchModule,
      manageTimetable,
      campusMap,
      checklist,
      eventCalendar,
    ];
    currentPage = homeScreen;
  }

  Color getIconColor(int index) {
    return selectedTab == index ? Colors.blue : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF12171D),
      body: Stack(
        children: <Widget>[
          currentPage,
          bottomNavigator(),
        ],
      ),
    );
  }

  Widget bottomNavigator() {
    return Positioned(
      bottom: 0.0,
      right: 0.0,
      left: 0.0,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color.fromARGB(255, 17, 17, 17),
          onTap: (int tab) {
            setState(() {
              selectedTab = tab;
              if (tab == 0 ||
                  tab == 1 ||
                  tab == 2 ||
                  tab == 3 ||
                  tab == 4 ||
                  tab == 5) {
                currentPage = pages[tab];
              }
            });
          },
          selectedFontSize: 7.0,
          unselectedFontSize: 7.0,
          currentIndex: selectedTab,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/house.svg",
                width: 40.0,
                colorFilter: ColorFilter.mode(getIconColor(0), BlendMode.srcIn),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/search-modulesvg.svg",
                width: 40.0,
                colorFilter: ColorFilter.mode(getIconColor(1), BlendMode.srcIn),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/planning.svg",
                width: 40.0,
                colorFilter: ColorFilter.mode(getIconColor(2), BlendMode.srcIn),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/map.svg",
                width: 40.0,
                colorFilter: ColorFilter.mode(getIconColor(3), BlendMode.srcIn),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/checklist.svg",
                width: 40.0,
                colorFilter: ColorFilter.mode(getIconColor(4), BlendMode.srcIn),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/timetable.svg",
                width: 40.0,
                colorFilter: ColorFilter.mode(getIconColor(5), BlendMode.srcIn),
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
