import 'package:flutter/material.dart';
import 'Dashboard_page.dart';
import 'Profile_page.dart';
import 'Settings_page.dart';
import 'reminder_store.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  final ReminderStore store = ReminderStore.instance;

  Color _statusColor(String status) {
    if (status == 'done') return const Color(0xFFDFF5E1);
    if (status == 'missed') return const Color(0xFFFDE2E2);
    return const Color(0xFFF4F4F4);
  }

  String _statusText(String status) {
    if (status == 'done') return 'Done';
    if (status == 'missed') return 'Not Done';
    return 'Pending';
  }

  void _updateStatus(ReminderItem item, String status) {
    store.updateReminderStatus(item.id, status);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          status == 'done'
              ? '${item.title} marked as done'
              : '${item.title} marked as not done',
        ),
      ),
    );
  }

  Widget _buildTopCard() {
    return Container(
      width: double.infinity,
      height: 135,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            color: Color(0x9257636C),
            offset: Offset(0, 0),
            spreadRadius: 1,
          ),
        ],
        borderRadius: BorderRadius.circular(25),
      ),
      padding: const EdgeInsets.all(18),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Patient Reminders',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'You can only view reminders and mark them as done or not done. Only the companion can add or edit reminders.',
            style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderCard(ReminderItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _statusColor(item.status),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(item.emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.day} - ${item.time}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _statusText(item.status),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                item.notification
                    ? Icons.notifications_active_outlined
                    : Icons.notifications_off_outlined,
                color: Colors.black54,
                size: 22,
              ),
              const SizedBox(width: 10),
              Icon(
                item.sound
                    ? Icons.volume_up_outlined
                    : Icons.volume_off_outlined,
                color: Colors.black54,
                size: 22,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => _updateStatus(item, 'done'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF87CEEB),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('✅', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _updateStatus(item, 'missed'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade400,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('❌', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<ReminderItem> items) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            color: Color(0x14000000),
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 14),
          if (items.isEmpty)
            const Text(
              'No reminders here',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            )
          else
            ...items.map(_buildReminderCard),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem({
    required BuildContext context,
    required IconData icon,
    required Widget page,
    required bool isCurrent,
  }) {
    return IconButton(
      onPressed: () {
        if (isCurrent) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      icon: Icon(
        icon,
        size: icon == Icons.settings_outlined ? 45 : 50,
        color: Colors.black,
      ),
      splashColor: Colors.grey.withOpacity(0.25),
      highlightColor: Colors.grey.withOpacity(0.18),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final medicines = store.remindersByCategory(ReminderCategory.medicine);
        final meals = store.remindersByCategory(ReminderCategory.meal);
        final appointments = store.remindersByCategory(
          ReminderCategory.appointment,
        );

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: const Color(0xFFF4F4F4),
            body: SafeArea(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 130,
                        color: const Color(0xFF87CEEB),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 100),
                        child: Container(
                          width: double.infinity,
                          height: 41,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF4F4F4),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(70),
                              topRight: Radius.circular(70),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                      child: Column(
                        children: [
                          _buildTopCard(),
                          _buildSection('Medicines', medicines),
                          _buildSection('Meals', meals),
                          _buildSection('Appointments', appointments),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildBottomNavItem(
                          context: context,
                          icon: Icons.home_outlined,
                          page: const DashboardPage(),
                          isCurrent: false,
                        ),
                        _buildBottomNavItem(
                          context: context,
                          icon: Icons.person_outlined,
                          page: const ProfilePage(),
                          isCurrent: false,
                        ),
                        _buildBottomNavItem(
                          context: context,
                          icon: Icons.settings_outlined,
                          page: const SettingsPage(),
                          isCurrent: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
