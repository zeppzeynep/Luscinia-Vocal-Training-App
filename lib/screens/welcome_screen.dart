import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Container5
              Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/logo.png', // Logo dosyasının yolu
                    width: 400,
                    height: 400,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Luscinia',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                  shadows: [
                    Shadow(
                      color: const Color(0xFFF19C79).withOpacity(0.3),
                      offset: const Offset(0, 3),
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Sesinizi Keşfedin',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/exercise-list');
                },
                child: const Text(
                  'Başla',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
