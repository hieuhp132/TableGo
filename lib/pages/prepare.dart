import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';

class Prepare extends StatelessWidget {
  const Prepare({super.key});

  @override
  Widget build(BuildContext context) {
    final preparingItems = context
        .watch<MyAppState>()
        .addedItems
        .where((item) => item.status == 'preparing')
        .toList();

    if (preparingItems.isEmpty) {
      return const Center(child: Text('No items currently preparing.'));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Items currently being prepared:',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 10),
        ...preparingItems.map(
          (item) => ListTile(
            leading: const Icon(Icons.hourglass_top),
            title: Text(item.name),
            subtitle: const Text('Status: Preparing'),
          ),
        ),
      ],
    );
  }
}
