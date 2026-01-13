import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = task.isCompleted ? Colors.grey : Colors.black87;
    final textDecoration = task.isCompleted ? TextDecoration.lineThrough: null;

    return Dismissible(
        key: Key(task.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right:20),
          color: Colors.redAccent,
          child: const Icon(Icons.delete , color: Colors.white),
        ),
        onDismissed: (_) => onDelete(),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          elevation: task.isCompleted ? 0 : 2,
          color : task.isCompleted ? Colors.grey[50] : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            onTap: onTap,
            leading: Checkbox(
                value: task.isCompleted,
                activeColor: Colors.indigo,
                onChanged : (_) => onToggle(),
                shape: const CircleBorder(),
                ),
            title: Text(
              task.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: textColor,
                decoration: textDecoration,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(task.description.isNotEmpty)
                  Text(
                    task.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color:textColor),
                  ),
                if(task.dueDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, size: 12, color: textColor),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('MMM d, y').format(task.dueDate!),
                          style: TextStyle(fontSize: 12, color: textColor),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        )
    );
  }
}
