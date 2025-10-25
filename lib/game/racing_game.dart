import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'game_components.dart';

class RacingGame extends FlameGame with KeyboardEvents, TapDetector {
  late PlayerCar player;
  late RoadBackground road;
  late ScoreComponent scoreComponent;
  late HighScoreComponent highScoreComponent;
  late CoinsDisplayComponent coinsDisplay;
  late SpeedIndicatorComponent speedIndicator;
  late ActivePowerUpsComponent activePowerUps;
  
  int score = 0;
  int highScore = 0;
  int coins = 0;
  double gameSpeed = 200.0;
  bool isGameOver = false;
  double timePassed = 0;
  
  final Random random = Random();
  double timeSinceLastObstacle = 0;
  double timeSinceLastCoin = 0;
  double timeSinceLastPowerUp = 0;
  final double obstacleInterval = 1.5;
  final double coinInterval = 2.0;
  final double powerUpInterval = 10.0;
  
  // Power-ups
  bool shieldActive = false;
  double shieldTimeLeft = 0;
  bool slowTimeActive = false;
  double slowTimeLeft = 0;
  bool magnetActive = false;
  double magnetTimeLeft = 0;
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Load high score
    await _loadHighScore();
    
    // Add road background
    road = RoadBackground();
    add(road);
    
    // Add player car
    player = PlayerCar(
      position: Vector2(size.x / 2, size.y - 150),
    );
    add(player);
    
    // Add UI components
    scoreComponent = ScoreComponent();
    add(scoreComponent);
    
    highScoreComponent = HighScoreComponent();
    add(highScoreComponent);
    
    coinsDisplay = CoinsDisplayComponent();
    add(coinsDisplay);
    
    speedIndicator = SpeedIndicatorComponent();
    add(speedIndicator);
    
    activePowerUps = ActivePowerUpsComponent();
    add(activePowerUps);
    
