import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/surah_provider.dart';

class ListSurahScreen extends StatelessWidget {
  const ListSurahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final surahProvider = Provider.of<SurahProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4), // Mengubah ke background soft abu-hijau biar lebih aesthetic web
      appBar: AppBar(
        title: const Text(
          'Daftar Surah',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: surahProvider.surahList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Center( // MENARUH CONTENT DI TENGAH LAYAR WEB
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800), // MEMBATASI LEBAR DI WEB
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  itemCount: surahProvider.surahList.length,
                  itemBuilder: (context, index) {
                    final surah = surahProvider.surahList[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/surah-detail',
                            arguments: surah.nomor,
                          );
                        },
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20), // Padding diperluas agar lebih lega di web
                          decoration: BoxDecoration(
                            color: Colors.white, // Mengubah warna kartu jadi putih bersih
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(color: const Color(0xFFE8F5E9), width: 1.5),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE8F5E9),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${surah.nomor}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2E7D32),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      surah.nama,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${surah.namaLatin} • ${surah.jumlahAyat} Ayat • ${surah.tempatTurun} • ${surah.arti}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF66BB6A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Color(0xFF4CAF50),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}