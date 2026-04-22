class Surah {
  final int nomor;
  final String nama;
  final String namaLatin; // Disarankan menggunakan camelCase
  final String jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String deskripsi;
  final Map<String, String> audioFull;

  // Constructor harus di dalam kurung kurawal kelas
  Surah({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    required this.audioFull,
  });

  // Opsional: Menambahkan factory untuk mempermudah parsing data dari JSON/API
  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      nomor: json['nomor'],
      nama: json['nama'],
      namaLatin: json['namaLatin'],
      jumlahAyat: json['jumlahAyat'].toString(),
      tempatTurun: json['tempatTurun'],
      arti: json['arti'],
      deskripsi: json['deskripsi'],
      audioFull: Map<String, String>.from(json['audioFull']),
    );
  }
}