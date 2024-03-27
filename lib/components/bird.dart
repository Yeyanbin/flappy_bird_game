
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flappy_bird_game/game/bird_movement.dart';
import 'package:flappy_bird_game/game/assets.dart';
import 'package:flappy_bird_game/game/configuration.dart';
import 'package:flappy_bird_game/game/flappy_bird_game.dart';
import 'package:flutter/material.dart';

/*
SpriteGroupComponent 类是 Flame 游戏引擎提供的一种组件，用于处理精灵动画的渲染和更新。
<BirdMovement> 是泛型参数，它指定了小鸟可能的不同动作。这个参数可以让我们在 Bird 类中指定小鸟的动画帧或动作。

HasGameRef 类是 Flame 游戏引擎提供的一个特性，它允许组件访问游戏实例。通过混合 HasGameRef，Bird 类可以访问 FlappyBirdGame 的实例，以便在需要时与游戏逻辑进行交互。
CollisionCallbacks 类是 Flame 游戏引擎提供的一个特性，它允许组件处理碰撞事件。通过混合 CollisionCallbacks，Bird 类可以检测到与其他碰撞体的碰撞，并在需要时执行相应的逻辑处理。


*/
class Bird extends SpriteGroupComponent<BirdMovement>
    with HasGameRef<FlappyBirdGame>, CollisionCallbacks {
  Bird();

  int score = 0;

  // 在这个 onLoad() 方法中，小鸟的初始化逻辑被执行。
  @override
  Future<void> onLoad() async {

    // 这里加载了brid在三种不同状态的资源
    final birdMidFlap = await gameRef.loadSprite(Assets.birdMidFlap); 
    final birdUpFlap = await gameRef.loadSprite(Assets.birdUpFlap);
    final birdDownFlap = await gameRef.loadSprite(Assets.birdDownFlap);

    // gameRef.bird;
    
    // bird的初始状态
    size = Vector2(50, 40);
    position = Vector2(50, gameRef.size.y / 2 - size.y / 2);
    current = BirdMovement.middle;
    sprites = {
      BirdMovement.middle: birdMidFlap,
      BirdMovement.up: birdUpFlap,
      BirdMovement.down: birdDownFlap,
    };

    // add 方法是 Flame 游戏引擎中组件的一个方法，用于向游戏场景中添加子组件。
    // 这行代码添加了一个圆形碰撞体组件，用于检测小鸟与其他碰撞体的碰撞。默认情况下，CircleHitbox() 的半径大小是根据其所属的组件的尺寸自动计算的。
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    // 调用了父类 SpriteGroupComponent 的 update() 方法，用于执行父类中定义的更新逻辑。
    // 这个调用确保了在更新小鸟组件之前会执行父类的更新操作，以确保整个游戏的逻辑能够正确运行。
    super.update(dt);

    // 这行代码根据当前小鸟的速度（Config.birdVelocity）和时间增量（dt），更新小鸟在垂直方向（Y 轴）上的位置。这个更新操作使得小鸟在游戏进行中垂直方向上不断地向下移动。
    position.y += Config.birdVelocity * dt;

    // 小鸟的 Y 坐标小于 1，意味着小鸟已经触底（超出游戏屏幕的下边界）
    if (position.y < 1) {
      gameOver();
    }
  }

  void fly() {
    add(
      // MoveByEffect 是 Flame 游戏引擎提供的一种效果，用于在一定时间内将组件沿着指定的向量移动一定的距离。它可以用于创建物体移动的动画效果。
      MoveByEffect(
        // 表示移动的增量向量，即每次更新时物体移动的距离和方向。
        // 这里是每次更新时组件沿着 Y 轴负方向移动。
        // 使用了 Config.gravity 作为移动的距离，因此可以理解为该效果模拟了重力作用，使得组件在垂直方向上向下移动。
        Vector2(0, Config.gravity),
        // 效果的控制器，它指定了效果的持续时间为 0.2 秒，
        // 并且使用了减速曲线 Curves.decelerate。持续时间较短且采用减速曲线，将在短时间内迅速移动并逐渐减速至停止。
        EffectController(duration: 0.2, curve: Curves.decelerate),
        // 效果执行完成时的回调函数
        // 在这里，将 current 属性设置为 BirdMovement.down，就是改变小鸟的动画效果为向下飞行。
        onComplete: () => current = BirdMovement.down,
      ),
    );

    // 播放声效
    FlameAudio.play(Assets.flying);
    // 上升
    current = BirdMovement.up;
  }

  // CollisionCallbacks中的回调
  // intersectionPoints 是一个集合，包含了碰撞发生时的交点坐标。
  // other 则是与当前碰撞发生的另一个组件。
  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    print('小鸟产生了碰撞');
    print(other);
    // print(intersectionPoints);
    gameOver();
  }

  // 重制
  void reset() {
    position = Vector2(50, gameRef.size.y / 2 - size.y / 2);
    score = 0;
  }

  void gameOver() {
    FlameAudio.play(Assets.collision);
    game.isHit = true;
    gameRef.overlays.add('gameOver');
    gameRef.pauseEngine();
  }
}
