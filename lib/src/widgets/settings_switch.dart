import 'package:flutter/material.dart';

/// A settings switch widget following Material 3 design.
class SettingsSwitch extends StatelessWidget {
  /// The title of the switch.
  final String title;

  /// Optional subtitle.
  final String? subtitle;

  /// Optional leading icon.
  final IconData? icon;

  /// Current value of the switch.
  final bool value;

  /// Callback when the value changes.
  final ValueChanged<bool> onChanged;

  /// Whether the switch is enabled.
  final bool enabled;

  /// Creates a SettingsSwitch.
  const SettingsSwitch({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.0,
      child: InkWell(
        onTap: enabled ? () => onChanged(!value) : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: enabled
                      ? Theme.of(context).iconTheme.color
                      : Theme.of(context).disabledColor,
                ),
                const SizedBox(width: 16.0),
              ],
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: enabled ? null : Theme.of(context).disabledColor,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2.0),
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: enabled
                              ? Theme.of(context).textTheme.bodyMedium?.color
                              : Theme.of(context).disabledColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: enabled ? onChanged : null,
                activeThumbColor: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
