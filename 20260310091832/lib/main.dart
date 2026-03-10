import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'ui/main_menu.dart';
import 'ui/hud.dart';
import 'ui/game_over_dialog.dart';
import 'game/game_manager.dart';
import 'game/game_state.dart';
import 'physics/collision_system.dart';
import 'physics/physics_engine.dart';

void main() {
  runApp(const LevelDevilApp());
}

class LevelDevilApp extends StatelessWidget {
  const LevelDevilApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Level Devil',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);
  
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late GameManager _gameManager;
  late Ticker _ticker;
  
  @override
  void initState() {
    super.initState();
    _gameManager = GameManager();
    
    // 初始化游戏
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      _gameManager.init(size);
    });
    
    // 创建游戏循环
    _ticker = createTicker((elapsed) {
      setState(() {
        _gameManager.update();
      });
    });
    _ticker.start();
  }
  
  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onPanStart: (details) => _gameManager.handleTouchStart(details.localPosition),
        onPanUpdate: (details) => _gameManager.handleTouchMove(details.localPosition, 0),
        onPanEnd: (details) => _gameManager.handleTouchEnd(0),
        child: Stack(
          children: [
            // 游戏画面
            _buildGameContent(),
            
            // UI覆盖层
            _buildUIOverlay(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildGameContent() {
    final gameState = _gameManager.gameState.currentState;
    
    switch (gameState) {
      case GameState.menu:
        return MainMenu(
          onStart: () {
            _gameManager.loadLevel(0);
            _gameManager.startGame();
          },
          onLevelSelect: () {
            // 简单实现：直接开始游戏
            _gameManager.loadLevel(0);
            _gameManager.startGame();
          },
        );
      
      case GameState.playing:
      case GameState.paused:
      case GameState.levelComplete:
        return _buildGameView();
      
      case GameState.gameOver:
        return _buildGameView();
      
      case GameState.victory:
        return VictoryScreen(
          onMenu: () {
            _gameManager.returnToMenu();
          },
        );
    }
  }
  
  Widget _buildGameView() {
    final level = _gameManager.levelManager.getCurrentLevel();
    final player = _gameManager.player;
    
    return CustomPaint(
      size: Size.infinite,
      painter: GameWorldPainter(
        level: level,
        player: player,
        cameraPosition: _gameManager.cameraPosition,
        screenSize: _gameManager.screenSize,
      ),
    );
  }
  
  Widget _buildUIOverlay() {
    final gameState = _gameManager.gameState.currentState;
    final player = _gameManager.player;
    
    if (gameState == GameState.menu || gameState == GameState.victory) {
      return const SizedBox.shrink();
    }
    
    return Stack(
      children: [
        // HUD
        if (gameState == GameState.playing || gameState == GameState.paused)
          GameHUD(
            currentLevel: _gameManager.levelManager.currentLevelIndex + 1,
            totalLevels: _gameManager.levelManager.levelCount,
            deathCount: _gameManager.deathCount,
            onPause: () => _gameManager.pauseGame(),
          ),
        
        // 虚拟控制器
        if (gameState == GameState.playing)
          VirtualControls(
            onMove: (x) {
              if (x > 0.3) {
                _gameManager.inputController.inputDirection = InputDirection.right;
              } else if (x < -0.3) {
                _gameManager.inputController.inputDirection = InputDirection.left;
              } else {
                _gameManager.inputController.inputDirection = InputDirection.none;
              }
            },
            onJump: () => _gameManager.playerJump(),
          ),
        
        // 死亡提示
        if (player != null && player.isDead)
          DeathToast(
            onRetry: () {
              final level = _gameManager.levelManager.getCurrentLevel();
              player!.reset(level.playerStart);
            },
          ),
        
        // 暂停对话框
        if (gameState == GameState.paused)
          PauseDialog(
            onResume: () => _gameManager.resumeGame(),
            onRestart: () => _gameManager.restartLevel(),
            onMenu: () => _gameManager.returnToMenu(),
          ),
      ],
    );
  }
}

/// 游戏世界绘制器
class GameWorldPainter extends CustomPainter {
  final LevelData level;
  final player;
  final Vector2 cameraPosition;
  final Size screenSize;
  
  GameWorldPainter({
    required this.level,
    required this.player,
    required this.cameraPosition,
    required this.screenSize,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    // 绘制背景
    final backgroundPaint = Paint()..color = Color(level.backgroundColor);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );
    
    // 应用摄像机变换
    canvas.save();
    canvas.translate(-cameraPosition.x, -cameraPosition.y);
    
    // 绘制所有碰撞体
    for (final collider in level.colliders) {
      _drawCollider(canvas, collider);
    }
    
    // 绘制玩家
    if (player != null && !player!.isDead) {
      _drawPlayer(canvas);
    }
    
    canvas.restore();
  }
  
  void _drawCollider(Canvas canvas, Collider collider) {
    final rect = collider.bounds;
    final paint = Paint();
    
    switch (collider.type) {
      case ColliderType.platform:
        paint.color = const Color(0xFF34495E);
        paint.style = PaintingStyle.fill;
        // 绘制平台
        canvas.drawRect(rect, paint);
        // 绘制边框
        paint.color = const Color(0xFF2C3E50);
        paint.style = PaintingStyle.stroke;
        paint.strokeWidth = 2;
        canvas.drawRect(rect, paint);
        break;
      
      case ColliderType.wall:
        paint.color = const Color(0xFF7F8C8D);
        paint.style = PaintingStyle.fill;
        canvas.drawRect(rect, paint);
        paint.color = const Color(0xFF627273);
        paint.style = PaintingStyle.stroke;
        paint.strokeWidth = 2;
        canvas.drawRect(rect, paint);
        break;
      
      case ColliderType.hazard:
        paint.color = const Color(0xFFE74C3C);
        paint.style = PaintingStyle.fill;
        // 绘制三角形尖刺
        final spikeWidth = rect.width / 3;
        final numSpikes = (rect.width / spikeWidth).round();
        for (int i = 0; i < numSpikes; i++) {
          final path = Path();
          final left = rect.left + i * spikeWidth;
          final right = left + spikeWidth;
          path.moveTo(left, rect.bottom);
          path.lineTo((left + right) / 2, rect.top);
          path.lineTo(right, rect.bottom);
          path.close();
          canvas.drawPath(path, paint);
        }
        break;
      
      case ColliderType.trigger:
        paint.color = const Color(0xFFF1C40F);
        paint.style = PaintingStyle.fill;
        // 绘制终点旗帜
        canvas.drawCircle(
          Offset(rect.center.dx, rect.center.dy),
          15,
          paint,
        );
        // 绘制旗帜杆
        paint.color = const Color(0xFF8E44AD);
        canvas.drawRect(
          Rect.fromLTWH(rect.center.dx - 2, rect.top, 4, rect.height),
          paint,
        );
        // 绘制旗帜布
        paint.color = const Color(0xFF2ECC71);
        final flagPath = Path();
        flagPath.moveTo(rect.center.dx, rect.top);
        flagPath.lineTo(rect.right, rect.top + 15);
        flagPath.lineTo(rect.center.dx, rect.top + 30);
        flagPath.close();
        canvas.drawPath(flagPath, paint);
        break;
    }
  }
  
  void _drawPlayer(Canvas canvas) {
    if (player == null) return;
    
    final playerRect = player!.bounds;
    
    // 绘制玩家身体
    final bodyPaint = Paint()
      ..color = player!.color
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(playerRect, bodyPaint);
    
    // 绘制边框
    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(playerRect, borderPaint);
    
    // 绘制眼睛（根据朝向）
    final eyeOffset = player!.facingRight ? 8.0 : -8.0;
    final eyeX = playerRect.center.dx + eyeOffset;
    final eyeY = playerRect.top + 15;
    
    // 白眼球
    canvas.drawCircle(
      Offset(eyeX, eyeY),
      6,
      Paint()..color = Colors.white,
    );
    
    // 黑眼珠
    final pupilOffset = player!.facingRight ? 2.0 : -2.0;
    canvas.drawCircle(
      Offset(eyeX + pupilOffset, eyeY),
      3,
      Paint()..color = Colors.black,
    );
    
    // 绘制嘴巴
    final mouthY = playerRect.top + 30;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(playerRect.center.dx, mouthY), radius: 6),
      0,
      3.14,
      false,
      Paint()
        ..color = Colors.black
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
  }
  
  @override
  bool shouldRepaint(covariant GameWorldPainter oldDelegate) {
    return oldDelegate.player != player ||
           oldDelegate.cameraPosition != cameraPosition;
  }
}
