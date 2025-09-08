# Data Model: Modern Settings UI

## Entities

### SettingsScreen

- **Purpose**: Main container for organizing settings into sections
- **Fields**:
  - title: String (screen title)
  - sections: List<SettingsSection>
  - theme: SettingsTheme? (optional custom theme)
- **Relationships**: Contains SettingsSection
- **Validation**: At least one section required

### SettingsSection

- **Purpose**: Groups related settings items
- **Fields**:
  - title: String (section title)
  - description: String? (optional description)
  - items: List<SettingsItem>
  - expanded: bool (default true)
- **Relationships**: Contains SettingsItem
- **Validation**: At least one item required

### SettingsItem

- **Purpose**: Individual setting component
- **Fields**:
  - id: String (unique identifier)
  - type: SettingsItemType (switch, toggle, dropdown, etc.)
  - title: String
  - subtitle: String?
  - icon: IconData?
  - value: dynamic (current value)
  - enabled: bool (default true)
  - onChanged: Function(dynamic)?
- **Relationships**: Belongs to SettingsSection
- **Validation**: id must be unique within section

### SettingsTheme

- **Purpose**: Customization options for appearance
- **Fields**:
  - primaryColor: Color?
  - backgroundColor: Color?
  - textStyle: TextStyle?
  - iconTheme: IconThemeData?
  - shape: ShapeBorder?
- **Relationships**: Applied to SettingsScreen
- **Validation**: None (all optional)

### UserPreference

- **Purpose**: Persistent storage of user choices
- **Fields**:
  - key: String (unique key)
  - value: dynamic
  - type: PreferenceType
- **Relationships**: Linked to SettingsItem by key
- **Validation**: key must be unique

## State Transitions

### SettingsItem Value Changes

- Initial: value = default
- User Interaction: value = newValue
- Validation: if invalid, revert or show error
- Persistence: save to UserPreference

### SettingsSection Expansion

- Initial: expanded = true
- User Tap: expanded = !expanded
- Animation: smooth expand/collapse

## Data Flow

1. Load UserPreferences on app start
2. Initialize SettingsItems with saved values
3. User changes trigger onChanged callbacks
4. Update UserPreferences storage
5. Notify UI to refresh

## Validation Rules

- All string fields: non-empty, max length 200
- Color fields: valid Color objects
- Function callbacks: non-null for interactive items
- Unique IDs: no duplicates within scope

## Performance Considerations

- Lazy loading for large item lists
- Efficient re-rendering on value changes
- Minimal object creation for themes
