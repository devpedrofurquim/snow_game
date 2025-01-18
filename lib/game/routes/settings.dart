import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({
    super.key,
    this.onBackPressed,
    required this.musicNotifier,
    required this.sfxNotifier,
  });

  static const id = 'Settings';

  final VoidCallback? onBackPressed;
  final ValueNotifier<bool> musicNotifier;
  final ValueNotifier<bool> sfxNotifier;

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
              'Settings',
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<bool>(
              valueListenable: musicNotifier,
              builder: (context, value, child) {
                return SwitchListTile(
                  value: value,
                  onChanged: (newValue) => musicNotifier.value = newValue,
                  title: const Text('Music'),
                );
              },
            ),
            ValueListenableBuilder<bool>(
              valueListenable: sfxNotifier,
              builder: (context, value, child) {
                return SwitchListTile(
                  value: value,
                  onChanged: (newValue) => sfxNotifier.value = newValue,
                  title: const Text('Sfx'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
