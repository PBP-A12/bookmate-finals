import 'package:flutter/material.dart';
import 'package:bookmate/globals.dart' as globals;

class GuidePage extends StatelessWidget {
  final VoidCallback onStart;

  GuidePage({required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to the Match Page!',
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            Text(
              'Explore exciting recommendations here. Swipe left if they aren\'t your preference, or tap the "Match" button if you find someone interesting.',
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            // You can add more text or images here...
            ElevatedButton(
              onPressed: onStart,
              child: Text('Start'),
            ),
          ],
        ),

    );
  }
}