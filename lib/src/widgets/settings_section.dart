import 'package:flutter/material.dart';
import '../models/settings_section.dart';
import '../models/settings_theme.dart';
import 'settings_item_widget.dart';

/// Widget for displaying a settings section with expandable items.
class SettingsSectionWidget extends StatefulWidget {
  /// The settings section to display.
  final SettingsSection section;

  /// The theme to apply.
  final SettingsTheme theme;

  /// Creates a SettingsSectionWidget.
  const SettingsSectionWidget({
    super.key,
    required this.section,
    required this.theme,
  });

  @override
  State<SettingsSectionWidget> createState() => _SettingsSectionWidgetState();
}

class _SettingsSectionWidgetState extends State<SettingsSectionWidget> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.section.expanded;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        InkWell(
          onTap: () {
            setState(() {
              _expanded = !_expanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              children: [
                if (widget.section.icon != null) ...[
                  Icon(
                    widget.section.icon,
                    color: widget.theme.primaryColor,
                  ),
                  const SizedBox(width: 16.0),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.section.title,
                        style: widget.theme.titleStyle ??
                            Theme.of(context).textTheme.titleLarge,
                      ),
                      if (widget.section.description != null) ...[
                        const SizedBox(height: 4.0),
                        Text(
                          widget.section.description!,
                          style: widget.theme.subtitleStyle ??
                              Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  color: Theme.of(context).iconTheme.color,
                ),
              ],
            ),
          ),
        ),

        // Section items
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState:
              _expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: Column(
            children: widget.section.items.map((item) {
              return SettingsItemWidget(
                item: item,
                theme: widget.theme,
              );
            }).toList(),
          ),
          secondChild: const SizedBox.shrink(),
        ),
      ],
    );
  }
}
