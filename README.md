# Level Devil Android App

一个基于 Flutter 开发的 2D 平台跳跃游戏安卓应用，灵感来源于 Poki.com 上的 Level Devil 游戏。

## 游戏特色

- **5个精心设计的关卡**：从简单到困难，逐步挑战
- **物理引擎系统**：包含重力、摩擦力、碰撞检测
- **触摸控制**：虚拟摇杆和跳跃按钮，适合手机操作
- **多样的陷阱**：尖刺、移动平台等
- **精美的UI**：主菜单、HUD、暂停、游戏结束等界面
- **音效支持**：跳跃、死亡、关卡完成等音效（需添加音频文件）

## 技术栈

- **Flutter**：跨平台移动应用框架
- **Dart**：编程语言
- **自定义物理引擎**：实现 2D 物理模拟

## 项目结构

```
lib/
├── audio/              # 音频管理
│   └── audio_manager.dart
├── entities/           # 游戏实体
│   └── player.dart
├── game/               # 游戏逻辑
│   ├── game_input.dart
│   ├── game_manager.dart
│   └── game_state.dart
├── levels/             # 关卡数据
│   └── level_data.dart
├── physics/            # 物理引擎
│   ├── collision_system.dart
│   ├── physics_engine.dart
│   └── rigidbody.dart
└── ui/                 # 用户界面
    ├── game_over_dialog.dart
    ├── hud.dart
    └── main_menu.dart

android/                # Android 平台配置
├── app/
│   ├── build.gradle
│   └── src/main/
│       ├── AndroidManifest.xml
│       └── res/
└── build.gradle

assets/
└── audio/              # 音频资源（需手动添加）
```

## 安装和运行

### 前置要求

1. 安装 Flutter SDK（3.0.0 或更高版本）
2. 安装 Android SDK 和 Android Studio
3. 配置 Android 模拟器或连接 Android 设备

### 运行步骤

1. 克隆或下载项目到本地

2. 进入项目目录：
```bash
cd level_devil_android
```

3. 获取依赖：
```bash
flutter pub get
```

4. 检查设备连接：
```bash
flutter devices
```

5. 运行应用：
```bash
flutter run
```

## 添加音频文件（可选）

为了获得完整的游戏体验，可以将以下音频文件添加到 `assets/audio/` 目录：

- `jump.mp3` - 跳跃音效
- `death.mp3` - 死亡音效
- `level_complete.mp3` - 关卡完成音效
- `button_click.mp3` - 按钮点击音效
- `hazard_hit.mp3` - 撞击陷阱音效
- `menu_bgm.mp3` - 主菜单背景音乐
- `game_bgm.mp3` - 游戏背景音乐

注意：即使没有音频文件，游戏也能正常运行。

## 构建发布版 APK

### 构建 Debug APK
```bash
flutter build apk --debug
```

### 构建 Release APK
```bash
flutter build apk --release
```

APK 文件将生成在 `build/app/outputs/flutter-apk/` 目录下。

## 游戏操作

- **虚拟摇杆**：控制角色左右移动
- **跳跃按钮**：点击红色按钮跳跃
- **暂停按钮**：点击右上角暂停图标暂停游戏

## 关卡设计

1. **Level 1 - Welcome**：入门关卡，学习基本操作
2. **Level 2 - Dangerous Path**：更多陷阱和挑战
3. **Level 3 - Vertical Challenge**：垂直跳跃挑战
4. **Level 4 - Trap Maze**：陷阱迷宫
5. **Level 5 - Final Challenge**：终极挑战

## 开发说明

### 物理引擎

游戏使用自定义的 2D 物理引擎，包括：
- **重力系统**：角色受重力影响下落
- **碰撞检测**：检测角色与平台、陷阱的碰撞
- **摩擦力**：角色移动时的减速效果
- **单向平台**：可以从下方跳过的平台

### 碰撞体类型

- **Platform**：普通平台，可以站在上面
- **Wall**：墙壁，可以跳跃踩踏
- **Hazard**：陷阱（尖刺等），触碰即死
- **Trigger**：触发器（终点），触碰过关

### 游戏状态

- **Menu**：主菜单
- **Playing**：游戏中
- **Paused**：暂停
- **LevelComplete**：关卡完成
- **GameOver**：游戏结束
- **Victory**：通关

## 自定义关卡

可以在 `lib/levels/level_data.dart` 文件中添加自定义关卡。每个关卡包含：

- 玩家起始位置
- 多个碰撞体（平台、墙壁、陷阱、终点）
- 背景颜色

示例：
```dart
LevelData(
  id: 6,
  name: 'Level 6: My Custom Level',
  playerStart: Vector2(50, 300),
  backgroundColor: 0xFF1ABC9C,
  colliders: [
    Collider(
      bounds: Rect(0, 400, 800, 100),
      type: ColliderType.platform,
    ),
    // 添加更多碰撞体...
  ],
)
```

## 许可证

本项目仅供学习和个人使用。

## 致谢

灵感来源于 [Poki.com](https://poki.com/zh/g/level-devil) 上的 Level Devil 游戏。
