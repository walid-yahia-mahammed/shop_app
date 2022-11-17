//packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//screens
import './screens/auth_screen.dart';
import './screens/product_details_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/add_product_screen.dart';
import './screens/edit_product_screen.dart';

//providers
import './providers/orders.dart';
import './providers/products_provider.dart';
import './providers/cart.dart';
import './providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          create: (ctx) => ProductsProvider('', '', []),
          update: (ctx, auth, previousProducts) => ProductsProvider(
              auth.token, auth.userId, previousProducts?.items ?? []),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders('','', []),
          update: (ctx, auth, previousOrders) =>
              Orders(auth.token, auth.userId, previousOrders?.orders ?? []),
        ),
      ],
      child: Consumer<Auth>(builder: (ctx, auth, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
              colorScheme: ThemeData().colorScheme.copyWith(
                    primary: Colors.purple,
                    secondary: Colors.deepOrangeAccent,
                  ),
              fontFamily: 'Lato'),
          home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            AddProductScreen.routeName: (ctx) => AddProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        );
      }),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
      ),
      body: const Center(
        child: Text('Let\'s build a shop!'),
      ),
    );
  }
}
