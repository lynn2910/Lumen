import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lumen/models/display_image.dart';
import 'package:provider/provider.dart';

import '../services/favorite.dart';
import '../services/pixabay_image.dart';
import '../states/favorites.dart';

class ImagesGridView extends StatefulWidget {
  final List<DisplayImage> shownImages;
  final ThemeData theme;

  const ImagesGridView({
    super.key,
    required this.shownImages,
    required this.theme,
  });

  @override
  State<ImagesGridView> createState() => _ImagesGridViewState();
}

class _ImagesGridViewState extends State<ImagesGridView> {
  @override
  Widget build(BuildContext context) {
    final List<DisplayImage> shownImages = widget.shownImages;
    final ThemeData theme = widget.theme;
    final favoriteImages = Provider.of<FavoriteImages>(context);

    return MasonryGridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      itemCount: shownImages.length,
      itemBuilder: (BuildContext context, int index) {
        final photo = shownImages[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: AspectRatio(
            aspectRatio: photo.width / photo.height,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    photo.photoUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Chargement en cours...",
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.broken_image)),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight.add(
                    AlignmentGeometry.xy(-0.05, 0.05),
                  ),
                  child: IconButton.filledTonal(
                    onPressed: () async {
                      if (favoriteImages.isFavorite(photo.id)) {
                        favoriteImages.removeByImageId(photo.id);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            showCloseIcon: true,
                            content: Text('Image supprimée des favoris!'),
                          ),
                        );
                      } else {
                        FavoriteItem item = FavoriteItem(
                          imageId: photo.id,
                          tags: photo.tags,
                          pageURL: photo.pageUrl,
                          imageURL: photo.photoUrl,
                          width: photo.width,
                          height: photo.height,
                          isLowQuality: photo.isLowQuality ? 1 : 0,
                          isAiGenerated: photo.isAiGenerated,
                          added: DateTime.now(),
                        );

                        favoriteImages.add(item);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            showCloseIcon: true,
                            content: Text('Image ajoutée aux favoris!'),
                          ),
                        );
                      }
                    },
                    icon: favoriteImages.isFavorite(photo.id)
                        ? const Icon(Icons.favorite)
                        : const Icon(Icons.favorite_outline),
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.7),
                      foregroundColor: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
