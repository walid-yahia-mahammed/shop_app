import 'dart:math';

//packages
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//providers
import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
      height:
          _expanded ? min(widget.order.products.length * 20 + 110, 200) : 100,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle:
                Text(DateFormat('d MMM y hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              icon:
                  _expanded ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
            padding: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 4,
            ),
            height: _expanded
                ? min(widget.order.products.length * 20 + 10, 100)
                : 0,
            child: ListView(
              children: widget.order.products
                  .map(
                    (prod) => Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            prod.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${prod.qty} x \$${prod.price}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          )
        ]),
      ),
    );
  }
}
