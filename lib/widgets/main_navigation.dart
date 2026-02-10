import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:univtime/screens/campus_map_screen.dart';
import 'package:univtime/screens/courses_screen.dart';
import 'package:univtime/screens/checklist.dart';
import 'package:univtime/screens/timetable_screen.dart';
import 'package:univtime/screens/home_screen.dart';
import 'package:univtime/utils/theme.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  
  final List<NavItem> _navItems = [
    NavItem(icon: 'home', label: 'Home', svgPath: 'assets/icons/house.svg'),
    NavItem(icon: 'courses', label: 'Courses', svgPath: 'assets/icons/search-modulesvg.svg'),
    NavItem(icon: 'schedule', label: 'Schedule', svgPath: 'assets/icons/timetable.svg'),
    NavItem(icon: 'tasks', label: 'Tasks', svgPath: 'assets/icons/checklist.svg'),
  ];

  final List<Widget> _pages = [
    const HomeScreen(),
    const CoursesScreen(),
    const TimetableScreen(),
    const Checklist(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _navItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = _selectedIndex == index;
          
          return Expanded(
            child: GestureDetector(
              onTap: () => _onItemTapped(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: SvgPicture.asset(
                        item.svgPath,
                        colorFilter: ColorFilter.mode(
                          isSelected ? AppColors.primary : AppColors.textTertiary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? AppColors.primary : AppColors.textTertiary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.primary,
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.school, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'UnivTime',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Student Portal',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildDrawerItem(
            icon: Icons.map,
            title: 'Campus Map',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CampusMapScreen()),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.calendar_today,
            title: 'Academic Calendar',
            onTap: () {},
          ),
          _buildDrawerItem(
            icon: Icons.notifications,
            title: 'Notifications',
            onTap: () {},
          ),
          const Divider(),
          _buildDrawerItem(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () {},
          ),
          _buildDrawerItem(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {},
          ),
          _buildDrawerItem(
            icon: Icons.info,
            title: 'About',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      onTap: onTap,
    );
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }
}

class NavItem {
  final String icon;
  final String label;
  final String svgPath;

  NavItem({required this.icon, required this.label, required this.svgPath});
}
