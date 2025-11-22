import 'package:flutter/material.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/screens/film_list_screen.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/screens/purchase_history_screen.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/screens/profile_screen.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/services/auth_service.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/services/home_service.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/theme/app_theme.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/widget/film_card.dart';

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
    // --- PERUBAHAN DIMULAI DI SINI ---
    // Pindahkan definisi _screens ke dalam metode build
    // agar _goToHomeTab dapat diakses dengan aman.
    final List<Widget> _screens = [
      const HomeTab(),
      const FilmListScreen(),
      PurchaseHistoryScreen(onBackToHomePressed: _goToHomeTab),
      const ProfileScreen(),
    ];
    // --- PERUBAHAN SELESAI DI SINI ---

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

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nowPlayingMovies = HomeService.getNowPlayingMovies();
    final recommendedMovies = HomeService.getRecommendedMovies();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sedang Tayang',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: nowPlayingMovies.length,
              itemBuilder: (context, index) {
                return FilmCard(film: nowPlayingMovies[index]);
              },
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Rekomendasi Film',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recommendedMovies.length,
              itemBuilder: (context, index) {
                return FilmCard(film: recommendedMovies[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}