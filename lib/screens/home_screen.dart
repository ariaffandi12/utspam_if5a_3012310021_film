import 'package:flutter/material.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/models/film_model.dart'; // <-- TAMBAHKAN IMPORT INI
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

  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      HomeTab(
        key: ValueKey(_currentIndex),
        onSeeAllPressed: () => _changeTab(1),
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
class HomeTab extends StatefulWidget {
  final VoidCallback? onSeeAllPressed;

  const HomeTab({Key? key, this.onSeeAllPressed}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  // --- PERBAIKAN TIPE DATA DI SINI ---
  List<Film> nowPlayingMovies = [];
  List<Film> recommendedMovies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      nowPlayingMovies = HomeService.getNowPlayingMovies();
      recommendedMovies = HomeService.getRecommendedMovies();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor));
    }

    final featuredMovie = nowPlayingMovies.isNotEmpty ? nowPlayingMovies.first : null;

    return RefreshIndicator(
      onRefresh: _loadMovies,
      color: AppTheme.primaryColor,
      child: CustomScrollView(
        slivers: [
          if (featuredMovie != null)
            SliverToBoxAdapter(
              child: FeaturedMovieCard(film: featuredMovie),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
          if (nowPlayingMovies.isNotEmpty)
            SliverToBoxAdapter(
              child: _buildSectionCard(
                title: 'Sedang Tayang',
                films: nowPlayingMovies,
                onSeeAllPressed: widget.onSeeAllPressed,
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
          if (recommendedMovies.isNotEmpty)
            SliverToBoxAdapter(
              child: _buildSectionCard(
                title: 'Rekomendasi Film',
                films: recommendedMovies,
                onSeeAllPressed: widget.onSeeAllPressed,
              ),
            ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Film> films, // Tipe juga disesuaikan
    VoidCallback? onSeeAllPressed,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.tertiaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: title,
            onSeeAllPressed: onSeeAllPressed,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: films.length,
              itemBuilder: (context, index) {
                return FilmCard(film: films[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}