import 'package:flutter/material.dart';
import 'package:modern_setting_ui/src/models/animation_config.dart';

/// Widget for selecting animation curves.
class AnimationCurveSelector extends StatefulWidget {
  /// Current animation configuration.
  final AnimationConfig config;

  /// Callback when configuration changes.
  final ValueChanged<AnimationConfig> onChanged;

  /// Creates an AnimationCurveSelector.
  const AnimationCurveSelector({
    super.key,
    required this.config,
    required this.onChanged,
  });

  @override
  State<AnimationCurveSelector> createState() => _AnimationCurveSelectorState();
}

class _AnimationCurveSelectorState extends State<AnimationCurveSelector> {
  final List<_CurveOption> _curveOptions = [
    _CurveOption('Linear', Curves.linear, _buildLinearCurve()),
    _CurveOption('Ease', Curves.ease, _buildEaseCurve()),
    _CurveOption('Ease In', Curves.easeIn, _buildEaseInCurve()),
    _CurveOption('Ease Out', Curves.easeOut, _buildEaseOutCurve()),
    _CurveOption('Ease In Out', Curves.easeInOut, _buildEaseInOutCurve()),
    _CurveOption('Smooth', Curves.easeInOutCubic, _buildSmoothCurve()),
    _CurveOption('Bounce', Curves.bounceOut, _buildBounceCurve()),
    _CurveOption('Elastic', Curves.elasticOut, _buildElasticCurve()),
  ];

  void _selectCurve(Curve curve) {
    final newConfig = widget.config.copyWith(curve: curve);
    widget.onChanged(newConfig);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Animation Curve',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _curveOptions.map((option) {
            final isSelected = widget.config.curve == option.curve;
            return _CurveButton(
              option: option,
              isSelected: isSelected,
              onPressed: () => _selectCurve(option.curve),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        _CurvePreview(
          curve: widget.config.curve,
          duration: widget.config.duration,
        ),
      ],
    );
  }
}

/// Represents a curve option with visual representation.
class _CurveOption {
  final String name;
  final Curve curve;
  final Path path;

  const _CurveOption(this.name, this.curve, this.path);
}

/// Button for selecting an animation curve.
class _CurveButton extends StatelessWidget {
  final _CurveOption option;
  final bool isSelected;
  final VoidCallback onPressed;

  const _CurveButton({
    required this.option,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 60,
              height: 40,
              child: CustomPaint(
                painter: _CurvePainter(option.path, isSelected),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              option.name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Painter for drawing curve visualizations.
class _CurvePainter extends CustomPainter {
  final Path path;
  final bool isSelected;

  const _CurvePainter(this.path, this.isSelected);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isSelected ? Colors.blue.shade600 : Colors.grey.shade600
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Scale and translate the path to fit the canvas
    final matrix = Matrix4.identity()
      ..scale(size.width / 100, size.height / 100, 1.0);
    final scaledPath = path.transform(matrix.storage);

    canvas.drawPath(scaledPath, paint);
  }

  @override
  bool shouldRepaint(_CurvePainter oldDelegate) {
    return oldDelegate.path != path || oldDelegate.isSelected != isSelected;
  }
}

/// Widget that shows a preview of the selected curve.
class _CurvePreview extends StatefulWidget {
  final Curve curve;
  final Duration duration;

  const _CurvePreview({
    required this.curve,
    required this.duration,
  });

  @override
  State<_CurvePreview> createState() => _CurvePreviewState();
}

class _CurvePreviewState extends State<_CurvePreview>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );
  }

  @override
  void didUpdateWidget(_CurvePreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.curve != widget.curve ||
        oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
      _animation = CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playAnimation() {
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preview',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Container(
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Positioned(
                    left: _animation.value * 280, // 300 - 20 for padding
                    top: 20,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                left: 0,
                top: 30,
                child: Text(
                  'Start',
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 30,
                child: Text(
                  'End',
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: OutlinedButton.icon(
            onPressed: _playAnimation,
            icon: const Icon(Icons.play_arrow, size: 16),
            label: const Text('Play'),
          ),
        ),
      ],
    );
  }
}

// Curve path builders
Path _buildLinearCurve() {
  final path = Path();
  path.moveTo(0, 50);
  path.lineTo(100, 0);
  return path;
}

Path _buildEaseCurve() {
  final path = Path();
  path.moveTo(0, 50);
  path.cubicTo(25, 50, 75, 0, 100, 0);
  return path;
}

Path _buildEaseInCurve() {
  final path = Path();
  path.moveTo(0, 50);
  path.cubicTo(50, 50, 85, 25, 100, 0);
  return path;
}

Path _buildEaseOutCurve() {
  final path = Path();
  path.moveTo(0, 50);
  path.cubicTo(15, 25, 50, 0, 100, 0);
  return path;
}

Path _buildEaseInOutCurve() {
  final path = Path();
  path.moveTo(0, 50);
  path.cubicTo(25, 50, 75, 0, 100, 0);
  return path;
}

Path _buildSmoothCurve() {
  final path = Path();
  path.moveTo(0, 50);
  path.cubicTo(30, 50, 70, 0, 100, 0);
  return path;
}

Path _buildBounceCurve() {
  final path = Path();
  path.moveTo(0, 50);
  path.lineTo(85, 5);
  path.cubicTo(90, 0, 95, 5, 100, 0);
  return path;
}

Path _buildElasticCurve() {
  final path = Path();
  path.moveTo(0, 50);
  path.cubicTo(20, 50, 10, 20, 30, 20);
  path.cubicTo(50, 20, 40, 10, 60, 10);
  path.cubicTo(80, 10, 70, 0, 100, 0);
  return path;
}
