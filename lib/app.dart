import 'package:flutter/material.dart';
import 'pages/order.dart';
import 'pages/payment.dart';
import 'pages/prepare.dart';
import 'pages/ready.dart';

import '../models/order.dart';
import 'models/device_type.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TableGo',
      theme: ThemeData(
        useMaterial3: false, // or false, depending on preference
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.grey[900],
          selectedItemColor: Colors.deepOrange,
          unselectedItemColor: Colors.white70,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepOrange, // AppBar background
          foregroundColor: Colors.white, // Icon & text color
          elevation: 4, // Shadow depth
          centerTitle: true, // Centered title
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  late final List<Order> orders;
  String selectedFilter = 'all';
  final List<String> filters = ['all', 'foods', 'drinks', 'menu'];

  @override
  void initState() {
    super.initState();
    orders = Order.generateList(50); // generate 10 random orders
  }

  Widget buildFilterRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: filters.map((filter) {
          final isSelected = selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  selectedFilter = filter;
                });
              },
              selectedColor: Colors.deepOrange,
              backgroundColor: Colors.grey[300],
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(
          begin: isSelected ? 1.0 : 0.8,
          end: isSelected ? 1.2 : 1.0,
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Colors.white, Colors.yellowAccent],
                  ).createShader(bounds),
                  child: Icon(icon, size: 26, color: Colors.white),
                ),
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontSize: 12,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  duration: const Duration(milliseconds: 200),
                  child: Text(label),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Routing pages through selectedIndex.
  @override
  Widget build(BuildContext context) {
    final deviceType = getDeviceType(context);

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = OrderListWidget(orders: orders, filter: selectedFilter);
        break;
      case 1:
        page = Payment();
        break;
      case 2:
        page = Prepare();
        break;
      case 3:
        page = Ready();
        break;
      default:
        throw UnimplementedError('No widget for index $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (deviceType == DeviceType.mobile) {
          // Use BottomNavigationBar for mobile
          return Scaffold(
            appBar: AppBar(
              title: const Text('TableGo'),
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepOrange, Colors.orangeAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            body: Column(
              children: [
                if (selectedIndex == 0) buildFilterRow(),
                if (selectedIndex == 0) const Divider(height: 1),
                Expanded(
                  child: selectedIndex == 0
                      ? OrderListWidget(orders: orders, filter: selectedFilter)
                      : page,
                ),
              ],
            ),
            bottomNavigationBar: Container(
              height: 70,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepOrange, Colors.orangeAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.list_alt, 'Orders', 0),
                  _buildNavItem(Icons.credit_card, 'Payments', 1),
                  _buildNavItem(Icons.microwave, 'Prepare', 2),
                  _buildNavItem(Icons.done, 'Done', 3),
                ],
              ),
            ),
          );
        } else {
          // Use NavigationRail for tablet/desktop
          return Scaffold(
            body: Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: false,
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.list_alt),
                        label: Text('Orders'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.credit_card),
                        label: Text('Payments'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.microwave),
                        label: Text('Prepare'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.done),
                        label: Text('Done'),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: page,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
