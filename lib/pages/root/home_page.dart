import 'package:flutter/material.dart';
import 'package:lumen/services/pixabay_image.dart';
import 'package:lumen/services/pixabay_images.dart';

// Importez le bon chemin pour la nouvelle API du package
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart'; // Ceci est correct

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PixabayImage> shownImages = [];
  int totalHits = 0;
  int total = 0;

  @override
  void initState() {
    super.initState();
    loadPhotos();
  }

  Future<void> loadPhotos() async {
    try {
      PixabayResponse res = await fetchPhotos(perPage: 100);

      if (!mounted) return;

      setState(() {
        shownImages = res.hits;
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
    }
  }

  @override
  Widget build(BuildContext context) {
    if (shownImages.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),

      child: MasonryGridView.count(
        crossAxisCount: 4,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        itemCount: shownImages.length,
        itemBuilder: (BuildContext context, int index) {
          final photo = shownImages[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(photo.webformatURL, fit: BoxFit.cover),
          );
        },
      ),
    );
  }
}
