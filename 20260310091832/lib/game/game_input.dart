import 'package:flutter/material.dart';
import '../entities/player.dart';
import '../physics/rigidbody.dart';

/// 游戏输入控制器
class GameInputController {
  /// 当前输入方向
  InputDirection inputDirection = InputDirection.none;
  
  /// 触摸控制区域
  final List<Offset> touchPoints = [];
  
  /// 虚拟摇杆位置
  Offset? joystickPosition;
  
  /// 虚拟跳跃按钮位置
  Rect? jumpButtonRect;
  
  /// 屏幕尺寸
  Size screenSize = Size.zero;
  
  /// 初始化虚拟控制
  void init(Size size) {
    screenSize = size;
    
    // 虚拟摇杆位置（左下角）
    joystickPosition = Offset(
      size.width * 0.15,
      size.height * 0.85,
    );
    
    // 跳跃按钮位置（右下角）
    const buttonSize = 80.0;
    jumpButtonRect = Rect.fromLTWH(
      size.width * 0.85 - buttonSize / 2,
      size.height * 0.85 - buttonSize / 2,
      buttonSize,
      buttonSize,
    );
  }
  
  /// 处理触摸开始
  void handleTouchStart(Offset position) {
    touchPoints.add(position);
    _updateInputFromTouch(position);
  }
  
  /// 处理触摸移动
  void handleTouchMove(Offset position, int pointerId) {
    if (pointerId < touchPoints.length) {
      touchPoints[pointerId] = position;
    }
    _updateInputFromTouch(position);
  }
  
  /// 处理触摸结束
  void handleTouchEnd(int pointerId) {
    if (pointerId < touchPoints.length) {
      touchPoints.removeAt(pointerId);
    }
    if (touchPoints.isEmpty) {
      inputDirection = InputDirection.none;
    }
  }
  
  /// 从触摸位置更新输入
  void _updateInputFromTouch(Offset position) {
    if (joystickPosition == null) return;
    
    final dx = position.dx - joystickPosition!.dx;
    final dy = position.dy - joystickPosition!.dy;
    final threshold = 30.0;
    
    if (dx.abs() > threshold || dy.abs() > threshold) {
      if (dx.abs() > dy.abs()) {
        inputDirection = dx > 0 ? InputDirection.right : InputDirection.left;
      } else {
        inputDirection = dx > 0 ? InputDirection.right : InputDirection.left;
      }
    }
  }
  
  /// 检查是否点击了跳跃按钮
  bool isJumpButtonPressed(Offset position) {
    return jumpButtonRect?.containsPoint(Vector2(position.dx, position.dy)) ?? false;
  }
  
  /// 获取当前输入方向
  InputDirection getInputDirection() {
    return inputDirection;
  }
  
  /// 重置输入
  void reset() {
    inputDirection = InputDirection.none;
    touchPoints.clear();
  }
}
