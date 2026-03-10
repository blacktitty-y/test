import 'package:flutter/material.dart';
import '../physics/rigidbody.dart';
import '../physics/collision_system.dart';

/// 玩家控制方向
enum InputDirection {
  left,
  right,
  none,
}

/// 玩家类
class Player {
  /// 刚体
  final RigidBody body;
  
  /// 碰撞盒大小
  static const double width = 32.0;
  static const double height = 48.0;
  
  /// 当前输入方向
  InputDirection inputDirection = InputDirection.none;
  
  /// 是否跳跃中
  bool isJumping = false;
  
  /// 是否面向右侧
  bool facingRight = true;
  
  /// 玩家颜色
  final Color color = Colors.red;
  
  /// 死亡状态
  bool isDead = false;
  
  /// 动画状态
  String animationState = 'idle';
  
  Player({required Vector2 startPosition})
      : body = RigidBody(
          position: startPosition,
          mass: 1.0,
          affectedByGravity: true,
          isStatic: false,
        );
  
  /// 获取碰撞盒
  Rect get bounds => Rect.fromLTWH(
        body.position.x - width / 2,
        body.position.y - height / 2,
        width,
        height,
      );
  
  /// 更新玩家状态
  void update() {
    if (isDead) return;
    
    // 处理移动输入
    switch (inputDirection) {
      case InputDirection.left:
        body.move(-1.0);
        facingRight = false;
        animationState = body.isOnGround ? 'run' : 'jump';
        break;
      case InputDirection.right:
        body.move(1.0);
        facingRight = true;
        animationState = body.isOnGround ? 'run' : 'jump';
        break;
      case InputDirection.none:
        animationState = body.isOnGround ? 'idle' : 'jump';
        break;
    }
    
    // 更新跳跃状态
    isJumping = !body.isOnGround;
    
    // 更新物理
    body.update();
  }
  
  /// 跳跃
  void jump() {
    if (!isDead && body.isOnGround) {
      body.jump();
      animationState = 'jump';
    }
  }
  
  /// 设置输入方向
  void setInputDirection(InputDirection direction) {
    inputDirection = direction;
  }
  
  /// 死亡
  void die() {
    isDead = true;
    animationState = 'dead';
  }
  
  /// 重置
  void reset(Vector2 startPosition) {
    isDead = false;
    body.position = startPosition.copy();
    body.velocity = Vector2.zero();
    body.acceleration = Vector2.zero();
    inputDirection = InputDirection.none;
    animationState = 'idle';
  }
  
  /// 检查是否与陷阱碰撞
  bool checkHazardCollision(CollisionSystem collisionSystem) {
    final collision = collisionSystem.checkCollision(body, bounds);
    if (collision.hasCollision && collision.collider?.type == ColliderType.hazard) {
      return true;
    }
    return false;
  }
  
  /// 检查是否到达终点
  bool checkGoalCollision(CollisionSystem collisionSystem) {
    final collision = collisionSystem.checkCollision(body, bounds);
    if (collision.hasCollision && collision.collider?.type == ColliderType.trigger) {
      return true;
    }
    return false;
  }
}
