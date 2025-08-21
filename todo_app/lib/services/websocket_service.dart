import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../config/env.dart';

class WebSocketService {
  late IO.Socket socket;

  void connect(Function(String, dynamic) onEvent) {
    socket = IO.io(Env.wsBase(), IO.OptionBuilder().setTransports(['websocket']).enableForceNew().build());
    socket.onConnect((_) {});
    socket.onDisconnect((_) {});
    socket.on("todo_added", (d) => onEvent("todo_added", d));
    socket.on("todo_updated", (d) => onEvent("todo_updated", d));
    socket.on("todo_deleted", (d) => onEvent("todo_deleted", d));
  }

  void dispose() {
    socket.dispose();
  }
}
