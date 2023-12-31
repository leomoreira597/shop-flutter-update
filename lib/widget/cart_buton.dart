import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/cart.dart';

import '../models/orde_list.dart';

class CartButton extends StatefulWidget {
  final Cart cart;

  const CartButton({required this.cart, Key? key}) : super(key: key);

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const CircularProgressIndicator()
        : TextButton(
            onPressed: widget.cart.itemsCount == 0
                ? null
                : () async {
                    setState(() {
                      _isLoading = true;
                    });
                    await Provider.of<OrderList>(context, listen: false)
                        .addOrder(widget.cart);
                    widget.cart.clear();
                    setState(() {
                      _isLoading = false;
                    });
                  },
            style: TextButton.styleFrom(
              textStyle: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            child: const Text("COMPRAR"),
          );
  }
}
