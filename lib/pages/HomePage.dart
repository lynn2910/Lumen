import 'package:flutter/material.dart';
import 'package:lumen/services/pixabay_image.dart';
import 'package:lumen/services/pixabay_images.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PixabayImage> shownImages = [];

  /// The number of images accessible through the API. By default, the API is limited to return a maximum of 500 images per query.
  int totalHits = 0;

  /// The total number of hits.
  int total = 0;

  Future<void> loadPhotos() async {
    try {
      PixabayResponse res = await fetchPhotos();

      setState(() {
        shownImages = res.hits;
        totalHits = res.totalHits;
        total = res.total;
      });
    } catch (e) {
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
    return Center(child: Text("Coucou!"));
  }
}
