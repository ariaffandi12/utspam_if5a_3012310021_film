class Validators {
  // ====================== EMAIL ======================
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }

    if (!value.endsWith('@gmail.com')) {
      return 'Email harus menggunakan domain @gmail.com';
    }

    final emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }

    return null;
  }

  // ====================== PASSWORD ======================
  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password tidak boleh kosong';
    }

    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }

    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.trim().isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }

    if (value != password) {
      return 'Konfirmasi password tidak cocok';
    }

    return null;
  }

  // ====================== NAMA UMUM ======================
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    return null;
  }

  // ====================== USERNAME ======================
  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username tidak boleh kosong';
    }
    return null;
  }

  // ====================== ALAMAT ======================
  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Alamat tidak boleh kosong';
    }
    return null;
  }

  // ====================== NOMOR TELEPON ======================
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }

    final phoneRegex = RegExp(r'^[0-9]+$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Nomor telepon hanya boleh berisi angka';
    }

    return null;
  }

  // ====================== JUMLAH TIKET ======================
  static String? validateTicketCount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Jumlah tiket tidak boleh kosong';
    }

    final ticketCount = int.tryParse(value);
    if (ticketCount == null) {
      return 'Jumlah tiket harus berupa angka';
    }

    if (ticketCount <= 0) {
      return 'Jumlah tiket harus lebih dari 0';
    }

    return null;
  }

  // ====================== NOMOR KARTU ======================
  static String? validateCardNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor kartu tidak boleh kosong';
    }

    final cardRegex = RegExp(r'^[0-9]+$');
    if (!cardRegex.hasMatch(value)) {
      return 'Nomor kartu hanya boleh berisi angka';
    }

    if (value.length != 16) {
      return 'Nomor kartu harus 16 digit';
    }

    return null;
  }

  // ====================== NAMA PEMBELI ======================
  static String? validateBuyerName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama pembeli wajib diisi';
    }

    // Perbolehkan hanya huruf dan spasi
    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameRegex.hasMatch(value)) {
      return 'Nama hanya boleh berisi huruf';
    }

    if (value.trim().length < 3) {
      return 'Nama terlalu pendek';
    }

    return null;
  }
}
