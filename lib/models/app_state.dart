import 'package:english_words/english_words.dart';
import 'package:fapp/models/order.dart';
import 'package:flutter/material.dart';

class MyAppState extends ChangeNotifier {
  var current = Order.random();
  var favorites = <Order>[];

  void getNext() {
    current = Order.random();
    notifyListeners();
  }

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}
