import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../providers/surah_provider.dart';

class DetailSurahScreen extends StatefulWidget {
  final int surahNumber;

  const DetailSurahScreen({super.key, required this.surahNumber});

  @override
  State<DetailSurahScreen> createState() => _DetailSurahScreenState();
}

class _DetailSurahScreenState extends State<DetailSurahScreen> {
  late final AudioPlayer _audioPlayer;
  
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();
  
  bool _isPlayingFullSurah = false;
  int _currentHighlightAyatIndex = -1; 

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    
    Future.microtask(() {
      if (!mounted) return;
      Provider.of<SurahProvider>(context, listen: false)
          .fetchSurahDetail(widget.surahNumber);
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        _playNextAyat();
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playNextAyat() {
    final provider = Provider.of<SurahProvider>(context, listen: false);
    final details = provider.selectedSurah;
    if (details == null) return;

    int nextIndex = _currentHighlightAyatIndex + 1;

    if (nextIndex < details.ayat.length) {
      setState(() {
        _currentHighlightAyatIndex = nextIndex;
      });
      
      final nextAudioUrl = details.ayat[nextIndex].audio.values.first;
      _audioPlayer.play(UrlSource(nextAudioUrl));
      
      _scrollToActiveAyat(nextIndex);
    } else {
      setState(() {
        _isPlayingFullSurah = false;
        _currentHighlightAyatIndex = -1;
      });
    }
  }

  void _toggleAudioAyat(int index, String audioUrl) async {
    try {
      if (_currentHighlightAyatIndex == index && _isPlayingFullSurah) {
        await _audioPlayer.stop();
        setState(() {
          _isPlayingFullSurah = false;
          _currentHighlightAyatIndex = -1;
        });
      } else {
        await _audioPlayer.stop();
        setState(() {
          _isPlayingFullSurah = true;
          _currentHighlightAyatIndex = index;
        });
        await _audioPlayer.play(UrlSource(audioUrl));
        _scrollToActiveAyat(index);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memutar audio: $e")),
      );
    }
  }

  void _toggleFullSurahAudio() async {
    final provider = Provider.of<SurahProvider>(context, listen: false);
    final details = provider.selectedSurah;
    if (details == null || details.ayat.isEmpty) return;

    if (_isPlayingFullSurah) {
      await _audioPlayer.stop();
      setState(() {
        _isPlayingFullSurah = false;
        _currentHighlightAyatIndex = -1;
      });
    } else {
      await _audioPlayer.stop();
      setState(() {
        _isPlayingFullSurah = true;
        _currentHighlightAyatIndex = 0;
      });
      final firstAudioUrl = details.ayat[0].audio.values.first;
      await _audioPlayer.play(UrlSource(firstAudioUrl));
      _scrollToActiveAyat(0);
    }
  }

  void _scrollToActiveAyat(int index) {
    _itemScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
      alignment: 0.35, 
    );
  }

  Widget _buildInfoColumn(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12), 
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24, width: 0.8),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const quranThemeColor = Color(0xFF0D5C46); 

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F7),
      appBar: AppBar(
        title: Consumer<SurahProvider>(
          builder: (context, provider, child) {
            final details = provider.selectedSurah;
            return Text(details != null ? details.namaLatin : 'Memuat...',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18));
          },
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: quranThemeColor,
        foregroundColor: Colors.white,
      ),
      body: Consumer<SurahProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) return const Center(child: CircularProgressIndicator());
          if (provider.errorMessage.isNotEmpty) return Center(child: Text(provider.errorMessage));

          final details = provider.selectedSurah;
          if (details == null) return const Center(child: Text('Data tidak tersedia.'));

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800), 
              child: Column(
                children: [
                  // --- HEADER INFO ---
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16), 
                    decoration: BoxDecoration(
                      color: quranThemeColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          details.nama, 
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)
                        ),
                        const SizedBox(height: 2),
                        Text(
                          details.namaLatin, 
                          style: TextStyle(fontSize: 15, color: Colors.white.withOpacity(0.7), fontWeight: FontWeight.w500)
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildInfoColumn('${details.jumlahAyat} Ayat'),
                            _buildInfoColumn(details.tempatTurun == 'Mecca' ? 'Mekah' : 'Madinah'),
                            _buildInfoColumn(details.arti),
                          ],
                        ),
                        const SizedBox(height: 12),
                        
                        // --- TOMBOL: DENGARKAN SURAH ---
                        InkWell(
                          onTap: _toggleFullSurahAudio,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), 
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _isPlayingFullSurah ? Icons.stop_rounded : Icons.play_arrow_rounded,
                                  color: quranThemeColor,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _isPlayingFullSurah ? 'Berhenti' : 'Dengarkan Surah',
                                  style: const TextStyle(color: quranThemeColor, fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 6),
                        const Divider(color: Colors.white24, height: 12),
                        
                        // --- DROPDOWN: DESKRIPSI SURAH ---
                        Theme(
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            tilePadding: const EdgeInsets.symmetric(horizontal: 4),
                            title: const Text('Deskripsi Surat', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                            iconColor: Colors.white,
                            collapsedIconColor: Colors.white,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(4, 2, 4, 8),
                                child: Text(
                                  details.deskripsi.replaceAll(RegExp(r'<[^>]*>'), ''),
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(color: Colors.white24, height: 12),
                        const SizedBox(height: 4),
                        const Text('Daftar Ayat', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                  ),
                  
                  // --- DAFTAR AYAT ---
                  Expanded(
                    child: ScrollablePositionedList.separated(
                      itemScrollController: _itemScrollController,
                      itemPositionsListener: _itemPositionsListener,
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                      itemCount: details.ayat.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final ayat = details.ayat[index];
                        final bool isCurrentAyat = _currentHighlightAyatIndex == index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isCurrentAyat ? const Color(0xFFF0F7F5) : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: isCurrentAyat ? Border.all(color: quranThemeColor, width: 1) : null,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 11, 
                                    backgroundColor: isCurrentAyat ? quranThemeColor : const Color(0xFFE8F1ED),
                                    child: Text('${ayat.nomorAyat}', style: TextStyle(fontSize: 9, color: isCurrentAyat ? Colors.white : quranThemeColor, fontWeight: FontWeight.bold))
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(child: Text(ayat.teksArab, textAlign: TextAlign.right, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, height: 1.8, color: isCurrentAyat ? quranThemeColor : Colors.black87))),
                                ],
                              ),
                              const SizedBox(height: 12),
                              
                              // --- TAMBAHAN TEKS LATIN PER AYAT ---
                              Text(
                                ayat.teksLatin,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic, // Dibuat miring agar membedakan dari terjemahan
                                  color: isCurrentAyat ? const Color(0xFF0D5C46) : Colors.black87,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 6),
                              
                              // --- TEKS TERJEMAHAN INDONESIA ---
                              Text(
                                ayat.teksIndonesia, 
                                style: const TextStyle(
                                  fontSize: 13, 
                                  color: Colors.black54, 
                                  height: 1.4
                                )
                              ),
                              const Divider(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () => _toggleAudioAyat(index, ayat.audio.values.first),
                                    icon: Icon(isCurrentAyat && _isPlayingFullSurah ? Icons.stop_circle_outlined : Icons.play_circle_outline, color: quranThemeColor, size: 22),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}