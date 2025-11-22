class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    
    // Check if email ends with @gmail.com
    if (!value.endsWith('@gmail.com')) {
      return 'Email harus menggunakan domain @gmail.com';
    }
    
    // Basic email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    
    if (value != password) {
      return 'Konfirmasi password tidak cocok';
    }
    
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    
    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username tidak boleh kosong';
    }
    
    return null;
  }

  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Alamat tidak boleh kosong';
    }
    
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    
    // Check if phone number contains only digits
    final phoneRegex = RegExp(r'^[0-9]+$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Nomor telepon hanya boleh berisi angka';
    }
    
    return null;
  }

  static String? validateTicketCount(String? value) {
    if (value == null || value.isEmpty) {
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

  static String? validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor kartu tidak boleh kosong';
    }
    
    // Check if card number contains only digits
    final cardRegex = RegExp(r'^[0-9]+$');
    if (!cardRegex.hasMatch(value)) {
      return 'Nomor kartu hanya boleh berisi angka';
    }
    
    if (value.length != 16) {
      return 'Nomor kartu harus 16 digit';
    }
    
    return null;
  }
    // ... fungsi validator lainnya

  static String? validateBuyerName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama pembeli wajib diisi';
    }

    // Periksa apakah nama mengandung angka
    if (value.contains(RegExp(r'[0-9]'))) {
      return 'Nama tidak boleh mengandung angka';
    }

    return null;
  }

  // ... fungsi validator lainnya



}