import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'racing_game.dart';

// Coin Component for collecting
class CoinComponent extends PositionComponent with HasGameReference<RacingGame> {
  final double speed;
  bool collected = false;
  double rotationAngle = 0;
  
  CoinComponent({required Vector2 position, required this.speed}) : super(
    position: position,
    size: Vector2(40, 40),
    anchor: Anchor.center,
  );
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    if (collected) return;
    
    canvas.save();
    canvas.translate(size.x / 2, size.y / 2);
    canvas.rotate(rotationAngle);
    canvas.translate(-size.x / 2, -size.y / 2);
    
    // Draw coin
    final paint = Paint()
      ..color = Colors.yellow.shade600
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), 18, paint);
    
    // Draw inner circle
    final innerPaint = Paint()
      ..color = Colors.yellow.shade300
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), 12, innerPaint);
    
    // Draw $ symbol
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '\$',
        style: TextStyle(
          color: Colors.orange,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        size.x / 2 - textPainter.width / 2,
        size.y / 2 - textPainter.height / 2,
      ),
    );
    
    canvas.restore();
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    if (collected) {
      removeFromParent();
      return;
    }
    
    position.y += speed * dt;
    rotationAngle += dt * 3;
    
    // Check collection with player
    if ((position - game.player.position).length < 50) {
      game.collectCoin();
      collected = true;
    }
    
    // Remove if off screen
    if (position.y > game.size.y + 100) {
      removeFromParent();
    }
  }
}

// Power-up Component (Shield)
class PowerUpComponent extends PositionComponent with HasGameReference<RacingGame> {
  final double speed;
  final PowerUpType type;
  bool collected = false;
  double pulseScale = 1.0;
  
  PowerUpComponent({
    required Vector2 position,
    required this.speed,
    required this.type,
  }) : super(
    position: position,
    size: Vector2(50, 50),
    anchor: Anchor.center,
  );
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    if (collected) return;
    
    canvas.save();
    canvas.translate(size.x / 2, size.y / 2);
    canvas.scale(pulseScale);
    canvas.translate(-size.x / 2, -size.y / 2);
    
    // Draw based on type
    if (type == PowerUpType.shield) {
      _drawShield(canvas);
    } else if (type == PowerUpType.slowTime) {
      _drawSlowTime(canvas);
    } else if (type == PowerUpType.magnet) {
      _drawMagnet(canvas);
    }
    
    canvas.restore();
  }
  
  void _drawShield(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.cyan.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;
    
    // Draw shield hexagon
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60.0) * pi / 180;
      final x = size.x / 2 + 20 * cos(angle);
      final y = size.y / 2 + 20 * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    
    canvas.drawPath(path, paint);
    
    // Draw shield icon
    final iconPainter = TextPainter(
      text: const TextSpan(
        text: '🛡️',
        style: TextStyle(fontSize: 24),
      ),
      textDirection: TextDirection.ltr,
    );
    iconPainter.layout();
    iconPainter.paint(
      canvas,
      Offset(
        size.x / 2 - iconPainter.width / 2,
        size.y / 2 - iconPainter.height / 2,
      ),
    );
  }
  
  void _drawSlowTime(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.purple.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), 22, paint);
    
    final iconPainter = TextPainter(
      text: const TextSpan(
        text: '⏱️',
        style: TextStyle(fontSize: 24),
      ),
      textDirection: TextDirection.ltr,
    );
    iconPainter.layout();
    iconPainter.paint(
      canvas,
      Offset(
        size.x / 2 - iconPainter.width / 2,
        size.y / 2 - iconPainter.height / 2,
      ),
    );
  }
  
  void _drawMagnet(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.orange.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;
    
    // Draw magnet shape
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.x / 2, size.y / 2),
        width: 30,
        height: 40,
      ),
      const Radius.circular(8),
    );
    canvas.drawRRect(rect, paint);
    
    final iconPainter = TextPainter(
      text: const TextSpan(
        text: '🧲',
        style: TextStyle(fontSize: 24),
      ),
      textDirection: TextDirection.ltr,
    );
    iconPainter.layout();
    iconPainter.paint(
      canvas,
      Offset(
        size.x / 2 - iconPainter.width / 2,
        size.y / 2 - iconPainter.height / 2,
      ),
    );
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    if (collected) {
      removeFromParent();
      return;
    }
    
    position.y += speed * dt;
    pulseScale = 1.0 + sin(game.timePassed * 5) * 0.1;
    
    // Check collection with player
    if ((position - game.player.position).length < 60) {
      game.collectPowerUp(type);
      collected = true;
    }
    
    // Remove if off screen
    if (position.y > game.size.y + 100) {
      removeFromParent();
    }
  }
}

enum PowerUpType {
  shield,
  slowTime,
  magnet,
}

// Particle Effect Component
class ParticleEffect extends PositionComponent {
  final Color color;
  final double lifeTime;
  double age = 0;
  final Vector2 velocity;
  
  ParticleEffect({
    required Vector2 position,
    required this.color,
    required this.lifeTime,
    required this.velocity,
  }) : super(
    position: position,
    size: Vector2(8, 8),
    anchor: Anchor.center,
  );
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    final opacity = (1.0 - age / lifeTime).clamp(0.0, 1.0);
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), 4, paint);
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    age += dt;
    position.add(velocity * dt);
    
    if (age >= lifeTime) {
      removeFromParent();
    }
  }
}

// High Score Display Component
class HighScoreComponent extends PositionComponent with HasGameReference<RacingGame> {
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Best: ${game.highScore}',
        style: const TextStyle(
          color: Colors.amber,
          fontSize: 24,
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
    textPainter.paint(canvas, const Offset(20, 80));
  }
}

// Coins Display Component
class CoinsDisplayComponent extends PositionComponent with HasGameReference<RacingGame> {
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    final textPainter = TextPainter(
      text: TextSpan(
        text: '💰 ${game.coins}',
        style: const TextStyle(
          color: Colors.yellow,
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
    textPainter.paint(canvas, Offset(game.size.x / 2 - textPainter.width / 2, 40));
  }
}

// Speed Indicator Component
class SpeedIndicatorComponent extends PositionComponent with HasGameReference<RacingGame> {
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    final speedKmh = (game.gameSpeed * 0.5).toInt();
    
    final textPainter = TextPainter(
      text: TextSpan(
        text: '🏎️ $speedKmh km/h',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
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
    textPainter.paint(canvas, const Offset(20, 120));
  }
}

// Active Power-ups Display
class ActivePowerUpsComponent extends PositionComponent with HasGameReference<RacingGame> {
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    double yOffset = game.size.y - 100;
    
    if (game.shieldActive) {
      _drawActivePowerUp(canvas, '🛡️', 'Shield', game.shieldTimeLeft, yOffset);
      yOffset -= 50;
    }
    
    if (game.slowTimeActive) {
      _drawActivePowerUp(canvas, '⏱️', 'Slow', game.slowTimeLeft, yOffset);
      yOffset -= 50;
    }
    
    if (game.magnetActive) {
      _drawActivePowerUp(canvas, '🧲', 'Magnet', game.magnetTimeLeft, yOffset);
    }
  }
  
  void _drawActivePowerUp(Canvas canvas, String icon, String name, double timeLeft, double yPos) {
    // Background
    final bgPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(game.size.x - 120, yPos, 110, 40),
        const Radius.circular(8),
      ),
      bgPaint,
    );
    
    // Icon and text
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$icon $name ${timeLeft.toInt()}s',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    textPainter.paint(canvas, Offset(game.size.x - 110, yPos + 10));
  }
}
