import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';

class Input extends Component with KeyboardHandler, HasGameRef {
  Input({Map<LogicalKeyboardKey, VoidCallback>? keyCallbacks})
      : _keyCallbacks = keyCallbacks ?? <LogicalKeyboardKey, VoidCallback>{};
  bool _leftPressed = false;
  bool _rightPressed = false;

  var hAxis = .0;
  var _leftInput = .0;
  var _rightInput = .0;
  static const _sensitivity = 2.0;

  final Map<LogicalKeyboardKey, VoidCallback> _keyCallbacks;

  @override
  void update(double dt) {
    _leftInput =
        lerpDouble(_leftInput, _leftPressed ? 1.5 : 0, _sensitivity * dt)!;
    _rightInput =
        lerpDouble(_rightInput, _rightPressed ? 1.5 : 0, _sensitivity * dt)!;

    hAxis = _rightInput - _leftInput;
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (game.paused == false) {
      _leftPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
          keysPressed.contains(LogicalKeyboardKey.arrowLeft);
      _rightPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
          keysPressed.contains(LogicalKeyboardKey.arrowRight);

      if (event is KeyDownEvent) {
        for (final entry in _keyCallbacks.entries) {
          if (entry.key == event.logicalKey) {
            entry.value.call();
          }
        }
      }
    }
    return super.onKeyEvent(event, keysPressed);
  }
}
