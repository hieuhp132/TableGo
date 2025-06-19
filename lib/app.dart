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
      title: 'Namer App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
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

  @override
  void initState() {
    super.initState();
    orders = Order.generateList(50); // generate 10 random orders
  }

  // Routing pages through selectedIndex.
  @override
  Widget build(BuildContext context) {
    final deviceType = getDeviceType(context);

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = OrderListWidget(orders: orders);
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
            body: page,
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt),
                  label: 'Orders',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.credit_card),
                  label: 'Payments',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.microwave),
                  label: 'Prepare',
                ),
                BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Done'),
              ],
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
