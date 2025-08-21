import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/todo.dart';
import '../config/env.dart';

class ApiService {
  static String base = Env.apiBase();
  static String baseUrl = "$base/todos";

  static Future<List<Todo>> fetchTodos() async {
    final r = await http.get(Uri.parse(baseUrl));
    if (r.statusCode == 200) {
      final List data = jsonDecode(r.body);
      return data.map((e) => Todo.fromJson(Map<String, dynamic>.from(e))).toList();
    }
    throw Exception("fetch failed");
  }

  static Future<Todo> addTodo(Map<String, dynamic> body) async {
    final r = await http.post(Uri.parse(baseUrl), headers: {"Content-Type": "application/json"}, body: jsonEncode(body));
    if (r.statusCode == 200) return Todo.fromJson(jsonDecode(r.body));
    throw Exception("add failed");
  }

  static Future<Todo> updateTodo(int id, Map<String, dynamic> body) async {
    final r = await http.put(Uri.parse("$baseUrl/$id"), headers: {"Content-Type": "application/json"}, body: jsonEncode(body));
    if (r.statusCode == 200) return Todo.fromJson(jsonDecode(r.body));
    throw Exception("update failed");
  }

  static Future<void> deleteTodo(int id) async {
    final r = await http.delete(Uri.parse("$baseUrl/$id"));
    if (r.statusCode != 200) throw Exception("delete failed");
  }
}
