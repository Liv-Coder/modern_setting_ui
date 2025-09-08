import 'package:flutter/material.dart';
import 'package:modern_setting_ui/src/models/animation_config.dart';

/// Widget for configuring animation duration settings.
class AnimationDurationSelector extends StatefulWidget {
  /// Current animation configuration.
  final AnimationConfig config;

  /// Callback when configuration changes.
  final ValueChanged<AnimationConfig> onChanged;

  /// Creates an AnimationDurationSelector.
  const AnimationDurationSelector({
    super.key,
    required this.config,
    required this.onChanged,
  });

  @override
  State<AnimationDurationSelector> createState() =>
      _AnimationDurationSelectorState();
}

class _AnimationDurationSelectorState extends State<AnimationDurationSelector> {
  late double _durationMs;

  @override
  void initState() {
    super.initState();
    _durationMs = widget.config.duration.inMilliseconds.toDouble();
  }

  @override
  void didUpdateWidget(AnimationDurationSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config.duration != widget.config.duration) {
      _durationMs = widget.config.duration.inMilliseconds.toDouble();
    }
  }

  void _updateDuration(double value) {
    setState(() {
      _durationMs = value;
    });

    final newConfig = widget.config.copyWith(
      duration: Duration(milliseconds: value.round()),
    );
    widget.onChanged(newConfig);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Animation Duration',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          '${_durationMs.round()}ms',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Slider(
          value: _durationMs,
          min: 0,
          max: 2000,
          divisions: 40,
          label: '${_durationMs.round()}ms',
          onChanged: _updateDuration,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _PresetButton(
              label: 'Instant',
              duration: 0,
              isSelected: _durationMs == 0,
              onPressed: () => _updateDuration(0),
            ),
            _PresetButton(
              label: 'Fast',
              duration: 150,
              isSelected: _durationMs == 150,
              onPressed: () => _updateDuration(150),
            ),
            _PresetButton(
              label: 'Normal',
              duration: 300,
              isSelected: _durationMs == 300,
              onPressed: () => _updateDuration(300),
            ),
            _PresetButton(
              label: 'Slow',
              duration: 500,
              isSelected: _durationMs == 500,
              onPressed: () => _updateDuration(500),
            ),
          ],
        ),
      ],
    );
  }
}

/// Preset button for common animation durations.
class _PresetButton extends StatelessWidget {
  final String label;
  final int duration;
  final bool isSelected;
  final VoidCallback onPressed;

  const _PresetButton({
    required this.label,
    required this.duration,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor:
            isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Text(
            '${duration}ms',
            style: TextStyle(
              fontSize: 10,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
