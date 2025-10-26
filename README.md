# 🏁 Racing Car Game

An exciting 2D racing game built with Flutter and Flame engine! Dodge obstacles, collect points, and test your reflexes in this fast-paced mobile racing experience.

![Flutter](https://img.shields.io/badge/Flutter-3.35.4-blue)
![Flame](https://img.shields.io/badge/Flame-1.32.0-orange)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20Web-green)

## 🎮 Game Features

### Core Gameplay
- **🚗 Smooth Controls**: Seamless lane switching with keyboard arrow keys or touch controls
- **🚧 Dynamic Obstacles**: Randomly spawning obstacle cars to avoid
- **📊 Real-time Scoring**: Track your score as you survive longer
- **⚡ Progressive Difficulty**: Game speed increases over time for added challenge
- **💥 Collision Detection**: Precise collision system for fair gameplay
- **🔄 Instant Restart**: Quick restart functionality to try again

### Visual Elements
- **🛣️ Animated Road**: Scrolling road with lane markings
- **🌳 Side Grass**: Beautiful green grass borders
- **🎨 Custom Graphics**: Hand-drawn car designs with wheels and windows
- **🏆 Score Display**: Real-time score counter
- **📱 Responsive UI**: Adapts to different screen sizes

### Controls
- **⌨️ Desktop**: Arrow keys (← →) to move left/right
- **📱 Mobile**: Tap left or right side of screen to change lanes
- **🖱️ Web**: Both keyboard and mouse click supported

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.35.4 or higher
- Dart 3.9.2 or higher
- Android SDK (for Android builds)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/mohamed-khairy-5i/game.git
cd game
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the game:
```bash
# For web
flutter run -d chrome

# For Android
flutter run -d android

# For release build
flutter run --release
```

## 📦 Download APK & AAB

Ready to play on Android? Download the latest release:

### Version 2.0.0 (Latest)

**For Direct Installation (APK):**
- **[📥 Universal APK (40MB)](releases/racing-game-v2.0.0.apk)** - Works on all Android devices
- **[📥 ARM64 APK (14MB)](releases/racing-game-v2.0.0-arm64.apk)** - Optimized for modern devices

**For Google Play Store Upload (AAB):**
- **[📦 App Bundle (37MB)](releases/racing-game-v2.0.0.aab)** - For Play Store submission

### Installation Instructions
**For APK files:**
1. Download the APK file (Universal or ARM64)
2. Enable "Install from Unknown Sources" in your Android settings
3. Open the APK file and tap "Install"
4. Launch the game and enjoy!

**For AAB file:**
1. Upload to Google Play Console
2. Google Play will generate optimized APKs for users
3. Users download from Play Store directly

## 🎯 How to Play

1. **Start**: Game begins automatically when launched
2. **Move**: Use arrow keys (desktop) or tap screen (mobile) to switch lanes
3. **Avoid**: Dodge red obstacle cars coming towards you
4. **Score**: Survive as long as possible to maximize your score
5. **Speed**: Game gets progressively faster as you play
6. **Crash**: Game ends when you collide with an obstacle
7. **Restart**: Tap "Play Again" button to restart

## 🏗️ Project Structure

```
lib/
├── main.dart              # App entry point and game wrapper
└── game/
    └── racing_game.dart   # Main game logic and components
        ├── RacingGame     # Game engine controller
        ├── PlayerCar      # Player-controlled car
        ├── ObstacleCar    # AI obstacle cars
        ├── RoadBackground # Animated road rendering
        ├── ScoreComponent # Score display
        └── GameTitle      # Title display
```

## 🛠️ Technical Details

### Architecture
- **Game Engine**: Flame 1.32.0
- **State Management**: Built-in Flame component system
- **Rendering**: Custom Canvas drawing
- **Animation**: Manual frame-based animation
- **Collision**: Distance-based collision detection

### Performance
- 60 FPS target frame rate
- Optimized rendering pipeline
- Memory-efficient component management
- Smooth animations with delta time calculations

### Components

#### PlayerCar
- 3-lane movement system
- Smooth lane transitions
- Touch and keyboard input handling
- Collision detection with obstacles

#### ObstacleCar
- Random lane spawning
- Speed-based movement
- Automatic removal when off-screen
- Visual distinction from player

#### RoadBackground
- Scrolling road effect
- Lane markings animation
- Grass borders
- Yellow road edges

## 🎨 Customization

Want to modify the game? Here are some easy customizations:

### Change Player Car Color
```dart
// In PlayerCar.render()
final paint = Paint()..color = Colors.blue; // Change to your color
```

### Adjust Game Difficulty
```dart
// In RacingGame
double gameSpeed = 200.0; // Initial speed (higher = harder)
final double obstacleInterval = 1.5; // Obstacle spawn rate (lower = harder)
```

### Modify Scoring
```dart
// In RacingGame.update()
score += (dt * 10).toInt(); // Increase multiplier for faster scoring
```

## 🧪 Testing

### Web Preview
```bash
flutter run -d chrome
```

### Android Testing
```bash
flutter run -d android
```

### Release Build Testing
```bash
flutter build apk --release
adb install build/app/outputs/flutter-apk/app-release.apk
```

## 📱 Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| Android  | ✅ Fully Supported | APK available for download |
| Web      | ✅ Fully Supported | Play in browser |
| iOS      | ⚠️ Not Tested | Should work with minor adjustments |
| Desktop  | ⚠️ Experimental | Works but not optimized |

## 🤝 Contributing

Contributions are welcome! Here are some ideas for improvements:

- [ ] Add power-ups (speed boost, shield, etc.)
- [ ] Multiple car designs to choose from
- [ ] Sound effects and background music
- [ ] High score leaderboard
- [ ] Multiple difficulty levels
- [ ] Different road environments
- [ ] Particle effects for collisions
- [ ] Achievement system

## 📄 License

This project is open source and available under the MIT License.

## 👨‍💻 Developer

Created with ❤️ by **Mohamed Khairy**

- GitHub: [@mohamed-khairy-5i](https://github.com/mohamed-khairy-5i)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Flame engine for game development capabilities
- Open source community for inspiration

## 📞 Support

Having issues? Found a bug? Have suggestions?

- Open an issue on GitHub
- Submit a pull request
- Contact the developer

## 🎮 Play Online

Try the web version: [Play Racing Game](https://5060-ichwqzk6k5eop1u9o3xeb-3844e1b6.sandbox.novita.ai)

---

**Enjoy the game! 🏁🚗💨**
