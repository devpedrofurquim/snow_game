import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LevelComplete extends StatelessWidget {
  const LevelComplete(
      {super.key,
      this.onNextLevelPressed,
      this.onRetryPressed,
      this.onExitPressed});

  static const id = 'LevelComplete';

  final VoidCallback? onNextLevelPressed;
  final VoidCallback? onRetryPressed;
  final VoidCallback? onExitPressed;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(210, 229, 238, 238),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Level Completed',
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 15),
            SizedBox(
                width: 150,
                child: OutlinedButton(
                    onPressed: onNextLevelPressed, child: Text('Next Level'))),
            const SizedBox(height: 5),
            SizedBox(
                width: 150,
                child: OutlinedButton(
                    onPressed: onRetryPressed, child: Text('Retry'))),
            const SizedBox(height: 5),
            SizedBox(
                width: 150,
                child: OutlinedButton(
                    onPressed: onExitPressed, child: Text('Exit'))),
          ],
        ),
      ),
    );
  }
}
