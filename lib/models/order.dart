import 'dart:math';

class Order {
  final String name;
  final double price;
  final int sales;
  final String category;
  String status; // 'new', 'preparing', 'ready'

  Order({
    required this.name,
    required this.price,
    required this.sales,
    required this.category,
    this.status = 'new', // default value
  });

  factory Order.random() {
    final name = _sampleNames[_random.nextInt(_sampleNames.length)];
    final category = _foodNames.contains(name) ? 'foods' : 'drinks';

    return Order(
      name: name,
      price: double.parse(((_random.nextDouble() * 50) + 1).toStringAsFixed(2)),
      sales: _random.nextInt(100),
      category: category,
      status: 'new', // all new orders default to "preparing"
    );
  }

  static List<Order> generateList(int count) =>
      List.generate(count, (_) => Order.random());

  static List<Order> filterOrders(List<Order> orders, String category) {
    switch (category.toLowerCase()) {
      case 'foods':
        return orders.where((o) => o.category == 'foods').toList();
      case 'drinks':
        return orders.where((o) => o.category == 'drinks').toList();
      case 'menu':
        final foods = orders.where((o) => o.category == 'foods').toList();
        final drinks = orders.where((o) => o.category == 'drinks').toList();

        final int comboCount = min(foods.length, drinks.length);
        final List<Order> combos = [];

        for (int i = 0; i < comboCount; i++) {
          final food = foods[i];
          final drink = drinks[i];

          final comboName = '${food.name} + ${drink.name}';
          final comboSales = min(food.sales, drink.sales);
          final comboPrice =
              (food.price * comboSales / 100) +
              (drink.price * comboSales / 100);

          combos.add(
            Order(
              name: comboName,
              price: comboPrice,
              sales: comboSales,
              category: 'menu',
              status: 'new',
            ),
          );
        }

        return combos;

      case 'all':
      default:
        return orders;
    }
  }

  static final _random = Random();

  static const _foodNames = [
    'Bagel',
    'Cheesecake',
    'Sandwich',
    'Salad',
    'Muffin',
  ];
  static const _drinkNames = [
    'Espresso',
    'Cappuccino',
    'Latte',
    'Green Tea',
    'Smoothie',
  ];

  static const _sampleNames = [..._foodNames, ..._drinkNames];
}
