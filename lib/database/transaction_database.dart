import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/models/transaction_model.dart';

class TransactionDatabase {
  static const String _transactionsKey = 'transactions';

  static Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  static Future<void> saveTransaction(Transaction transaction) async {
    final prefs = await _prefs;
    final transactions = await getAllTransactions();
    transactions.add(transaction);
    await prefs.setString(
        _transactionsKey, jsonEncode(transactions.map((t) => t.toJson()).toList()));
  }

  static Future<void> updateTransaction(Transaction transaction) async {
    final prefs = await _prefs;
    final transactions = await getAllTransactions();
    
    final index = transactions.indexWhere((t) => t.id == transaction.id);
    if (index != -1) {
      transactions[index] = transaction;
      await prefs.setString(
          _transactionsKey, jsonEncode(transactions.map((t) => t.toJson()).toList()));
    }
  }

  static Future<void> deleteTransaction(String transactionId) async {
    final prefs = await _prefs;
    final transactions = await getAllTransactions();
    transactions.removeWhere((t) => t.id == transactionId);
    await prefs.setString(
        _transactionsKey, jsonEncode(transactions.map((t) => t.toJson()).toList()));
  }

  static Future<List<Transaction>> getAllTransactions() async {
    final prefs = await _prefs;
    final String? transactionsString = prefs.getString(_transactionsKey);
    if (transactionsString != null) {
      final List<dynamic> jsonList = jsonDecode(transactionsString);
      return jsonList.map((json) => Transaction.fromJson(json)).toList();
    }
    return [];
  }

  // Fungsi lama (mungkin tidak digunakan lagi)
  static Future<List<Transaction>> getTransactionsByBuyerName(String buyerName) async {
    final transactions = await getAllTransactions();
    return transactions.where((t) => t.buyerName == buyerName).toList();
  }

  // Fungsi baru yang akan kita gunakan
  static Future<List<Transaction>> getTransactionsByUsername(String username) async {
    final transactions = await getAllTransactions();
    // Filter transaksi berdasarkan field 'username'
    return transactions.where((t) => t.username == username).toList();
  }
}