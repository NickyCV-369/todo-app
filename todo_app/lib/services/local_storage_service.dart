import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';
import '../models/pending_action.dart';

class LocalStorageService {
  static const keyTodos = "todos";
  static const keyQueue = "pending_queue";

  static Future<void> saveTodos(List<Todo> todos) async {
    final p = await SharedPreferences.getInstance();
    p.setString(keyTodos, jsonEncode(todos.map((t) => t.toJson()).toList()));
  }

  static Future<List<Todo>> loadTodos() async {
    final p = await SharedPreferences.getInstance();
    final s = p.getString(keyTodos);
    if (s == null) return [];
    final List list = jsonDecode(s);
    return list.map((e) => Todo.fromJson(Map<String, dynamic>.from(e))).toList();
    }

  static Future<void> saveQueue(List<PendingAction> queue) async {
    final p = await SharedPreferences.getInstance();
    p.setString(keyQueue, jsonEncode(queue.map((q) => q.toJson()).toList()));
  }

  static Future<List<PendingAction>> loadQueue() async {
    final p = await SharedPreferences.getInstance();
    final s = p.getString(keyQueue);
    if (s == null) return [];
    final List list = jsonDecode(s);
    return list.map((e) => PendingAction.fromJson(Map<String, dynamic>.from(e))).toList();
  }
}
