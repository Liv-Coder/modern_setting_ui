# Widget API Contracts

## ModernSettingsUI Widget

### Constructor

```dart
ModernSettingsUI({
  Key? key,
  required List<SettingsSection> sections,
  SettingsTheme? theme,
  ScrollPhysics? physics,
  EdgeInsets? padding,
})
```

### Parameters

- `sections`: List of settings sections to display
- `theme`: Optional custom theme for the entire settings UI
- `physics`: Scroll physics for the list
- `padding`: Padding around the settings list

### Contract

- MUST render all sections in order
- MUST apply theme to all child widgets
- MUST handle empty sections gracefully
- MUST support scrolling for large lists

## SettingsSection Widget

### Constructor

```dart
SettingsSection({
  Key? key,
  required String title,
  String? description,
  required List<SettingsItem> items,
  bool expanded = true,
  IconData? icon,

})
```

### Parameters

- `title`: Section title
- `description`: Optional section description

- `items`: List of settings items
- `expanded`: Whether section is expanded by default
- `icon`: Optional section icon

### Contract

- MUST display title prominently
- MUST show/hide items based on expanded state

- MUST animate expand/collapse transitions
- MUST handle empty items list

## SettingsSwitch Widget

### Constructor

```dart
SettingsSwitch({
  Key? key,
  required String title,
  String? subtitle,
  IconData? icon,

  required bool value,
  required ValueChanged<bool> onChanged,
  bool enabled = true,
})
```

### Parameters

- `title`: Switch label
- `subtitle`: Optional description
- `icon`: Optional leading icon
- `value`: Current switch value
- `onChanged`: Callback when value changes
- `enabled`: Whether switch is interactive

### Contract

- MUST display switch in Material 3 style
- MUST call onChanged when toggled
- MUST show disabled state when enabled=false
- MUST support accessibility (screen readers)

## SettingsDropdown Widget

### Constructor

```dart
SettingsDropdown({
  Key? key,
  required String title,

  String? subtitle,
  IconData? icon,
  required List<String> options,
  required String value,
  required ValueChanged<String> onChanged,
  bool enabled = true,
})
```

### Parameters

- `title`: Dropdown label
- `subtitle`: Optional description
- `icon`: Optional leading icon
- `options`: List of selectable options
- `value`: Currently selected value
- `onChanged`: Callback when selection changes

- `enabled`: Whether dropdown is interactive

### Contract

- MUST display current value
- MUST show dropdown menu on tap
- MUST call onChanged with selected value
- MUST handle invalid values gracefully

## SettingsTheme Class

### Constructor

```dart
SettingsTheme({
  Color? primaryColor,
  Color? backgroundColor,
  TextStyle? titleStyle,
  TextStyle? subtitleStyle,
  IconThemeData? iconTheme,

  double? itemHeight,
})
```

### Properties

- `primaryColor`: Primary color for switches and highlights
- `backgroundColor`: Background color for items
- `titleStyle`: Text style for titles
- `subtitleStyle`: Text style for subtitles
- `iconTheme`: Theme for icons
- `itemHeight`: Height of list items

### Contract

- All properties are optional
- MUST merge with default Material 3 theme
- MUST apply to all descendant widgets