    // Add game title
    add(GameTitle());
  }
  
  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt('highScore') ?? 0;
    coins = prefs.getInt('totalCoins') ?? 0;
  }
  
  Future<void> _saveHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    if (score > highScore) {
      highScore = score;
      await prefs.setInt('highScore', highScore);
    }
    await prefs.setInt('totalCoins', coins);
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    if (isGameOver) return;
    
    timePassed += dt;
    
    // Update power-ups
    _updatePowerUps(dt);
    
    // Increase game speed over time
    gameSpeed += dt * 2;
    
    // Spawn obstacles
    timeSinceLastObstacle += dt;
    if (timeSinceLastObstacle >= obstacleInterval) {
      spawnObstacle();
      timeSinceLastObstacle = 0;
    }
    
    // Spawn coins
    timeSinceLastCoin += dt;
    if (timeSinceLastCoin >= coinInterval) {
      spawnCoin();
      timeSinceLastCoin = 0;
    }
    
    // Spawn power-ups
    timeSinceLastPowerUp += dt;
    if (timeSinceLastPowerUp >= powerUpInterval) {
      spawnPowerUp();
      timeSinceLastPowerUp = 0;
    }
    
    // Increase score
    score += (dt * 10).toInt();
  }
  
  void _updatePowerUps(double dt) {
    if (shieldActive) {
      shieldTimeLeft -= dt;
      if (shieldTimeLeft <= 0) {
        shieldActive = false;
        shieldTimeLeft = 0;
      }
    }
    
    if (slowTimeActive) {
      slowTimeLeft -= dt;
      if (slowTimeLeft <= 0) {
        slowTimeActive = false;
        slowTimeLeft = 0;
      }
    }
    
    if (magnetActive) {
      magnetTimeLeft -= dt;
      if (magnetTimeLeft <= 0) {
        magnetActive = false;
        magnetTimeLeft = 0;
      }
      _attractCoins();
    }
  }
  
  void _attractCoins() {
    children.whereType<CoinComponent>().forEach((coin) {
      if (!coin.collected && (coin.position - player.position).length < 200) {
        final direction = (player.position - coin.position).normalized();
        coin.position.add(direction * 5);
      }
    });
  }
  
  void spawnObstacle() {
    final lanes = [size.x * 0.25, size.x * 0.5, size.x * 0.75];
    final lane = lanes[random.nextInt(lanes.length)];
    
    final effectiveSpeed = slowTimeActive ? gameSpeed * 0.5 : gameSpeed;
    
    add(ObstacleCar(
      position: Vector2(lane, -100),
      speed: effectiveSpeed,
    ));
  }
  
  void spawnCoin() {
    final lanes = [size.x * 0.25, size.x * 0.5, size.x * 0.75];
    final lane = lanes[random.nextInt(lanes.length)];
    
    final effectiveSpeed = slowTimeActive ? gameSpeed * 0.5 : gameSpeed;
    
    add(CoinComponent(
      position: Vector2(lane, -100),
      speed: effectiveSpeed,
    ));
  }
  
  void spawnPowerUp() {
    final lanes = [size.x * 0.25, size.x * 0.5, size.x * 0.75];
    final lane = lanes[random.nextInt(lanes.length)];
    
    final types = [PowerUpType.shield, PowerUpType.slowTime, PowerUpType.magnet];
    final type = types[random.nextInt(types.length)];
    
    final effectiveSpeed = slowTimeActive ? gameSpeed * 0.5 : gameSpeed;
    
    add(PowerUpComponent(
      position: Vector2(lane, -100),
      speed: effectiveSpeed,
      type: type,
    ));
  }
  
  void collectCoin() {
    coins++;
    score += 50;
    _createParticles(player.position, Colors.yellow, 8);
  }
  
  void collectPowerUp(PowerUpType type) {
    _createParticles(player.position, Colors.purple, 12);
    
    switch (type) {
      case PowerUpType.shield:
        shieldActive = true;
        shieldTimeLeft = 5.0;
        break;
      case PowerUpType.slowTime:
        slowTimeActive = true;
        slowTimeLeft = 5.0;
        break;
      case PowerUpType.magnet:
        magnetActive = true;
        magnetTimeLeft = 8.0;
        break;
    }
  }
  
  void _createParticles(Vector2 position, Color color, int count) {
    for (int i = 0; i < count; i++) {
      final angle = (i / count) * 2 * pi;
      final velocity = Vector2(cos(angle), sin(angle)) * 100;
      
      add(ParticleEffect(
        position: position.clone(),
        color: color,
        lifeTime: 0.5,
        velocity: velocity,
      ));
    }
  }
  
  void gameOver() {
    if (shieldActive) {
      shieldActive = false;
      shieldTimeLeft = 0;
      _createParticles(player.position, Colors.cyan, 16);
      return; // Shield protected the player
    }
    
    isGameOver = true;
    _saveHighScore();
    overlays.add('GameOver');
  }
  
  void restart() {
    isGameOver = false;
    score = 0;
    gameSpeed = 200.0;
    timePassed = 0;
    
    // Reset power-ups
    shieldActive = false;
    shieldTimeLeft = 0;
    slowTimeActive = false;
    slowTimeLeft = 0;
    magnetActive = false;
    magnetTimeLeft = 0;
    
    // Remove all obstacles, coins, and power-ups
    children.whereType<ObstacleCar>().toList().forEach((obstacle) {
      obstacle.removeFromParent();
    });
    children.whereType<CoinComponent>().toList().forEach((coin) {
      coin.removeFromParent();
    });
    children.whereType<PowerUpComponent>().toList().forEach((powerUp) {
      powerUp.removeFromParent();
    });
    
    // Reset player position
    player.position = Vector2(size.x / 2, size.y - 150);
    player.currentLane = 1;
    
    overlays.remove('GameOver');
  }
  
  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (isGameOver) return KeyEventResult.ignored;
    
    final isKeyDown = event is KeyDownEvent;
    
    if (isKeyDown) {
      if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        player.moveLeft();
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
        player.moveRight();
      }
    }
    
    return KeyEventResult.handled;
  }
  
  @override
  void onTapDown(TapDownInfo info) {
    if (isGameOver) return;
    
    final tapX = info.eventPosition.global.x;
    if (tapX < size.x / 2) {
      player.moveLeft();
    } else {
      player.moveRight();
    }
  }
}

// Player Car Component
class PlayerCar extends PositionComponent with HasGameReference<RacingGame> {
  int currentLane = 1; // 0: left, 1: center, 2: right
  bool isMoving = false;
  
  PlayerCar({required Vector2 position}) : super(
    position: position,
    size: Vector2(60, 100),
    anchor: Anchor.center,
  );
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Draw shield if active
    if (game.shieldActive) {
      final shieldPaint = Paint()
        ..color = Colors.cyan.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;
      
      canvas.drawCircle(
        Offset(size.x / 2, size.y / 2),
        45,
        shieldPaint,
      );
      
      final shieldFillPaint = Paint()
        ..color = Colors.cyan.withValues(alpha: 0.1)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(
        Offset(size.x / 2, size.y / 2),
        45,
        shieldFillPaint,
      );
    }
    
