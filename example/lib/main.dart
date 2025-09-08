import 'package:flutter/material.dart';
import 'package:modern_setting_ui/modern_setting_ui.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const ModernSettingsDemoApp());
}

class ModernSettingsDemoApp extends StatelessWidget {
  const ModernSettingsDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SmartFeaturesProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Modern Settings UI Demo',
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _useCustomColors = false;

  ThemeMode get themeMode => _themeMode;
  bool get useCustomColors => _useCustomColors;

  ThemeData get lightTheme {
    if (_useCustomColors) {
      return ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.light,
        ),
      );
    }
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
    );
  }

  ThemeData get darkTheme {
    if (_useCustomColors) {
      return ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.dark,
        ),
      );
    }
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
    );
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void toggleCustomColors() {
    _useCustomColors = !_useCustomColors;
    notifyListeners();
  }
}

class SmartFeaturesProvider extends ChangeNotifier {
  ContextAwarenessService? _contextService;

  bool _smartFeaturesEnabled = false;
  bool _isInitialized = false;

  bool get smartFeaturesEnabled => _smartFeaturesEnabled;
  bool get isInitialized => _isInitialized;

  Future<void> initializeServices() async {
    if (_isInitialized) return;

    final prefs = await SharedPreferences.getInstance();

    _contextService = ContextAwarenessService(prefs);

    _isInitialized = true;
    notifyListeners();
  }

  Future<void> toggleSmartFeatures() async {
    if (!_isInitialized) {
      await initializeServices();
    }

    _smartFeaturesEnabled = !_smartFeaturesEnabled;
    notifyListeners();
  }

  Future<void> recordInteraction(String itemId, dynamic value) async {
    if (_smartFeaturesEnabled && _contextService != null) {
      await _contextService!.recordInteraction(itemId, value, DateTime.now());
    }
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.secondaryContainer,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.settings_suggest,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Modern Settings UI',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Advanced Flutter Settings Package',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),

              // Tab Bar
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Basic', icon: Icon(Icons.settings)),
                  Tab(text: 'Smart', icon: Icon(Icons.smart_toy)),
                  Tab(text: 'Animations', icon: Icon(Icons.animation)),
                  Tab(text: 'Branding', icon: Icon(Icons.palette)),
                ],
              ),

              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    BasicSettingsTab(),
                    SmartFeaturesTab(),
                    AnimationsTab(),
                    BrandingTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BasicSettingsTab extends StatefulWidget {
  const BasicSettingsTab({super.key});

  @override
  State<BasicSettingsTab> createState() => _BasicSettingsTabState();
}

class _BasicSettingsTabState extends State<BasicSettingsTab> {
  bool _notifications = true;
  bool _darkMode = false;
  String _language = 'English';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ModernSettingsUI(
          sections: [
            SettingsSection(
              title: 'Appearance',
              icon: Icons.palette,
              items: [
                SettingsItem(
                  id: 'dark_mode',
                  type: SettingsItemType.switch_,
                  title: 'Dark Mode',
                  subtitle: 'Enable dark theme',
                  value: _darkMode,
                  onChanged: (value) {
                    setState(() {
                      _darkMode = value;
                    });
                    context.read<ThemeProvider>().setThemeMode(
                          value ? ThemeMode.dark : ThemeMode.light,
                        );
                    context
                        .read<SmartFeaturesProvider>()
                        .recordInteraction('dark_mode', value);
                  },
                ),
                SettingsItem(
                  id: 'custom_colors',
                  type: SettingsItemType.switch_,
                  title: 'Custom Colors',
                  subtitle: 'Use purple theme variant',
                  value: context.watch<ThemeProvider>().useCustomColors,
                  onChanged: (value) {
                    context.read<ThemeProvider>().toggleCustomColors();
                    context
                        .read<SmartFeaturesProvider>()
                        .recordInteraction('custom_colors', value);
                  },
                ),
              ],
            ),
            SettingsSection(
              title: 'General',
              icon: Icons.settings,
              items: [
                SettingsItem(
                  id: 'language',
                  type: SettingsItemType.dropdown,
                  title: 'Language',
                  subtitle: 'Select your preferred language',
                  value: _language,
                  onChanged: (value) {
                    setState(() {
                      _language = value;
                    });
                    context
                        .read<SmartFeaturesProvider>()
                        .recordInteraction('language', value);
                  },
                ),
                SettingsItem(
                  id: 'notifications',
                  type: SettingsItemType.switch_,
                  title: 'Notifications',
                  subtitle: 'Receive push notifications',
                  value: _notifications,
                  onChanged: (value) {
                    setState(() {
                      _notifications = value;
                    });
                    context
                        .read<SmartFeaturesProvider>()
                        .recordInteraction('notifications', value);
                  },
                ),
              ],
            ),
          ],
          scrollable: false,
        ),
      ),
    );
  }
}

