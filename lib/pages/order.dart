import 'package:flutter/material.dart';
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
  final List<Order> addedItems = [];
  bool cartVisible = false;
  bool isDragging = false;

  void _addItem(Order order) {
    setState(() {
      addedItems.add(order);
      if (!cartVisible) cartVisible = true; // Auto-show cart after first add
    });
  }

  void _removeItem(int index) {
    setState(() => addedItems.removeAt(index));
  }

  void _toggleCart() => setState(() => cartVisible = !cartVisible);

  double get totalPrice => addedItems.fold(0, (sum, item) => sum + item.price);

  @override
  Widget build(BuildContext context) {
    final filteredOrders = Order.filterOrders(widget.orders, widget.filter);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          // Order list
          ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            itemCount: filteredOrders.length,
            itemBuilder: (context, index) =>
                _buildOrderCard(filteredOrders[index]),
          ),

          // Show cart button (only if hidden and has items)
          if (!cartVisible && addedItems.isNotEmpty) _buildShowCartButton(),

          // Cart sheet (only if visible and has items)
          if (cartVisible && addedItems.isNotEmpty) _buildCartSheet(),
        ],
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
      right: MediaQuery.of(context).size.width / 2 - 28, // center horizontally
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
        return NotificationListener<DraggableScrollableNotification>(
          onNotification: (notification) {
            setState(() {
              isDragging =
                  notification.extent != notification.minExtent &&
                  notification.extent != notification.maxExtent;
            });
            return true;
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
            ),
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

                // Header Row: "Your Cart" + close button
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
                        tooltip: 'Close Cart',
                      ),
                    ],
                  ),
                ),
                const Divider(),

                // Scrollable cart list
                Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    controller: scrollController,
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: addedItems.length,
                      itemBuilder: (context, index) {
                        final item = addedItems[index];
                        return ListTile(
                          title: Text(item.name),
                          subtitle: Text('Sales: ${item.sales}'),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () => _removeItem(index),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const Divider(),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 6,
                    bottom: 12,
                    left: 16,
                    right: 16,
                  ),
                  child: Row(
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
