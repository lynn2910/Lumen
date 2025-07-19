import 'package:flutter/material.dart';
import 'package:lumen/widgets/navigation/navigation_rail.dart';
import 'package:go_router/go_router.dart';

class GlobalLayout extends StatefulWidget {
  final Widget child;

  const GlobalLayout({super.key, required this.child});

  @override
  State<GlobalLayout> createState() => _GlobalLayoutState();
}

class _GlobalLayoutState extends State<GlobalLayout> {
  int _getSelectedIndex(BuildContext context) {
    final String location = GoRouter.of(context).state.uri.toString();
    if (location == '/') {
      return 0;
    } else if (location.startsWith('/albums')) {
      return 1;
    } else if (location.startsWith('/favorites')) {
      return 2;
    }
    return 1;
  }

  void _onDestinationSelected(int navigationIndex) {
    switch (navigationIndex) {
      case 0:
        context.pushNamed('home');
        break;
      case 1:
        context.pushNamed('albums');
        break;
      case 2:
        context.pushNamed('favorites');
        break;
      default:
        context.pushNamed('home');
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      body: Row(
        children: [
          AppNavigationRail(
            extended: false,

            selectedIndex: _getSelectedIndex(context),
            onDestinationSelected: _onDestinationSelected,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 16, 0),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Container(
                  color: theme.colorScheme.surfaceContainerHigh,
                  child: widget.child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
