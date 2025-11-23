import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/database/transaction_database.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/models/transaction_model.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/theme/app_theme.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/utils/validators.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/widget/custom_button.dart';

class EditPurchaseScreen extends StatefulWidget {
  final Transaction transaction;

  const EditPurchaseScreen({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  State<EditPurchaseScreen> createState() => _EditPurchaseScreenState();
}

class _EditPurchaseScreenState extends State<EditPurchaseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _ticketCountController;
  late TextEditingController _cardNumberController;
  
  late String _paymentMethod;
  bool _isLoading = false;
  late double _totalCost;
  late double _ticketPrice;

  @override
  void initState() {
    super.initState();
    _ticketCountController = TextEditingController(text: widget.transaction.ticketCount.toString());
    _cardNumberController = TextEditingController(text: widget.transaction.cardNumber ?? '');
    _paymentMethod = widget.transaction.paymentMethod;
    _totalCost = widget.transaction.totalCost;
    _ticketPrice = _totalCost / widget.transaction.ticketCount;
  }

  @override
  void dispose() {
    _ticketCountController.dispose();
    _cardNumberController.dispose();
    super.dispose();
  }

  void _calculateTotalCost() {
    final ticketCount = int.tryParse(_ticketCountController.text) ?? 1;
    setState(() {
      _totalCost = ticketCount * _ticketPrice;
    });
  }

  Future<void> _updateTransaction() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final updatedTransaction = Transaction(
  id: widget.transaction.id,
  filmId: widget.transaction.filmId,
  filmTitle: widget.transaction.filmTitle,
  filmPoster: widget.transaction.filmPoster,
  scheduleId: widget.transaction.scheduleId,
  scheduleDate: widget.transaction.scheduleDate,
  scheduleTime: widget.transaction.scheduleTime,
  studio: widget.transaction.studio,
  buyerName: widget.transaction.buyerName,
  username: widget.transaction.username, // <-- WAJIB
  ticketCount: int.parse(_ticketCountController.text),
  purchaseDate: widget.transaction.purchaseDate,
  totalCost: _totalCost,
  paymentMethod: _paymentMethod,
  cardNumber: _paymentMethod == 'Kartu' ? _cardNumberController.text : null,
  status: widget.transaction.status,
);


    await TransactionDatabase.updateTransaction(updatedTransaction);

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Transaksi berhasil diperbarui'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context, updatedTransaction);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Edit Pembelian'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Film details (read-only)
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.transaction.filmPoster,
                      width: 100,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.transaction.filmTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${widget.transaction.scheduleDate} • ${widget.transaction.scheduleTime}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Studio: ${widget.transaction.studio}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Editable fields
              TextFormField(
                controller: _ticketCountController,
                validator: Validators.validateTicketCount,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Tiket',
                  prefixIcon: Icon(Icons.confirmation_number),
                ),
                onChanged: (value) {
                  _calculateTotalCost();
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Total Biaya: Rp ${_totalCost.toInt()}',
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _paymentMethod,
                decoration: const InputDecoration(
                  labelText: 'Metode Pembayaran',
                  prefixIcon: Icon(Icons.payment),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Cash',
                    child: Text('Cash'),
                  ),
                  DropdownMenuItem(
                    value: 'Kartu',
                    child: Text('Kartu'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value!;
                  });
                },
              ),
              if (_paymentMethod == 'Kartu') ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cardNumberController,
                  validator: Validators.validateCardNumber,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Nomor Kartu',
                    prefixIcon: Icon(Icons.credit_card),
                  ),
                ),
              ],
              const SizedBox(height: 30),
              CustomButton(
                text: 'Simpan Perubahan',
                onPressed: _updateTransaction,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}