import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/models/user_model.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/screens/login_screen.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/services/auth_service.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/theme/app_theme.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/widget/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    // Tampilkan dialog konfirmasi sebelum logout
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ya'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await AuthService.logout();
    
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
    return FutureBuilder<User?>(
      future: AuthService.getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          final user = snapshot.data!;
          return _buildProfileContent(context, user);
        }
        return const Center(
          child: Text(
            'Data pengguna tidak ditemukan.',
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildProfileContent(BuildContext context, User user) {
    return CustomScrollView(
      slivers: [
        // Bagian Header dengan Avatar dan Nama
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.tertiaryColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.fullName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '@${user.username}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
        // Bagian Informasi Pribadi
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppTheme.tertiaryColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Informasi Pribadi',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildInfoTile(
                  icon: Icons.email,
                  label: 'Email',
                  value: user.email,
                ),
                _buildInfoTile(
                  icon: Icons.location_on,
                  label: 'Alamat',
                  value: user.address,
                ),
                _buildInfoTile(
                  icon: Icons.phone,
                  label: 'Nomor Telepon',
                  value: user.phoneNumber,
                  showBottomBorder: false, // Hilangkan garis bawah di item terakhir
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
        // Bagian Tombol Logout
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomButton(
              text: 'Logout',
              onPressed: () => _logout(context),
              backgroundColor: Colors.red,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)), // Padding di bawah
      ],
    );
  }

  // Widget helper untuk membuat ListTile informasi
  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    bool showBottomBorder = true,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: AppTheme.primaryColor),
          title: Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          subtitle: Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
        if (showBottomBorder)
          Padding(
            padding: const EdgeInsets.only(left: 72.0), // Sejajarkan dengan teks subtitle
            child: Divider(
              height: 1,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
      ],
    );
  }
}