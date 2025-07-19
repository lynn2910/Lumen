import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lumen/pages/HomePage.dart';
import 'package:lumen/pages/global_layout.dart';
import 'package:lumen/pages/root/albums_page.dart';
import 'package:lumen/pages/root/details_page.dart';
import 'package:lumen/pages/root/favorite_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (contexte, state, child) {
          return GlobalLayout(child: child);
        },
        routes: [
          // TODO /home
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => HomePage(),
          ),
          // TODO /albums
          GoRoute(
            path: '/albums',
            name: 'albums',
            builder: (context, state) => AlbumsPage(),
          ),
          // TODO /favorites
          GoRoute(
            path: '/favorites',
            name: 'favorites',
            builder: (context, state) => FavoritesPage(),
          ),
          // TODO /details/:id
          GoRoute(
            path: '/details/:id',
            name: 'details',
            builder: (context, state) {
              final id = state.pathParameters['id'];
              return DetailsPage(id: id);
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Erreur de Navigation')),
      body: Center(child: Text('Page non trouvée: ${state.uri.path}')),
    ),
  );
}
