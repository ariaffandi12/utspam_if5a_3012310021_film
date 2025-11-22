import 'package:flutter/material.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/theme/app_theme.dart';

class BackgroundPattern extends StatelessWidget {
  final Widget child;

  const BackgroundPattern({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        // Gradien latar belakang yang lebih dalam
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A1A2E), // Ungu tua
            Color(0xFF16213E), // Biru tua
            Color(0xFF0F3460), // Biru lebih tua
            AppTheme.backgroundColor, // Warna tema dasar
          ],
        ),
      ),
      // Tambahkan overlay untuk memberikan efek 'noise' atau tekstur
      child: Stack(
        children: [
          // Anda bisa menambahkan gambar pola di sini jika ingin
          // Image.asset(..., repeat: ImageRepeat.repeat, opacity: 0.05),
          child,
        ],
      ),
    );
  }
}