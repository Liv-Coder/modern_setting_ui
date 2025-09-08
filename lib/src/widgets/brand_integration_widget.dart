import 'package:flutter/material.dart';
import 'package:modern_setting_ui/src/models/brand_color_scheme.dart';

/// Widget for configuring brand integration settings.
class BrandIntegrationWidget extends StatefulWidget {
  /// Current brand color scheme.
  final BrandColorScheme brandScheme;

  /// Callback when brand scheme changes.
  final ValueChanged<BrandColorScheme> onChanged;

  /// Whether the widget is enabled.
  final bool enabled;

  /// Creates a BrandIntegrationWidget.
  const BrandIntegrationWidget({
    super.key,
    required this.brandScheme,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  State<BrandIntegrationWidget> createState() => _BrandIntegrationWidgetState();
}

class _BrandIntegrationWidgetState extends State<BrandIntegrationWidget> {
  late BrandColorScheme _currentScheme;
  late TextEditingController _brandNameController;
  late TextEditingController _logoUrlController;

  @override
  void initState() {
    super.initState();
    _currentScheme = widget.brandScheme;
    _brandNameController =
        TextEditingController(text: _currentScheme.brandName);
    _logoUrlController = TextEditingController(text: _currentScheme.logoUrl);
  }

  @override
  void didUpdateWidget(BrandIntegrationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.brandScheme != widget.brandScheme) {
      _currentScheme = widget.brandScheme;
      _brandNameController.text = _currentScheme.brandName ?? '';
      _logoUrlController.text = _currentScheme.logoUrl ?? '';
    }
  }

  @override
  void dispose() {
    _brandNameController.dispose();
    _logoUrlController.dispose();
    super.dispose();
  }

  void _updateScheme(BrandColorScheme newScheme) {
    setState(() {
      _currentScheme = newScheme;
    });
    widget.onChanged(newScheme);
  }

  void _updateBrandName(String name) {
    final newScheme =
        _currentScheme.copyWith(brandName: name.isEmpty ? null : name);
    _updateScheme(newScheme);
  }

  void _updateLogoUrl(String url) {
    final newScheme =
        _currentScheme.copyWith(logoUrl: url.isEmpty ? null : url);
    _updateScheme(newScheme);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.business,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Brand Integration',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Customize your brand colors and identity',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
            ),
            const SizedBox(height: 24),

            // Brand Information Section
            Text(
              'Brand Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),

            // Brand Name
            TextField(
              controller: _brandNameController,
              enabled: widget.enabled,
              decoration: const InputDecoration(
                labelText: 'Brand Name',
                hintText: 'Enter your brand name',
                border: OutlineInputBorder(),
              ),
              onChanged: _updateBrandName,
            ),
            const SizedBox(height: 16),

            // Logo URL
            TextField(
              controller: _logoUrlController,
              enabled: widget.enabled,
              decoration: const InputDecoration(
                labelText: 'Logo URL',
                hintText: 'https://example.com/logo.png',
                border: OutlineInputBorder(),
              ),
              onChanged: _updateLogoUrl,
            ),
            const SizedBox(height: 24),

            // Colors Section
            Text(
              'Brand Colors',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),

            // Primary and Secondary Colors
            Row(
              children: [
                Expanded(
                  child: _ColorPickerField(
                    label: 'Primary Color',
                    color: _currentScheme.primary,
                    enabled: widget.enabled,
                    onColorSelected: (color) {
                      _updateScheme(_currentScheme.copyWith(primary: color));
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _ColorPickerField(
                    label: 'Secondary Color',
                    color: _currentScheme.secondary,
                    enabled: widget.enabled,
                    onColorSelected: (color) {
                      _updateScheme(_currentScheme.copyWith(secondary: color));
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Optional Colors
            if (_currentScheme.accent != null)
              _ColorPickerField(
                label: 'Accent Color',
                color: _currentScheme.accent!,
                enabled: widget.enabled,
                onColorSelected: (color) {
                  _updateScheme(_currentScheme.copyWith(accent: color));
                },
              ),

            if (_currentScheme.success != null) ...[
              const SizedBox(height: 16),
              _ColorPickerField(
                label: 'Success Color',
                color: _currentScheme.success!,
                enabled: widget.enabled,
                onColorSelected: (color) {
                  _updateScheme(_currentScheme.copyWith(success: color));
                },
              ),
            ],

            if (_currentScheme.warning != null) ...[
              const SizedBox(height: 16),
              _ColorPickerField(
                label: 'Warning Color',
                color: _currentScheme.warning!,
                enabled: widget.enabled,
                onColorSelected: (color) {
                  _updateScheme(_currentScheme.copyWith(warning: color));
                },
              ),
            ],

            if (_currentScheme.error != null) ...[
              const SizedBox(height: 16),
              _ColorPickerField(
                label: 'Error Color',
                color: _currentScheme.error!,
                enabled: widget.enabled,
                onColorSelected: (color) {
                  _updateScheme(_currentScheme.copyWith(error: color));
                },
              ),
            ],

            const SizedBox(height: 24),

            // Preview Section
            Text(
              'Preview',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),

            _BrandPreview(scheme: _currentScheme),
          ],
        ),
      ),
    );
  }
}

/// Simple color picker widget for the dialog.
class ColorPicker extends StatelessWidget {
  final Color currentColor;
  final ValueChanged<Color> onColorSelected;

  const ColorPicker({
    super.key,
    required this.currentColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
      Colors.black,
      Colors.white,
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: colors.map((color) {
        return GestureDetector(
          onTap: () {
            onColorSelected(color);
            Navigator.of(context).pop(color);
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(
                color: color == currentColor
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade300,
                width: color == currentColor ? 3 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Widget for displaying a color picker field.
class _ColorPickerField extends StatelessWidget {
  final String label;
  final Color color;
  final bool enabled;
  final ValueChanged<Color> onColorSelected;

  const _ColorPickerField({
    required this.label,
    required this.color,
    required this.enabled,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '#${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            IconButton(
              onPressed: enabled
                  ? () async {
                      final selectedColor = await showDialog<Color>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Pick a $label'),
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              currentColor: color,
                              onColorSelected: onColorSelected,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancel'),
                            ),
                          ],
                        ),
                      );

                      if (selectedColor != null) {
                        onColorSelected(selectedColor);
                      }
                    }
                  : null,
              icon: const Icon(Icons.color_lens),
              tooltip: 'Pick $label',
            ),
          ],
        ),
      ],
    );
  }
}

/// Widget for previewing the brand color scheme.
class _BrandPreview extends StatelessWidget {
  final BrandColorScheme scheme;

  const _BrandPreview({required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Preview Card
        Card(
          color: scheme.surface ?? Theme.of(context).colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  scheme.brandName ?? 'Brand Name',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: scheme.onSurface ??
                            Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: scheme.primary,
                        foregroundColor: scheme.onPrimary ?? Colors.white,
                      ),
                      child: const Text('Primary Button'),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: scheme.secondary),
                      ),
                      child: Text(
                        'Secondary Button',
                        style: TextStyle(color: scheme.secondary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Color Palette Preview
        Text(
          'Color Palette',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _ColorChip(color: scheme.primary, label: 'Primary'),
            _ColorChip(color: scheme.secondary, label: 'Secondary'),
            if (scheme.accent != null)
              _ColorChip(color: scheme.accent!, label: 'Accent'),
            if (scheme.success != null)
              _ColorChip(color: scheme.success!, label: 'Success'),
            if (scheme.warning != null)
              _ColorChip(color: scheme.warning!, label: 'Warning'),
            if (scheme.error != null)
              _ColorChip(color: scheme.error!, label: 'Error'),
          ],
        ),
      ],
    );
  }
}

/// Widget for displaying a color chip in the preview.
class _ColorChip extends StatelessWidget {
  final Color color;
  final String label;

  const _ColorChip({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
