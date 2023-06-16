import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/product.dart';
import '../../../models/product_list.dart';
import '../../../widget/product_grid_item.dart';

class GridProducts extends StatelessWidget {
  final bool showFavoriteOnly;

  const GridProducts({Key? key, required this.showFavoriteOnly})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
    List<Product> loadedProducts =
        showFavoriteOnly ? provider.favoriteItems : provider.items;
    return provider.items.isEmpty
        ? const Center(
            child: Text(
              "Cadastre Novos Produtos para sua loja",
            ),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: loadedProducts.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (ctx, index) {
              return ChangeNotifierProvider.value(
                value: loadedProducts[index],
                child: const ProductGridItem(),
              );
            },
          );
  }
}
