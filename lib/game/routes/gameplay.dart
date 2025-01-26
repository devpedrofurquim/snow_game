import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/src/services/hardware_keyboard.dart';
import 'package:flutter/src/services/keyboard_key.g.dart';
import 'package:penguin_adventure/game/actors/snowman.dart';
import 'package:penguin_adventure/game/input.dart';
import 'package:penguin_adventure/game/actors/player.dart';

class Gameplay extends Component with KeyboardHandler, HasGameRef {
  Gameplay(
    this.currentLevel, {
    super.key,
    required this.onPausePressed,
    required this.onLevelComplete,
    required this.onGameOver,
  });

  static const id = 'Gameplay';
  final VoidCallback onPausePressed;
  final VoidCallback onLevelComplete;
  final VoidCallback onGameOver;

  late final input = Input(keyCallbacks: {
    LogicalKeyboardKey.keyP: onPausePressed,
    LogicalKeyboardKey.keyC: onLevelComplete,
    LogicalKeyboardKey.keyO: onGameOver,
  });

  late final int currentLevel;
  @override
  Future<void> onLoad() async {
    final gameSize = gameRef.size;
    print('Current Level: $currentLevel');

    final map = await TiledComponent.load('Level_One.tmx', Vector2.all(16))
      ..debugMode = true;

    final world = World(children: [map, input]);
    await add(world);

    final camera = CameraComponent.withFixedResolution(
      width: gameSize.x / 3,
      height: gameSize.y / 3,
      world: world,
    );
    await add(camera);

    final tiles = game.images.fromCache('../images/tilemap_packed.png');
    final spriteSheet = SpriteSheet(image: tiles, srcSize: Vector2.all(16));

    final spawnPoint = map.tileMap.getLayer<ObjectGroup>('SpawnPoint');
    final objects = spawnPoint?.objects;

    if (objects != null) {
      for (final object in objects) {
        switch (object.class_) {
          case 'Player':
            final player = Player(
                position: Vector2(object.x, object.y),
                sprite: spriteSheet.getSprite(5, 10))
              ..debugMode = false;
            await world.add(player);
            camera.follow(player);
            break;
          case 'Snowman':
            final snowman = Snowman(
                position: Vector2(object.x, object.y),
                sprite: spriteSheet.getSprite(5, 9));
            world.add(snowman);
            break;
        }
      }
    }

    return super.onLoad();
  }
}
