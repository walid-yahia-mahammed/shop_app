//packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//widgets
import './product_item.dart';

//providers
import '../providers/products_provider.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavorite;

  const ProductGrid(this.showFavorite);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products = showFavorite ? productsData.favorites : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, i) {
        return ChangeNotifierProvider.value(
          value: products[i],
          child: ProductItem(),
        );
      },
    );
  }
}
