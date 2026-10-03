import 'package:flutter/material.dart';
import '../widgets/progressbar_widget.dart';
import '../widgets/current_exercise_widget.dart';
import '../widgets/play_button_widget.dart';
import '../widgets/microphone_widget.dart';
import '../models/exercise_type.dart';

class HomeScreen extends StatefulWidget {
  final Exercise exercise;

  const HomeScreen({
    Key? key,
    required this.exercise,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentStepIndex = 0;

  void nextStep() {
    if (currentStepIndex < widget.exercise.steps.length - 1) {
      setState(() {
        currentStepIndex++;
      });
    }
  }

  void previousStep() {
    if (currentStepIndex > 0) {
      setState(() {
        currentStepIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = widget.exercise.steps[currentStepIndex];
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        title: Text(widget.exercise.name),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          children: [
            // Progress bar
            Expanded(
              flex: 1,
              child: ProgressbarWidget(
                currentStep: currentStepIndex + 1,
                totalSteps: widget.exercise.steps.length,
              ),
            ),
            const SizedBox(height: 1),
            
            // Current exercise info
            Expanded(
              flex: 1,
              child: Center(
                child: CurrentExerciseWidget(
                  title: currentStep.title,
                  description: currentStep.description,
                ),
              ),
            ),
            const SizedBox(height: 1),
            
            // Play button ve navigation
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PlayButtonWidget(
                    audioPath: currentStep.audioPath,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: currentStepIndex > 0 ? previousStep : null,
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: currentStepIndex < widget.exercise.steps.length - 1
                            ? nextStep
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Microphone widget 
            Expanded(
              flex: 6,
              child: MicrophoneWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
