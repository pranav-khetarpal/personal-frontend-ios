import 'package:flutter/material.dart';
import 'package:personal_frontend/components/my_rounded_textfield.dart';
import 'package:personal_frontend/helper/helper_functions.dart';
import 'package:personal_frontend/models/stock_model.dart';
import 'package:personal_frontend/pages/stock_detail_page.dart';
import 'package:personal_frontend/services/stock_services.dart';

// class needed to ensure bottom navigation bar is present in sub pages
class SearchStocks extends StatelessWidget {
  const SearchStocks({super.key});

  @override
  Widget build(BuildContext context) {
    return const SearchStocksHome();
  }
}

class SearchStocksHome extends StatefulWidget {
  const SearchStocksHome({super.key});

  @override
  State<SearchStocksHome> createState() => _SearchStocksHomeState();
}

class _SearchStocksHomeState extends State<SearchStocksHome> {
  // List to hold the search results
  List<StockModel> searchResults = [];

  // Controller for the search text field
  final TextEditingController searchController = TextEditingController();

  // Object to use StockServices methods
  final StockServices stockServices = StockServices();

  // Index prices
  Map<String, double> indexPrices = {
    'SPY': 0.0,
    'QQQ': 0.0,
    'DIA': 0.0,
    'IWM': 0.0,
  };

  @override
  void initState() {
    super.initState();
    // Fetch index prices when the widget initializes
    fetchIndexPrices();
  }

  // Method to fetch index prices
  Future<void> fetchIndexPrices() async {
    try {
      // Fetch the prices of the three indexes
      Map<String, double> prices = await stockServices.fetchStockPrices(['SPY', 'QQQ', 'DIA', 'IWM']);
      setState(() {
        indexPrices = prices;
      });
    } catch (e) {
      // Log the error and provide user feedback
      print('Error fetching index prices: $e');
      displayMessageToUser('Error fetching index prices: $e', context);
    }
  }

  // Method to search for stocks by ticker
  Future<void> searchStocksByTicker(String query) async {
    try {
      final results = await stockServices.searchStocks(query);
      setState(() {
        searchResults = results;
      });
    } catch (e) {
      // Log the error and provide user feedback
      print('Error searching stocks: $e');
      displayMessageToUser('Error searching stocks: $e', context);
    }
  }

  // Method to navigate to the stock detail page
  void navigateToStockDetail(BuildContext context, String symbol) {
    Navigator.of(context).push(
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
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Index Prices Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: indexPrices.keys.map((ticker) {
                return Column(
                  children: [
                    Text(
                      ticker,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${indexPrices[ticker]?.toStringAsFixed(2) ?? '--'}',
                    ),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 16), // Add some space between the index prices and search input
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
                    if (searchController.text.isNotEmpty) {
                      searchStocksByTicker(searchController.text); // Call the search method when the button is pressed
                    }
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
