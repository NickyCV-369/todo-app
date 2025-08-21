import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/todo.dart';
import '../models/pending_action.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';
import '../services/websocket_service.dart';
import '../services/notification_service.dart';
import '../services/network_service.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> todos = [];
  List<PendingAction> queue = [];
  late WebSocketService _ws;
  bool isOnline = true;
  String filter = "all";
  String sort = "created_desc";
  String search = "";
  Timer? _notifTimer;

  Future<void> bootstrap() async {
    await NotificationService.init();
    await _initConnectivity();
    await _loadInitial();
    _initWebSocket();
    _startDueChecker();
  }

  Future<void> _loadInitial() async {
    try {
      todos = await ApiService.fetchTodos();
      await LocalStorageService.saveTodos(todos);
    } catch (_) {
      todos = await LocalStorageService.loadTodos();
    }
    queue = await LocalStorageService.loadQueue();
    notifyListeners();
  }

  Future<void> refresh() async {
    await _loadInitial();
  }

  Future<void> _initConnectivity() async {
    final c = await Connectivity().checkConnectivity();
    isOnline = !(c.contains(ConnectivityResult.none));
    Connectivity().onConnectivityChanged.listen((r) async {
      final online = !r.contains(ConnectivityResult.none);
      if (online && !isOnline) {
        isOnline = true;
        await _flushQueue();
        await refresh();
      } else {
        isOnline = online;
      }
      notifyListeners();
    });
  }

  void _initWebSocket() {
    _ws = WebSocketService();
    _ws.connect((event, payload) {
      if (event == "todo_added") {
        final t = Todo.fromJson(Map<String, dynamic>.from(payload));
        if (!todos.any((e) => e.id == t.id)) todos.add(t);
      } else if (event == "todo_updated") {
        final u = Todo.fromJson(Map<String, dynamic>.from(payload));
        final i = todos.indexWhere((e) => e.id == u.id);
        if (i != -1) todos[i] = u;
      } else if (event == "todo_deleted") {
        final id = payload["id"];
        todos.removeWhere((e) => e.id == id);
      }
      notifyListeners();
    });
  }

  void _startDueChecker() {
    _notifTimer?.cancel();
    _notifTimer = Timer.periodic(const Duration(minutes: 1), (_) => NotificationService.notifyDueSoon(todos));
  }

  List<Todo> get filtered {
    Iterable<Todo> list = todos;
    if (filter == "completed") list = list.where((t) => t.isCompleted);
    if (filter == "pending") list = list.where((t) => !t.isCompleted);
    if (search.isNotEmpty) {
      final q = search.toLowerCase();
      list = list.where((t) => t.title.toLowerCase().contains(q) || t.description.toLowerCase().contains(q));
    }
    final l = list.toList();
    if (sort == "created_desc") l.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (sort == "created_asc") l.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    if (sort == "title_asc") l.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    if (sort == "title_desc") l.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
    return l;
  }

  Future<void> addTodo(String title, String desc, DateTime? due) async {
    final body = {
      "title": title,
      "description": desc,
      "isCompleted": false,
      "createdAt": DateTime.now().toIso8601String(),
      "updatedAt": DateTime.now().toIso8601String(),
      "dueDate": due?.toIso8601String()
    };
    if (await NetworkService.hasNetwork()) {
      await ApiService.addTodo(body);
    } else {
      final temp = Todo(id: DateTime.now().millisecondsSinceEpoch, title: title, description: desc, isCompleted: false, createdAt: DateTime.now(), updatedAt: DateTime.now(), dueDate: due);
      todos.add(temp);
      queue.add(PendingAction(type: "add", payload: body));
      await LocalStorageService.saveQueue(queue);
    }
    await LocalStorageService.saveTodos(todos);
    notifyListeners();
  }

  Future<void> updateTodo(Todo todo) async {
    todo.updatedAt = DateTime.now();
    if (await NetworkService.hasNetwork()) {
      final u = await ApiService.updateTodo(todo.id, todo.toJson());
      final i = todos.indexWhere((e) => e.id == todo.id);
      if (i != -1) todos[i] = u;
    } else {
      final i = todos.indexWhere((e) => e.id == todo.id);
      if (i != -1) todos[i] = todo;
      queue.add(PendingAction(type: "update", payload: todo.toJson()));
      await LocalStorageService.saveQueue(queue);
    }
    await LocalStorageService.saveTodos(todos);
    notifyListeners();
  }

  Future<void> deleteTodo(int id) async {
    if (await NetworkService.hasNetwork()) {
      await ApiService.deleteTodo(id);
      todos.removeWhere((e) => e.id == id);
    } else {
      todos.removeWhere((e) => e.id == id);
      queue.add(PendingAction(type: "delete", payload: {"id": id}));
      await LocalStorageService.saveQueue(queue);
    }
    await LocalStorageService.saveTodos(todos);
    notifyListeners();
  }

  Future<void> _flushQueue() async {
    final copy = List<PendingAction>.from(queue);
    for (final a in copy) {
      if (a.type == "add") {
        await ApiService.addTodo(a.payload);
      } else if (a.type == "update") {
        final id = a.payload["id"];
        await ApiService.updateTodo(id, a.payload);
      } else if (a.type == "delete") {
        final id = a.payload["id"];
        await ApiService.deleteTodo(id);
      }
    }
    queue.clear();
    await LocalStorageService.saveQueue(queue);
  }

  void setFilter(String v) {
    filter = v;
    notifyListeners();
  }

  void setSort(String v) {
    sort = v;
    notifyListeners();
  }

  void setSearch(String v) {
    search = v;
    notifyListeners();
  }

  @override
  void dispose() {
    _notifTimer?.cancel();
    super.dispose();
  }
}
