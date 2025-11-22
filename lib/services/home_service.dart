import 'package:utspam_if5a_3012310021_filmbioskop/models/film_model.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/services/movie_service.dart';

class HomeService {
  static List<Film> getNowPlayingMovies() {
    final allMovies = MovieService.getDummyMovies();
    // Return first 5 movies as "now playing"
    return allMovies.take(5).toList();
  }

  static List<Film> getRecommendedMovies() {
    final allMovies = MovieService.getDummyMovies();
    // Return movies with rating >= 7.5 as "recommended"
    return allMovies.where((movie) => movie.rating >= 7.5).toList();
  }

  static List<Film> getAllMovies() {
    return MovieService.getDummyMovies();
  }

  static Film? getMovieById(String id) {
    try {
      return MovieService.getDummyMovies().firstWhere((movie) => movie.id == id);
    } catch (e) {
      return null;
    }
  }
}