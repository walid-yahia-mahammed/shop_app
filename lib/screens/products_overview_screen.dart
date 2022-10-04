import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/products_grid.dart';

enum filterOptions {
  Favorite,
  All,
}

class ProductsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsContainer = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('myShop'),
        actions: [
          PopupMenuButton(
            onSelected: (filterOptions value) {
              if (value == filterOptions.Favorite) {
                productsContainer.showFavorite();
              } else {
                productsContainer.showAll();
              }
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only favorite'),
                value: filterOptions.Favorite,
              ),
              PopupMenuItem(
                child: Text('Show all'),
                value: filterOptions.All,
              ),
            ],
          )
        ],
      ),
      body: ProductGrid(),
    );
  }
}
