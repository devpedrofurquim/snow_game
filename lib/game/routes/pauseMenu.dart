import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PauseMenu extends StatelessWidget {
  const PauseMenu(
      {super.key,
      this.onResumePressed,
      this.onRestartPressed,
      this.onExitPressed});

  static const id = 'PauseMenu';

  final VoidCallback? onResumePressed;
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
              'Paused',
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 15),
            SizedBox(
                width: 150,
                child: OutlinedButton(
                    onPressed: onResumePressed, child: Text('Resume'))),
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
