import 'package:flutter/material.dart';
import 'package:modern_setting_ui/src/models/animation_config.dart';

/// Widget for creating and configuring custom animations.
class CustomAnimationsWidget extends StatefulWidget {
  /// Current animation configuration.
  final AnimationConfig config;

  /// Callback when configuration changes.
  final ValueChanged<AnimationConfig> onChanged;

  /// Whether the widget is enabled.
  final bool enabled;

  /// Creates a CustomAnimationsWidget.
  const CustomAnimationsWidget({
    super.key,
    required this.config,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  State<CustomAnimationsWidget> createState() => _CustomAnimationsWidgetState();
}

class _CustomAnimationsWidgetState extends State<CustomAnimationsWidget> {
  late AnimationConfig _currentConfig;
  final TextEditingController _customCurveController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentConfig = widget.config;
    _durationController.text =
        _currentConfig.duration.inMilliseconds.toString();
    _customCurveController.text = _curveToString(_currentConfig.curve);
  }

  @override
  void didUpdateWidget(CustomAnimationsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config != widget.config) {
      _currentConfig = widget.config;
      _durationController.text =
          _currentConfig.duration.inMilliseconds.toString();
      _customCurveController.text = _curveToString(_currentConfig.curve);
    }
  }

  @override
  void dispose() {
    _customCurveController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _updateConfig() {
    final duration = int.tryParse(_durationController.text) ?? 300;
    final curve = _stringToCurve(_customCurveController.text);

    final newConfig = _currentConfig.copyWith(
      duration: Duration(milliseconds: duration),
      curve: curve,
    );

    widget.onChanged(newConfig);
  }

  Curve _stringToCurve(String curveString) {
    switch (curveString.toLowerCase()) {
      case 'linear':
        return Curves.linear;
      case 'ease':
        return Curves.ease;
      case 'easein':
        return Curves.easeIn;
      case 'easeout':
        return Curves.easeOut;
      case 'easeinout':
        return Curves.easeInOut;
      case 'bouncein':
        return Curves.bounceIn;
      case 'bounceout':
        return Curves.bounceOut;
      case 'elasticin':
        return Curves.elasticIn;
      case 'elasticout':
        return Curves.elasticOut;
      default:
        return Curves.easeInOut;
    }
  }

  String _curveToString(Curve curve) {
    if (curve == Curves.linear) return 'linear';
    if (curve == Curves.ease) return 'ease';
    if (curve == Curves.easeIn) return 'easein';
    if (curve == Curves.easeOut) return 'easeout';
    if (curve == Curves.easeInOut) return 'easeinout';
    if (curve == Curves.bounceIn) return 'bouncein';
    if (curve == Curves.bounceOut) return 'bounceout';
    if (curve == Curves.elasticIn) return 'elasticin';
    if (curve == Curves.elasticOut) return 'elasticout';
    return 'easeinout';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Custom Animation Configuration',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16.0),

            // Duration Input
            TextField(
              controller: _durationController,
              decoration: const InputDecoration(
                labelText: 'Duration (milliseconds)',
                hintText: '300',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              enabled: widget.enabled,
              onChanged: (_) => _updateConfig(),
            ),
            const SizedBox(height: 16.0),

            // Curve Input
            TextField(
              controller: _customCurveController,
              decoration: const InputDecoration(
                labelText: 'Animation Curve',
                hintText: 'easeinout',
                border: OutlineInputBorder(),
                helperText:
                    'linear, ease, easein, easeout, easeinout, bouncein, bounceout, elasticin, elasticout',
              ),
              enabled: widget.enabled,
              onChanged: (_) => _updateConfig(),
            ),
            const SizedBox(height: 16.0),

            // Preview Button
            ElevatedButton(
              onPressed: widget.enabled ? _previewAnimation : null,
              child: const Text('Preview Animation'),
            ),
          ],
        ),
      ),
    );
  }

  void _previewAnimation() {
    // Show a simple animation preview
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Animation Preview'),
        content: SizedBox(
          height: 100,
          child: AnimatedContainer(
            duration: _currentConfig.duration,
            curve: _currentConfig.curve,
            width: 100,
            height: 100,
            color: Theme.of(context).primaryColor,
            child: const Center(
              child: Text(
                'Preview',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

/// Extension methods for custom animation configurations.
extension CustomAnimationExtensions on AnimationConfig {
  /// Creates a custom tween animation.
  Animation<T> createCustomAnimation<T>(
    TickerProvider tickerProvider,
    Tween<T> tween,
  ) {
    final controller = AnimationController(
      duration: duration,
      vsync: tickerProvider,
    );

    return tween.animate(
      CurvedAnimation(
        parent: controller,
        curve: curve,
      ),
    );
  }
}
