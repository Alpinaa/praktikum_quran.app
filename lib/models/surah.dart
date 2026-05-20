class Surah {
  final int nomor;
  final String nama;
  final String namaLatin; 
  final String jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String deskripsi;
  final Map<String, String> audioFull;

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

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      nomor: json['nomor'],
      nama: json['nama'],
      namaLatin: json['namaLatin'],
      jumlahAyat: json['jumlahAyat'].toString(),
      tempatTurun: json['tempatTurun'],
      arti: json['arti'],
      deskripsi: json['deskripsi'],
      // Perubahan di sini: Ditambahkan validasi null-safety dengan ?? {}
      audioFull: json['audioFull'] != null 
          ? Map<String, String>.from(json['audioFull']) 
          : {},
    );
  }
}