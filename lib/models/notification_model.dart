class NotificationModel {
  final String title;
  final String description;

  NotificationModel({
    required this.title,
    required this.description,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'],
      description: json['description'],
    );
  }
}