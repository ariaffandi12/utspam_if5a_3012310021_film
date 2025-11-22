import 'package:flutter/material.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/screens/film_list_screen.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/screens/purchase_history_screen.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/screens/profile_screen.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/services/auth_service.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/services/home_service.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/theme/app_theme.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/widget/film_card.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/widget/featured_movie_card_baru.dart';

import 'package:utspam_if5a_3012310021_filmbioskop/widget/section_header_baru.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;

  const HomeScreen({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentIndex;
  String? _username;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final username = await AuthService.getCurrentUsername();
    if (mounted) {
      setState(() {
        _username = username;
      });
    }
  }

  void _goToHomeTab() {
    setState(() {
      _currentIndex = 0;
    });
  }

  // Fungsi untuk mengubah tab
  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      // Kirim fungsi _changeTab ke HomeTab
      HomeTab(
        key: ValueKey(_currentIndex),
        onSeeAllPressed: () => _changeTab(1), // 1 adalah index untuk 'Daftar Film'
      ),
      const FilmListScreen(),
      PurchaseHistoryScreen(onBackToHomePressed: _goToHomeTab),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(_currentIndex == 0
            ? 'Selamat Datang, ${_username ?? 'User'}'
            : _getAppBarTitle()),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.secondaryColor,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Daftar Film'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 1:
        return 'Daftar Film';
      case 2:
        return 'Riwayat Pembelian';
      case 3:
        return 'Profil';
      default:
        return 'Beranda';
    }
  }
}

// --- HOME TAB YANG DIPERBAIKI ---
class HomeTab extends StatelessWidget {
  final VoidCallback? onSeeAllPressed; // Terima callback

  const HomeTab({Key? key, this.onSeeAllPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ... kode untuk memuat film tetap sama
    List<dynamic> nowPlayingMovies = HomeService.getNowPlayingMovies();
    List<dynamic> recommendedMovies = HomeService.getRecommendedMovies();

    return RefreshIndicator(
      onRefresh: () async {}, // Tetap biarkan bisa refresh
      color: AppTheme.primaryColor,
      child: CustomScrollView(
        slivers: [
          // ... bagian Featured Movie
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Sedang Tayang',
              onSeeAllPressed: onSeeAllPressed, // Gunakan callback di sini
            ),
          ),
          SliverToBoxAdapter(child: _buildHorizontalFilmList(nowPlayingMovies)),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Rekomendasi Film',
              onSeeAllPressed: onSeeAllPressed, // Dan di sini
            ),
          ),
          SliverToBoxAdapter(child: _buildHorizontalFilmList(recommendedMovies)),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildHorizontalFilmList(List films) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: films.length,
        itemBuilder: (context, index) {
          return FilmCard(film: films[index]);
        },
      ),
    );
  }
}