    // Draw car body
    final paint = Paint()..color = Colors.blue;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(8),
    );
    canvas.drawRRect(rect, paint);
    
    // Draw car windows
    final windowPaint = Paint()..color = Colors.lightBlue.shade200;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(10, 20, size.x - 20, 30),
        const Radius.circular(4),
      ),
      windowPaint,
    );
    
    // Draw wheels
    final wheelPaint = Paint()..color = Colors.black;
    canvas.drawCircle(Offset(15, 10), 8, wheelPaint);
    canvas.drawCircle(Offset(size.x - 15, 10), 8, wheelPaint);
    canvas.drawCircle(Offset(15, size.y - 10), 8, wheelPaint);
    canvas.drawCircle(Offset(size.x - 15, size.y - 10), 8, wheelPaint);
  }
  
  void moveLeft() {
    if (isMoving || currentLane <= 0) return;
    currentLane--;
    moveToLane();
  }
  
  void moveRight() {
    if (isMoving || currentLane >= 2) return;
    currentLane++;
    moveToLane();
  }
  
  void moveToLane() {
    isMoving = true;
    final targetX = game.size.x * (currentLane == 0 ? 0.25 : currentLane == 1 ? 0.5 : 0.75);
    
    final duration = 0.2;
    final startX = position.x;
    double elapsed = 0;
    
    game.add(
      TimerComponent(
        period: 0.016,
        repeat: true,
        onTick: () {
          elapsed += 0.016;
          final progress = (elapsed / duration).clamp(0.0, 1.0);
          position.x = startX + (targetX - startX) * progress;
          
          if (progress >= 1.0) {
            isMoving = false;
            return;
          }
        },
      ),
    );
  }
}

// Obstacle Car Component
class ObstacleCar extends PositionComponent with HasGameReference<RacingGame> {
  final double speed;
  
  ObstacleCar({required Vector2 position, required this.speed}) : super(
    position: position,
    size: Vector2(60, 100),
    anchor: Anchor.center,
  );
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Draw obstacle car in red
    final paint = Paint()..color = Colors.red;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(8),
    );
    canvas.drawRRect(rect, paint);
    
    // Draw car windows
    final windowPaint = Paint()..color = Colors.red.shade200;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(10, size.y - 50, size.x - 20, 30),
        const Radius.circular(4),
      ),
      windowPaint,
    );
    
    // Draw wheels
    final wheelPaint = Paint()..color = Colors.black;
    canvas.drawCircle(Offset(15, 10), 8, wheelPaint);
    canvas.drawCircle(Offset(size.x - 15, 10), 8, wheelPaint);
    canvas.drawCircle(Offset(15, size.y - 10), 8, wheelPaint);
    canvas.drawCircle(Offset(size.x - 15, size.y - 10), 8, wheelPaint);
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    position.y += speed * dt;
    
    // Check collision with player
    if ((position - game.player.position).length < 70) {
      game.gameOver();
    }
    
    // Remove if off screen
    if (position.y > game.size.y + 100) {
      removeFromParent();
    }
  }
}

// Road Background Component
class RoadBackground extends Component with HasGameReference<RacingGame> {
  double roadOffset = 0;
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Draw road background
    final paint = Paint()..color = Colors.grey.shade800;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, game.size.x, game.size.y),
      paint,
    );
    
    // Draw grass on sides
    final grassPaint = Paint()..color = Colors.green.shade700;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, game.size.x * 0.1, game.size.y),
      grassPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(game.size.x * 0.9, 0, game.size.x * 0.1, game.size.y),
      grassPaint,
    );
    
    // Draw road lines
    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4;
    
    final lineSpacing = 40.0;
    final lineHeight = 20.0;
    
    for (double y = -lineHeight + (roadOffset % (lineHeight + lineSpacing)); 
         y < game.size.y; 
         y += lineHeight + lineSpacing) {
      // Center line
      canvas.drawLine(
        Offset(game.size.x / 2, y),
        Offset(game.size.x / 2, y + lineHeight),
        linePaint,
      );
      
      // Lane dividers
      canvas.drawLine(
        Offset(game.size.x * 0.375, y),
        Offset(game.size.x * 0.375, y + lineHeight),
        linePaint,
      );
      canvas.drawLine(
        Offset(game.size.x * 0.625, y),
        Offset(game.size.x * 0.625, y + lineHeight),
        linePaint,
      );
    }
    
    // Draw road edges
    final edgePaint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 6;
    canvas.drawLine(
      Offset(game.size.x * 0.1, 0),
      Offset(game.size.x * 0.1, game.size.y),
      edgePaint,
    );
    canvas.drawLine(
      Offset(game.size.x * 0.9, 0),
      Offset(game.size.x * 0.9, game.size.y),
      edgePaint,
    );
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    if (!game.isGameOver) {
      final effectiveSpeed = game.slowTimeActive ? game.gameSpeed * 0.5 : game.gameSpeed;
      roadOffset += effectiveSpeed * dt;
    }
  }
}

// Score Component
class ScoreComponent extends PositionComponent with HasGameReference<RacingGame> {
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Score: ${game.score}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Colors.black,
              offset: Offset(2, 2),
              blurRadius: 4,
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    textPainter.paint(canvas, Offset(game.size.x - textPainter.width - 20, 40));
  }
}

// Game Title Component
class GameTitle extends PositionComponent with HasGameReference<RacingGame> {
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '🏁 Racing Game',
        style: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Colors.black,
              offset: Offset(2, 2),
              blurRadius: 4,
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    textPainter.paint(canvas, const Offset(20, 40));
  }
}
