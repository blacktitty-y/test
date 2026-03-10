import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// 音效类型
enum SoundEffect {
  jump,
  death,
  levelComplete,
  buttonClick,
  hazardHit,
}

/// 背景音乐类型
enum BackgroundMusic {
  menu,
  playing,
}

/// 音频管理器
class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();
  
  late AudioPlayer _bgmPlayer;
  late AudioPlayer _sfxPlayer;
  
  bool _isInitialized = false;
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  
  /// 初始化音频管理器
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      _bgmPlayer = AudioPlayer();
      _sfxPlayer = AudioPlayer();
      
      // 设置背景音乐循环播放
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
      
      _isInitialized = true;
      debugPrint('AudioManager initialized');
    } catch (e) {
      debugPrint('Error initializing AudioManager: $e');
    }
  }
  
  /// 播放音效
  Future<void> playSound(SoundEffect sound) async {
    if (!_isInitialized || !_soundEnabled) return;
    
    try {
      String assetPath;
      switch (sound) {
        case SoundEffect.jump:
          assetPath = 'assets/audio/jump.mp3';
          break;
        case SoundEffect.death:
          assetPath = 'assets/audio/death.mp3';
          break;
        case SoundEffect.levelComplete:
          assetPath = 'assets/audio/level_complete.mp3';
          break;
        case SoundEffect.buttonClick:
          assetPath = 'assets/audio/button_click.mp3';
          break;
        case SoundEffect.hazardHit:
          assetPath = 'assets/audio/hazard_hit.mp3';
          break;
      }
      
      await _sfxPlayer.play(AssetSource(assetPath));
    } catch (e) {
      debugPrint('Error playing sound $sound: $e');
      // 忽略音频文件不存在的错误
    }
  }
  
  /// 播放背景音乐
  Future<void> playMusic(BackgroundMusic music) async {
    if (!_isInitialized || !_musicEnabled) return;
    
    try {
      String assetPath;
      switch (music) {
        case BackgroundMusic.menu:
          assetPath = 'assets/audio/menu_bgm.mp3';
          break;
        case BackgroundMusic.playing:
          assetPath = 'assets/audio/game_bgm.mp3';
          break;
      }
      
      await _bgmPlayer.play(AssetSource(assetPath));
      await _bgmPlayer.setVolume(0.5);
    } catch (e) {
      debugPrint('Error playing music $music: $e');
      // 忽略音频文件不存在的错误
    }
  }
  
  /// 停止背景音乐
  Future<void> stopMusic() async {
    if (!_isInitialized) return;
    
    try {
      await _bgmPlayer.stop();
    } catch (e) {
      debugPrint('Error stopping music: $e');
    }
  }
  
  /// 暂停背景音乐
  Future<void> pauseMusic() async {
    if (!_isInitialized) return;
    
    try {
      await _bgmPlayer.pause();
    } catch (e) {
      debugPrint('Error pausing music: $e');
    }
  }
  
  /// 恢复背景音乐
  Future<void> resumeMusic() async {
    if (!_isInitialized) return;
    
    try {
      await _bgmPlayer.resume();
    } catch (e) {
      debugPrint('Error resuming music: $e');
    }
  }
  
  /// 设置音量
  Future<void> setMusicVolume(double volume) async {
    if (!_isInitialized) return;
    
    try {
      await _bgmPlayer.setVolume(volume.clamp(0.0, 1.0));
    } catch (e) {
      debugPrint('Error setting music volume: $e');
    }
  }
  
  /// 设置音效音量
  Future<void> setSoundVolume(double volume) async {
    if (!_isInitialized) return;
    
    try {
      await _sfxPlayer.setVolume(volume.clamp(0.0, 1.0));
    } catch (e) {
      debugPrint('Error setting sound volume: $e');
    }
  }
  
  /// 切换音效开关
  void toggleSound() {
    _soundEnabled = !_soundEnabled;
  }
  
  /// 切换音乐开关
  void toggleMusic() {
    _musicEnabled = !_musicEnabled;
    if (!_musicEnabled) {
      stopMusic();
    }
  }
  
  /// 音效是否开启
  bool get isSoundEnabled => _soundEnabled;
  
  /// 音乐是否开启
  bool get isMusicEnabled => _musicEnabled;
  
  /// 是否正在播放音乐
  bool get isPlaying => _isInitialized ? _bgmPlayer.state == PlayerState.playing : false;
  
  /// 释放资源
  Future<void> dispose() async {
    if (!_isInitialized) return;
    
    try {
      await _bgmPlayer.dispose();
      await _sfxPlayer.dispose();
      _isInitialized = false;
    } catch (e) {
      debugPrint('Error disposing AudioManager: $e');
    }
  }
}
