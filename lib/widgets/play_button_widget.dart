import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayButtonWidget extends StatefulWidget {
  final String audioPath;

  const PlayButtonWidget({
    Key? key,
    required this.audioPath,
  }) : super(key: key);

  @override
  State<PlayButtonWidget> createState() => _PlayButtonWidgetState();
}

class _PlayButtonWidgetState extends State<PlayButtonWidget> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _loadAudio();

  }

  Future<void> _loadAudio() async {
    try {
      debugPrint('Yüklenen ses dosyası: ${widget.audioPath}');
      await _audioPlayer.setAsset(widget.audioPath);
      debugPrint('Ses dosyası başarıyla yüklendi');
      // Ses dosyası bittiğinde _isPlaying'i false yap
      _audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            _isPlaying = false;
            _isPaused = false;
          });
        }
      });
    } catch (e) {
      debugPrint('Ses dosyası yüklenirken hata: $e');
    }
  }

  Future play() async {
    setState(() {
      _isPlaying = true;
    });
    await _audioPlayer.seek(Duration.zero);
    await _audioPlayer.play();
  }

  Future pause() async {
    setState(() {
      _isPlaying = false;
      _isPaused = true;
    });
    await _audioPlayer.pause();
  }
  
  Future resume() async {
    setState(() {
      _isPlaying = true;
      _isPaused = false;
    });
    await _audioPlayer.play();
  }

  @override
  void didUpdateWidget(PlayButtonWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.audioPath != widget.audioPath) {
      _loadAudio();
    }
  }

  /* Future<void> _togglePlay() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
        debugPrint('duraklatildi!');
      } else {
        await _audioPlayer.seek(Duration.zero); // Başa sar
        await _audioPlayer.play();
        debugPrint('oynatildi!');
      }

      setState(() {
        _isPlaying = !_isPlaying;
      });
    } catch (e) {
      debugPrint('Ses çalınırken hata: $e');
    }
  } */

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_outlined,
        color: Theme.of(context).colorScheme.primary,
      ),
      iconSize: 64,
      onPressed: () => _isPlaying ? pause() : _isPaused ? resume() : play(),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
