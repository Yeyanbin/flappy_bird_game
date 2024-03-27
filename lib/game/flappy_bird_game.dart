import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flappy_bird_game/components/background.dart';
import 'package:flappy_bird_game/components/bird.dart';
import 'package:flappy_bird_game/components/ground.dart';
import 'package:flappy_bird_game/components/pipe_group.dart';
import 'package:flappy_bird_game/game/configuration.dart';
import 'package:flutter/painting.dart';

/*
跳跃小鸟游戏的实例类。（其他代码中通过gameRef获取的实例就是这个东东）

继承自 FlameGame，并混合了 TapDetector 和 HasCollisionDetection。

游戏将使用Flame引擎，并且可以检测到点击事件和碰撞事件。
*/
class FlappyBirdGame extends FlameGame with TapDetector, HasCollisionDetection {
  //构造函数 FlappyBirdGame() 创建了一个新的FlappyBirdGame实例。
  FlappyBirdGame();

  late Bird bird; // 小鸟
  late TextComponent score; // 分数
  //interval 是一个定时器，它被设置为以指定的 Config.pipeInterval 间隔重复执行，
  Timer interval = Timer(Config.pipeInterval, repeat: true);
  bool isHit = false;
  @override
  Future<void> onLoad() async {

    /*
    addAll 方法是 Flutter Flame 游戏引擎中 BaseGame 类的方法之一，用于一次性将多个组件添加到游戏中。
    这里用于将游戏中的多个组件添加到 FlappyBirdGame 中。
    */
    addAll([
      Background(),
      Ground(),
      bird = Bird(),
      score = buildScore(),
    ]);

    // interval计时器每次触发时都会添加一个新的 PipeGroup 到游戏中。
    interval.onTick = () => add(PipeGroup());
  }

  // 该方法是用来创建游戏中显示分数的文本组件的方法。
  TextComponent buildScore() {
    // 返回一个文本组件
    return TextComponent(
        position: Vector2(size.x / 2, size.y / 2 * 0.2), // Vector2 对象用于描述方向向量
        anchor: Anchor.center,
        textRenderer: TextPaint( // 绘制文本
          style: const TextStyle(
              fontSize: 40, fontFamily: 'Game', fontWeight: FontWeight.bold),
        ));
  }

  @override
  void onTap() {
    // 方法被触摸事件调用，它会让鸟飞一下。
    bird.fly();
  }

  @override
  void update(double dt) {
    // 方法在每一帧被调用，用于更新游戏状态。在这个方法中，定时器和分数文本都被更新。
    super.update(dt);
    interval.update(dt);
    score.text = 'Score: ${bird.score}';
  }
}
