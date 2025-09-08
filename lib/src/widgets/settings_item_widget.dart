import 'package:flutter/material.dart';
import '../models/settings_item.dart';
import '../models/settings_theme.dart';

/// Widget for displaying individual settings items.
class SettingsItemWidget extends StatelessWidget {
  /// The settings item to display.
  final SettingsItem item;

  /// The theme to apply.
  final SettingsTheme theme;

  /// Creates a SettingsItemWidget.
  const SettingsItemWidget({
    super.key,
    required this.item,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: theme.itemHeight ?? 56.0,
      color: theme.backgroundColor,
      child: InkWell(
        onTap: item.enabled ? () {} : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              if (item.icon != null) ...[
                Icon(
                  item.icon,
                  color: item.enabled
                      ? theme.iconTheme?.color ??
                          Theme.of(context).iconTheme.color
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
                      item.title,
                      style: (theme.titleStyle ??
                              Theme.of(context).textTheme.bodyLarge)
                          ?.copyWith(
                        color: item.enabled
                            ? null
                            : Theme.of(context).disabledColor,
                      ),
                    ),
                    if (item.subtitle != null) ...[
                      const SizedBox(height: 2.0),
                      Text(
                        item.subtitle!,
                        style: (theme.subtitleStyle ??
                                Theme.of(context).textTheme.bodyMedium)
                            ?.copyWith(
                          color: item.enabled
                              ? Theme.of(context).textTheme.bodyMedium?.color
                              : Theme.of(context).disabledColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Placeholder for item-specific controls (switch, dropdown, etc.)
              Container(
                width: 48.0,
                height: 24.0,
                color: Colors.grey[300],
                child: const Center(
                  child: Text('TODO', style: TextStyle(fontSize: 10.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
