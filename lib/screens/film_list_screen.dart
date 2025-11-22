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
    // HAPUS APPBAR DAN SCAFFOLD
    // Kita hanya perlu mengembalikan body-nya saja
    return FutureBuilder<List<Film>>(
      future: Future.value(HomeService.getAllMovies()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerEffect();
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Terjadi kesalahan saat memuat film.',
              style: TextStyle(color: Colors.red),
            ),
          );
        }
        if (snapshot.hasData) {
          final films = snapshot.data!;
          return _buildFilmGrid(films);
        }
        return const Center(
          child: Text(
            'Tidak ada film yang tersedia.',
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  // ... fungsi _buildShimmerEffect dan _buildFilmGrid tetap sama
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
        itemCount: 6,
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