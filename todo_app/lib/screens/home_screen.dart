import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../widgets/filter_bar_widget.dart';
import '../widgets/todo_item_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late final TextEditingController _searchCtrl;

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<TodoProvider>();
    final isWide = MediaQuery.of(context).size.width > 720;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF6C5CE7), Color(0xFF00D2D3)]))),
        title: const Text("Todo Realtime", style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (!p.isOnline)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              color: const Color(0xFFFFC048),
              child: const Text("Đang ở chế độ offline", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          Container(
            margin: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
            child: TextField(
              controller: _searchCtrl,
              onChanged: p.setSearch,
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: "Tìm kiếm tiêu đề hoặc mô tả", border: InputBorder.none, contentPadding: EdgeInsets.all(14)),
            ),
          ),
          FilterBarWidget(),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: p.filtered.isEmpty
                  ? Center(
                      key: const ValueKey("empty"),
                      child: Text("Không có công việc", style: TextStyle(color: Colors.grey.shade600, fontSize: 16, fontWeight: FontWeight.w600)),
                    )
                  : Padding(
                      key: const ValueKey("list"),
                      padding: const EdgeInsets.all(12),
                      child: isWide
                          ? GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 16 / 6),
                              itemCount: p.filtered.length,
                              itemBuilder: (_, i) => TodoItemWidget(todo: p.filtered[i]),
                            )
                          : ListView.separated(
                              itemCount: p.filtered.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (_, i) => TodoItemWidget(todo: p.filtered[i]),
                            ),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text("Tổng: ${p.filtered.length} • Cập nhật: ${DateFormat.Hm().format(DateTime.now())}", style: TextStyle(color: Colors.grey.shade600)),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, "/add"),
        label: const Text("Thêm"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
