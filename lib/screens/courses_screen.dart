import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:univtime/utils/theme.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  int _selectedTab = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  Map<String, dynamic> jsonData = {};
  String selectedCategory = "";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      String jsonString = await DefaultAssetBundle.of(context).loadString('assets/data.json');
      Map<String, dynamic> data = jsonDecode(jsonString);
      Map<String, dynamic>? dataSet = data['data_set'];

      if (dataSet != null) {
        setState(() {
          jsonData = dataSet;
          selectedCategory = jsonData.keys.elementAt(0);
        });
      }
    } catch (e) {
      developer.log('Error loading data: $e', name: 'CoursesScreen');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'Courses',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list),
            color: AppColors.textSecondary,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: _selectedTab == 0 ? _buildSearchTab() : _buildMyCoursesTab(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    final tabs = ['Browse', 'My Courses'];
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final label = entry.value;
          final isSelected = _selectedTab == index;
          
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
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

  Widget _buildSearchTab() {
    return Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: jsonData.isEmpty
              ? Center(child: CircularProgressIndicator(color: AppColors.primary))
              : _buildCourseList(),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.surface,
          hintText: 'Search courses...',
          hintStyle: const TextStyle(color: AppColors.textTertiary),
          prefixIcon: const Icon(Icons.search, color: AppColors.textTertiary),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.textTertiary),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 40,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        children: jsonData.keys.map((category) {
          final isSelected = category == selectedCategory;
          return GestureDetector(
            onTap: () => setState(() => selectedCategory = category),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.divider,
                ),
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCourseList() {
    final categoryData = jsonData[selectedCategory];
    if (categoryData == null || categoryData is! Map) {
      return const Center(child: Text('No courses available'));
    }
    
    final allKeys = categoryData.keys.whereType<String>().toList();
    final filteredCourses = _searchQuery.isEmpty 
        ? allKeys
        : allKeys.where((courseCode) => courseCode.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    return Column(
      children: [
        const SizedBox(height: 8),
        _buildCategoryChips(),
        const SizedBox(height: 8),
        Expanded(
          child: filteredCourses.isEmpty
              ? const Center(child: Text('No courses found'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: filteredCourses.length,
                  itemBuilder: (context, index) {
                    final courseCode = filteredCourses[index];
                    final courseDetails = categoryData[courseCode] ?? {};
                    
                    return _buildCourseCard(courseCode, courseDetails);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildCourseCard(String courseCode, Map<String, dynamic> courseDetails) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                courseCode.split('CSC').last,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                courseCode,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        children: courseDetails.entries.map((section) {
          final sectionName = section.key;
          final sectionDetails = section.value ?? {};
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    sectionName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              ...sectionDetails.entries.map((detail) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        '${detail.key}:',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${detail.value}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              )),
              const SizedBox(height: 8),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMyCoursesTab() {
    final myCourses = [
      {'code': 'CSCW01', 'name': 'Web Technologies', 'credits': 3},
      {'code': 'CSCS03', 'name': 'Software Engineering', 'credits': 4},
      {'code': 'CSCD01', 'name': 'Database Systems', 'credits': 4},
      {'code': 'CSCJ01', 'name': 'Java Programming', 'credits': 3},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: myCourses.length,
      itemBuilder: (context, index) {
        final course = myCourses[index];
        return _buildMyCourseCard(course);
      },
    );
  }

  Widget _buildMyCourseCard(Map<String, dynamic> course) {
    final colors = [AppColors.primary, AppColors.success, AppColors.warning, AppColors.error];
    final color = colors[course['code'].hashCode % colors.length];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                course['code'].substring(4),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course['code'],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  course['name'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.stars, size: 14, color: AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Text(
                      '${course['credits']} Credits',
                      style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }
}
