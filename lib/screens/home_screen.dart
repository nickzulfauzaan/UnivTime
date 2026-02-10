import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:univtime/utils/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(user),
              const SizedBox(height: 24),
              _buildQuickStats(),
              const SizedBox(height: 24),
              _buildUpcomingClasses(),
              const SizedBox(height: 24),
              _buildQuickActions(),
              const SizedBox(height: 24),
              _buildRecentTasks(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(User? user) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: CircleAvatar(
            radius: 28,
            backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: user?.photoURL == null 
                ? Icon(Icons.person, color: AppColors.primary, size: 32)
                : null,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back,',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              Text(
                user?.displayName?.split(' ').first ?? 'Student',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_outlined),
          color: AppColors.textSecondary,
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        _buildStatCard(
          icon: Icons.book,
          label: 'Courses',
          value: '5',
          color: AppColors.primary,
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          icon: Icons.check_circle,
          label: 'Tasks',
          value: '3',
          color: AppColors.success,
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          icon: Icons.event,
          label: 'Events',
          value: '2',
          color: AppColors.warning,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingClasses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Today's Classes",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'See all',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildClassCard(
          code: 'CSCW01',
          name: 'Web Technologies',
          time: '10:00 AM - 11:30 AM',
          location: 'Room 301',
          color: AppColors.primary,
        ),
        const SizedBox(height: 10),
        _buildClassCard(
          code: 'CSCS03',
          name: 'Software Engineering',
          time: '2:00 PM - 3:30 PM',
          location: 'Room 205',
          color: AppColors.success,
        ),
      ],
    );
  }

  Widget _buildClassCard({
    required String code,
    required String name,
    required String time,
    required String location,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
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
            width: 4,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      code,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 12, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.location_on, size: 12, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      location,
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {'icon': Icons.add, 'label': 'Add Task', 'color': AppColors.primary},
      {'icon': Icons.event, 'label': 'Add Event', 'color': AppColors.warning},
      {'icon': Icons.search, 'label': 'Find Course', 'color': AppColors.success},
      {'icon': Icons.map, 'label': 'Campus Map', 'color': AppColors.error},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: actions.map((action) {
            return GestureDetector(
              onTap: () {},
              child: Container(
                width: 80,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: (action['color'] as Color).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        action['icon'] as IconData,
                        color: action['color'] as Color,
                        size: 22,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      action['label'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRecentTasks() {
    final tasks = [
      {'title': 'Submit assignment', 'due': 'Tomorrow', 'completed': false},
      {'title': 'Study for exam', 'due': 'Friday', 'completed': false},
      {'title': 'Project presentation', 'due': 'Next week', 'completed': true},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Upcoming Tasks',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.add, color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...tasks.map((task) => _buildTaskItem(
          title: task['title'] as String,
          due: task['due'] as String,
          isCompleted: task['completed'] as bool,
        )),
      ],
    );
  }

  Widget _buildTaskItem({
    required String title,
    required String due,
    required bool isCompleted,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isCompleted ? AppColors.success : AppColors.divider,
                width: 2,
              ),
              color: isCompleted ? AppColors.success : Colors.transparent,
            ),
            child: isCompleted
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 12, color: AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Text(
                      due,
                      style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
