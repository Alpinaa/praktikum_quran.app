import 'surah.dart';
import 'ayah.dart';

class DetailedSurah extends Surah {
  final List<Ayah> ayat;

  DetailedSurah({
    required super.nomor,
    required super.nama,
    required super.namaLatin,
    required super.jumlahAyat,
    required super.tempatTurun,
    required super.arti,
    required super.deskripsi,
    required super.audioFull,
    required this.ayat,
  });

  factory DetailedSurah.fromJson(Map<String, dynamic> json) {
    return DetailedSurah(
      nomor: json['nomor'] as int? ?? 0,
      nama: json['nama'] as String? ?? '',
      namaLatin: json['namaLatin'] as String? ?? '',
      jumlahAyat: json['jumlahAyat']?.toString() ?? '',
      tempatTurun: json['tempatTurun'] as String? ?? '',
      arti: json['arti'] as String? ?? '',
      deskripsi: json['deskripsi'] as String? ?? '',
      audioFull: (json['audioFull'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, value.toString()),
      ).cast<String, String>() ?? {},
      ayat: (json['ayat'] as List<dynamic>?)
          ?.map((ayat) => Ayah.fromJson(ayat as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}