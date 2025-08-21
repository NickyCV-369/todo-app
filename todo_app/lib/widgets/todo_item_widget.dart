import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';

class TodoItemWidget extends StatelessWidget {
  final Todo todo;
  const TodoItemWidget({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    final p = context.read<TodoProvider>();
    final accent = todo.isCompleted ? const Color(0xFF00D2D3) : const Color(0xFF6C5CE7);
    final df = DateFormat('dd/MM HH:mm');
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [accent.withOpacity(.12), Colors.white]),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Slidable(
        key: ValueKey(todo.id),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => Navigator.pushNamed(context, "/edit", arguments: todo),
              backgroundColor: const Color(0xFFFFC048),
              icon: Icons.edit,
              label: 'Sửa',
            ),
            SlidableAction(
              onPressed: (_) => p.deleteTodo(todo.id),
              backgroundColor: const Color(0xFFE74C3C),
              icon: Icons.delete,
              label: 'Xóa',
            ),
          ],
        ),
        child: ListTile(
          leading: Checkbox(
            value: todo.isCompleted,
            onChanged: (v) {
              todo.isCompleted = v ?? false;
              p.updateTodo(todo);
            },
          ),
          title: Text(
            todo.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              decoration: todo.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
              color: todo.isCompleted ? Colors.grey.shade600 : Colors.black87,
            ),
          ),
          subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (todo.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(todo.description, maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.schedule, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text("Tạo: ${df.format(todo.createdAt.toLocal())}", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                const SizedBox(width: 10),
                Text("Cập nhật: ${df.format(todo.updatedAt.toLocal())}", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                if (todo.dueDate != null) ...[
                  const SizedBox(width: 10),
                  Icon(Icons.event, size: 14, color: Colors.pink.shade400),
                  const SizedBox(width: 4),
                  Text(df.format(todo.dueDate!.toLocal()), style: TextStyle(color: Colors.pink.shade400, fontSize: 12, fontWeight: FontWeight.w600)),
                ]
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
