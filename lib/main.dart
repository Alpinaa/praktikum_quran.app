import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/providers.dart';
import 'screens/screens.dart';

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
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const ListSurahScreen(),
          '/surah-detail': (context) {
            final surahNumber =
                ModalRoute.of(context)!.settings.arguments as int;
            return DetailSurahScreen(surahNumber: surahNumber);
          },
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}