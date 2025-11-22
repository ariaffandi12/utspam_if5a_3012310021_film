import 'package:utspam_if5a_3012310021_filmbioskop/models/film_model.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/models/jadwal_model.dart'; // Pastikan import ini ada

class MovieService {
  static List<Film> getDummyMovies() {
    return [
      Film(
        id: '1',
        title: 'Super Hero Movie',
        genre: 'Action, Comedy',
        duration: '98 min',
        description: 'Parodi dari film-film pahlawan super yang mengisahkan tentang Rick Riker, seorang remaja biasa yang mendapatkan kekuatan super setelah digigit laba-laba yang dimodifikasi secara genetik.',
        posterUrl: 'https://ik.imagekit.io/Ari/Super%20Hero%20Movie.jpg',
        rating: 6.5,
        schedules: [
          Jadwal(id: '1-1', date: '2023-12-25', time: '10:00', studio: 'Studio 1', price: 50000.0),
          Jadwal(id: '1-2', date: '2023-12-25', time: '14:30', studio: 'Studio 2', price: 50000.0),
          Jadwal(id: '1-3', date: '2023-12-26', time: '18:00', studio: 'Studio 3', price: 55000.0),
        ],
      ),
      Film(
        id: '2',
        title: 'Warkop DKI Reborn',
        genre: 'Comedy',
        duration: '120 min',
        description: 'Kisah petualangan terbaru dari trio Dono, Kasino, dan Indro yang kocak dan menggelikan. Mereka kembali beraksi dengan adegan-adegan komedi yang segar.',
        posterUrl: 'https://ik.imagekit.io/Ari/Warkop%20Dki%20Reborn.jpg',
        rating: 7.2,
        schedules: [
          Jadwal(id: '2-1', date: '2023-12-25', time: '11:00', studio: 'Studio 4', price: 45000.0),
          Jadwal(id: '2-2', date: '2023-12-26', time: '13:00', studio: 'Studio 1', price: 45000.0),
          Jadwal(id: '2-3', date: '2023-12-27', time: '19:00', studio: 'Studio 2', price: 50000.0),
        ],
      ),
      Film(
        id: '3',
        title: 'Jadi Tuh Barang',
        genre: 'Comedy, Drama',
        duration: '95 min',
        description: 'Sebuah film komedi lokal yang mengangkat cerita kehidupan sehari-hari dengan sentuhan humor yang segar dan menghibur.',
        posterUrl: 'https://ik.imagekit.io/Ari/Jadi%20Tuh%20Barang.jpeg',
        rating: 6.8,
        schedules: [
          Jadwal(id: '3-1', date: '2023-12-25', time: '13:30', studio: 'Studio 5', price: 45000.0),
          Jadwal(id: '3-2', date: '2023-12-26', time: '16:00', studio: 'Studio 4', price: 45000.0),
          Jadwal(id: '3-3', date: '2023-12-27', time: '20:30', studio: 'Studio 3', price: 50000.0),
        ],
      ),
      Film(
        id: '4',
        title: 'Film Bucin',
        genre: 'Romance, Comedy, Drama',
        duration: '110 min',
        description: 'Mengisahkan tentang perjalanan cinta 4 pasangan dengan karakter yang berbeda. Mereka harus belajar arti cinta sejati di tengah problema hubungan.',
        posterUrl: 'https://ik.imagekit.io/Ari/Film%20Bucin.jpg',
        rating: 7.0,
        schedules: [
          Jadwal(id: '4-1', date: '2023-12-25', time: '15:00', studio: 'Studio 2', price: 50000.0),
          Jadwal(id: '4-2', date: '2023-12-26', time: '17:30', studio: 'Studio 1', price: 50000.0),
          Jadwal(id: '4-3', date: '2023-12-27', time: '20:00', studio: 'Studio 5', price: 55000.0),
        ],
      ),
      Film(
        id: '5',
        title: 'The War Begins',
        genre: 'Action, War',
        duration: '125 min',
        description: 'Film epik yang menggambarkan awal mula sebuah konflik besar. Kisah kepahlawanan, pengorbanan, dan perjuangan demi kemerdekaan.',
        posterUrl: 'https://ik.imagekit.io/Ari/The%20War%20Begins.jpg',
        rating: 7.8,
        schedules: [
          Jadwal(id: '5-1', date: '2023-12-25', time: '17:00', studio: 'Studio 3', price: 60000.0),
          Jadwal(id: '5-2', date: '2023-12-26', time: '19:30', studio: 'Studio 2', price: 60000.0),
          Jadwal(id: '5-3', date: '2023-12-27', time: '21:00', studio: 'Studio 1', price: 65000.0),
        ],
      ),
      Film(
        id: '6',
        title: 'Transformers: Age of Extinction',
        genre: 'Action, Adventure, Sci-Fi',
        duration: '165 min',
        description: 'Ketika umat manusia mengkhianati para Autobot, Optimus Prime dan kawan-kawan harus menyelamatkan Bumi dari ancaman Transformer baru yang lebih berbahaya.',
        posterUrl: 'https://ik.imagekit.io/Ari/Transformers%20Age%20of%20Extinction.jpg',
        rating: 7.1,
        schedules: [
          Jadwal(id: '6-1', date: '2023-12-25', time: '19:00', studio: 'Studio 1', price: 60000.0),
          Jadwal(id: '6-2', date: '2023-12-26', time: '20:00', studio: 'Studio 4', price: 65000.0),
          Jadwal(id: '6-3', date: '2023-12-27', time: '21:30', studio: 'Studio 2', price: 70000.0),
        ],
      ),
      Film(
        id: '7',
        title: 'Sekawan Limo',
        genre: 'Action, Comedy',
        duration: '105 min',
        description: 'Petualangan lima sekawan yang memiliki kemampuan unik. Mereka bersatu untuk menghadapi ancaman yang membahayakan kota mereka.',
        posterUrl: 'https://ik.imagekit.io/Ari/Sekawan%20Limo.jpg',
        rating: 6.9,
        schedules: [
          Jadwal(id: '7-1', date: '2023-12-25', time: '10:30', studio: 'Studio 5', price: 45000.0),
          Jadwal(id: '7-2', date: '2023-12-26', time: '14:00', studio: 'Studio 3', price: 50000.0),
          Jadwal(id: '7-3', date: '2023-12-27', time: '17:00', studio: 'Studio 4', price: 50000.0),
        ],
      ),
      Film(
        id: '8',
        title: 'Merah Putih Memanggil',
        genre: 'Action, War, Drama',
        duration: '115 min',
        description: 'Sebuah film perjuangan yang mengisahkan tentang semangat patriotisme para pejuang dalam mempertahankan kemerdekaan Indonesia dari penjajah.',
        posterUrl: 'https://ik.imagekit.io/Ari/Merah%20Putih%20Memanggile.jpg',
        rating: 8.0,
        schedules: [
          Jadwal(id: '8-1', date: '2023-12-25', time: '12:00', studio: 'Studio 2', price: 55000.0),
          Jadwal(id: '8-2', date: '2023-12-26', time: '15:30', studio: 'Studio 5', price: 55000.0),
          Jadwal(id: '8-3', date: '2023-12-27', time: '18:30', studio: 'Studio 1', price: 60000.0),
        ],
      ),
      Film(
        id: '9',
        title: 'Pinjam 100',
        genre: 'Comedy, Drama',
        duration: '100 min',
        description: 'Kisah lucu tentang seorang pemuda yang nekat meminjam uang dalam jumlah besar untuk sebuah keperluan tak terduga, yang justru membawanya pada petualangan kocak.',
        posterUrl: 'https://ik.imagekit.io/Ari/Pinjam%20100.jpg',
        rating: 6.7,
        schedules: [
          Jadwal(id: '9-1', date: '2023-12-25', time: '11:30', studio: 'Studio 3', price: 45000.0),
          Jadwal(id: '9-2', date: '2023-12-26', time: '13:30', studio: 'Studio 4', price: 45000.0),
          Jadwal(id: '9-3', date: '2023-12-27', time: '16:30', studio: 'Studio 5', price: 50000.0),
        ],
      ),
      Film(
        id: '10',
        title: 'Transformers: Rise of the Beasts',
        genre: 'Action, Adventure, Sci-Fi',
        duration: '127 min',
        description: 'Optimus Prime dan para Autobot memulai petualangan baru dan bertemu dengan Maximals, yang akan membantu mereka menghadapi ancaman dari masa lalu.',
        posterUrl: 'https://ik.imagekit.io/Ari/Transformers%20Rise%20Of%20the%20Beasts.jpg',
        rating: 7.5,
        schedules: [
          Jadwal(id: '10-1', date: '2023-12-25', time: '20:00', studio: 'Studio 1', price: 65000.0),
          Jadwal(id: '10-2', date: '2023-12-26', time: '21:00', studio: 'Studio 2', price: 70000.0),
          Jadwal(id: '10-3', date: '2023-12-27', time: '22:00', studio: 'Studio 3', price: 75000.0),
        ],
      ),
    ];
  }
}