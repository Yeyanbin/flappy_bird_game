import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flappy_bird_game/game/flappy_bird_game.dart';
import 'package:flappy_bird_game/screens/main_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/game_over_screen.dart';

Future<void> main() async {

  // 设置系统UI覆盖样式，这里将状态栏颜色设置为透明。
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  // 确保 Flutter 绑定已经初始化。
  WidgetsFlutterBinding.ensureInitialized();

  // 使用 Flame 提供的 device 功能使应用程序进入全屏模式。
  await Flame.device.fullScreen();
  
  // 创建Flappy Bird 游戏的实例 
  final game = FlappyBirdGame();

  // 启动app
  runApp(
    // 游戏组件
    GameWidget(
      game: game,
      // 指定了游戏启动时要显示的初始叠加层，这里指定为主菜单屏幕。
      initialActiveOverlays: const [MainMenuScreen.id],
      // 指定了不同叠加层的构建器，用于根据需要构建不同的叠加层。在这里，指定了 mainMenu 和 gameOver 两个叠加层的构建器。
      overlayBuilderMap: {
        'mainMenu': (context, _) => MainMenuScreen(game: game),
        'gameOver': (context, _) => GameOverScreen(game: game),
      },
    ),
  );
}
/*

在游戏开发中，"叠加层"（Overlay）是指位于游戏场景之上的一种特殊UI层，通常用于显示游戏中的菜单、对话框、得分板等界面元素。这些叠加层通常不直接影响游戏的逻辑或渲染，而是在游戏场景之上提供额外的用户界面元素和交互。

在Flame游戏引擎中，叠加层可以通过 GameWidget 的 overlayBuilderMap 参数来管理。每个叠加层都有一个唯一的标识符（通常是字符串），以及一个与之关联的构建器函数。当需要显示特定叠加层时，可以通过标识符调用相应的构建器函数来构建该叠加层的UI界面。

叠加层通常用于显示游戏中的菜单、游戏状态信息、游戏结束画面等，它们与游戏场景分开管理，可以独立于游戏逻辑进行更新和渲染。这种机制使得游戏开发者可以更加灵活地管理游戏界面，并且可以根据需要动态地切换和显示不同的UI界面，以提供更好的用户体验。
*/