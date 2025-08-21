import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';

class FilterBarWidget extends StatelessWidget {
  const FilterBarWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final p = context.watch<TodoProvider>();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE3F2FD), Color(0xFFEDE7F6)],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: SegmentedButton<String>(
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              segments: const [
                ButtonSegment(
                  value: "all",
                  icon: Icon(Icons.list_alt, size: 16),
                  label: Text("Tất cả", overflow: TextOverflow.ellipsis),
                ),
                ButtonSegment(
                  value: "pending",
                  icon: Icon(Icons.hourglass_bottom, size: 16),
                  label: Text("Chưa", overflow: TextOverflow.ellipsis),
                ),
                ButtonSegment(
                  value: "completed",
                  icon: Icon(Icons.check_circle, size: 16),
                  label: Text("Xong", overflow: TextOverflow.ellipsis),
                ),
              ],
              selected: {p.filter},
              onSelectionChanged: (s) =>
                  context.read<TodoProvider>().setFilter(s.first),
            ),
          ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list, color: Colors.black87),
            initialValue: p.sort,
            onSelected: (v) => context.read<TodoProvider>().setSort(v),
            itemBuilder: (context) => const [
              PopupMenuItem(
                  value: "created_desc", child: Text("Mới nhất")),
              PopupMenuItem(
                  value: "created_asc", child: Text("Cũ nhất")),
              PopupMenuItem(value: "title_asc", child: Text("A → Z")),
              PopupMenuItem(value: "title_desc", child: Text("Z → A")),
            ],
          ),
        ],
      ),
    );
  }
}
