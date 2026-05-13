import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../models/surah.dart'; 

class ListSurahScreen extends StatelessWidget {
  const ListSurahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final surahProvider = Provider.of<SurahProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Daftar Surah'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: surahProvider.surahList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: surahProvider.surahList.length,
              itemBuilder: (context, index) {
                final surah = surahProvider.surahList[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/surah-detail',
                        arguments: surah.nomor,
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9), // Background Card Hijau Muda
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          // --- NOMOR DALAM BULATAN HIJAU SOFT ---
                          Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                              color: Color(0xFFC8E6C9), // Bulatan Hijau Soft
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${surah.nomor}',
                                style: const TextStyle(
                                  fontSize: 12, // Angka dikecilkan
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E7D32), // Angka Hijau Gelap agar kontras
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // --- TEKS UTAMA ---
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // NAMA ARAB: HITAM BOLD
                                Text(
                                  surah.nama,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                // DETAIL TEKS: HIJAU SOFT (Sesuai image_63a341.png)
                                Text(
                                  '${surah.namaLatin} . ${surah.jumlahAyat} Ayat . ${surah.tempatTurun} . ${surah.arti}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF81C784), // Hijau Soft
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Tanda Panah ">"
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
    );
  }
}