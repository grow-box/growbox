import 'package:growbox/plant.dart';
import 'package:growbox/add_plant.dart';
import 'package:growbox/plant_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:growbox/settings.dart';
import 'package:hive_flutter/hive_flutter.dart';

final ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.blueGrey,
    accentColor: Colors.lightGreenAccent,
    brightness: Brightness.light,
  ),
);
final ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.blueGrey,
    accentColor: Colors.lightGreenAccent,
    brightness: Brightness.dark,
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(PlantAdapter());
  Hive.registerAdapter(WateredAdapter());
  await Hive.openBox<Plant>('plants');
  await Hive.openBox('settings');

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box('settings').listenable(keys: ['dark_mode']),
        builder: (context, Box box, _) {
          final theme = box.get('dark_mode', defaultValue: false)
              ? darkTheme
              : lightTheme;
          return MaterialApp(
            title: 'Growbox',
            theme: theme,
            home: const Home('Growbox'),
            routes: {
              '/settings': (context) => const Settings(),
            },
          );
        });
  }
}

class Home extends StatefulWidget {
  final String title;

  const Home(this.title, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          const AddPlant(),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: const Center(
        child: PlantsList(),
      ),
    );
  }
}

class PlantsList extends StatefulWidget {
  const PlantsList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlantsListState();
}

class _PlantsListState extends State<PlantsList> {
  late Box<Plant> plantBox;

  @override
  void initState() {
    super.initState();

    plantBox = Hive.box('plants');
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: plantBox.listenable(),
        builder: (context, Box<Plant> box, _) {
          var plants = box.values.toList(growable: false);
          return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: plants.length,
              itemBuilder: (BuildContext ctx, int idx) {
                return PlantCard(plants[idx]);
              });
        });
  }
}
