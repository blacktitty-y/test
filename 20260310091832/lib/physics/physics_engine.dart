import 'dart:math';

/// 简单的2D物理引擎
class PhysicsEngine {
  /// 重力常量
  static const double gravity = 0.5;
  
  /// 最大下落速度
  static const double maxFallSpeed = 12.0;
  
  /// 摩擦力系数
  static const double friction = 0.85;
  
  /// 跳跃力量
  static const double jumpForce = -12.0;
  
  /// 移动速度
  static const double moveSpeed = 5.0;
  
  /// 碰撞检测精度
  static const double collisionPadding = 0.1;
}

/// 2D向量类
class Vector2 {
  double x;
  double y;
  
  Vector2(this.x, this.y);
  
  Vector2.zero() : x = 0, y = 0;
  
  Vector2 copy() => Vector2(x, y);
  
  Vector2 operator +(Vector2 other) => Vector2(x + other.x, y + other.y);
  
  Vector2 operator -(Vector2 other) => Vector2(x - other.x, y - other.y);
  
  Vector2 operator *(double scalar) => Vector2(x * scalar, y * scalar);
  
  double length => sqrt(x * x + y * y);
  
  Vector2 normalized() {
    final len = length;
    if (len > 0) {
      return Vector2(x / len, y / len);
    }
    return Vector2.zero();
  }
}

/// 矩形碰撞盒
class Rect {
  double x;
  double y;
  double width;
  double height;
  
  Rect(this.x, this.y, this.width, this.height);
  
  Rect.fromLTWH(double left, double top, double width, double height)
      : x = left,
        y = top,
        width = width,
        height = height;
  
  double get left => x;
  double get right => x + width;
  double get top => y;
  double get bottom => y + height;
  
  /// 检查是否与另一个矩形相交
  bool intersects(Rect other) {
    return right > other.left + PhysicsEngine.collisionPadding &&
           left < other.right - PhysicsEngine.collisionPadding &&
           bottom > other.top + PhysicsEngine.collisionPadding &&
           top < other.bottom - PhysicsEngine.collisionPadding;
  }
  
  /// 获取交集矩形
  Rect? intersection(Rect other) {
    final newLeft = max(left, other.left);
    final newTop = max(top, other.top);
    final newRight = min(right, other.right);
    final newBottom = min(bottom, other.bottom);
    
    if (newRight > newLeft && newBottom > newTop) {
      return Rect(newLeft, newTop, newRight - newLeft, newBottom - newTop);
    }
    return null;
  }
  
  /// 检查点是否在矩形内
  bool containsPoint(Vector2 point) {
    return point.x >= left &&
           point.x <= right &&
           point.y >= top &&
           point.y <= bottom;
  }
}
