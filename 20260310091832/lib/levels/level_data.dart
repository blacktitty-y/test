import '../physics/collision_system.dart';
import '../physics/physics_engine.dart';

/// 关卡数据结构
class LevelData {
  /// 关卡ID
  final int id;
  
  /// 关卡名称
  final String name;
  
  /// 玩家起始位置
  final Vector2 playerStart;
  
  /// 所有碰撞体
  final List<Collider> colliders;
  
  /// 背景颜色
  final int backgroundColor;
  
  LevelData({
    required this.id,
    required this.name,
    required this.playerStart,
    required this.colliders,
    required this.backgroundColor,
  });
}

/// 关卡数据管理器
class LevelManager {
  final List<LevelData> _levels = [];
  
  /// 当前关卡索引
  int currentLevelIndex = 0;
  
  LevelManager() {
    _initializeLevels();
  }
  
  /// 初始化关卡数据
  void _initializeLevels() {
    // 第1关 - 入门关卡
    _levels.add(LevelData(
      id: 1,
      name: 'Level 1: Welcome',
      playerStart: Vector2(100, 300),
      backgroundColor: 0xFF2C3E50,
      colliders: [
        // 地面
        Collider(
          bounds: Rect(0, 400, 800, 100),
          type: ColliderType.platform,
        ),
        // 起始平台
        Collider(
          bounds: Rect(0, 350, 150, 50),
          type: ColliderType.platform,
        ),
        // 中间平台
        Collider(
          bounds: Rect(250, 320, 100, 30),
          type: ColliderType.platform,
        ),
        // 高平台
        Collider(
          bounds: Rect(400, 250, 150, 30),
          type: ColliderType.platform,
        ),
        // 终点平台
        Collider(
          bounds: Rect(600, 300, 200, 30),
          type: ColliderType.platform,
        ),
        // 终点触发器
        Collider(
          bounds: Rect(750, 250, 30, 50),
          type: ColliderType.trigger,
        ),
        // 陷阱1 - 尖刺
        Collider(
          bounds: Rect(200, 385, 40, 15),
          type: ColliderType.hazard,
        ),
        // 陷阱2 - 尖刺
        Collider(
          bounds: Rect(500, 385, 40, 15),
          type: ColliderType.hazard,
        ),
      ],
    ));
    
    // 第2关 - 更多陷阱
    _levels.add(LevelData(
      id: 2,
      name: 'Level 2: Dangerous Path',
      playerStart: Vector2(50, 300),
      backgroundColor: 0xFF8E44AD,
      colliders: [
        // 地面（有陷阱）
        Collider(
          bounds: Rect(0, 400, 200, 100),
          type: ColliderType.platform,
        ),
        Collider(
          bounds: Rect(250, 400, 100, 100),
          type: ColliderType.hazard,
        ),
        Collider(
          bounds: Rect(350, 400, 150, 100),
          type: ColliderType.platform,
        ),
        Collider(
          bounds: Rect(550, 400, 250, 100),
          type: ColliderType.platform,
        ),
        // 移动平台模拟（静态）
        Collider(
          bounds: Rect(150, 300, 80, 20),
          type: ColliderType.platform,
          isOneWay: true,
        ),
        Collider(
          bounds: Rect(280, 220, 80, 20),
          type: ColliderType.platform,
          isOneWay: true,
        ),
        Collider(
          bounds: Rect(450, 280, 80, 20),
          type: ColliderType.platform,
          isOneWay: true,
        ),
        // 终点
        Collider(
          bounds: Rect(750, 250, 30, 50),
          type: ColliderType.trigger,
        ),
        // 尖刺阵列
        for (var i = 0; i < 5; i++)
          Collider(
            bounds: Rect(150 + i * 30, 385, 25, 15),
            type: ColliderType.hazard,
          ),
      ],
    ));
    
    // 第3关 - 垂直挑战
    _levels.add(LevelData(
      id: 3,
      name: 'Level 3: Vertical Challenge',
      playerStart: Vector2(50, 350),
      backgroundColor: 0xFFE67E22,
      colliders: [
        // 底部平台
        Collider(
          bounds: Rect(0, 400, 150, 100),
          type: ColliderType.platform,
        ),
        // 逐级上升的平台
        Collider(
          bounds: Rect(100, 320, 80, 20),
          type: ColliderType.platform,
        ),
        Collider(
          bounds: Rect(250, 250, 80, 20),
          type: ColliderType.platform,
        ),
        Collider(
          bounds: Rect(120, 180, 80, 20),
          type: ColliderType.platform,
        ),
        Collider(
          bounds: Rect(300, 110, 80, 20),
          type: ColliderType.platform,
        ),
        // 墙壁
        Collider(
          bounds: Rect(400, 0, 50, 400),
          type: ColliderType.wall,
        ),
        // 顶部平台
        Collider(
          bounds: Rect(450, 100, 200, 30),
          type: ColliderType.platform,
        ),
        // 终点
        Collider(
          bounds: Rect(620, 50, 30, 50),
          type: ColliderType.trigger,
        ),
        // 墙上的尖刺
        Collider(
          bounds: Rect(400, 250, 50, 15),
          type: ColliderType.hazard,
        ),
        Collider(
          bounds: Rect(400, 180, 50, 15),
          type: ColliderType.hazard,
        ),
      ],
    ));
    
    // 第4关 - 陷阱迷宫
    _levels.add(LevelData(
      id: 4,
      name: 'Level 4: Trap Maze',
      playerStart: Vector2(50, 300),
      backgroundColor: 0xFFC0392B,
      colliders: [
        // 外框
        Collider(
          bounds: Rect(0, 0, 20, 500),
          type: ColliderType.wall,
        ),
        Collider(
          bounds: Rect(780, 0, 20, 500),
          type: ColliderType.wall,
        ),
        Collider(
          bounds: Rect(0, 480, 800, 20),
          type: ColliderType.platform,
        ),
        // 内部墙壁和平台
        Collider(
          bounds: Rect(100, 350, 20, 150),
          type: ColliderType.wall,
        ),
        Collider(
          bounds: Rect(300, 200, 20, 300),
          type: ColliderType.wall,
        ),
        Collider(
          bounds: Rect(500, 350, 20, 150),
          type: ColliderType.wall,
        ),
        // 平台
        Collider(
          bounds: Rect(120, 300, 80, 20),
          type: ColliderType.platform,
          isOneWay: true,
        ),
        Collider(
          bounds: Rect(250, 250, 50, 20),
          type: ColliderType.platform,
        ),
        Collider(
          bounds: Rect(350, 200, 150, 20),
          type: ColliderType.platform,
        ),
        Collider(
          bounds: Rect(520, 280, 80, 20),
          type: ColliderType.platform,
          isOneWay: true,
        ),
        Collider(
          bounds: Rect(620, 220, 100, 20),
          type: ColliderType.platform,
        ),
        // 终点
        Collider(
          bounds: Rect(730, 100, 30, 50),
          type: ColliderType.trigger,
        ),
        // 陷阱
        Collider(
          bounds: Rect(180, 465, 50, 15),
          type: ColliderType.hazard,
        ),
        Collider(
          bounds: Rect(380, 465, 50, 15),
          type: ColliderType.hazard,
        ),
        Collider(
          bounds: Rect(580, 465, 50, 15),
          type: ColliderType.hazard,
        ),
      ],
    ));
    
    // 第5关 - 终极挑战
    _levels.add(LevelData(
      id: 5,
      name: 'Level 5: Final Challenge',
      playerStart: Vector2(50, 400),
      backgroundColor: 0xFF27AE60,
      colliders: [
        // 起点
        Collider(
          bounds: Rect(0, 450, 100, 50),
          type: ColliderType.platform,
        ),
        // 上升路径
        for (int i = 0; i < 5; i++)
          Collider(
            bounds: Rect(100 + i * 120, 400 - i * 80, 60, 20),
            type: ColliderType.platform,
          ),
        // 顶部平台
        Collider(
          bounds: Rect(400, 50, 100, 20),
          type: ColliderType.platform,
        ),
        // 下降路径
        for (int i = 0; i < 4; i++)
          Collider(
            bounds: Rect(550 + i * 80, 50 + i * 100, 60, 20),
            type: ColliderType.platform,
          ),
        // 终点
        Collider(
          bounds: Rect(770, 380, 30, 50),
          type: ColliderType.trigger,
        ),
        // 大量陷阱
        for (int i = 0; i < 8; i++)
          Collider(
            bounds: Rect(80 + i * 90, 485, 25, 15),
            type: ColliderType.hazard,
          ),
        for (int i = 0; i < 3; i++)
          Collider(
            bounds: Rect(200 + i * 100, 320, 30, 15),
            type: ColliderType.hazard,
          ),
        for (int i = 0; i < 3; i++)
          Collider(
            bounds: Rect(200 + i * 100, 160, 30, 15),
            type: ColliderType.hazard,
          ),
      ],
    ));
  }
  
  /// 获取当前关卡
  LevelData getCurrentLevel() {
    return _levels[currentLevelIndex];
  }
  
  /// 获取指定关卡
  LevelData getLevel(int index) {
    return _levels[index];
  }
  
  /// 获取关卡数量
  int get levelCount => _levels.length;
  
  /// 下一关
  bool nextLevel() {
    if (currentLevelIndex < _levels.length - 1) {
      currentLevelIndex++;
      return true;
    }
    return false;
  }
  
  /// 上一关
  bool previousLevel() {
    if (currentLevelIndex > 0) {
      currentLevelIndex--;
      return true;
    }
    return false;
  }
  
  /// 重置到第一关
  void reset() {
    currentLevelIndex = 0;
  }
  
  /// 设置关卡
  void setLevel(int index) {
    if (index >= 0 && index < _levels.length) {
      currentLevelIndex = index;
    }
  }
}
