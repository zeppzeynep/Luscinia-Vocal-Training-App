import 'package:flutter/material.dart';
import 'dart:async';
import '../services/pitch_detector_service.dart';
import 'pitch_visualizer_widget.dart';

enum MicrophoneMode { recording, analyzing }

class MicrophoneWidget extends StatefulWidget {
  final ValueChanged<PitchData>? onPitchData;

  const MicrophoneWidget({
    Key? key,
    this.onPitchData,
    }) : super(key: key);

  @override
  State<MicrophoneWidget> createState() => _MicrophoneWidgetState();
}

class _MicrophoneWidgetState extends State<MicrophoneWidget> {

  // recording mode fiels has been removed 
  // Analyzing mode variables
  
  bool _isAnalyzing = false;
  final PitchDetectorService _pitchService = PitchDetectorService();
  PitchData? _currentPitchData;
  
  // current mode variable has been removed. bc we only have analyzing mode now. recording mode rip.
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
          if (!mounted) return;
          setState(() {
            _currentPitchData = pitchData;
          });
          widget.onPitchData?.call(pitchData);
          ///// burayı biraz kurcalarım
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

        // widgets are  determined by the active-current mode(analyzing or recording)
        // --- now only analyzing mode is implemented, recording mode has been removed bc... it was non-functional?!
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
