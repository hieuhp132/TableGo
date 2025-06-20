import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';

class Ready extends StatelessWidget {
  const Ready({super.key});

  @override
  Widget build(BuildContext context) {
    final readyItems = context
        .watch<MyAppState>()
        .addedItems
        .where((item) => item.status == 'ready')
        .toList();

    if (readyItems.isEmpty) {
      return const Center(child: Text('No ready items yet.'));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Your ready items:', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 10),
        ...readyItems.map(
          (item) => ListTile(
            leading: const Icon(Icons.check_circle, color: Colors.green),
            title: Text(item.name),
            subtitle: const Text('Status: Ready'),
          ),
        ),
      ],
    );
  }
}
