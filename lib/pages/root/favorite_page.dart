import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lumen/widgets/images_grid_view.dart';
import 'package:provider/provider.dart';

import '../../models/display_image.dart';
import '../../states/favorites.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteImages = Provider.of<FavoriteImages>(context);

    var theme = Theme.of(context);

    if (favoriteImages.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_search, size: 64),
            SizedBox(height: 20),
            Text("Aucune image favorite à afficher"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.pushNamed('home');
              },
              child: Text('Découvrir des images'),
            ),
          ],
        ),
      );
    }

    var sortedFavoriteImages = favoriteImages.items.toList();
    sortedFavoriteImages.sort((a, b) {
      return b.added.compareTo(a.added);
    });

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Scrollbar(
        interactive: true,
        thumbVisibility: true,
        thickness: 8.0,
        radius: const Radius.circular(10.0),
        child: ListView(
          primary: true,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 20),
              child: Text(
                "${favoriteImages.items.length} images favorites",
                style: theme.textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            ImagesGridView(
              shownImages: sortedFavoriteImages.map((i) {
                return DisplayImage.fromFavoriteImage(i);
              }).toList(),
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }
}
