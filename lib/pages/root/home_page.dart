import 'package:flutter/material.dart';
import 'package:lumen/services/favorite.dart';
import 'package:lumen/services/pixabay_image.dart';
import 'package:lumen/services/pixabay_images.service.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../states/favorites.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PixabayImage> shownImages = [];
  int totalHits = 0;
  int total = 0;
  int currentPage = 1;
  final int photosPerPage = 100;

  bool isAddingPhotoLoading = false;

  @override
  void initState() {
    super.initState();
    loadPhotos();
  }

  Future<void> loadPhotos() async {
    if (isAddingPhotoLoading) return;

    // Prevent loading more if we've already loaded all available photos
    if (totalHits > 0 && shownImages.length >= totalHits) {
      return;
    }

    try {
      setState(() {
        isAddingPhotoLoading = true;
      });

      PixabayResponse res = await fetchPhotos(
        perPage: photosPerPage,
        page: currentPage,
      );

      if (!mounted) return;

      setState(() {
        shownImages.addAll(res.hits);
        totalHits = res.totalHits;
        total = res.total;
        currentPage++;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load photos: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isAddingPhotoLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (shownImages.isEmpty && isAddingPhotoLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    var theme = Theme.of(context);

    final ButtonStyle defaultButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      elevation: 5,
    );

    final ButtonStyle disabledButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      foregroundColor: theme.colorScheme.onSurfaceVariant,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: theme.textTheme.labelLarge,
      elevation: 0,
    );

    final bool canLoadMore = shownImages.length < totalHits;

    final favoriteImages = Provider.of<FavoriteImages>(context);

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
            MasonryGridView.count(
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
                    aspectRatio: photo.webformatWidth / photo.webformatHeight,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            photo.webformatURL,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                              null
                                          ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
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
                                    content: Text(
                                      'Image supprimée des favoris!',
                                    ),
                                  ),
                                );
                              } else {
                                FavoriteItem item = FavoriteItem(
                                  imageId: photo.id,
                                  tags: photo.tags,
                                  pageURL: photo.pageURL,
                                  isLowQuality: photo.isLowQuality,
                                  isAiGenerated: photo.isAiGenerated,
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
                              backgroundColor: theme
                                  .colorScheme
                                  .surfaceContainerHighest
                                  .withValues(alpha: 0.7),
                              foregroundColor:
                                  theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isAddingPhotoLoading && shownImages.isNotEmpty)
                  const CircularProgressIndicator()
                else
                  ElevatedButton.icon(
                    onPressed: canLoadMore ? loadPhotos : null,
                    style: canLoadMore
                        ? defaultButtonStyle
                        : disabledButtonStyle,
                    label: Text(
                      canLoadMore
                          ? "Charger plus"
                          : "Toutes les photos chargées",
                    ),
                    icon: Icon(Icons.download),
                  ),
              ],
            ),

            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
