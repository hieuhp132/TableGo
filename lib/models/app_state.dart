import 'package:flutter/material.dart';
import 'order.dart';

class MyAppState extends ChangeNotifier {
  final List<Order> _addedItems = [];
  bool isOrderProcessing = false;

  List<Order> get addedItems => List.unmodifiable(_addedItems);

  void addItem(Order order) {
    _addedItems.add(order);
    notifyListeners();
  }

  void removeItem(Order order) {
    _addedItems.remove(order);
    notifyListeners();
  }

  void clearItems() {
    _addedItems.clear();
    notifyListeners();
  }

  void markOrderProcessing() {
    for (var item in addedItems) {
      item.status = 'preparing';
    }
    notifyListeners();
    _simulatePreparation();
  }

  void clearCart() {
    addedItems.clear();
    notifyListeners();
  }

  void _simulatePreparation() {
    Future.delayed(const Duration(seconds: 10), () {
      for (var item in addedItems) {
        if (item.status == 'preparing') {
          item.status = 'ready';
        }
      }
      notifyListeners();
    });
  }
}
