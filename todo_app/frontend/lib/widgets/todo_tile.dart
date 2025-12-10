import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../utils/constants.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;
  final Function(bool?)? onChanged;
  final VoidCallback? onDelete;

  const TodoTile({
    super.key,
    required this.todo,
    this.onChanged,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Checkbox(
              value: todo.isCompleted,
              onChanged: onChanged,
              activeColor: AppColors.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                todo.title,
                style: TextStyle(
                  fontSize: 16,
                  decoration:
                      todo.isCompleted ? TextDecoration.lineThrough : null,
                  color: todo.isCompleted ? AppColors.muted : Colors.black87,
                ),
              ),
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
              color: AppColors.danger,
            ),
          ],
        ),
      ),
    );
  }
}
