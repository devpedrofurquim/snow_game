import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
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
  late final World _world;
  late final CameraComponent _camera;
  late final Player _player;

  int _nTrailTriggers = 0;
  bool get _isOffTrail => _nTrailTriggers == 0;

  late final _gameSize;

  @override
  Future<void> onLoad() async {
    _gameSize = gameRef.size;
    print('Current Level: $currentLevel');

    final map = await TiledComponent.load('Level_One.tmx', Vector2.all(16))
      ..debugMode = true;

    await _setupWorldAndCamera(map, _gameSize);
    await _handleSpawnPoints(map);
    await _handleTriggers(map);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    print('Trail Triggers: $_nTrailTriggers offTrail: $_isOffTrail');
  }

  Future<void> _setupWorldAndCamera(TiledComponent map, gameSize) async {
    _world = World(children: [map, input]);
    await add(_world);

    _camera = CameraComponent.withFixedResolution(
      width: gameSize.x / 3,
      height: gameSize.y / 3,
      world: _world,
    );
    await add(_camera);
  }

  Future<void> _handleSpawnPoints(TiledComponent<FlameGame<World>> map) async {
    final tiles = game.images.fromCache('../images/tilemap_packed.png');
    final spriteSheet = SpriteSheet(image: tiles, srcSize: Vector2.all(16));

    final spawnPoint = map.tileMap.getLayer<ObjectGroup>('SpawnPoint');
    final objects = spawnPoint?.objects;

    if (objects != null) {
      for (final object in objects) {
        switch (object.class_) {
          case 'Player':
            _player = Player(
                position: Vector2(object.x, object.y),
                sprite: spriteSheet.getSprite(5, 10))
              ..debugMode = false;
            await _world.add(_player);
            _camera.follow(_player);
            break;
          case 'Snowman':
            final snowman = Snowman(
                position: Vector2(object.x, object.y),
                sprite: spriteSheet.getSprite(5, 9));
            _world.add(snowman);
            break;
        }
      }
    }
  }

  Future<void> _handleTriggers(TiledComponent<FlameGame<World>> map) async {
    final triggerLayer = map.tileMap.getLayer<ObjectGroup>('Trigger');
    final objects = triggerLayer?.objects;

    if (objects != null) {
      for (final object in objects) {
        switch (object.class_) {
          case "Trail":
            final vertices = <Vector2>[];
            for (final point in object.polygon) {
              vertices.add(Vector2(point.x + object.x, point.y + object.y));
            }
            final hitbox = PolygonHitbox(vertices,
                collisionType: CollisionType.passive, isSolid: true)
              ..debugMode = true;

            hitbox.onCollisionStartCallback = (_, __) => _onTrailEnter();
            hitbox.onCollisionEndCallback = (_) => _onTrailExit();
            await map.add(hitbox);
            break;
        }
      }
    }
  }

  void _onTrailEnter() {
    ++_nTrailTriggers;
  }

  void _onTrailExit() {
    --_nTrailTriggers;
  }
}
