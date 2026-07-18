class Notificationinterface {
  final String id;
  final String recipient;
  final String title;
  final String body;
  final String type;
  bool read;
  final String createdAt;

  Notificationinterface(
      {required this.id,
      required this.recipient,
      required this.title,
      required this.body,
      required this.type,
      required this.read,
      required this.createdAt});

  factory Notificationinterface.fromJSON(Map<String, dynamic> json) {
    return Notificationinterface(
      id: json['_id'] ?? "",
      recipient: json['recipient'] ?? "",
      title: json['title'] ?? "",
      body: json['body'] ?? "",
      type: json['type'] ?? "",
      read: json['read'] ?? false,
      createdAt: json['createdAt'] ?? "",
    );
  }
}
