import 'package:flutter/material.dart';

class GuidePage extends StatelessWidget {
  final VoidCallback onStart;

  const GuidePage({super.key, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome to the Match Page!',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Adjust the color
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          Text(
            'Discover your perfect match and make connections with BookMate! Swipe left if they aren\'t your preference, or tap the "Match" button if you find someone interesting.',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: 16.0,
                  color: const Color(0x8A000000), // Adjust the color
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24.0),
          const SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: onStart,
            style: ElevatedButton.styleFrom(
              backgroundColor:  const Color(0xFFB6536B), // Change the button color
              foregroundColor: Colors.white, // Change the text color
              minimumSize: const Size(200, 50), // Set the button size
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Let\'s Start Matching!',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }
}
