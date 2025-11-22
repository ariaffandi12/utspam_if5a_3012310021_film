class Jadwal {
  final String id;
  final String date;
  final String time;
  final String studio;
  final double price;

  Jadwal({
    required this.id,
    required this.date,
    required this.time,
    required this.studio,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'time': time,
      'studio': studio,
      'price': price,
    };
  }

  factory Jadwal.fromJson(Map<String, dynamic> json) {
    return Jadwal(
      id: json['id'],
      date: json['date'],
      time: json['time'],
      studio: json['studio'],
      price: json['price'].toDouble(),
    );
  }
}