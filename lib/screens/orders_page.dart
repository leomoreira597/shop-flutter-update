import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/orde_list.dart';
import 'package:shop/widget/app_drawer.dart';
import 'package:shop/widget/order_item.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderList orders = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Meus Pedidos",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: orders.itemsCount,
        itemBuilder: (ctx, index) {
          return OrderItem(order: orders.items[index]);
        },
      ),
    );
  }
}
