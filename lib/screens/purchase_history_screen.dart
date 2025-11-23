import 'package:flutter/material.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/database/transaction_database.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/models/transaction_model.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/services/auth_service.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/theme/app_theme.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/widget/transaction_card.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/widget/custom_button.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  final VoidCallback? onBackToHomePressed;

  const PurchaseHistoryScreen({Key? key, this.onBackToHomePressed})
      : super(key: key);

  @override
  State<PurchaseHistoryScreen> createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen>
    with WidgetsBindingObserver {
  List<Transaction> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadTransactions();
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

  Future<void> _loadTransactions() async {
    final user = await AuthService.getCurrentUser();
    if (user == null) return;

    final transactions =
        await TransactionDatabase.getTransactionsByUsername(user.username);

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

      // ❌ AppBar sudah DIHAPUS

      body: Column(
        children: [
          Expanded(child: _buildContent()),

          if (widget.onBackToHomePressed != null && _transactions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomButton(
                text: 'Kembali ke Beranda',
                onPressed: widget.onBackToHomePressed ?? () {},
                backgroundColor: AppTheme.tertiaryColor,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryColor),
      );
    }

    if (_transactions.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada riwayat pembelian',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadTransactions,
      color: AppTheme.primaryColor,
      child: ListView.builder(
        itemCount: _transactions.length,
        itemBuilder: (context, index) {
          return TransactionCard(transaction: _transactions[index]);
        },
      ),
    );
  }
}
