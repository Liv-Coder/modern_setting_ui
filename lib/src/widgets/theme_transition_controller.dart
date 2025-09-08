import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:modern_setting_ui/src/models/settings_theme.dart';

/// Controller for managing theme transitions with smooth animations.
class ThemeTransitionController extends ChangeNotifier {
  SettingsTheme _currentTheme;
  AnimationController? _animationController;
  SettingsTheme? _fromTheme;
  SettingsTheme? _toTheme;
  TickerProvider? _tickerProvider;

  /// Creates a new ThemeTransitionController.
  ThemeTransitionController({
    required SettingsTheme initialTheme,
    TickerProvider? tickerProvider,
  }) : _currentTheme = initialTheme {
    _tickerProvider = tickerProvider;
  }

  /// Gets the current theme.
  SettingsTheme get currentTheme => _currentTheme;

  /// Gets whether an animation is currently running.
  bool get isAnimating => _animationController?.isAnimating ?? false;

  /// Sets the ticker provider for animations.
  void setTickerProvider(TickerProvider tickerProvider) {
    _tickerProvider = tickerProvider;
  }

  /// Animates to a new theme with smooth transitions.
  void animateToTheme(
    SettingsTheme targetTheme, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.linear,
  }) {
    if (_tickerProvider == null) {
      // If no ticker provider, switch instantly
      switchToTheme(targetTheme);
      return;
    }

    // Cancel any ongoing animation
    _animationController?.dispose();

    _fromTheme = _currentTheme;
    _toTheme = targetTheme;

    _animationController = AnimationController(
      duration: duration,
      vsync: _tickerProvider!,
    );

    final curvedAnimation = CurvedAnimation(
      parent: _animationController!,
      curve: curve,
    );

    curvedAnimation.addListener(_onAnimationUpdate);
    _animationController!.addStatusListener(_onAnimationStatusChanged);

    _animationController!.forward();
  }

  /// Instantly switches to a new theme without animation.
  void switchToTheme(SettingsTheme targetTheme) {
    _animationController?.dispose();
    _animationController = null;
    _fromTheme = null;
    _toTheme = null;

    _currentTheme = targetTheme;
    notifyListeners();
  }

  /// Cancels the current animation if running.
  void cancelAnimation() {
    if (_animationController != null && _animationController!.isAnimating) {
      _animationController!.stop();
      _animationController!.dispose();
      _animationController = null;
      _fromTheme = null;
      _toTheme = null;
    }
  }

  /// Gets the interpolated theme at a specific progress (0.0 to 1.0).
  SettingsTheme getThemeAtProgress(double progress) {
    if (_fromTheme == null || _toTheme == null) {
      return _currentTheme;
    }

    return SettingsTheme(
      brightness:
          progress < 0.5 ? _fromTheme!.brightness : _toTheme!.brightness,
      primaryColor: Color.lerp(
          _fromTheme!.primaryColor, _toTheme!.primaryColor, progress)!,
      secondaryColor: Color.lerp(
          _fromTheme!.secondaryColor, _toTheme!.secondaryColor, progress)!,
      backgroundColor: Color.lerp(
          _fromTheme!.backgroundColor, _toTheme!.backgroundColor, progress),
      surfaceColor: Color.lerp(
          _fromTheme!.surfaceColor, _toTheme!.surfaceColor, progress),
      itemHeight:
          lerpDouble(_fromTheme!.itemHeight, _toTheme!.itemHeight, progress),
      borderRadius: lerpDouble(
          _fromTheme!.borderRadius, _toTheme!.borderRadius, progress),
      transitionDuration: _toTheme!.transitionDuration,
    );
  }

  void _onAnimationUpdate() {
    if (_animationController != null &&
        _fromTheme != null &&
        _toTheme != null) {
      final progress = _animationController!.value;
      _currentTheme = getThemeAtProgress(progress);
      notifyListeners();
    }
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      // Ensure we end up exactly at the target theme
      if (_toTheme != null) {
        _currentTheme = _toTheme!;
        notifyListeners();
      }

      // Clean up
      _animationController?.dispose();
      _animationController = null;
      _fromTheme = null;
      _toTheme = null;
    }
  }

  @override
  void dispose() {
    cancelAnimation();
    super.dispose();
  }
}

/// Widget that provides theme transition controller to its descendants.
class ThemeTransitionProvider extends StatefulWidget {
  final SettingsTheme initialTheme;
  final Widget child;

  const ThemeTransitionProvider({
    super.key,
    required this.initialTheme,
    required this.child,
  });

  @override
  State<ThemeTransitionProvider> createState() =>
      _ThemeTransitionProviderState();

  static ThemeTransitionController of(BuildContext context) {
    final provider =
        context.findAncestorStateOfType<_ThemeTransitionProviderState>();
    if (provider == null) {
      throw FlutterError('ThemeTransitionProvider not found in widget tree');
    }
    return provider.controller;
  }
}

class _ThemeTransitionProviderState extends State<ThemeTransitionProvider>
    with TickerProviderStateMixin {
  late ThemeTransitionController controller;

  @override
  void initState() {
    super.initState();
    controller = ThemeTransitionController(
      initialTheme: widget.initialTheme,
      tickerProvider: this,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
