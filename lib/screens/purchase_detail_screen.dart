import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/database/transaction_database.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/models/transaction_model.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/screens/edit_purchase_screen.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/theme/app_theme.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/widget/custom_button.dart';

class PurchaseDetailScreen extends StatefulWidget {
  final Transaction transaction;

  const PurchaseDetailScreen({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  State<PurchaseDetailScreen> createState() => _PurchaseDetailScreenState();
}

class _PurchaseDetailScreenState extends State<PurchaseDetailScreen> {
  // Variabel untuk menyimpan data transaksi yang bisa berubah (status, dll)
  late Transaction _transaction;

  @override
  void initState() {
    super.initState();
    // Inisialisasi variabel state dengan data dari widget
    _transaction = widget.transaction;
  }

  /// Fungsi untuk membatalkan transaksi
  Future<void> _cancelTransaction() async {
    // Tampilkan dialog konfirmasi terlebih dahulu
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Batalkan Pembelian'),
        content: const Text('Apakah Anda yakin ingin membatalkan pembelian tiket ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Batal
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Ya
            child: const Text('Ya'),
          ),
        ],
      ),
    );

    // Jika pengguna menekan "Tidak" atau menutup dialog, jangan lakukan apa-apa
    if (confirm != true) {
      return;
    }

    // Buat objek transaksi baru dengan status 'dibatalkan'
    final updatedTransaction = Transaction(
      id: _transaction.id,
      filmId: _transaction.filmId,
      filmTitle: _transaction.filmTitle,
      filmPoster: _transaction.filmPoster,
      scheduleId: _transaction.scheduleId,
      scheduleDate: _transaction.scheduleDate,
      scheduleTime: _transaction.scheduleTime,
      studio: _transaction.studio,
      buyerName: _transaction.buyerName,
      ticketCount: _transaction.ticketCount,
      purchaseDate: _transaction.purchaseDate,
      totalCost: _transaction.totalCost,
      paymentMethod: _transaction.paymentMethod,
      cardNumber: _transaction.cardNumber,
      status: 'dibatalkan', // Ubah status
    );

    // Simpan perubahan ke database lokal
    await TransactionDatabase.updateTransaction(updatedTransaction);

    // Tampilkan snackbar sukses
    if (mounted) { // Pastikan widget masih ada
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pembelian tiket berhasil dibatalkan.'),
          backgroundColor: Colors.green,
        ),
      );
    }

    // Kembali ke layar sebelumnya (PurchaseHistoryScreen)
    // Ini akan memicu build ulang PurchaseHistoryScreen jika menggunakan metode async/await
    Navigator.pop(context);
  }

  /// Fungsi untuk menangani navigasi ke layar edit
  Future<void> _editTransaction() async {
    // Navigasi ke layar edit dan tunggu hasilnya
    final result = await Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: EditPurchaseScreen(transaction: _transaction),
      ),
    );

    // Jika ada hasil yang dikembalikan (data transaksi yang diperbarui)
    if (result != null && result is Transaction) {
      // Perbarui state di layar ini agar perubahan langsung terlihat
      setState(() {
        _transaction = result;
      });
    }
  }

  /// Fungsi untuk menyembunyikan sebagian nomor kartu
  String _maskCardNumber(String? cardNumber) {
    if (cardNumber == null || cardNumber.isEmpty) return '-';
    // Tampilkan 4 digit terakhir
    final masked = '*' * (cardNumber.length - 4) + cardNumber.substring(cardNumber.length - 4);
    return masked;
  }

  /// Fungsi helper untuk membuat baris detail
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140, // Lebarkan sedikit untuk label yang lebih panjang
            child: Text(
              '$label:',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Fungsi untuk mendapatkan warna berdasarkan status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'selesai':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'dibatalkan':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Detail Pembelian'),
        // Tombol kembali otomatis ada di sini
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Poster dan Detail Film
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    _transaction.filmPoster,
                    width: 100,
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Tampilkan ikon error jika gambar gagal dimuat
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
                        _transaction.filmTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_transaction.scheduleDate} • ${_transaction.scheduleTime}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Studio: ${_transaction.studio}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Status akan diperbarui secara real-time jika ada perubahan
                      Row(
                        children: [
                          const Text(
                            'Status: ',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            _transaction.status,
                            style: TextStyle(
                              color: _getStatusColor(_transaction.status),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Bagian Detail Pembelian
            const Text(
              'Detail Pembelian',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('ID Transaksi', _transaction.id),
            _buildDetailRow('Nama Pembeli', _transaction.buyerName),
            _buildDetailRow('Jumlah Tiket', '${_transaction.ticketCount} tiket'),
            _buildDetailRow('Tanggal Pembelian', _transaction.purchaseDate),
            _buildDetailRow('Total Biaya', 'Rp ${_transaction.totalCost.toInt()}'),
            _buildDetailRow('Metode Pembayaran', _transaction.paymentMethod),
            if (_transaction.paymentMethod == 'Kartu')
              _buildDetailRow('Nomor Kartu', _maskCardNumber(_transaction.cardNumber)),
            const SizedBox(height: 30),
            // Tombol Aksi (hanya muncul jika status 'selesai')
            if (_transaction.status == 'selesai') ...[
              CustomButton(
                text: 'Edit',
                onPressed: _editTransaction,
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Batalkan',
                onPressed: _cancelTransaction,
                backgroundColor: Colors.red,
              ),
              const SizedBox(height: 16),
            ],
            // --- TOMBOL KEMBALI YANG DITAMBAHKAN ---
            CustomButton(
              text: 'Kembali',
              onPressed: () {
                Navigator.pop(context);
              },
              // Gunakan warna yang lebih netral agar tidak menonjol seperti aksi utama
              backgroundColor: AppTheme.tertiaryColor, 
            ),
          ],
        ),
      ),
    );
  }
}