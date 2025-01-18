import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GameOver extends StatelessWidget {
  const GameOver({super.key, this.onRestartPressed, this.onExitPressed});

  static const id = 'GameOver';

  final VoidCallback? onRestartPressed;
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
              'Game Over',
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 5),
            SizedBox(
                width: 150,
                child: OutlinedButton(
                    onPressed: onRestartPressed, child: Text('Restart'))),
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

  void onPressed() {}
}
