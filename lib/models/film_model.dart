import 'jadwal_model.dart'; // Tambahkan import ini

class Film {
  final String id;
  final String title;
  final String genre;
  final String duration;
  final String description;
  final String posterUrl;
  final double rating;
  final List<Jadwal> schedules; // Tetap menggunakan Jadwal

  Film({
    required this.id,
    required this.title,
    required this.genre,
    required this.duration,
    required this.description,
    required this.posterUrl,
    required this.rating,
    required this.schedules,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'genre': genre,
      'duration': duration,
      'description': description,
      'posterUrl': posterUrl,
      'rating': rating,
      'schedules': schedules.map((schedule) => schedule.toJson()).toList(),
    };
  }

  factory Film.fromJson(Map<String, dynamic> json) {
    var schedulesList = json['schedules'] as List;
    List<Jadwal> schedules = schedulesList.map((i) => Jadwal.fromJson(i)).toList();

    return Film(
      id: json['id'],
      title: json['title'],
      genre: json['genre'],
      duration: json['duration'],
      description: json['description'],
      posterUrl: json['posterUrl'],
      rating: json['rating'].toDouble(),
      schedules: schedules,
    );
  }
}

