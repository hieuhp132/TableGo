import 'package:fapp/models/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';

class OrderListWidget extends StatefulWidget {
  final List<Order> orders;
  final String filter;

  const OrderListWidget({
    super.key,
    required this.orders,
    required this.filter,
  });

  @override
  State<OrderListWidget> createState() => _OrderListWidgetState();
}

class _OrderListWidgetState extends State<OrderListWidget> {
  bool cartVisible = false;
  bool isDragging = false;

  void _addItem(Order order) {
    final appState = context.read<MyAppState>();
    appState.addItem(order);
    if (!cartVisible) {
      setState(() {
        cartVisible = true;
      });
    }
  }

  void _removeItem(Order order) {
    final appState = context.read<MyAppState>();
    appState.removeItem(order);
  }

  void _toggleCart() => setState(() => cartVisible = !cartVisible);

  double get totalPrice => context.watch<MyAppState>().addedItems.fold(
    0,
    (sum, item) => sum + item.price,
  );

  @override
  Widget build(BuildContext context) {
    final filteredOrders = Order.filterOrders(widget.orders, widget.filter);
    final bottomPadding = MediaQuery.of(context).padding.bottom + 100;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Stack(
          children: [
            ListView.builder(
              padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPadding),
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) =>
                  _buildOrderCard(filteredOrders[index]),
            ),

            if (!cartVisible &&
                context.watch<MyAppState>().addedItems.isNotEmpty)
              _buildShowCartButton(),

            if (cartVisible &&
                context.watch<MyAppState>().addedItems.isNotEmpty)
              _buildCartSheet(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          order.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Sales: ${order.sales}'),
        trailing: IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () => _addItem(order),
          color: Colors.deepOrange,
        ),
      ),
    );
  }

  Widget _buildShowCartButton() {
    return Positioned(
      bottom: 24,
      right: MediaQuery.of(context).size.width / 2 - 28,
      child: FloatingActionButton.small(
        backgroundColor: Colors.deepOrange,
        onPressed: _toggleCart,
        tooltip: 'Show Cart',
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }

  Widget _buildCartSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.25,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
          ),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Drag handle
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),

                    // Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Your Cart',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.keyboard_arrow_down),
                            onPressed: _toggleCart,
                            color: Colors.deepOrange,
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                  ],
                ),
              ),

              // Scrollable list
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = context.watch<MyAppState>().addedItems[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('Sales: ${item.sales}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _removeItem(item),
                    ),
                  );
                }, childCount: context.watch<MyAppState>().addedItems.length),
              ),

              // Total
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Column(
                    children: [
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
