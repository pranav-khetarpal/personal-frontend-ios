// import 'package:flutter/material.dart';
// import 'package:personal_frontend/components/my_rounded_textfield.dart';
// import 'package:personal_frontend/components/my_stock_tile.dart';
// import 'package:personal_frontend/helper/helper_functions.dart';
// import 'package:personal_frontend/models/stock_model.dart';
// import 'package:personal_frontend/models/user_model.dart';
// import 'package:personal_frontend/services/stock_services.dart';

// class EditStockListPage extends StatefulWidget {
//   final String listName;
//   final Map<String, List<String>> stockLists;
//   final UserModel? currentUser;

//   const EditStockListPage({
//     super.key,
//     required this.listName,
//     required this.stockLists,
//     required this.currentUser,
//   });

//   @override
//   State<EditStockListPage> createState() => _EditStockListPageState();
// }

// class _EditStockListPageState extends State<EditStockListPage> {
//   // Local copy of stocks for editing
//   List<String> localStocks = []; // Local copy of stocks for editing

//   // List to hold the search results
//   List<StockModel> searchResults = [];

//   // Text controllers
//   TextEditingController searchController = TextEditingController();
//   TextEditingController stockListNameController = TextEditingController();

//   // Object for using stockServices methods
//   StockServices stockServices = StockServices();

//   @override
//   void initState() {
//     super.initState();
//     // Initialize local stocks with the current stock list
//     localStocks.addAll(widget.stockLists[widget.listName] ?? []);

//     // make sure the text controller for the stock list name is full
//     stockListNameController.text = widget.listName;
//   }

//   // Method to search for stocks by ticker
//   Future<void> searchStocksByTicker(String query) async {
//     try {
//       final results = await stockServices.searchStocks(query);
//       setState(() {
//         searchResults = results;
//       });
//     } catch (e) {
//       // Log the error and provide user feedback
//       print('Error searching stocks: $e');
//       displayMessageToUser('Error searching stocks: $e', context);
//     }
//   }

//   // Method to add a stock to localStocks
//   void addToLocalStocks(StockModel stock) {
//     setState(() {
//       // Check if the stock symbol is already in localStocks
//       if (!localStocks.contains(stock.symbol)) {
//         localStocks.add(stock.symbol); // Add the stock symbol to localStocks
//       } else {
//         // Optionally, you can provide feedback that the stock is already in the list
//         displayMessageToUser('${stock.symbol} is already in the list', context);
//       }
//     });
//   }

//   // Method to update the user's stock list
//   void updateStockList() async {
//     // Check if the stock list name is not empty
//     if (stockListNameController.text.isEmpty) {
//       displayMessageToUser('Stock list name cannot be empty', context);
//       return;
//     }

//     try {
//       // Call StockServices method to update stock list
//       await stockServices.updateStockList(
//         widget.listName, // the previous name of the list
//         stockListNameController.text.trim(), // Trimmed stock list name
//         localStocks, // List of stock tickers
//       );

//       // Provide user feedback
//       displayMessageToUser('Stock list updated successfully', context);

//       // Optionally, you can navigate back after updating
//       Navigator.of(context).pop();
//     } catch (e) {
//       // Log error and provide feedback to user
//       print('Error updating stock list: $e');
//       displayMessageToUser('Error updating stock list: $e', context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           IconButton(
//             onPressed: () {
//               // Handle done button pressed (to be implemented)
//               // This is where you'll send updates to backend
//               updateStockList();
//             },
//             icon: const Icon(Icons.done),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               TextField(
//                 controller: stockListNameController,
//                 style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                 decoration: const InputDecoration(
//                   hintText: 'List Name',
//                 ),
//               ),

//               const SizedBox(height: 16),

//               // Row to hold the search text field and search button
//               Row(
//                 children: [
//                   Expanded(
//                     child: MyRoundedTextField(
//                       hintText: 'Search stocks to add',
//                       controller: searchController,
//                       maxLength: 15,
//                       allowSpaces: false,
//                     ),
//                   ),
//                   const SizedBox(width: 8),

//                   // Search button
//                   IconButton(
//                     icon: const Icon(Icons.search),
//                     onPressed: () {
//                       if (searchController.text.isNotEmpty) {
//                         searchStocksByTicker(searchController.text);
//                       }
//                     },
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 16),

//               // Display search results
//               if (searchResults.isNotEmpty)
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: searchResults.length,
//                   itemBuilder: (context, index) {
//                     StockModel stock = searchResults[index];
//                     return StockTile(
//                       stock: stock,
//                       onTap: () => addToLocalStocks(stock), // Add stock to localStocks on tap
//                     );
//                   },
//                 ),

//               const SizedBox(height: 16),

//               // ReorderableListView to display and reorder localStocks
//               ReorderableListView(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 children: localStocks.map((stockSymbol) {
//                   return ListTile(
//                     key: Key(stockSymbol),
//                     title: Text(stockSymbol),
//                     leading: IconButton(
//                       icon: const Icon(Icons.close, color: Colors.red),
//                       onPressed: () {
//                         setState(() {
//                           localStocks.remove(stockSymbol);
//                         });
//                       },
//                     ),
//                   );
//                 }).toList(),
//                 onReorder: (oldIndex, newIndex) {
//                   setState(() {
//                     if (newIndex > oldIndex) {
//                       newIndex -= 1;
//                     }
//                     final String item = localStocks.removeAt(oldIndex);
//                     localStocks.insert(newIndex, item);
//                   });
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:async'; // Import the async library

import 'package:flutter/material.dart';
import 'package:personal_frontend/components/my_stock_tile.dart';
import 'package:personal_frontend/helper/helper_functions.dart';
import 'package:personal_frontend/models/stock_model.dart';
import 'package:personal_frontend/models/user_model.dart';
import 'package:personal_frontend/services/stock_services.dart';

class EditStockListPage extends StatefulWidget {
  final String listName;
  final Map<String, List<String>> stockLists;
  final UserModel? currentUser;

  const EditStockListPage({
    super.key,
    required this.listName,
    required this.stockLists,
    required this.currentUser,
  });

  @override
  State<EditStockListPage> createState() => _EditStockListPageState();
}

class _EditStockListPageState extends State<EditStockListPage> {
  // Local copy of stocks for editing
  List<String> localStocks = []; // Local copy of stocks for editing

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
    // Initialize local stocks with the current stock list
    localStocks.addAll(widget.stockLists[widget.listName] ?? []);

    // make sure the text controller for the stock list name is full
    stockListNameController.text = widget.listName;
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

  // Method to update the user's stock list
  void updateStockList() async {
    // Check if the stock list name is not empty
    if (stockListNameController.text.isEmpty) {
      displayMessageToUser('Stock list name cannot be empty', context);
      return;
    }

    try {
      // Call StockServices method to update stock list
      await stockServices.updateStockList(
        widget.listName, // the previous name of the list
        stockListNameController.text.trim(), // Trimmed stock list name
        localStocks, // List of stock tickers
      );

      // Provide user feedback
      displayMessageToUser('Stock list updated successfully', context);

      // Optionally, you can navigate back after updating
      Navigator.of(context).pop();
    } catch (e) {
      // Log error and provide feedback to user
      print('Error updating stock list: $e');
      displayMessageToUser('Error updating stock list: $e', context);
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
              updateStockList();
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
