import 'package:flutter/material.dart';
import 'package:personal_frontend/models/stock_model.dart';

class StockTile extends StatelessWidget {
  final StockModel stock;
  final VoidCallback onTap;

  const StockTile({super.key, required this.stock, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.tertiary,
      
      // Stock Name
      title: Text(
        stock.name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(
        stock.symbol,
        // style: TextStyle(),
      ),

      trailing: Text(
        '\$${stock.price.toStringAsFixed(2)}',
        style: const TextStyle(
          fontSize: 20,
        ),
      ),


    );
  }
}
