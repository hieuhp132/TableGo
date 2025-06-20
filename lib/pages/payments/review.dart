import 'package:flutter/material.dart';
import 'success.dart';

class PaymentReviewPage extends StatelessWidget {
  final String paymentMethod;
  final String name;
  final String email;

  const PaymentReviewPage({
    super.key,
    required this.paymentMethod,
    required this.name,
    required this.email,
  });

  void _confirmPayment(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const PaymentSuccessPage()),
    );
  }

  void _cancel(BuildContext context) => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Review & Confirm')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Payment Method: $paymentMethod'),
            const SizedBox(height: 10),
            Text('Name: $name'),
            const SizedBox(height: 10),
            Text('Email: $email'),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => _cancel(context),
                  child: const Text('Back'),
                ),
                ElevatedButton(
                  onPressed: () => _confirmPayment(context),
                  child: const Text('Confirm Payment'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
