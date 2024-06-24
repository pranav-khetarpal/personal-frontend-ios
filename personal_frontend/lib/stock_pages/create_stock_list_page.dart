import 'dart:async';
import 'package:flutter/material.dart';
import 'package:personal_frontend/components/my_stock_tile.dart';
import 'package:personal_frontend/helper/helper_functions.dart';
import 'package:personal_frontend/models/stock_model.dart';
import 'package:personal_frontend/models/user_model.dart';
import 'package:personal_frontend/services/stock_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateStockListPage extends StatefulWidget {
  final Map<String, List<String>> stockLists;
  final UserModel? currentUser;

  const CreateStockListPage({
    super.key,
    required this.stockLists,
    required this.currentUser,
  });

  @override
  State<CreateStockListPage> createState() => _CreateStockListPageState();
}

class _CreateStockListPageState extends State<CreateStockListPage> {
  // Local copy of stocks for editing
  List<String> localStocks = [];

  // List to hold the search results
  List<StockModel> searchResults = [];

  // Text controllers
  TextEditingController searchController = TextEditingController();
  TextEditingController stockListNameController = TextEditingController();

  // Timer for debouncing
  Timer? _debounce;

  // Object for using stockServices methods
  StockServices stockServices = StockServices();

    @override
  void initState() {
    super.initState();
    showIntroMessage(); // Show intro message if it's the first time
  }

  // Method to show initial introductory messages to the user
  Future<void> showIntroMessage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTimeCreatingStockList') ?? true;

    if (isFirstTime) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Create a Stock Sist"),
          content: const Text("You can create a stock list by first giving it a name, and then searching for stocks to add to the list. "
            "To remove a stock from the list, simply press the red X. You can also change the order of the stocks shown by dragging and dropping stocks."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Got it!"),
            ),
          ],
        ),
      );

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Save Changes"),
          content: const Text("Press the check mark at the top right to save your new stock list."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Got it!"),
            ),
          ],
        ),
      );

      // Set the flag to false so the intro message won't be shown again
      await prefs.setBool('isFirstTimeCreatingStockList', false);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
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

  // Method to handle the search input changes with debounce
  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        searchStocksByTicker(query);
      } else {
        setState(() {
          searchResults.clear();
        });
      }
    });
  }

  // Method to add a stock to localStocks
  void addToLocalStocks(StockModel stock) {
    setState(() {
      // Check if the stock symbol is already in localStocks
      if (!localStocks.contains(stock.symbol)) {
        localStocks.add(stock.symbol); // Add the stock symbol to localStocks
      } else {
        // Optionally, you can provide feedback that the stock is already in the list
        displayMessageToUser('${stock.symbol} is already in the list', context);
      }
    });
  }

  // Method to create a new stock list
  void createStockList() async {
    // Check if the stock list name is not empty
    if (stockListNameController.text.isEmpty) {
      displayMessageToUser('Stock list name cannot be empty', context);
      return;
    }

    // Check if the list name is unique
    if (widget.stockLists.containsKey(stockListNameController.text.trim())) {
      displayMessageToUser('A list with this name already exists', context);
      return;
    }

    try {
      // Call StockServices method to create a new stock list
      await stockServices.createStockList(
        stockListNameController.text.trim(), // Trimmed stock list name
        localStocks, // List of stock tickers
      );

      // Provide user feedback
      displayMessageToUser('Stock list created successfully', context);

      // Optionally, you can navigate back after creating
      Navigator.of(context).pop();
    } catch (e) {
      // Log error and provide feedback to user
      print('Error creating stock list: $e');
      displayMessageToUser('Error creating stock list: $e', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              // Handle done button pressed (to be implemented)
              // This is where you'll send updates to backend
              createStockList();
            },
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: stockListNameController,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                decoration: const InputDecoration(
                  hintText: 'List Name',
                ),
              ),

              const SizedBox(height: 16),

              // Row to hold the search text field and search button
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Search for a stock...',
                      ),
                      onChanged: onSearchChanged, // Call the onSearchChanged method when the text changes
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),

              const SizedBox(height: 16),

              // Display search results
              if (searchResults.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    StockModel stock = searchResults[index];
                    return StockTile(
                      stock: stock,
                      onTap: () => addToLocalStocks(stock), // Add stock to localStocks on tap
                    );
                  },
                ),

              const SizedBox(height: 16),

              // ReorderableListView to display and reorder localStocks
              ReorderableListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: localStocks.map((stockSymbol) {
                  return ListTile(
                    key: Key(stockSymbol),
                    title: Text(stockSymbol),
                    leading: IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          localStocks.remove(stockSymbol);
                        });
                      },
                    ),
                  );
                }).toList(),
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final String item = localStocks.removeAt(oldIndex);
                    localStocks.insert(newIndex, item);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
