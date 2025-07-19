import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DetailsPage extends StatelessWidget {
  final String? id;

  const DetailsPage({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Détails de l\'ID: $id')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Détails pour l\'élément avec l\'ID: $id'),
            ElevatedButton(
              onPressed: () {
                // Check if we can pop before attempting to do so
                if (context.canPop()) {
                  context.pop();
                } else {
                  // If we can't pop and we're viewing details from albums page,
                  // navigate back to albums page instead of home
                  context.goNamed('albums');
                }
              },
              child: const Text('Retour'),
            ),
          ],
        ),
      ),
    );
  }
}
