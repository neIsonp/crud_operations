class EventModel {
  final int id;
  final String title, description, image, date;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.date,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      date: json['date'],
    );
  }
}
