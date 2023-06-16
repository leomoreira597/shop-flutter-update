import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/constants/app_routes.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/orde_list.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/screens/cart_page.dart';
import 'package:shop/screens/orders_page.dart';
import 'package:shop/screens/product_details.dart';
import 'package:shop/screens/product_form_page.dart';
import 'package:shop/screens/products_page.dart';
import 'package:shop/screens/products_overview_pages/products_overview_pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductList(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderList(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            secondary: Colors.deepOrange,
          ),
          fontFamily: "Lato",
          useMaterial3: true,
        ),
        routes: {
          AppRoutes.home: (ctx) => const ProductsOverviewPage(),
          AppRoutes.productsDetail: (ctx) => const ProductDetailPage(),
          AppRoutes.cartPage: (ctx) => const CartPage(),
          AppRoutes.orders: (ctx) => const OrdersPage(),
          AppRoutes.products: (ctx) => const ProductsPage(),
          AppRoutes.productsForm: (ctx) => const ProductsFormPage(),
        },
      ),
    );
  }
}
