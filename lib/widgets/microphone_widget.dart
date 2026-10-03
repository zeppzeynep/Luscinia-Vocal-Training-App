import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import '../services/pitch_detector_service.dart';
import 'pitch_visualizer_widget.dart';

enum MicrophoneMode { recording, analyzing }

class MicrophoneWidget extends StatefulWidget {
  const MicrophoneWidget({Key? key}) : super(key: key);

  @override
  State<MicrophoneWidget> createState() => _MicrophoneWidgetState();
}

class _MicrophoneWidgetState extends State<MicrophoneWidget> {
  
  // Recording mode değişkenleri
  bool _isRecording = false;
  late final AudioRecorder _audioRecorder;
  Timer? _timer;
  String _recordDuration = '00:00';

  // Analyzing mode değişkenleri
  bool _isAnalyzing = false;
  final PitchDetectorService _pitchService = PitchDetectorService();
  PitchData? _currentPitchData;
  
  // Mod seçimi
  MicrophoneMode _currentMode = MicrophoneMode.analyzing;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pitchService.dispose();
    super.dispose();
  }


  // ========== ANALYZING MODE ==========
  Future<void> _startAnalyzing() async {
    try {
      // İzin kontrolü
      final hasPermission = await _pitchService.checkPermission();
      if (!hasPermission) {
        _showPermissionDialog();
        return;
      }

      // Pitch detection başlat
      await _pitchService.start(
        algorithm: PitchAlgorithm.yin,
        sampleRate: 22050,
        bufferSize: 1024,
      );

      // Stream dinle
      _pitchService.listen(
        (pitchData) {
          setState(() {
            _currentPitchData = pitchData;
          });
        },
        onError: (error) {
          debugPrint('Pitch detection hatası: $error');
          _stopAnalyzing();
        },
      );

      setState(() {
        _isAnalyzing = true;
      });
    } catch (e) {
      debugPrint('Analiz başlatılırken hata: $e');
      _showErrorDialog(e.toString());
    }
  }

  Future<void> _stopAnalyzing() async {
    try {
      await _pitchService.stop();
      setState(() {
        _isAnalyzing = false;
        _currentPitchData = null;
      });
    } catch (e) {
      debugPrint('Analiz durdurulurken hata: $e');
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mikrofon İzni Gerekli'),
        content: const Text(
          'Ses analizi için mikrofon iznine ihtiyaç var. Lütfen uygulama ayarlarından mikrofon iznini açın.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hata'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  // ========== UI ==========
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Mod seçici toggle
        const SizedBox(height: 20),

        // Aktif moda göre içeri---- sadece analyzing mode olarak değiştirldi
          _buildAnalyzingMode(),
      ],
    );
  }

  



  Widget _buildAnalyzingMode() {
    return Column(
      children: [
        // Pitch visualizer
        PitchVisualizerWidget(
          pitchData: _currentPitchData,
          isAnalyzing: _isAnalyzing,
        ),
        const SizedBox(height: 30),
        
        // Start/Stop butonu
        ElevatedButton.icon(
          onPressed: () {
            if (_isAnalyzing) {
              _stopAnalyzing();
            } else {
              _startAnalyzing();
            }
          },
          icon: Icon(_isAnalyzing ? Icons.stop : Icons.play_arrow),
          label: Text(_isAnalyzing ? 'Analizi Durdur' : 'Analizi Başlat'),
          style: ElevatedButton.styleFrom(
            backgroundColor: _isAnalyzing ? Colors.red : Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
