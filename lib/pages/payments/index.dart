import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/app_state.dart';
import '../../models/order.dart';
import './form.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  void _startPayment(BuildContext context, String method) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentFormPage(paymentMethod: method),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    // Check if order has already been processed
    if (appState.isOrderProcessing) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Status')),
        body: const Center(
          child: Text(
            '🛒 Order is being processed!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    final items = appState.addedItems;
    if (items.isEmpty) {
      return const Center(child: Text('No items added.'));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Your Order')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) => ListTile(
                leading: const Icon(Icons.shopping_bag),
                title: Text(items[index].name),
                subtitle: Text('\$${items[index].price.toStringAsFixed(2)}'),
              ),
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Choose Payment Method:',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Wrap(
            spacing: 12,
            children: [
              ElevatedButton(
                onPressed: () => _startPayment(context, 'VNPAY'),
                child: const Text('VNPAY'),
              ),
              ElevatedButton(
                onPressed: () => _startPayment(context, 'PayPal'),
                child: const Text('PayPal'),
              ),
              ElevatedButton(
                onPressed: () => _startPayment(context, 'Bank Transfer'),
                child: const Text('Banking'),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
