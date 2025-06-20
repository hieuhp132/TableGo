import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/app_state.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key});

  void _finish(BuildContext context) {
    context.read<MyAppState>().markOrderProcessing();
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Status')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // shrink to fit content
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 20),
              const Text(
                'Payment successful!\nYour order is being processed...',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _finish(context),
                child: const Text('Finish'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
