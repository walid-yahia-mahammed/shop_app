import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';

import './add_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/userProducts';
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetUserProducts();
  }

  @override
  Widget build(BuildContext context) {
    _refreshProducts(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('your products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddProductScreen.routeName);
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (context, snapShot) {
            return snapShot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<ProductsProvider>(
                        builder: (context, productsData, _) {
                      return Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: productsData.userItems.length,
                          itemBuilder: (_, i) => Column(
                            children: [
                              UserProductItem(
                                id: productsData.items[i].id,
                                title: productsData.items[i].title,
                                imageUrl: productsData.items[i].imageUrl,
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      );
                    }),
                  );
          }),
    );
  }
}
