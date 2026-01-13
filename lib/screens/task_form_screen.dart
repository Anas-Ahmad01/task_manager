import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';

class TaskFormScreen extends StatefulWidget {
  final TaskModel? task;

  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descController = TextEditingController(text: widget.task?.description ?? '');
    _selectedDate = widget.task?.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final provider = Provider.of<TaskProvider>(context, listen: false);

      if (widget.task == null) {
        await provider.addTask(
          _titleController.text,
          _descController.text,
          _selectedDate,
        );
      } else {
        await provider.updateTask(
          widget.task!.id,
          _titleController.text,
          _descController.text,
          _selectedDate,
        );
      }

      // FORCE NAVIGATION TO HOME
      if (mounted) {
        context.go('/');
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        // NEW: Home Icon that forces you back to the main screen
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => context.go('/'),
        ),
        title: Text(isEditing ? "Edit Task" : "New Task"),
        actions: [
          _isLoading
              ? const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Center(
                child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))),
          )
              : TextButton(
            onPressed: _saveTask,
            child: const Text("SAVE", style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  hintText: "What needs to be done?",
                  border: InputBorder.none,
                ),
                validator: (v) => v!.trim().isEmpty ? "Title is required" : null,
              ),
              const Divider(),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: "Description (optional)",
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 20),
              ActionChip(
                avatar: const Icon(Icons.calendar_today, size: 16),
                label: Text(_selectedDate == null
                    ? "Set Due Date"
                    : DateFormat('MMM d, y').format(_selectedDate!)),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() => _selectedDate = picked);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}