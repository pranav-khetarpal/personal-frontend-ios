import 'package:flutter/material.dart';
import 'package:personal_frontend/components/my_rouded_textfield.dart';
import 'package:personal_frontend/models/stock_model.dart';
import 'package:personal_frontend/pages/stock_detail_page.dart';
import 'package:personal_frontend/services/stock_services.dart';

// class needed to ensure bottom navigation bar is present in sub pages
class SearchStocks extends StatelessWidget {
  const SearchStocks({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => const SearchStocksHome());
      },
    );
  }
}

class SearchStocksHome extends StatefulWidget {
  const SearchStocksHome({super.key});

  @override
  State<SearchStocksHome> createState() => _SearchStockHomeState();
}

class _SearchStockHomeState extends State<SearchStocksHome> {
  // List to hold the search results
  List<StockModel> searchResults = [];

  // Controller for the search text field
  final TextEditingController searchController = TextEditingController();

  // Object to use StockServices methods
  final StockServices stockServices = StockServices();

  // Method to search for stocks by ticker
  Future<void> SearchStocksHome(String query) async {
    try {
      final results = await stockServices.searchStocks(query);
      setState(() {
        searchResults = results;
      });
    } catch (e) {
      // Log the error and provide user feedback
      print('Error searching stocks: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching stocks: $e')),
      );
    }
  }

  // Method to navigate to the stock detail page
  void navigateToStockDetail(BuildContext context, String symbol) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StockDetailPage(symbol: symbol), // Pass the stock symbol to the detail page
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Stocks'), // Title of the search page
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Row to hold the search text field and search button
            Row(
              children: [
                // Use the MyTextField component
                Expanded(
                  child: MyRoundedTextField(
                    hintText: 'Search by ticker',
                    controller: searchController,
                    maxLength: 15,
                    allowSpaces: false,
                  ),
                ),
                const SizedBox(width: 8), // Add some space between the text field and button
                // Search button
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    SearchStocksHome(searchController.text); // Call the search method when the button is pressed
                  },
                ),
              ],
            ),
            const SizedBox(height: 16), // Add some space between the input row and the search results
            // Display search results
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  StockModel stock = searchResults[index];
                  return ListTile(
                    title: Text(stock.name),
                    subtitle: Text(stock.symbol),
                    trailing: Text('\$${stock.price.toStringAsFixed(2)}'),
                    onTap: () => navigateToStockDetail(context, stock.symbol), // Navigate to the stock detail page on tap
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
