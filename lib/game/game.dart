import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:penguin_adventure/game/routes/gameOver.dart';
import 'package:penguin_adventure/game/routes/gameplay.dart';
import 'package:penguin_adventure/game/routes/levelComplete.dart';
import 'package:penguin_adventure/game/routes/levelSelection.dart';
import 'package:penguin_adventure/game/routes/mainMenu.dart';
import 'package:penguin_adventure/game/routes/pauseMenu.dart';
import 'package:penguin_adventure/game/routes/settings.dart';

class PenguinAdventur extends FlameGame with HasKeyboardHandlerComponents {
  late final routes = <String, Route>{
    MainMenu.id: OverlayRoute(
      (context, game) => MainMenu(
        onPlayPressed: () => _routeById(LevelSelection.id),
        onSettingsPressed: () => _routeById(Settings.id),
      ),
    ),
    Settings.id: OverlayRoute(
      (context, game) => Settings(
        onBackPressed: _popRoute,
        musicNotifier: ValueNotifier<bool>(true),
        sfxNotifier: ValueNotifier<bool>(true),
      ),
    ),
    LevelSelection.id: OverlayRoute((context, game) => LevelSelection(
          onLevelSelected: _startLevel,
          onBackPressed: _popRoute,
        )),
    PauseMenu.id: OverlayRoute((context, game) => PauseMenu(
          onResumePressed: _resumeGame,
          onRestartPressed: _restartLevel,
          onExitPressed: _exitToMenu,
        )),
    LevelComplete.id: OverlayRoute((context, game) => LevelComplete(
          onNextLevelPressed: _startNextLevel,
          onRetryPressed: _restartLevel,
          onExitPressed: _exitToMenu,
        )),
    GameOver.id: OverlayRoute((context, game) => GameOver(
          onRestartPressed: _restartLevel,
          onExitPressed: _exitToMenu,
        ))
  };

  late final _router =
      RouterComponent(initialRoute: MainMenu.id, routes: routes);

  @override
  Future<void> onLoad() async {
    await add(_router);
    return super.onLoad();
  }

  void _routeById(String id) {
    _router.pushNamed(id);
  }

  void _popRoute() {
    _router.pop();
  }

  void _startLevel(int levelIndex) {
    _router.pop();

    _router.pushReplacement(
        Route(
          () => Gameplay(levelIndex,
              onLevelComplete: _showLevelCompleted,
              onPausePressed: _pauseGame,
              onGameOver: _showGameOver,
              key: ComponentKey.named(Gameplay.id)),
        ),
        name: Gameplay.id);
  }

  void _restartLevel() {
    final gameplay = findByKeyName<Gameplay>(Gameplay.id);
    if (gameplay != null) {
      _startLevel(gameplay.currentLevel);
      resumeEngine();
    }
  }

  void _startNextLevel() {
    final gameplay = findByKeyName<Gameplay>(Gameplay.id);
    if (gameplay != null) {
      _startLevel(gameplay.currentLevel + 1);
    }
  }

  void _pauseGame() {
    _router.pushNamed(PauseMenu.id);
    pauseEngine();
  }

  void _resumeGame() {
    _router.pop();
    resumeEngine();
  }

  void _exitToMenu() {
    _resumeGame();
    _router.pushReplacementNamed(MainMenu.id);
  }

  void _showLevelCompleted() {
    _router.pushNamed(LevelComplete.id);
  }

  void _showGameOver() {
    _router.pushNamed(GameOver.id);
  }

  @override
  Color backgroundColor() => Color.fromARGB(255, 238, 248, 254);
}
