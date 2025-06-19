import 'package:flutter/material.dart';
import 'pages/order.dart';
import 'pages/payment.dart';
import 'pages/prepare.dart';
import 'pages/ready.dart';

import '../models/order.dart';

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

    // Layout builder for homepage
    return LayoutBuilder(
      builder: (context, constraints) {
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
      },
    );
  }
}
