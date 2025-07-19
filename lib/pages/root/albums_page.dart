import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AlbumsPage extends StatelessWidget {
  const AlbumsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Page Albums'),
          ElevatedButton(
            onPressed: () => context.go('/details/123'),
            child: const Text('Voir détails de l\'album 123'),
          ),
        ],
      ),
    );
  }
}
