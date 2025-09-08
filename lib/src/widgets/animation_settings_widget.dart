import 'package:flutter/material.dart';
import 'package:modern_setting_ui/src/models/animation_config.dart';
import 'package:modern_setting_ui/src/widgets/animation_duration_selector.dart';
import 'package:modern_setting_ui/src/widgets/animation_curve_selector.dart';

/// Comprehensive widget for configuring animation settings.
class AnimationSettingsWidget extends StatefulWidget {
  /// Current animation configuration.
  final AnimationConfig config;

  /// Callback when configuration changes.
  final ValueChanged<AnimationConfig> onChanged;

  /// Whether the widget is enabled.
  final bool enabled;

  /// Creates an AnimationSettingsWidget.
  const AnimationSettingsWidget({
    super.key,
    required this.config,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  State<AnimationSettingsWidget> createState() =>
      _AnimationSettingsWidgetState();
}

class _AnimationSettingsWidgetState extends State<AnimationSettingsWidget> {
  late AnimationConfig _currentConfig;

  @override
  void initState() {
    super.initState();
    _currentConfig = widget.config;
  }

  @override
  void didUpdateWidget(AnimationSettingsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config != widget.config) {
      _currentConfig = widget.config;
    }
  }

  void _updateConfig(AnimationConfig newConfig) {
    setState(() {
      _currentConfig = newConfig;
    });
    widget.onChanged(newConfig);
  }

  void _toggleAnimations(bool enabled) {
    final newConfig = _currentConfig.copyWith(enabled: enabled);
    _updateConfig(newConfig);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.animation,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Animation Settings',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const Spacer(),
                  Switch(
                    value: _currentConfig.enabled,
                    onChanged: widget.enabled ? _toggleAnimations : null,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Customize how theme transitions are animated',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.7),
                    ),
              ),
              const SizedBox(height: 24),
              if (_currentConfig.enabled) ...[
                AnimationDurationSelector(
                  config: _currentConfig,
                  onChanged: _updateConfig,
                ),
                const SizedBox(height: 24),
                AnimationCurveSelector(
                  config: _currentConfig,
                  onChanged: _updateConfig,
                ),
                const SizedBox(height: 16),
                _PresetSelector(
                  currentConfig: _currentConfig,
                  onPresetSelected: _updateConfig,
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(24),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.animation,
                        size: 48,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Animations are disabled',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.6),
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Theme changes will be instant',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.5),
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget for selecting predefined animation presets.
class _PresetSelector extends StatelessWidget {
  final AnimationConfig currentConfig;
  final ValueChanged<AnimationConfig> onPresetSelected;

  const _PresetSelector({
    required this.currentConfig,
    required this.onPresetSelected,
  });

  @override
  Widget build(BuildContext context) {
    final presets = [
      _Preset('Instant', AnimationConfig.instant),
      _Preset('Fast', AnimationConfig.fast),
      _Preset('Normal', AnimationConfig.normal),
      _Preset('Slow', AnimationConfig.slow),
      _Preset('Smooth', AnimationConfig.smooth),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Presets',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: presets.map((preset) {
            final isSelected = _isPresetSelected(preset.config);
            return _PresetButton(
              preset: preset,
              isSelected: isSelected,
              onPressed: () => onPresetSelected(preset.config),
            );
          }).toList(),
        ),
      ],
    );
  }

  bool _isPresetSelected(AnimationConfig preset) {
    return currentConfig.duration == preset.duration &&
        currentConfig.curve == preset.curve &&
        currentConfig.enabled == preset.enabled;
  }
}

/// Represents an animation preset.
class _Preset {
  final String name;
  final AnimationConfig config;

  const _Preset(this.name, this.config);
}

/// Button for selecting an animation preset.
class _PresetButton extends StatelessWidget {
  final _Preset preset;
  final bool isSelected;
  final VoidCallback onPressed;

  const _PresetButton({
    required this.preset,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(
        preset.name,
        style: TextStyle(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}
