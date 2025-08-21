import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';

class AddEditTodoScreen extends StatefulWidget {
  final Object? todoArg;
  const AddEditTodoScreen({super.key, this.todoArg});
  @override
  State<AddEditTodoScreen> createState() => _AddEditTodoScreenState();
}

class _AddEditTodoScreenState extends State<AddEditTodoScreen> {
  final _title = TextEditingController();
  final _desc = TextEditingController();
  DateTime? _due;

  @override
  void initState() {
    super.initState();
    if (widget.todoArg is Todo) {
      final t = widget.todoArg as Todo;
      _title.text = t.title;
      _desc.text = t.description;
      _due = t.dueDate;
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.todoArg is Todo;
    final p = context.read<TodoProvider>();
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF00D2D3), Color(0xFF6C5CE7)]))),
        title: Text(isEdit ? "Chỉnh sửa" : "Thêm mới", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
            padding: const EdgeInsets.all(14),
            child: Column(children: [
              TextField(decoration: const InputDecoration(labelText: "Tiêu đề"), controller: _title),
              const SizedBox(height: 12),
              TextField(decoration: const InputDecoration(labelText: "Mô tả"), controller: _desc, maxLines: 3),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: Text(_due == null ? "Không có thời hạn" : "Hạn: ${_due!.toLocal()}".split('.').first)),
                ElevatedButton.icon(
                  onPressed: () async {
                    final now = DateTime.now();
                    final d = await showDatePicker(context: context, initialDate: _due ?? now, firstDate: now.subtract(const Duration(days: 0)), lastDate: now.add(const Duration(days: 365)));
                    if (d == null) return;
                    final t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_due ?? now));
                    if (t == null) return;
                    setState(() => _due = DateTime(d.year, d.month, d.day, t.hour, t.minute));
                  },
                  icon: const Icon(Icons.event),
                  label: const Text("Chọn hạn"),
                )
              ]),
            ]),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () async {
              if (_title.text.trim().isEmpty) return;
              if (isEdit) {
                final todo = widget.todoArg as Todo;
                todo.title = _title.text.trim();
                todo.description = _desc.text.trim();
                todo.dueDate = _due;
                await p.updateTodo(todo);
              } else {
                await p.addTodo(_title.text.trim(), _desc.text.trim(), _due);
              }
              if (mounted) Navigator.pop(context);
            },
            icon: const Icon(Icons.save),
            label: const Text("Lưu"),
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          )
        ],
      ),
    );
  }
}
