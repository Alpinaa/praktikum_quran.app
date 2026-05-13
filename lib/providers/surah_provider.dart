import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/api_service.dart';

class SurahProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Surah> _surahList = [];
  List<Surah> get surahList => _surahList;

  DetailedSurah? _selectedSurah;
  DetailedSurah? get selectedSurah => _selectedSurah;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> fetchSurahList() async {
    _isLoading = true;
    _errorMessage = ''; // Reset pesan error setiap kali mulai
    notifyListeners();

    try {
      final response = await _apiService.getSurahList();

      if (response.code == 200 && response.data != null) {
        _surahList = response.data!;
        _errorMessage = '';
      } else {
        _errorMessage = response.message;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: $e';
    } finally {
      // Baris ini akan selalu dijalankan, sehingga loading akan berhenti
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSurahDetail(int surahNumber) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _apiService.getDetailSurah(surahNumber);

      if (response.code == 200 && response.data != null) {
        _selectedSurah = response.data;
        _errorMessage = '';
      } else {
        _errorMessage = response.message;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan detail: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSelectedSurah() {
    _selectedSurah = null;
    notifyListeners();
  }
}