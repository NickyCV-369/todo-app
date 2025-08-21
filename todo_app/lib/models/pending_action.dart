class PendingAction {
  final String type;
  final Map<String, dynamic> payload;

  PendingAction({required this.type, required this.payload});

  factory PendingAction.fromJson(Map<String, dynamic> json) => PendingAction(type: json["type"], payload: Map<String, dynamic>.from(json["payload"]));

  Map<String, dynamic> toJson() => {"type": type, "payload": payload};
}
