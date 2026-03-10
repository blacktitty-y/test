import 'package:flutter/material.dart';
import '../game/game_state.dart';

class MainMenu extends StatelessWidget {
  final VoidCallback onStart;
  final VoidCallback onLevelSelect;
  
  const MainMenu({
    Key? key,
    required this.onStart,
    required this.onLevelSelect,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2C3E50),
            Color(0xFF3498DB),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 游戏标题
            Container(
              padding: const EdgeInsets.all(20),
              child: const Text(
                'LEVEL DEVIL',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black,
                      offset: Offset(3, 3),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // 游戏图标
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person,
                size: 80,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 60),
            // 开始游戏按钮
            _buildButton(
              '开始游戏',
              Icons.play_arrow,
              Colors.green,
              onStart,
            ),
            const SizedBox(height: 20),
            // 选关按钮
            _buildButton(
              '选择关卡',
              Icons.list,
              Colors.orange,
              onLevelSelect,
            ),
            const SizedBox(height: 40),
            // 提示文本
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                '使用屏幕下方的虚拟摇杆和跳跃按钮控制角色',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildButton(String text, IconData icon, Color color, VoidCallback onPressed) {
    return Container(
      width: 250,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
