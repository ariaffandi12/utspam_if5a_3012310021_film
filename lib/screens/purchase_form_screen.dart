import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/models/jadwal_model.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/database/transaction_database.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/models/film_model.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/models/transaction_model.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/models/user_model.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/screens/home_screen.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/services/auth_service.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/theme/app_theme.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/utils/validators.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/widget/custom_button.dart';

class PurchaseFormScreen extends StatefulWidget {
  final Film film;
  final Jadwal schedule;

  const PurchaseFormScreen({
    Key? key,
    required this.film,
    required this.schedule,
  }) : super(key: key);

  @override
  State<PurchaseFormScreen> createState() => _PurchaseFormScreenState();
}

class _PurchaseFormScreenState extends State<PurchaseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _buyerNameController = TextEditingController();
  final _ticketCountController = TextEditingController(text: '1');
  final _cardNumberController = TextEditingController();

  String _paymentMethod = 'Cash';
  bool _isLoading = false;
  double _totalCost = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateTotalCost();
  }

  @override
  void dispose() {
    _buyerNameController.dispose();
    _ticketCountController.dispose();
    _cardNumberController.dispose();
    super.dispose();
  }

  void _calculateTotalCost() {
    final ticketCount = int.tryParse(_ticketCountController.text) ?? 1;
    setState(() {
      _totalCost = ticketCount * widget.schedule.price;
    });
  }

  Future<void> _purchaseTicket() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final user = await AuthService.getCurrentUser();
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mengambil data user. Silakan login kembali.'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => _isLoading = false);
      return;
    }

    final transaction = Transaction(
      id: const Uuid().v4(),
      filmId: widget.film.id,
      filmTitle: widget.film.title,
      filmPoster: widget.film.posterUrl,
      scheduleId: widget.schedule.id,
      scheduleDate: widget.schedule.date,
      scheduleTime: widget.schedule.time,
      studio: widget.schedule.studio,
      buyerName: _buyerNameController.text,
      username: user.username,
      ticketCount: int.parse(_ticketCountController.text),
      purchaseDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      totalCost: _totalCost,
      paymentMethod: _paymentMethod,
      cardNumber: _paymentMethod == 'Kartu' ? _cardNumberController.text : null,
      status: 'selesai',
    );

    await TransactionDatabase.saveTransaction(transaction);

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pembelian tiket berhasil!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(initialIndex: 2),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Beli Tiket'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.film.posterUrl,
                      width: 100,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 100,
                          height: 150,
                          color: AppTheme.tertiaryColor,
                          child: const Icon(Icons.broken_image, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.film.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${widget.schedule.date} • ${widget.schedule.time}',
                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Studio: ${widget.schedule.studio}',
                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Harga: Rp ${widget.schedule.price.toInt()}',
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // =======================
              // NAMA PEMBELI
              // =======================
              TextFormField(
                controller: _buyerNameController,
                validator: Validators.validateBuyerName,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Nama Pembeli',
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Masukkan nama pembeli',
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _ticketCountController,
                validator: Validators.validateTicketCount,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Jumlah Tiket',
                  prefixIcon: Icon(Icons.confirmation_number),
                ),
                onChanged: (_) => _calculateTotalCost(),
              ),

              const SizedBox(height: 16),

              TextFormField(
                initialValue: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Pembelian',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
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
                  DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                  DropdownMenuItem(value: 'Kartu', child: Text('Kartu')),
                ],
                onChanged: (value) {
                  setState(() => _paymentMethod = value!);
                },
              ),

              if (_paymentMethod == 'Kartu') ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cardNumberController,
                  validator: Validators.validateCardNumber,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'Nomor Kartu',
                    prefixIcon: Icon(Icons.credit_card),
                  ),
                ),
              ],

              const SizedBox(height: 30),

              CustomButton(
                text: 'Beli Tiket',
                onPressed: _purchaseTicket,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
