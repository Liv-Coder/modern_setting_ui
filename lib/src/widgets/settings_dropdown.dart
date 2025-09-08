import 'package:flutter/material.dart';

/// A settings dropdown widget following Material 3 design.
class SettingsDropdown extends StatelessWidget {
  /// The title of the dropdown.
  final String title;

  /// Optional subtitle.
  final String? subtitle;

  /// Optional leading icon.
  final IconData? icon;

  /// List of available options.
  final List<String> options;

  /// Current selected value.
  final String value;

  /// Callback when the value changes.
  final ValueChanged<String> onChanged;

  /// Whether the dropdown is enabled.
  final bool enabled;

  /// Creates a SettingsDropdown.
  const SettingsDropdown({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    required this.options,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.0,
      child: InkWell(
        onTap: enabled ? () => _showDropdown(context) : null,
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
              Row(
                children: [
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: enabled ? null : Theme.of(context).disabledColor,
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: enabled
                        ? Theme.of(context).iconTheme.color
                        : Theme.of(context).disabledColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDropdown(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((option) {
              return ListTile(
                title: Text(option),
                onTap: () {
                  onChanged(option);
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
