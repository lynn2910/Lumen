import 'package:flutter/material.dart';
import 'package:lumen/services/pixabay_image.dart';
import 'package:lumen/services/pixabay_images.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
    // Initial loading state before any images are loaded
    if (shownImages.isEmpty && isAddingPhotoLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    var theme = Theme.of(context);

    // Define your ButtonStyle objects
    final ButtonStyle defaultButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.primary,
      // Using primary for a more distinct color
      foregroundColor: theme.colorScheme.onPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.bold, // Example: make text bold
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // More rounded corners
      ),
      elevation: 5, // Add some shadow
    );

    final ButtonStyle disabledButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      foregroundColor: theme.colorScheme.onSurfaceVariant,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: theme.textTheme.labelLarge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 0, // No shadow when disabled
    );

    // Determine if there are more photos to load
    final bool canLoadMore = shownImages.length < totalHits;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Scrollbar(
        // Added Scrollbar widget
        interactive: true,
        // Make it interactive
        thumbVisibility: true,
        // Always show the scrollbar thumb
        thickness: 8.0,
        // Make it thicker
        radius: const Radius.circular(10.0),
        // Rounded corners for the thumb
        child: ListView(
          children: [
            MasonryGridView.count(
              crossAxisCount: 4,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              // ListView handles scrolling
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
                                      color: theme
                                          .colorScheme
                                          .primary, // Match theme
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Chargement en cours...",
                                      style: theme
                                          .textTheme
                                          .bodySmall, // Use theme text style
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
                            onPressed: () {
                              // TODO favoris
                            },
                            icon: const Icon(Icons.favorite_outline),
                            style: IconButton.styleFrom(
                              backgroundColor: theme.colorScheme.surfaceVariant
                                  .withOpacity(0.7),
                              // Semi-transparent background
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
