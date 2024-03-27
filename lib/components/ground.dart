import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/parallax.dart';
import 'package:flappy_bird_game/game/assets.dart';
import 'package:flappy_bird_game/game/configuration.dart';
import 'package:flappy_bird_game/game/flappy_bird_game.dart';

class Ground extends ParallaxComponent<FlappyBirdGame>
    with HasGameRef<FlappyBirdGame> {
  Ground();

  @override
  Future<void> onLoad() async {
    // 地面的图像资源。
    final ground = await Flame.images.load(Assets.ground);

    // 初始化了地面的视差效果。
    parallax = Parallax([
      ParallaxLayer(
        // 以创建一个表示地面的视差层。通过 fill: LayerFill.none 参数，指定了图像不填充整个视差层，保持原始大小。
        ParallaxImage(ground, fill: LayerFill.none),
      ),
    ]);
    
    // 地面组件中添加了一个矩形碰撞体 RectangleHitbox，用于检测小鸟与地面的碰撞。
    add(
      RectangleHitbox(
        position: Vector2(0, gameRef.size.y - Config.groundHeight),
        size: Vector2(gameRef.size.x, Config.groundHeight),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    // print('ground update ${dt}');
    // 视差层级的移动速度
    parallax?.baseVelocity.x = Config.gameSpeed;
  }
}
