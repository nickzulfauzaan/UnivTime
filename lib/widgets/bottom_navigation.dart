import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:univtime/screens/campus_map.dart';
import 'package:univtime/screens/checklist.dart';
import '../screens/event_calendar.dart';
import '../screens/home_screen.dart';
import '../screens/manage_timetable.dart';
import '../screens/search_module.dart';

class BottomNavigationFunction extends StatefulWidget {
  const BottomNavigationFunction({Key? key}) : super(key: key);

  @override
  _BottomNavigationFunctionState createState() =>
      _BottomNavigationFunctionState();
}

class _BottomNavigationFunctionState extends State<BottomNavigationFunction> {
  int _selectedTab = 0;
  Widget _currentPage = Container();
  HomeScreen _homeScreen = HomeScreen();
  SearchModule _searchModule = SearchModule();
  ManageTimetable _manageTimetable = ManageTimetable();
  CampusMap _campusMap = CampusMap();
  Checklist _checklist = Checklist();
  EventCalendar _eventCalendar = EventCalendar();
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _homeScreen = HomeScreen();
    _searchModule = SearchModule();
    _manageTimetable = ManageTimetable();
    _campusMap = CampusMap();
    _checklist = Checklist();
    _eventCalendar = EventCalendar();
    _pages = [
      _homeScreen,
      _searchModule,
      _manageTimetable,
      _campusMap,
      _checklist,
      _eventCalendar,
    ];
    _currentPage = _homeScreen;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF12171D),
      body: Stack(
        children: <Widget>[
          _currentPage,
          _bottomNavigator(),
        ],
      ),
    );
  }

  _bottomNavigator() {
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
              _selectedTab = tab;
              if (tab == 0 ||
                  tab == 1 ||
                  tab == 2 ||
                  tab == 3 ||
                  tab == 4 ||
                  tab == 5) {
                _currentPage = _pages[tab];
              }
            });
            // if (_selectedTab == 1) {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (_) => SearchModule()),
            //   );
            // } else if (_selectedTab == 2) {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (_) => ManageTimetable()),
            //   );
            // } else if (_selectedTab == 3) {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (_) => SubmitReview()),
            //   );
            // }
          },
          selectedFontSize: 7.0,
          unselectedFontSize: 7.0,
          currentIndex: _selectedTab,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/house.svg",
                width: 40.0,
                color: _selectedTab == 0 ? Colors.blue : Colors.white,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/search-modulesvg.svg",
                width: 40.0,
                color: _selectedTab == 1 ? Colors.blue : Colors.white,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/planning.svg",
                width: 40.0,
                color: _selectedTab == 2 ? Colors.blue : Colors.white,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/map.svg",
                width: 40.0,
                color: _selectedTab == 3 ? Colors.blue : Colors.white,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/checklist.svg",
                width: 40.0,
                color: _selectedTab == 4 ? Colors.blue : Colors.white,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/timetable.svg",
                width: 40.0,
                color: _selectedTab == 5 ? Colors.blue : Colors.white,
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
