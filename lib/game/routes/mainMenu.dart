import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key, this.onPlayPressed, this.onSettingsPressed});

  static const id = 'MainMenu';

  final VoidCallback? onPlayPressed;
  final VoidCallback? onSettingsPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Penguin Adventure',
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 15),
            SizedBox(
                width: 150,
                child: OutlinedButton(
                    onPressed: onPlayPressed, child: Text('Play'))),
            const SizedBox(height: 5),
            SizedBox(
                width: 150,
                child: OutlinedButton(
                    onPressed: onSettingsPressed, child: Text('Settings'))),
          ],
        ),
      ),
    );
  }

  void onPressed() {}
}
