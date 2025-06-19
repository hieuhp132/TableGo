import 'dart:math';

/// A simple Order model with random generation support.
class Order {
  final String name;
  final double price;
  final int sales;

  Order({
    required this.name,
    required this.price,
    required this.sales,
  });

  /// Generates a random Order using predefined sample data.
  factory Order.random() {
    return Order(
      name: _sampleNames[_random.nextInt(_sampleNames.length)],
      price: double.parse(((_random.nextDouble() * 50) + 1).toStringAsFixed(2)),
      sales: _random.nextInt(500),
    );
  }

  /// Generates a list of random orders.
  static List<Order> generateList(int count) {
    return List.generate(count, (_) => Order.random());
  }

  @override
  String toString() =>
      'Order(name: "$name", price: \$${price.toStringAsFixed(2)}, sales: $sales)';

  /// Serialization
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      sales: json['sales'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'sales': sales,
    };
  }

  // Static variables for reuse
  static final _random = Random();

  static const _sampleNames = [
    'Espresso',
    'Cappuccino',
    'Latte',
    'Green Tea',
    'Bagel',
    'Cheesecake',
    'Sandwich',
    'Salad',
    'Smoothie',
    'Muffin',
  ];
}
