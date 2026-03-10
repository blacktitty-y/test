/// 游戏状态枚举
enum GameState {
  menu,       // 主菜单
  playing,    // 游戏中
  paused,     // 暂停
  levelComplete, // 关卡完成
  gameOver,   // 游戏结束
  victory,    // 通关
}

/// 游戏状态管理器
class GameStateManager {
  GameState _currentState = GameState.menu;
  
  /// 获取当前状态
  GameState get currentState => _currentState;
  
  /// 设置状态
  void setState(GameState newState) {
    _currentState = newState;
  }
  
  /// 检查是否在指定状态
  bool isInState(GameState state) {
    return _currentState == state;
  }
  
  /// 开始游戏
  void startGame() {
    _currentState = GameState.playing;
  }
  
  /// 暂停游戏
  void pauseGame() {
    if (_currentState == GameState.playing) {
      _currentState = GameState.paused;
    }
  }
  
  /// 继续游戏
  void resumeGame() {
    if (_currentState == GameState.paused) {
      _currentState = GameState.playing;
    }
  }
  
  /// 关卡完成
  void levelComplete() {
    _currentState = GameState.levelComplete;
  }
  
  /// 游戏结束
  void gameOver() {
    _currentState = GameState.gameOver;
  }
  
  /// 胜利
  void victory() {
    _currentState = GameState.victory;
  }
  
  /// 返回菜单
  void returnToMenu() {
    _currentState = GameState.menu;
  }
}
