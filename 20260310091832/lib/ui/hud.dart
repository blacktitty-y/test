import 'package:flutter/material.dart';
import '../levels/level_data.dart';

/// 游戏HUD（抬头显示）
class GameHUD extends StatelessWidget {
  final int currentLevel;
  final int totalLevels;
  final int deathCount;
  final VoidCallback onPause;
  
  const GameHUD({
    Key? key,
    required this.currentLevel,
    required this.totalLevels,
    required this.deathCount,
    required this.onPause,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 关卡信息
              Row(
                children: [
                  const Icon(
                    Icons.flag,
                    color: Colors.yellow,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Level $currentLevel / $totalLevels',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // 死亡次数
              Row(
                children: [
                  const Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Death: $deathCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // 暂停按钮
              IconButton(
                onPressed: onPause,
                icon: const Icon(
                  Icons.pause,
                  color: Colors.white,
                  size: 32,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 虚拟控制按钮
class VirtualControls extends StatelessWidget {
  final Function(double x) onMove;
  final VoidCallback onJump;
  
  const VirtualControls({
    Key? key,
    required this.onMove,
    required this.onJump,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        
        return Stack(
          children: [
            // 虚拟摇杆区域
            Positioned(
              left: screenWidth * 0.1,
              bottom: screenHeight * 0.15,
              child: _Joystick(onMove: onMove),
            ),
            // 跳跃按钮
            Positioned(
              right: screenWidth * 0.1,
              bottom: screenHeight * 0.15,
              child: _JumpButton(onJump: onJump),
            ),
          ],
        );
      },
    );
  }
}

/// 虚拟摇杆
class _Joystick extends StatefulWidget {
  final Function(double x) onMove;
  
  const _Joystick({required this.onMove});
  
  @override
  State<_Joystick> createState() => _JoystickState();
}

class _JoystickState extends State<_Joystick> {
  double _dragX = 0;
  double _baseSize = 80;
  double _stickSize = 40;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        setState(() {
          _dragX = details.localPosition.dx;
        });
        widget.onMove(_dragX / (_baseSize / 2));
      },
      onPanUpdate: (details) {
        setState(() {
          _dragX = details.localPosition.dx;
        });
        widget.onMove(_dragX / (_baseSize / 2));
      },
      onPanEnd: (details) {
        setState(() {
          _dragX = 0;
        });
        widget.onMove(0);
      },
      child: Container(
        width: _baseSize,
        height: _baseSize,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
        ),
        child: Center(
          child: Container(
            width: _stickSize,
            height: _stickSize,
            transform: Matrix4.translationValues(
              _dragX.clamp(-(_baseSize / 2 - _stickSize / 2), 
                           (_baseSize / 2 - _stickSize / 2)),
              0,
              0,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 跳跃按钮
class _JumpButton extends StatelessWidget {
  final VoidCallback onJump;
  
  const _JumpButton({required this.onJump});
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onJump,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.7),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_upward,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}
