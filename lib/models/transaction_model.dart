class Transaction {
  final String id;
  final String filmId;
  final String filmTitle;
  final String filmPoster;
  final String scheduleId;
  final String scheduleDate;
  final String scheduleTime;
  final String studio;
  final String buyerName;
  final int ticketCount;
  final String purchaseDate;
  final double totalCost;
  final String paymentMethod;
  final String? cardNumber;
  final String status; // 'selesai', 'pending', 'dibatalkan'

  Transaction({
    required this.id,
    required this.filmId,
    required this.filmTitle,
    required this.filmPoster,
    required this.scheduleId,
    required this.scheduleDate,
    required this.scheduleTime,
    required this.studio,
    required this.buyerName,
    required this.ticketCount,
    required this.purchaseDate,
    required this.totalCost,
    required this.paymentMethod,
    this.cardNumber,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filmId': filmId,
      'filmTitle': filmTitle,
      'filmPoster': filmPoster,
      'scheduleId': scheduleId,
      'scheduleDate': scheduleDate,
      'scheduleTime': scheduleTime,
      'studio': studio,
      'buyerName': buyerName,
      'ticketCount': ticketCount,
      'purchaseDate': purchaseDate,
      'totalCost': totalCost,
      'paymentMethod': paymentMethod,
      'cardNumber': cardNumber,
      'status': status,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      filmId: json['filmId'],
      filmTitle: json['filmTitle'],
      filmPoster: json['filmPoster'],
      scheduleId: json['scheduleId'],
      scheduleDate: json['scheduleDate'],
      scheduleTime: json['scheduleTime'],
      studio: json['studio'],
      buyerName: json['buyerName'],
      ticketCount: json['ticketCount'],
      purchaseDate: json['purchaseDate'],
      totalCost: json['totalCost'].toDouble(),
      paymentMethod: json['paymentMethod'],
      cardNumber: json['cardNumber'],
      status: json['status'],
    );
  }
}