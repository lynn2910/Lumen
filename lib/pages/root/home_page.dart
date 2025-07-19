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

  bool isAddingPhotoLoading = false;

  @override
  void initState() {
    super.initState();
    loadPhotos();
  }

  Future<void> loadPhotos() async {
    if (isAddingPhotoLoading) return;

    try {
      setState(() {
        isAddingPhotoLoading = true;
      });

      PixabayResponse res = await fetchPhotos(perPage: 100);

      if (!mounted) return;

      setState(() {
        shownImages.addAll(res.hits);
        totalHits = res.totalHits;
        total = res.total;
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
    if (shownImages.isEmpty && !isAddingPhotoLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    var theme = Theme.of(context);

    final ButtonStyle defaultButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.surface,
      foregroundColor: theme.colorScheme.onPrimaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: theme.textTheme.labelLarge,
    );

    final ButtonStyle disabledButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      foregroundColor: theme.colorScheme.onSurfaceVariant,

      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: theme.textTheme.labelLarge,

      disabledBackgroundColor: theme.colorScheme.surfaceContainerHighest,
      disabledForegroundColor: theme.colorScheme.onSurfaceVariant,
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
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
                                  ),
                                  SizedBox(height: 10),
                                  Text("Chargement en cours..."),
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: isAddingPhotoLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                        onPressed: () {
                          if (!isAddingPhotoLoading) {
                            loadPhotos();
                          }
                        },
                        style: isAddingPhotoLoading
                            ? defaultButtonStyle
                            : disabledButtonStyle,
                        label: Text("Charger plus"),
                        icon: Icon(Icons.download),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
