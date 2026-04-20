import 'package:flutter/material.dart';
import 'reminder_store.dart';

class CompanionRemindersPage extends StatefulWidget {
  const CompanionRemindersPage({super.key});

  @override
  State<CompanionRemindersPage> createState() => _CompanionRemindersPageState();
}

class _CompanionRemindersPageState extends State<CompanionRemindersPage> {
  final ReminderStore store = ReminderStore.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _emojiController = TextEditingController();

  ReminderCategory _selectedCategory = ReminderCategory.medicine;
  bool _notification = true;
  bool _sound = true;

  ReminderItem? _editingReminder;

  @override
  void dispose() {
    _titleController.dispose();
    _timeController.dispose();
    _dayController.dispose();
    _emojiController.dispose();
    super.dispose();
  }

  String _categoryText(ReminderCategory category) {
    switch (category) {
      case ReminderCategory.medicine:
        return 'Medicine';
      case ReminderCategory.meal:
        return 'Meal';
      case ReminderCategory.appointment:
        return 'Appointment';
    }
  }

  void _fillFormForEdit(ReminderItem item) {
    setState(() {
      _editingReminder = item;
      _titleController.text = item.title;
      _timeController.text = item.time;
      _dayController.text = item.day;
      _emojiController.text = item.emoji;
      _selectedCategory = item.category;
      _notification = item.notification;
      _sound = item.sound;
    });
  }

  void _clearForm() {
    setState(() {
      _editingReminder = null;
      _titleController.clear();
      _timeController.clear();
      _dayController.clear();
      _emojiController.clear();
      _selectedCategory = ReminderCategory.medicine;
      _notification = true;
      _sound = true;
    });
  }

  void _saveReminder() {
    if (!_formKey.currentState!.validate()) return;

    if (_editingReminder == null) {
      final item = ReminderItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        time: _timeController.text.trim(),
        day: _dayController.text.trim(),
        emoji: _emojiController.text.trim(),
        category: _selectedCategory,
        notification: _notification,
        sound: _sound,
      );
      store.addReminder(item);
    } else {
      final updatedItem = ReminderItem(
        id: _editingReminder!.id,
        title: _titleController.text.trim(),
        time: _timeController.text.trim(),
        day: _dayController.text.trim(),
        emoji: _emojiController.text.trim(),
        category: _selectedCategory,
        notification: _notification,
        sound: _sound,
        status: _editingReminder!.status,
      );
      store.updateReminder(updatedItem);
    }

    _clearForm();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _editingReminder == null
              ? 'Reminder added successfully'
              : 'Reminder updated successfully',
        ),
      ),
    );
  }

  Widget _buildInput({
    required String label,
    required TextEditingController controller,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(border: InputBorder.none, labelText: label),
        validator: (value) {
          if ((value ?? '').trim().isEmpty) {
            return 'Required';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildReminderTile(ReminderItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
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
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.day} - ${item.time} • ${_categoryText(item.category)}',
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
                const SizedBox(height: 4),
                Text(
                  'Patient status: ${item.status}',
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _fillFormForEdit(item),
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            onPressed: () => store.deleteReminder(item.id),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF4F4F4),
          appBar: AppBar(
            backgroundColor: const Color(0xFF87CEEB),
            title: const Text('Companion Reminders'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          _editingReminder == null
                              ? 'Add Reminder'
                              : 'Edit Reminder',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _buildInput(
                          label: 'Title',
                          controller: _titleController,
                        ),
                        _buildInput(label: 'Time', controller: _timeController),
                        _buildInput(label: 'Day', controller: _dayController),
                        _buildInput(
                          label: 'Emoji',
                          controller: _emojiController,
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F4F4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonFormField<ReminderCategory>(
                            initialValue: _selectedCategory,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Category',
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: ReminderCategory.medicine,
                                child: Text('Medicine'),
                              ),
                              DropdownMenuItem(
                                value: ReminderCategory.meal,
                                child: Text('Meal'),
                              ),
                              DropdownMenuItem(
                                value: ReminderCategory.appointment,
                                child: Text('Appointment'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedCategory = value;
                                });
                              }
                            },
                          ),
                        ),
                        SwitchListTile(
                          value: _notification,
                          onChanged: (value) {
                            setState(() {
                              _notification = value;
                            });
                          },
                          title: const Text('Notification'),
                        ),
                        SwitchListTile(
                          value: _sound,
                          onChanged: (value) {
                            setState(() {
                              _sound = value;
                            });
                          },
                          title: const Text('Sound'),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _saveReminder,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF87CEEB),
                                  elevation: 0,
                                ),
                                child: Text(
                                  _editingReminder == null ? 'Add' : 'Update',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            if (_editingReminder != null)
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _clearForm,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey.shade400,
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'All Reminders',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 14),
                      if (store.reminders.isEmpty)
                        const Text('No reminders added yet')
                      else
                        ...store.reminders.map(_buildReminderTile),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
