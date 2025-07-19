import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:lumen/app_router.dart';
import 'package:lumen/services/isar.dart';
import 'package:lumen/states/favorites.dart';
import 'package:provider/provider.dart';
import 'package:lumen/services/favorite.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isarService = IsarService();
  final isarInstance = await isarService.db;

  runApp(
    MultiProvider(
      providers: [
        Provider<Isar>.value(value: isarInstance),
        ChangeNotifierProvider(
          create: (context) {
            final isar = Provider.of<Isar>(context, listen: false);
            return FavoriteImages(isar);
          },
        ),
      ],
      child: const App(),
    ),
  );
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.light,
        ),
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      routerConfig: AppRouter.router,
    );
  }
}
