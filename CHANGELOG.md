# Changelog - Racing Game

## Version 2.0.0 (2025-10-25)

### 🎉 Major New Features

#### Power-Ups System
- **🛡️ Shield Power-Up**: Protects from one collision (5 seconds duration)
- **⏱️ Slow Time Power-Up**: Slows down obstacles (5 seconds duration)
- **🧲 Magnet Power-Up**: Attracts nearby coins (8 seconds duration)
- Active power-ups displayed on screen with countdown timers

#### Coin Collection System
- **💰 Collectible Coins**: Spawn randomly in lanes
- **Animated Rotation**: Coins rotate for visual appeal
- **Score Bonus**: +50 points per coin collected
- **Total Coins Tracking**: Lifetime coins counter
- **Particle Effects**: Beautiful particle burst on collection

#### Enhanced UI & Feedback
- **High Score System**: Persistent high score using SharedPreferences
- **Speed Indicator**: Real-time speed display in km/h
- **Coins Display**: Current total coins shown during gameplay
- **New High Score Celebration**: Special message when beating high score
- **Improved Game Over Screen**: Shows score, high score, coins, and speed
- **Statistics Cards**: Beautiful stat display on game over

#### Visual Effects
- **Particle System**: Explosion effects for coin/power-up collection
- **Shield Visual**: Glowing cyan shield around player car
- **Power-Up Animations**: Pulsing scale effect on power-ups
- **Enhanced Graphics**: Better color schemes and visual polish

### 🔧 Technical Improvements
- Added `flame_audio` package (v2.11.10) for future audio support
- Added `shared_preferences` (v2.5.3) for persistent storage
- Improved game loop with power-up state management
- Better collision detection system
- Optimized rendering performance
- Clean code architecture with separate components file

### 📊 Game Balance
- Adjusted obstacle spawn rate
- Added coin spawn system (every 2 seconds)
- Power-ups spawn every 10 seconds
- Slow-time effect reduces speed by 50%
- Magnet attracts coins within 200 units radius

### 🎮 Enhanced Gameplay
- More strategic gameplay with power-ups
- Risk/reward decisions for collecting items
- Progressive difficulty still maintained
- Shield provides safety net for mistakes
- Coins add collection objective beyond survival

### 📱 Build Information
- **APK Size**: 42.1 MB
- **AAB Size**: 38.0 MB
- **Version Code**: 2
- **Min SDK**: API 21 (Android 5.0)
- **Target SDK**: API 35 (Android 15)

---

## Version 1.0.0 (2025-10-24)

### Initial Release Features

#### Core Gameplay
- 3-lane racing system
- Player car with smooth lane switching
- Obstacle cars that increase in speed
- Real-time score tracking
- Progressive difficulty
- Collision detection

#### Controls
- Keyboard support (arrow keys)
- Touch controls for mobile
- Smooth animated transitions

#### UI Elements
- Game title display
- Score counter
- Game over screen with restart
- Road animation with lane markings
- Grass borders and road edges

#### Graphics
- Hand-drawn car designs
- Blue player car
- Red obstacle cars
- Animated road lines
- Yellow road edges
- Green grass borders

#### Game Mechanics
- Speed increases over time
- Score based on survival time
- Instant game over on collision
- Quick restart functionality

### 📱 Build Information
- **APK Size**: 40.7 MB
- **Version Code**: 1
- **Min SDK**: API 21 (Android 5.0)
- **Target SDK**: API 35 (Android 15)

---

## Future Plans (Coming Soon)

### Audio System
- Background music
- Sound effects for:
  - Coin collection
  - Power-up pickup
  - Collision
  - Game over
  - New high score

### Additional Features
- Multiple car designs to choose from
- Car customization system
- Daily challenges
- Achievements system
- Online leaderboard
- Multiple road environments
- Weather effects (rain, fog)
- Night mode
- Multiplayer mode

### Gameplay Enhancements
- More power-up types:
  - Invincibility star
  - Double coins
  - Score multiplier
  - Jump over obstacles
- Special events
- Boss challenges
- Time trial mode
- Endless mode variations

---

**Download Links:**
- [APK v2.0.0](https://github.com/mohamed-khairy-5i/game/raw/main/releases/racing-game-v2.0.0.apk)
- [AAB v2.0.0](https://github.com/mohamed-khairy-5i/game/raw/main/releases/racing-game-v2.0.0.aab)
- [APK v1.0.0](https://github.com/mohamed-khairy-5i/game/raw/main/releases/racing-game-v1.0.0.apk)
