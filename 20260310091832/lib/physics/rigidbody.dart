import 'physics_engine.dart';

/// 刚体组件
class RigidBody {
  /// 位置
  Vector2 position;
  
  /// 速度
  Vector2 velocity;
  
  /// 加速度
  Vector2 acceleration;
  
  /// 质量
  double mass;
  
  /// 是否受重力影响
  bool affectedByGravity;
  
  /// 是否为静态物体
  bool isStatic;
  
  /// 地面检测
  bool isOnGround;
  
  RigidBody({
    Vector2? position,
    Vector2? velocity,
    Vector2? acceleration,
    this.mass = 1.0,
    this.affectedByGravity = true,
    this.isStatic = false,
  })  : position = position ?? Vector2.zero(),
        velocity = velocity ?? Vector2.zero(),
        acceleration = acceleration ?? Vector2.zero(),
        isOnGround = false;
  
  /// 物理更新
  void update() {
    if (isStatic) return;
    
    // 应用重力
    if (affectedByGravity) {
      acceleration.y += PhysicsEngine.gravity;
    }
    
    // 更新速度
    velocity = velocity + acceleration;
    
    // 限制最大下落速度
    if (velocity.y > PhysicsEngine.maxFallSpeed) {
      velocity.y = PhysicsEngine.maxFallSpeed;
    }
    
    // 应用摩擦力
    velocity.x *= PhysicsEngine.friction;
    
    // 更新位置
    position = position + velocity;
    
    // 重置加速度
    acceleration = Vector2.zero();
    
    // 重置地面状态
    isOnGround = false;
  }
  
  /// 施加力
  void applyForce(Vector2 force) {
    if (isStatic) return;
    acceleration = acceleration + (force * (1.0 / mass));
  }
  
  /// 施加冲量（用于跳跃）
  void applyImpulse(Vector2 impulse) {
    if (isStatic) return;
    velocity = velocity + (impulse * (1.0 / mass));
  }
  
  /// 设置速度
  void setVelocity(Vector2 newVelocity) {
    velocity = newVelocity.copy();
  }
  
  /// 跳跃
  void jump() {
    if (isOnGround) {
      velocity.y = PhysicsEngine.jumpForce;
    }
  }
  
  /// 移动
  void move(double direction) {
    if (isStatic) return;
    velocity.x = direction * PhysicsEngine.moveSpeed;
  }
}
