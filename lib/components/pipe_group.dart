import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flappy_bird_game/game/assets.dart';
import 'package:flappy_bird_game/game/configuration.dart';
import 'package:flappy_bird_game/game/flappy_bird_game.dart';
import 'package:flappy_bird_game/game/pipe_position.dart';
import 'package:flappy_bird_game/components/pipe.dart';

class PipeGroup extends PositionComponent with HasGameRef<FlappyBirdGame> {
  PipeGroup();

  final _random = Random();

  @override
  Future<void> onLoad() async {
    // gameRef是HasGameRef混合(mixin)后提供的属性，他可以访问当前游戏的实例
    position.x = gameRef.size.x;

    // 生成随机的管道Pipe属性数据
    final heightMinusGround = gameRef.size.y - Config.groundHeight;
    final spacing = 100 + _random.nextDouble() * (heightMinusGround / 4);
    final centerY =
        spacing + _random.nextDouble() * (heightMinusGround - spacing);

    // 用上面生成的数据创建两个管道
    addAll([
      Pipe(pipePosition: PipePosition.top, height: centerY - spacing / 2),
      Pipe(
          pipePosition: PipePosition.bottom,
          height: heightMinusGround - (centerY + spacing / 2)),
    ]);
  }

  // 用于更新游戏分数。每当管道组移出屏幕时，
  void updateScore() {
    // 游戏的分数增加 1，
    gameRef.bird.score += 1;
    // 并播放得分音效。
    FlameAudio.play(Assets.point);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // 更新管道的坐标
    position.x -= Config.gameSpeed * dt;

    // 每当管道组移出屏幕时触发，管道x坐标为-10
    if (position.x < -10) {
      // removeFromParent() 方法是 Flutter Flame 游戏框架中的一个方法，用于从父节点中移除当前组件。
      removeFromParent();
      updateScore();
    }

    if (gameRef.isHit) {
      removeFromParent();
      gameRef.isHit = false;
    }
  }
}
