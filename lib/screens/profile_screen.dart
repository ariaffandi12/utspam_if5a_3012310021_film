import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/screens/login_screen.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/services/auth_service.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/theme/app_theme.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/widget/custom_button.dart';

// --- UBAH MENJADI STATELESSWIDGET ---
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    await AuthService.logout();
    
    // Arahkan pengguna kembali ke layar login dan hapus semua riwayat navigasi
    Navigator.pushAndRemoveUntil(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        child: const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan FutureBuilder untuk menangani pemuatan data user
    return FutureBuilder(
      future: AuthService.getCurrentUser(),
      builder: (context, snapshot) {
        // --- State 1: Sedang Memuat ---
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          );
        }
        // --- State 2: Data Selesai Dimuat ---
        if (snapshot.hasData) {
          final user = snapshot.data!;
          return _buildProfileContent(context, user);
        }
        // --- State Default: Tidak ada data ---
        return const Center(
          child: Text(
            'Data pengguna tidak ditemukan.',
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  // Widget untuk menampilkan konten profil
  Widget _buildProfileContent(BuildContext context, Map<String, dynamic> user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Bagian Avatar dan Nama
          Center(
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user['fullName'] ?? 'User',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '@${user['username'] ?? 'user'}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          // Bagian Informasi Pribadi
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Informasi Pribadi',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            icon: Icons.email,
            label: 'Email',
            value: user['email'] ?? 'Tidak ada data',
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.location_on,
            label: 'Alamat',
            value: user['address'] ?? 'Tidak ada data',
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.phone,
            label: 'Nomor Telepon',
            value: user['phoneNumber'] ?? 'Tidak ada data',
          ),
          const SizedBox(height: 40),
          // Tombol Logout
          CustomButton(
            text: 'Logout',
            onPressed: () => _logout(context),
            backgroundColor: Colors.red,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Widget helper untuk membuat kartu informasi
  Widget _buildInfoCard({required IconData icon, required String label, required String value}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.tertiaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}