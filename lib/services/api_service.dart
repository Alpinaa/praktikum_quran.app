import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class ApiService {
  // Base URL tetap menggunakan v2
  static const String baseURL = 'https://equran.id/api/v2';

  Future<ApiResponse<List<Surah>>> getSurahList() async {
    try {
      // PERBAIKAN: Mengganti /surah menjadi /surat
      final response = await http.get(Uri.parse('$baseURL/surat'));

      // Tambahkan print ini untuk memantau proses di Debug Console
      print("Fetching Surah List: Status ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        
        return ApiResponse<List<Surah>>.fromJson(
          jsonMap,
          (dataJson) {
            return (dataJson as List<dynamic>)
                .map((e) => Surah.fromJson(e as Map<String, dynamic>))
                .toList();
          },
        );
      } else {
        return ApiResponse<List<Surah>>(
          code: response.statusCode,
          message: 'Gagal memuat daftar surah dari server.',
        );
      }
    } catch (e) {
      print("Error getSurahList: $e");
      return ApiResponse<List<Surah>>(
        code: 500,
        message: 'Gagal terhubung ke internet: $e',
      );
    }
  }

  Future<ApiResponse<DetailedSurah>> getDetailSurah(int nomorSurah) async {
    try {
      // PERBAIKAN: Mengganti /surah menjadi /surat
      final response = await http.get(Uri.parse('$baseURL/surat/$nomorSurah'));

      print("Fetching Detail Surah $nomorSurah: Status ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);

        return ApiResponse<DetailedSurah>.fromJson(
          jsonMap,
          (dataJson) => DetailedSurah.fromJson(dataJson as Map<String, dynamic>),
        );
      } else {
        return ApiResponse<DetailedSurah>(
          code: response.statusCode,
          message: 'Surah tidak ditemukan.',
        );
      }
    } catch (e) {
      print("Error getDetailSurah: $e");
      return ApiResponse<DetailedSurah>(
        code: 500,
        message: 'Terjadi kesalahan koneksi: $e',
      );
    }
  }
}