import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pixel_art_puzzle/confetti_animation/particle_system.dart';

enum BlastDirectionality {
  directional,
  explosive,
}

enum ConfettiControllerState {
  playing,
  stopped,
}

class ConfettiWidget extends StatefulWidget {
  const ConfettiWidget({
    Key? key,
    required this.confettiController,
    this.emissionFrequency = 0.02,
    this.numberOfParticles = 10,
    this.maxBlastForce = 20,
    this.minBlastForce = 5,
    this.blastDirectionality = BlastDirectionality.directional,
    this.blastDirection = pi,
    this.gravity = 0.2,
    this.shouldLoop = false,
    this.displayTarget = false,
    required this.colors,
    this.minimumSize = const Size(20, 10),
    this.maximumSize = const Size(30, 15),
    this.particleDrag = 0.05,
    required this.canvas,
    this.child,
  }) : super(key: key);

  final ConfettiController confettiController;

  final double maxBlastForce;

  final double minBlastForce;

  final BlastDirectionality blastDirectionality;

  final double blastDirection;
  final double gravity;
  final double emissionFrequency;
  final int numberOfParticles;
  final bool shouldLoop;
  final bool displayTarget;

  final List<Color> colors;
  final Size minimumSize;
  final Size maximumSize;

  final double particleDrag;
  final Size canvas;

  final Widget? child;

  @override
  _ConfettiWidgetState createState() => _ConfettiWidgetState();
}

class _ConfettiWidgetState extends State<ConfettiWidget>
    with SingleTickerProviderStateMixin {
  final GlobalKey _particleSystemKey = GlobalKey();

  late AnimationController _animController;
  late Animation<double> _animation;
  ParticleSystem? _particleSystem;

  Offset? _emitterPosition;

  Size _screenSize = const Size(0, 0);

  @override
  void initState() {
    widget.confettiController.addListener(_handleChange);

    _particleSystem = ParticleSystem(
        emissionFrequency: widget.emissionFrequency,
        numberOfParticles: widget.numberOfParticles,
        maxBlastForce: widget.maxBlastForce,
        minBlastForce: widget.minBlastForce,
        gravity: widget.gravity,
        blastDirection: widget.blastDirection,
        blastDirectionality: widget.blastDirectionality,
        colors: widget.colors,
        minimumSize: widget.minimumSize,
        maximumsize: widget.maximumSize,
        particleDrag: widget.particleDrag);

    _particleSystem?.addListener(_particleSystemListener);

    _initAnimation();
    super.initState();
  }

  void _initAnimation() {
    _animController = AnimationController(
        vsync: this, duration: widget.confettiController.duration);
    _animation = Tween<double>(begin: 0, end: 1).animate(_animController);
    _animation.addListener(_animationListener);
    _animation.addStatusListener(_animationStatusListener);

    if (widget.confettiController.state == ConfettiControllerState.playing) {
      _startAnimation();
      _startEmission();
    }
  }

  void _handleChange() {
    if (widget.confettiController.state == ConfettiControllerState.playing) {
      _startAnimation();
      _startEmission();
    } else if (widget.confettiController.state ==
        ConfettiControllerState.stopped) {
      _stopEmission();
    }
  }

  void _animationListener() {
    if (_particleSystem?.particleSystemStatus ==
        ParticleSystemStatus.finished) {
      _animController.stop();
      return;
    }
    _particleSystem?.update();
  }

  void _animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (!widget.shouldLoop) {
        _stopEmission();
      }
      _continueAnimation();
    }
  }

  void _particleSystemListener() {
    if (_particleSystem?.particleSystemStatus ==
        ParticleSystemStatus.finished) {
      _stopAnimation();
    }
  }

  void _startEmission() {
    _particleSystem?.startParticleEmission();
  }

  void _stopEmission() {
    if (_particleSystem?.particleSystemStatus == ParticleSystemStatus.stopped) {
      return;
    }
    _particleSystem?.stopParticleEmission();
  }

  void _startAnimation() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _setScreenSize();
      _setEmitterPosition();
      _animController.forward(from: 0);
    });
  }

  void _stopAnimation() {
    _animController.stop();
  }

  void _continueAnimation() {
    _animController.forward(from: 0);
  }

  void _setScreenSize() {
    _screenSize = _getScreenSize();
    _particleSystem?.screenSize = _screenSize;
  }

  void _setEmitterPosition() {
    _emitterPosition = _getContainerPosition();
    _particleSystem?.particleSystemPosition = _emitterPosition!;
  }

  Offset _getContainerPosition() {
    final RenderBox containerRenderBox =
        _particleSystemKey.currentContext?.findRenderObject() as RenderBox;
    return containerRenderBox.localToGlobal(Offset.zero);
  }

  Size _getScreenSize() {
    return widget.canvas;
  }

  void _updatePositionAndSize() {
    if (_getScreenSize() != _screenSize) {
      _setScreenSize();
      if (_emitterPosition != null) {
        _setEmitterPosition();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _updatePositionAndSize();
    return RepaintBoundary(
      child: CustomPaint(
        key: _particleSystemKey,
        foregroundPainter: ParticlePainter(
          _animController,
          particles: _particleSystem!.particles,
          paintEmitterTarget: widget.displayTarget,
        ),
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    widget.confettiController.stop();
    _animController.dispose();
    widget.confettiController.removeListener(_handleChange);
    _particleSystem?.removeListener(_particleSystemListener);
    _particleSystem = null;
    super.dispose();
  }
}

class ParticlePainter extends CustomPainter {
  ParticlePainter(Listenable repaint,
      {required this.particles,
      paintEmitterTarget = true,
      emitterTargetColor = Colors.black})
      : _paintEmitterTarget = paintEmitterTarget,
        _emitterPaint = Paint()
          ..color = emitterTargetColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0,
        _particlePaint = Paint()
          ..color = Colors.green
          ..style = PaintingStyle.fill,
        super(repaint: repaint);

  final List<Particle> particles;

  final Paint _emitterPaint;
  final bool _paintEmitterTarget;
  final Paint _particlePaint;

  @override
  void paint(Canvas canvas, Size size) {
    if (_paintEmitterTarget) {
      _paintEmitter(canvas);
    }
    _paintParticles(canvas);
  }

  void _paintEmitter(Canvas canvas) {
    const radius = 10.0;
    canvas.drawCircle(Offset.zero, radius, _emitterPaint);
    final path = Path();
    path.moveTo(0, -radius);
    path.lineTo(0, radius);
    path.moveTo(-radius, 0);
    path.lineTo(radius, 0);
    canvas.drawPath(path, _emitterPaint);
  }

  void _paintParticles(Canvas canvas) {
    for (final particle in particles) {
      final rotationMatrix4 = Matrix4.identity();
      rotationMatrix4
        ..translate(particle.location.dx, particle.location.dy)
        ..rotateX(particle.angleX)
        ..rotateY(particle.angleY)
        ..rotateZ(particle.angleZ);

      final finalPath = particle.path.transform(rotationMatrix4.storage);
      canvas.drawPath(finalPath, _particlePaint..color = particle.color);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ConfettiController extends ChangeNotifier {
  ConfettiController({this.duration = const Duration(seconds: 30)})
      : assert(!duration.isNegative && duration.inMicroseconds > 0);

  Duration duration;

  ConfettiControllerState _state = ConfettiControllerState.stopped;

  ConfettiControllerState get state => _state;

  void play() {
    _state = ConfettiControllerState.playing;
    notifyListeners();
  }

  void stop() {
    _state = ConfettiControllerState.stopped;
    notifyListeners();
  }
}
