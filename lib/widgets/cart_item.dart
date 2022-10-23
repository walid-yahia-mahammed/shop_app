//packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//providers
import '../providers/cart.dart' show Cart;

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final int qty;
  final double price;

  CartItem(this.id, this.productId, this.title, this.qty, this.price);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Alert'),
            content:
                Text('Are you sure you want to remove item from the cart?'),
            actions: [
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).deleteItem(productId);
      },
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Text('\$$price'),
                ),
              ),
            ),
            title: Text('$title'),
            subtitle: Text('\$${price * qty}'),
            trailing: Text('${qty} x'),
          ),
        ),
      ),
    );
  }
}
