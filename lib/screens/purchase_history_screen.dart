import 'package:flutter/material.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/database/transaction_database.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/models/transaction_model.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/services/auth_service.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/theme/app_theme.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/widget/transaction_card.dart'; // Ensure this file defines TransactionCard
import 'package:utspam_if5a_3012310021_filmbioskop/widget/custom_button.dart'; // <-- IMPORT TAMBAHAN

class PurchaseHistoryScreen extends StatefulWidget {
  // Tambahkan parameter untuk menerima fungsi callback
  final VoidCallback? onBackToHomePressed;

  const PurchaseHistoryScreen({Key? key, this.onBackToHomePressed}) : super(key: key);

  @override
  State<PurchaseHistoryScreen> createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> with WidgetsBindingObserver {
  List<Transaction> _transactions = [];
  bool _isLoading = true;
  String? _buyerName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadBuyerName();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadTransactions();
    }
  }

  Future<void> _loadBuyerName() async {
    final user = await AuthService.getCurrentUser();
    if (user != null) {
      setState(() {
        _buyerName = user.fullName;
      });
      _loadTransactions();
    }
  }

  Future<void> _loadTransactions() async {
    if (_buyerName == null) return;
    
    final transactions = await TransactionDatabase.getTransactionsByBuyerName(_buyerName!);
    if (mounted) {
      setState(() {
        _transactions = transactions;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      // Gunakan Column untuk menumpuk ListView dan tombol
      body: Column(
        children: [
          // Gunakan Expanded agar ListView dapat di-scroll dan tidak memenuhi seluruh layar
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ),
                  )
                : _transactions.isEmpty
                    ? const Center(
                        child: Text(
                          'Belum ada riwayat pembelian',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadTransactions,
                        color: AppTheme.primaryColor,
                        child: ListView.builder(
                          itemCount: _transactions.length,
                          itemBuilder: (context, index) {
                            return TransactionCard(
                              transaction: _transactions[index],
                            );
                          },
                        ),
                      ),
          ),
          // --- TOMBOL KEMBALI DITAMBAHKAN DI SINI ---
          // Tampilkan tombol hanya jika ada callback dan daftar tidak kosong
          if (widget.onBackToHomePressed != null && _transactions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomButton(
                text: 'Kembali ke Beranda',
                onPressed: widget.onBackToHomePressed ?? () {},
                backgroundColor: AppTheme.tertiaryColor, // Warna netral
              ),
            ),
        ],
      ),
    );
  }
}