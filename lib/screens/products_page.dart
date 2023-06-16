import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/constants/app_routes.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/widget/app_drawer.dart';
import 'package:shop/widget/product_item.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({Key? key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) {
    return Provider.of<ProductList>(context, listen: false).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final ProductList products = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Gerenciar Produtos",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.productsForm);
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
              itemCount: products.itemsCount,
              itemBuilder: (ctx, index) {
                return Column(
                  children: [
                    ProductItem(
                      product: products.items[index],
                    ),
                    const Divider(),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
