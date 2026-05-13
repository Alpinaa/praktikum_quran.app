import 'surah.dart';

class ApiResponse<T> {
  final int code;
  final String message;
  final T? data;

  ApiResponse({
    required this.code,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Object?) fromJsonT) {
    return ApiResponse(
      code: json['code'] as int,
      message: json['message'] as String,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}

class SurahListResponse {
  final List<Surah> surahList;

  SurahListResponse({required this.surahList});

  factory SurahListResponse.fromJson(List<dynamic> json) {
    return SurahListResponse(
      surahList: json.map((item) => Surah.fromJson(item)).toList(),
    );
  }
}