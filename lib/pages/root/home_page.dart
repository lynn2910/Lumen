import 'package:flutter/material.dart';
import 'package:lumen/services/pixabay_image.dart';
import 'package:lumen/services/pixabay_images.service.dart';
import 'package:lumen/widgets/images_grid_view.dart';

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
            ImagesGridView(shownImages: shownImages, theme: theme),

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
