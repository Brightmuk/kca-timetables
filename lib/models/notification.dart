import 'dart:convert';

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

class NotificationPayload {
  final String itemId;
  final String route;

  NotificationPayload({
    required this.itemId,
    required this.route,
  });

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'route': route,
    };
  }

  factory NotificationPayload.fromMap(Map<String, dynamic> map) {
    return NotificationPayload(
      itemId: map['itemId'] ?? '',
      route: map['route'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationPayload.fromJson(String source) =>
      NotificationPayload.fromMap(json.decode(source));

  @override
  String toString() => 'NotificationPayload(itemId: $itemId, route: $route)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotificationPayload &&
        other.itemId == itemId &&
        other.route == route;
  }

  @override
  int get hashCode => itemId.hashCode ^ route.hashCode;
}