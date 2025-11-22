import 'package:flutter/material.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/screens/film_list_screen.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/screens/purchase_history_screen.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/screens/profile_screen.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/services/auth_service.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/services/home_service.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/theme/app_theme.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/widget/film_card.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/widget/featured_movie_card_baru.dart'; // Import baru
import 'package:utspam_if5a_3012310021_filmbioskop/widget/section_header_baru.dart'; // Import baru

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

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      const HomeTab(),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Daftar Film',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
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
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<dynamic> nowPlayingMovies = [];
  List<dynamic> recommendedMovies = [];
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
          // Featured Movie Section
          if (featuredMovie != null)
            SliverToBoxAdapter(
              child: FeaturedMovieCard(film: featuredMovie),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
          // Now Playing Section
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Sedang Tayang',
              onSeeAllPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FilmListScreen()),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: _buildHorizontalFilmList(nowPlayingMovies),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
          // Recommended Section
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Rekomendasi Film',
              onSeeAllPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FilmListScreen()),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: _buildHorizontalFilmList(recommendedMovies),
          ),
          // Padding di bagian bawah agar tidak mentok
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
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