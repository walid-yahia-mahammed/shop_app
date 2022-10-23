//packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//providers
import '../providers/orders.dart';

//widgets
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart' as wgt;

class OrdersScreen extends StatelessWidget {
  static String routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('your Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: ordersData.orders.length,
        itemBuilder: (ctx, index) => wgt.OrderItem(ordersData.orders[index]),
      ),
    );
  }
}
