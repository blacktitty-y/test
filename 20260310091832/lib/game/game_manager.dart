import 'package:flutter/material.dart';
import '../entities/player.dart';
import '../levels/level_data.dart';
import '../physics/collision_system.dart';
import '../physics/physics_engine.dart';
import 'game_state.dart';
import 'game_input.dart';

/// 游戏管理器
class GameManager {
  /// 玩家
  Player? player;
  
  /// 关卡管理器
  LevelManager levelManager = LevelManager();
  
  /// 碰撞系统
  CollisionSystem collisionSystem = CollisionSystem();
  
  /// 游戏状态
  GameStateManager gameState = GameStateManager();
  
  /// 死亡次数
  int deathCount = 0;
  
  /// 输入控制器
  GameInputController inputController = GameInputController();
  
  /// 屏幕尺寸
  Size screenSize = Size.zero;
  
  /// 摄像机位置
  Vector2 cameraPosition = Vector2.zero();
  
  /// 初始化游戏
  void init(Size size) {
    screenSize = size;
    inputController.init(size);
    loadLevel(0);
  }
  
  /// 加载关卡
  void loadLevel(int levelIndex) {
    levelManager.setLevel(levelIndex);
    final level = levelManager.getCurrentLevel();
    
    // 重置碰撞系统
    collisionSystem.clear();
    for (final collider in level.colliders) {
      collisionSystem.addCollider(collider);
    }
    
    // 创建玩家
    player = Player(startPosition: level.playerStart);
    
    // 重置摄像机
    cameraPosition = Vector2.zero();
    
    // 重置状态
    gameState.setState(GameState.playing);
  }
  
  /// 更新游戏
  void update() {
    if (!gameState.isInState(GameState.playing)) return;
    
    if (player == null || player!.isDead) return;
    
    // 更新输入
    player!.setInputDirection(inputController.getInputDirection());
    
    // 更新玩家
    player!.update();
    
    // 碰撞检测和解析
    _handleCollisions();
    
    // 检查陷阱碰撞
    if (player!.checkHazardCollision(collisionSystem)) {
      playerDie();
      return;
    }
    
    // 检查终点碰撞
    if (player!.checkGoalCollision(collisionSystem)) {
      levelComplete();
    }
    
    // 更新摄像机
    _updateCamera();
  }
  
  /// 处理碰撞
  void _handleCollisions() {
    if (player == null) return;
    
    final playerBounds = player!.bounds;
    final collision = collisionSystem.checkCollision(player!.body, playerBounds);
    
    if (collision.hasCollision) {
      collisionSystem.resolveCollision(player!.body, playerBounds, collision);
    }
  }
  
  /// 更新摄像机跟随玩家
  void _updateCamera() {
    if (player == null) return;
    
    const targetMargin = 100.0;
    const cameraSmoothness = 0.1;
    
    // 计算目标摄像机位置（让玩家保持在屏幕中央偏下位置）
    final targetX = player!.body.position.x - screenSize.width / 2;
    final targetY = player!.body.position.y - screenSize.height * 0.6;
    
    // 平滑移动摄像机
    cameraPosition.x += (targetX - cameraPosition.x) * cameraSmoothness;
    cameraPosition.y += (targetY - cameraPosition.y) * cameraSmoothness;
    
    // 限制摄像机不要超出关卡边界（假设关卡宽800，高500）
    cameraPosition.x = cameraPosition.x.clamp(-100, 100);
    cameraPosition.y = cameraPosition.y.clamp(-50, 50);
  }
  
  /// 玩家死亡
  void playerDie() {
    if (player != null) {
      player!.die();
      deathCount++;
    }
    
    // 延迟重置
    Future.delayed(const Duration(milliseconds: 500), () {
      if (player != null) {
        final level = levelManager.getCurrentLevel();
        player!.reset(level.playerStart);
      }
    });
  }
  
  /// 关卡完成
  void levelComplete() {
    gameState.levelComplete();
    
    // 延迟进入下一关
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!levelManager.nextLevel()) {
        // 没有下一关了，显示胜利界面
        gameState.victory();
      } else {
        loadLevel(levelManager.currentLevelIndex);
        gameState.startGame();
      }
    });
  }
  
  /// 重启当前关卡
  void restartLevel() {
    loadLevel(levelManager.currentLevelIndex);
    deathCount = 0;
  }
  
  /// 暂停游戏
  void pauseGame() {
    gameState.pauseGame();
  }
  
  /// 继续游戏
  void resumeGame() {
    gameState.resumeGame();
  }
  
  /// 返回主菜单
  void returnToMenu() {
    gameState.returnToMenu();
    deathCount = 0;
    levelManager.reset();
  }
  
  /// 玩家跳跃
  void playerJump() {
    player?.jump();
  }
  
  /// 处理触摸输入
  void handleTouchStart(Offset position) {
    // 检查是否点击了跳跃按钮
    if (inputController.isJumpButtonPressed(position)) {
      playerJump();
    } else {
      inputController.handleTouchStart(position);
    }
  }
  
  void handleTouchMove(Offset position, int pointerId) {
    inputController.handleTouchMove(position, pointerId);
  }
  
  void handleTouchEnd(int pointerId) {
    inputController.handleTouchEnd(pointerId);
  }
}
