import 'package:flutter/material.dart';

class AppNavigationRail extends StatelessWidget {
  final bool extended;
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const AppNavigationRail({
    super.key,
    required this.extended,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;

    return SafeArea(
      child: NavigationRail(
        extended: extended,
        labelType: extended ? null : NavigationRailLabelType.all,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            if (extended)
              FloatingActionButton.extended(
                foregroundColor: colorScheme.primary,
                backgroundColor: colorScheme.surface,
                onPressed: () {},
                icon: const Icon(Icons.search),
                label: const Text("Rechercher"),
              )
            else
              FloatingActionButton(
                foregroundColor: colorScheme.primary,
                backgroundColor: colorScheme.surface,
                onPressed: () {},
                child: const Icon(Icons.search),
              ),
            SizedBox(height: 16),
          ],
        ),
        destinations: [
          NavigationRailDestination(
            icon: Icon(Icons.photo_camera),
            label: Text("Découverte"),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.photo_album),
            label: Text("Albums"),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.favorite),
            label: Text("Favoris"),
          ),
        ],
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}
