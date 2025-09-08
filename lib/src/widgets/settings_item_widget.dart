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
        onTap: item.enabled && item.onChanged != null
            ? () => item.onChanged!(null)
            : null,
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
              // Item-specific controls based on type
              _buildControlWidget(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the appropriate control widget based on the item type.
  Widget _buildControlWidget(BuildContext context) {
    if (!item.enabled) {
      return const SizedBox(width: 48.0);
    }

    switch (item.type) {
      case SettingsItemType.switch_:
        return SizedBox(
          width: 48.0,
          child: Switch(
            value: item.value ?? false,
            onChanged: item.onChanged != null
                ? (value) => item.onChanged!(value)
                : null,
            activeThumbColor: theme.primaryColor,
          ),
        );

      case SettingsItemType.dropdown:
        return SizedBox(
          width: 140.0, // Increased width to prevent overflow
          child: DropdownButton<dynamic>(
            value: item.value,
            onChanged: item.onChanged != null
                ? (value) => item.onChanged!(value)
                : null,
            items: item.dropdownOptions?.map((option) {
                  return DropdownMenuItem<dynamic>(
                    value: option.value,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (option.icon != null) ...[
                          Icon(option.icon, size: 16.0),
                          const SizedBox(width: 8.0),
                        ],
                        Flexible(
                          child: Text(
                            option.label,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList() ??
                [],
            selectedItemBuilder: item.dropdownOptions != null
                ? (context) => item.dropdownOptions!.map((option) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (option.icon != null) ...[
                            Icon(option.icon,
                                size: 16.0, color: theme.primaryColor),
                            const SizedBox(width: 8.0),
                          ],
                          Flexible(
                            child: Text(
                              option.label,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: theme.primaryColor),
                            ),
                          ),
                        ],
                      );
                    }).toList()
                : null,
            underline: const SizedBox(),
            icon: Icon(
              Icons.arrow_drop_down,
              color: theme.primaryColor,
            ),
            isExpanded: true, // Make dropdown fill available width
          ),
        );

      case SettingsItemType.navigation:
        return SizedBox(
          width: 48.0,
          child: Icon(
            Icons.chevron_right,
            color: theme.primaryColor,
          ),
        );

      case SettingsItemType.custom:
        return const SizedBox(
            width: 48.0); // Custom implementation can override this
    }
  }
}
