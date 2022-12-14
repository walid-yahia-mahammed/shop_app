//packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';

//screens
import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          title: Text('My shop'),
          automaticallyImplyLeading: false,
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text('Shop'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        ListTile(
          leading: Icon(Icons.payment),
          title: Text('orders'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text('Manage products'),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(UserProductsScreen.routeName);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Logout'),
          onTap: () {
            Provider.of<Auth>(context, listen: false).logOut();
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
      ]),
    );
  }
}
