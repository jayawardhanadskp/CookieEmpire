import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HomeWidget.setAppGroupId('group.CookieEmpireWidget');
  await HomeWidget.registerInteractivityCallback(backgroundCallback);
  runApp(const MyApp());
}

Future<void> backgroundCallback(Uri? uri) async {
  if (uri?.host == 'increment') {
    final prefs = await SharedPreferences.getInstance();
    final currentCount = prefs.getDouble('cookies') ?? 0;
    final multiplier = prefs.getDouble('tapMultiplier') ?? 1;
    await prefs.setDouble('cookies', currentCount + multiplier);
    await HomeWidget.saveWidgetData(
      'cookies', (currentCount + multiplier).toInt());
    await HomeWidget.saveWidgetData(
      'production', prefs.getDouble('production') ?? 0);
    await HomeWidget.updateWidget(
      androidName: 'CookieEmpireWidget',
      iOSName: 'CookieEmpireWidget',
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cookie Empire',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.brown,
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class Building {
  final String name;
  final String description;
  final double baseCost;
  final double baseProduction;
  final String icon;

  const Building({
    required this.name,
    required this.description,
    required this.baseCost,
    required this.baseProduction,
    required this.icon,
  });
}

class GameState {
  double cookies;
  double tapMultiplier;
  Map<String, int> buildings;
  List<String> achievements;

  GameState({
    this.cookies = 0,
    this.tapMultiplier = 1,
    Map<String, int>? buildings,
    List<String>? achievements,
  })  : buildings = buildings ?? {},
        achievements = achievements ?? [];

  double get productionPerSecond {
    double total = 0;
    buildings.forEach((name, count) {
      final building = availableBuildings.firstWhere((b) => b.name == name);
      total += building.baseProduction * count;
    });
    return total;
  }

  static const availableBuildings = [
    Building(
      name: 'Grandma',
      description: 'A nice grandma to bake cookies',
      baseCost: 10,
      baseProduction: 0.1,
      icon: '👵',
    ),
    Building(
      name: 'Bakery',
      description: 'Small bakery producing cookies',
      baseCost: 50,
      baseProduction: 0.5,
      icon: '🏪',
    ),
    Building(
      name: 'Factory',
      description: 'Industrial cookie production',
      baseCost: 500,
      baseProduction: 4,
      icon: '🏭',
    ),
    Building(
      name: 'Bank',
      description: 'Generates cookies from thin air',
      baseCost: 2000,
      baseProduction: 10,
      icon: '🏦',
    ),
    Building(
      name: 'Temple',
      description: 'Blessed cookie production',
      baseCost: 10000,
      baseProduction: 40,
      icon: '⛪',
    ),
  ];
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  GameState? gameState;
  final audioPlayer = AudioPlayer();
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _loadGame().then((_) {
      _startProduction();
    });
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
  }

  Future<void> _loadGame() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      gameState = GameState(
        cookies: prefs.getDouble('cookies') ?? 0,
        tapMultiplier: prefs.getDouble('tapMultiplier') ?? 1,
        buildings: Map.fromEntries(
          GameState.availableBuildings.map(
            (b) => MapEntry(b.name, prefs.getInt('building_${b.name}') ?? 0),
          ),
        ),
        achievements: prefs.getStringList('achievements') ?? [],
      );
    });
  }

  void _startProduction() {
    if (gameState == null) return;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;

      setState(() {
        gameState!.cookies += gameState!.productionPerSecond;
      });
      _saveGame();
      return true;
    });
  }

  Future<void> _saveGame() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('cookies', gameState!.cookies);
    await prefs.setDouble('production', gameState!.productionPerSecond);

    // Save data to HomeWidget
    await HomeWidget.saveWidgetData<double>('cookies', gameState!.cookies);
    await HomeWidget.saveWidgetData<double>('production', gameState!.productionPerSecond);
    await HomeWidget.updateWidget(
      androidName: 'CookieEmpireWidget',
      iOSName: 'CookieEmpireWidget',
    );
  }

  Future<void> _onTap() async {
    if (gameState == null) return;
    _controller.forward(from: 0);
    setState(() {
      gameState!.cookies += gameState!.tapMultiplier;
    });

    audioPlayer.play(AssetSource('tap.mp3'));
    _saveGame();
  }

  Future<void> _buyBuilding(Building building) async {
    if (gameState == null) return;
    final cost = building.baseCost * (1.15 * (gameState!.buildings[building.name] ?? 0));
    if (gameState!.cookies >= cost) {
      setState(() {
        gameState!.cookies -= cost;
        gameState!.buildings[building.name] =
            (gameState!.buildings[building.name] ?? 0) + 1;
      });
      audioPlayer.play(AssetSource('buy.mp3'));
      _saveGame();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (gameState == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          // Stats Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${gameState!.cookies.toInt()} Cookies',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      '${gameState!.productionPerSecond.toStringAsFixed(1)}/s',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.touch_app,
                        color: Theme.of(context).colorScheme.primary),
                    Text(' ${gameState!.tapMultiplier.toStringAsFixed(1)}x'),
                  ],
                ),
              ],
            ),
          ),

          // Main Cookie Button
          Expanded(
            child: Center(
              child: GestureDetector(
                onTapDown: (_) => _onTap(),
                child: ScaleTransition(
                  scale: Tween(begin: 1.0, end: 0.95).animate(_controller),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Image.asset('assets/cookie.png', height: 170,),
                  ),
                ),
              ),
            ),
          ),

          // Buildings List
          Container(
              height: 300,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: GameState.availableBuildings.length,
                  itemBuilder: (context, index) {
                    final building = GameState.availableBuildings[index];
                    final count = gameState!.buildings[building.name] ?? 0;
                    final cost = building.baseCost * (1.15 * count);
                    final canAfford = gameState!.cookies >= cost;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Text(
                          building.icon,
                          style: const TextStyle(fontSize: 24),
                        ),
                        title: Text(building.name),
                        subtitle: Text(
                          '${building.baseProduction}/s • Owned: $count',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        trailing: TextButton(
                          onPressed:
                              canAfford ? () => _buyBuilding(building) : null,
                          child: Text('${cost.toInt()} 🍪'),
                        ),
                      ),
                    )
                        .animate(delay: Duration(milliseconds: index * 100))
                        .fadeIn()
                        .slideX(begin: 0.2, end: 0);
                  })),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    audioPlayer.dispose();
    super.dispose();
  }
}
