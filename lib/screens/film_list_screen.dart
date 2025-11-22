import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/models/film_model.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/screens/film_schedule_screen.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/services/home_service.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/theme/app_theme.dart';

class FilmListScreen extends StatelessWidget {
  const FilmListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Menggunakan FutureBuilder untuk menangani pemuatan data secara asynchronous
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      // --- TAMBAHKAN APPBAR INI ---
      appBar: AppBar(
        title: const Text(''),
        centerTitle: true,
        // automaticallyImplyLeading bernilai true secara default,
        // jadi tombol kembali akan muncul otomatis.
      ),
      // ------------------------------------
      body: FutureBuilder<List<Film>>(
        // Bungkus pemanggilan sinkron ke dalam Future.value()
        future: Future.value(HomeService.getAllMovies()),
        builder: (context, snapshot) {
          // --- State 1: Sedang Memuat ---
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerEffect();
          }
          // --- State 2: Terjadi Error ---
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Terjadi kesalahan saat memuat film.',
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          // --- State 3: Data Selesai Dimuat ---
          if (snapshot.hasData) {
            final films = snapshot.data!;
            return _buildFilmGrid(films);
          }
          // --- State Default: Tidak ada data ---
          return const Center(
            child: Text(
              'Tidak ada film yang tersedia.',
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  // Widget untuk menampilkan efek shimmer saat loading
  Widget _buildShimmerEffect() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 6, // Jumlah placeholder shimmer
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: AppTheme.tertiaryColor,
            highlightColor: AppTheme.secondaryColor,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.tertiaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget untuk menampilkan grid film
  Widget _buildFilmGrid(List<Film> films) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: films.length,
        itemBuilder: (context, index) {
          final film = films[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FilmScheduleScreen(film: film),
                ),
              );
            },
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Image.network(
                      film.posterUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          color: AppTheme.tertiaryColor,
                          child: const Icon(Icons.broken_image, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          film.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              film.rating.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}