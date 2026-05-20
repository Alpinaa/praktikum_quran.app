import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/providers.dart';
import 'screens/screens.dart';
// Pastikan DetailSurahScreen sudah terekspor di dalam screens.dart, 
// atau jika belum, kamu bisa import manual: import 'screens/detail_surah_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SurahProvider()..fetchSurahList(),
      child: MaterialApp(
        title: 'Quran App',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true, // Opsional: Agar tampilan UI lebih modern
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const ListSurahScreen(),
          '/surah-detail': (context) {
            // 1. Ambil argumen nomor surah yang dikirim saat kartu surah diklik
            final surahNumber = ModalRoute.of(context)!.settings.arguments as int;
            
            // 2. Kembalikan ke halaman DetailSurahScreen yang asli dengan membawa surahNumber
            return DetailSurahScreen(surahNumber: surahNumber);
          },
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}