class SmartFeaturesTab extends StatelessWidget {
  const SmartFeaturesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SmartFeaturesProvider>(
      builder: (context, smartProvider, child) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ModernSettingsUI(
              sections: [
                SettingsSection(
                  title: 'Smart Features',
                  icon: Icons.smart_toy,
                  items: [
                    SettingsItem(
                      id: 'smart_features',
                      type: SettingsItemType.switch_,
                      title: 'Enable Smart Features',
                      subtitle: 'Context awareness and personalization',
                      value: smartProvider.smartFeaturesEnabled,
                      onChanged: (value) async {
                        await smartProvider.toggleSmartFeatures();
                      },
                    ),
                  ],
                ),
                if (smartProvider.smartFeaturesEnabled) ...[
                  SettingsSection(
                    title: 'Context Awareness',
                    icon: Icons.psychology,
                    items: [
                      SettingsItem(
                        id: 'context_info',
                        type: SettingsItemType.navigation,
                        title: 'Context Information',
                        subtitle: 'View current context analysis',
                        onChanged: (value) {
                          // Navigate to context details
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Context awareness is analyzing your usage patterns'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SettingsSection(
                    title: 'Personalization',
                    icon: Icons.recommend,
                    items: [
                      SettingsItem(
                        id: 'personalization_info',
                        type: SettingsItemType.navigation,
                        title: 'Personalization',
                        subtitle: 'View personalized recommendations',
                        onChanged: (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Personalization engine is learning your preferences'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ],
              scrollable: false,
            ),
          ),
        );
      },
    );
  }
}

class AnimationsTab extends StatefulWidget {
  const AnimationsTab({super.key});

  @override
  State<AnimationsTab> createState() => _AnimationsTabState();
}

class _AnimationsTabState extends State<AnimationsTab> {
  AnimationConfig _config = const AnimationConfig(
    enabled: true,
    curve: Curves.elasticOut,
    duration: Duration(milliseconds: 500),
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Animation Preview',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    AnimatedContainer(
                      duration:
                          _config.enabled ? _config.duration : Duration.zero,
                      curve: _config.curve,
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.animation,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 48,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CustomAnimationsWidget(
              config: _config,
              onChanged: (newConfig) {
                setState(() {
                  _config = newConfig;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BrandingTab extends StatefulWidget {
  const BrandingTab({super.key});

  @override
  State<BrandingTab> createState() => _BrandingTabState();
}

class _BrandingTabState extends State<BrandingTab> {
  final BrandColorScheme _brandScheme = BrandColorScheme(
    primary: Colors.blue,
    secondary: Colors.blue.shade700,
    brandName: 'Demo Brand',
    logoUrl: 'https://via.placeholder.com/100',
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Brand Preview',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _brandScheme.primary,
                            _brandScheme.secondary
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.business,
                            size: 48,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _brandScheme.brandName ?? 'Demo Brand',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ModernSettingsUI(
              sections: [
                SettingsSection(
                  title: 'Brand Colors',
                  icon: Icons.palette,
                  items: [
                    SettingsItem(
                      id: 'primary_color',
                      type: SettingsItemType.navigation,
                      title: 'Primary Color',
                      subtitle: 'Change primary brand color',
                      onChanged: (value) {
                        // Color picker would go here
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Color picker would open here'),
                          ),
                        );
                      },
                    ),
                    SettingsItem(
                      id: 'secondary_color',
                      type: SettingsItemType.navigation,
                      title: 'Secondary Color',
                      subtitle: 'Change secondary brand color',
                      onChanged: (value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Color picker would open here'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SettingsSection(
                  title: 'Brand Assets',
                  icon: Icons.image,
                  items: [
                    SettingsItem(
                      id: 'brand_name',
                      type: SettingsItemType.navigation,
                      title: 'Brand Name',
                      subtitle: _brandScheme.brandName ?? 'Not set',
                      onChanged: (value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Brand name editor would open here'),
                          ),
                        );
                      },
                    ),
                    SettingsItem(
                      id: 'logo_url',
                      type: SettingsItemType.navigation,
                      title: 'Logo URL',
                      subtitle: _brandScheme.logoUrl ?? 'Not set',
                      onChanged: (value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Logo uploader would open here'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
              scrollable: false,
            ),
          ],
        ),
      ),
    );
  }
}
