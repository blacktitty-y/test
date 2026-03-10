import 'physics_engine.dart';
import 'rigidbody.dart';

/// 碰撞体类型
enum ColliderType {
  platform,     // 平台
  wall,         // 墙壁
  hazard,       // 陷阱（尖刺、熔岩等）
  trigger,      // 触发器（终点、传送门等）
}

/// 碰撞体
class Collider {
  /// 碰撞盒
  final Rect bounds;
  
  /// 碰撞体类型
  final ColliderType type;
  
  /// 是否单向平台（可以从下方穿过）
  final bool isOneWay;
  
  /// 是否激活
  bool isActive;
  
  Collider({
    required this.bounds,
    required this.type,
    this.isOneWay = false,
    this.isActive = true,
  });
}

/// 碰撞信息
class CollisionInfo {
  /// 是否发生碰撞
  final bool hasCollision;
  
  /// 碰撞的法线方向
  final Vector2 normal;
  
  /// 碰撞体
  final Collider? collider;
  
  CollisionInfo({
    required this.hasCollision,
    this.normal = Vector2.zero(),
    this.collider,
  });
  
  static CollisionInfo none() => CollisionInfo(hasCollision: false);
}

/// 碰撞检测系统
class CollisionSystem {
  final List<Collider> _colliders = [];
  
  /// 添加碰撞体
  void addCollider(Collider collider) {
    _colliders.add(collider);
  }
  
  /// 移除碰撞体
  void removeCollider(Collider collider) {
    _colliders.remove(collider);
  }
  
  /// 清空所有碰撞体
  void clear() {
    _colliders.clear();
  }
  
  /// 检测刚体与所有碰撞体的碰撞
  CollisionInfo checkCollision(RigidBody body, Rect bodyBounds) {
    for (final collider in _colliders) {
      if (!collider.isActive) continue;
      
      // 单向平台检测（只能从上方落下时碰撞）
      if (collider.isOneWay) {
        if (bodyBounds.bottom <= collider.bounds.top + body.velocity.y + 5) {
          // 从上方接近，检测碰撞
          if (bodyBounds.intersects(collider.bounds)) {
            return CollisionInfo(
              hasCollision: true,
              normal: Vector2(0, -1),
              collider: collider,
            );
          }
        }
        continue;
      }
      
      // 普通碰撞检测
      if (bodyBounds.intersects(collider.bounds)) {
        // 计算碰撞法线
        final intersection = bodyBounds.intersection(collider.bounds);
        if (intersection != null) {
          final normal = _calculateCollisionNormal(bodyBounds, collider.bounds, intersection);
          return CollisionInfo(
            hasCollision: true,
            normal: normal,
            collider: collider,
          );
        }
      }
    }
    
    return CollisionInfo.none();
  }
  
  /// 计算碰撞法线
  Vector2 _calculateCollisionNormal(Rect body, Rect other, Rect intersection) {
    final dx = (body.center.x - other.center.x).abs();
    final dy = (body.center.y - other.center.y).abs();
    final widthSum = (body.width + other.width) / 2;
    final heightSum = (body.height + other.height) / 2;
    
    // 判断碰撞主要方向
    if (dx / widthSum > dy / heightSum) {
      // 水平碰撞
      return body.center.x < other.center.x ? Vector2(-1, 0) : Vector2(1, 0);
    } else {
      // 垂直碰撞
      return body.center.y < other.center.y ? Vector2(0, -1) : Vector2(0, 1);
    }
  }
  
  /// 解析碰撞，调整刚体位置
  void resolveCollision(RigidBody body, Rect bodyBounds, CollisionInfo collision) {
    if (!collision.hasCollision) return;
    
    final collider = collision.collider!;
    final normal = collision.normal;
    
    // 根据碰撞类型处理
    switch (collider.type) {
      case ColliderType.platform:
      case ColliderType.wall:
        _resolveSolidCollision(body, bodyBounds, collider, normal);
        break;
      case ColliderType.hazard:
        // 陷阱不产生物理碰撞，游戏逻辑会处理
        break;
      case ColliderType.trigger:
        // 触发器不产生物理碰撞
        break;
    }
  }
  
  /// 解析固体碰撞
  void _resolveSolidCollision(RigidBody body, Rect bodyBounds, Collider collider, Vector2 normal) {
    if (normal.y < 0) {
      // 从上方落下
      body.position.y = collider.bounds.top - bodyBounds.height / 2;
      body.velocity.y = 0;
      body.isOnGround = true;
    } else if (normal.y > 0) {
      // 从下方撞击
      body.position.y = collider.bounds.bottom + bodyBounds.height / 2;
      body.velocity.y = 0;
    } else if (normal.x < 0) {
      // 从左侧撞击
      body.position.x = collider.bounds.left - bodyBounds.width / 2;
      body.velocity.x = 0;
    } else if (normal.x > 0) {
      // 从右侧撞击
      body.position.x = collider.bounds.right + bodyBounds.width / 2;
      body.velocity.x = 0;
    }
  }
}

extension RectExtension on Rect {
  Vector2 get center => Vector2(x + width / 2, y + height / 2);
}
