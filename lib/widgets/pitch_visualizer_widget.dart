import 'package:flutter/material.dart';
import '../services/pitch_detector_service.dart';

class PitchVisualizerWidget extends StatelessWidget {
  final PitchData? pitchData;
  final bool isAnalyzing;

  const PitchVisualizerWidget({
    Key? key,
    this.pitchData,
    this.isAnalyzing = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: isAnalyzing ? Colors.green : Colors.grey,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: isAnalyzing
          ? (pitchData != null && pitchData!.isPitched
              ? _buildPitchDisplay(context)
              : _buildListening())
          : _buildIdle(),
    );
  }

  Widget _buildPitchDisplay(BuildContext context) {
    final cents = pitchData!.centsOffPitch;
    final frequency = pitchData!.pitch;
    final noteName = pitchData!.noteName;
    final probability = pitchData!.probability;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Nota ismi
          Text(
            noteName,
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          
          // Frekans
          Text(
            '${frequency.toStringAsFixed(1)} Hz',
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 16),
          
          // Tuning indicator (cent göstergesi)
          _buildTuningIndicator(cents),
          const SizedBox(height: 8),
          
          // Cent değeri
          Text(
            '${cents > 0 ? '+' : ''}${cents.toStringAsFixed(0)} cents',
            style: TextStyle(
              fontSize: 16,
              color: cents.abs() < 10 ? Colors.green : Colors.orange,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          
          // Güven skoru
          _buildConfidenceBar(probability),
        ],
      ),
    );
  }

  Widget _buildTuningIndicator(double cents) {
    // Cent değeri -50 ile +50 arasında normalize et
    final normalizedCents = cents.clamp(-50.0, 50.0);
    final offset = normalizedCents / 50.0; // -1 ile +1 arası
    
    return SizedBox(
      height: 40,
      child: Stack(
        children: [
          // Arka plan çizgiler
          Positioned.fill(
            child: Row(
              children: [
                Expanded(child: Container(color: Colors.red.shade100)),
                Container(width: 4, color: Colors.green),
                Expanded(child: Container(color: Colors.red.shade100)),
              ],
            ),
          ),
          
          // Merkez işareti
          Center(
            child: Container(
              width: 2,
              height: 40,
              color: Colors.green.shade700,
            ),
          ),
          
          // Hareket eden gösterge
          Center(
            child: Transform.translate(
              offset: Offset(offset * 100, 0),
              child: Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfidenceBar(double probability) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Güven: ',
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
        Container(
          width: 100,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: probability,
            child: Container(
              decoration: BoxDecoration(
                color: probability > 0.8
                    ? Colors.green
                    : probability > 0.5
                        ? Colors.orange
                        : Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${(probability * 100).toStringAsFixed(0)}%',
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildListening() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(color: Colors.green),
        SizedBox(height: 16),
        Text(
          'Dinleniyor...',
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
        SizedBox(height: 8),
        Text(
          'Bir ses çıkarın',
          style: TextStyle(fontSize: 14, color: Colors.black38),
        ),
      ],
    );
  }

  Widget _buildIdle() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.graphic_eq, size: 64, color: Colors.grey.shade400),
        const SizedBox(height: 16),
        Text(
          'Analiz bekleniyor',
          style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
