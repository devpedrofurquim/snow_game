import 'package:flutter/material.dart';

class LevelSelection extends StatelessWidget {
  const LevelSelection({super.key, this.onLevelSelected, this.onBackPressed});

  static const id = 'LevelSelection';

  final ValueChanged<int>? onLevelSelected;
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBackPressed,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select a Level',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Generate buttons for levels (one button per line)
            ...List.generate(4, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: SizedBox(
                  width: 150, // Fixed width for buttons
                  child: ElevatedButton(
                    onPressed: () {
                      if (onLevelSelected != null) {
                        onLevelSelected!(
                            index + 1); // Call the callback with level number
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Level ${index + 1}'),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
