// import 'package:flutter/material.dart';
// import 'package:personal_frontend/components/my_rounded_textfield.dart';
// import 'package:personal_frontend/components/my_small_button.dart';
// import 'package:personal_frontend/components/my_stock_tile.dart';
// import 'package:personal_frontend/helper/helper_functions.dart';
// import 'package:personal_frontend/models/stock_model.dart';
// import 'package:personal_frontend/stock_pages/create_stock_list_page.dart';
// import 'package:personal_frontend/stock_pages/edit_stock_list_page.dart';
// import 'package:personal_frontend/stock_pages/stock_detail_page.dart';
// import 'package:personal_frontend/services/user_interation_services.dart';
// import 'package:personal_frontend/services/stock_services.dart';
// import 'package:personal_frontend/models/user_model.dart';

// class SearchStocks extends StatelessWidget {
//   const SearchStocks({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const SearchStocksHome();
//   }
// }

// class SearchStocksHome extends StatefulWidget {
//   const SearchStocksHome({super.key});

//   @override
//   State<SearchStocksHome> createState() => _SearchStocksHomeState();
// }

// class _SearchStocksHomeState extends State<SearchStocksHome> {
//   // List to hold the search results
//   List<StockModel> searchResults = [];

//   // Controller for the search text field
//   final TextEditingController searchController = TextEditingController();

//   // the user model of the current user
//   UserModel? currentUser;

//   // Objects to use UserInteractionServices and StockServices methods
//   final StockServices stockServices = StockServices();
//   final UserInteractionServices userInteractionServices = UserInteractionServices();

//   // Index prices
//   Map<String, double> indexPrices = {
//     'SPY': 0.0,
//     'QQQ': 0.0,
//     'DIA': 0.0,
//     'IWM': 0.0,
//   };

//   // User's stock lists and their prices
//   Map<String, List<String>> stockLists = {};
//   Map<String, Map<String, double>> stockListPrices = {};

//   // Tracks which stock list is expanded
//   Map<String, bool> expandedStockLists = {};

//   @override
//   void initState() {
//     super.initState();
//     // Fetch index prices and user stock lists when the widget initializes
//     fetchIndexPrices();
//     fetchUserStockLists();
//   }

//   // Method to fetch index prices
//   Future<void> fetchIndexPrices() async {
//     try {
//       // Fetch the prices of the indexes
//       Map<String, double> prices = await stockServices.fetchStockPrices(['SPY', 'QQQ', 'DIA', 'IWM']);
//       setState(() {
//         indexPrices = prices;
//       });
//     } catch (e) {
//       // Log the error and provide user feedback
//       print('Error fetching index prices: $e');
//       displayMessageToUser('Error fetching index prices: $e', context);
//     }
//   }

//   // Method to fetch user's stock lists
//   Future<void> fetchUserStockLists() async {
//     try {
//       // Fetch user data including stockLists
//       UserModel user = await userInteractionServices.fetchCurrentUser();

//       setState(() {
//         currentUser = user;
//         stockLists = currentUser!.stockLists!;
//         if (stockLists.isNotEmpty) {
//           stockLists.keys.forEach((listName) {
//             expandedStockLists[listName] = false;
//             fetchStockPricesForList(listName, stockLists[listName]!);
//           });
//         }
//       });
//     } catch (e) {
//       // Log the error and provide user feedback
//       print('Error fetching user stock lists: $e');
//       displayMessageToUser('Error fetching user stock lists: $e', context);
//     }
//   }

//   // Method to fetch stock prices for the selected stock list
//   Future<void> fetchStockPricesForList(String listName, List<String> tickers) async {
//     try {
//       Map<String, double> prices = await stockServices.fetchStockPrices(tickers);
//       setState(() {
//         stockListPrices[listName] = prices;
//       });
//     } catch (e) {
//       // Log the error and provide user feedback
//       print('Error fetching stock prices: $e');
//       displayMessageToUser('Error fetching stock prices: $e', context);
//     }
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

//   // Method to navigate to the stock detail page
//   void navigateToStockDetail(BuildContext context, String symbol) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => StockDetailPage(symbol: symbol), // Pass the stock symbol to the detail page
//       ),
//     );
//   }

//   // Toggle the expansion of the stock list
//   void toggleStockListExpansion(String listName) {
//     setState(() {
//       expandedStockLists[listName] = !expandedStockLists[listName]!;
//     });
//   }

//   // Method to show the options for the user to edit or delete the stocks in their list
//   void showEditDeleteDialog(BuildContext context, String listName) {
//     showDialog(
//       context: context, 
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // edit button
//               MySmallButton(
//                 text: 'Edit List', 
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   Navigator.of(context).push(
//                     MaterialPageRoute(builder: (context) => EditStockListPage(
//                       listName: listName, 
//                       stockLists: stockLists,
//                       currentUser: currentUser,
//                     )),
//                   );
//                 },
//               ),

//               // delete button
//               MySmallButton(
//                 text: 'Delete List', 
//                 onTap: () {
//                   Navigator.of(context).pop(); // Close the current dialog
//                   showDeleteConfirmationDialog(context, listName); // Show confirmation dialog
//                 },
//               ),
//             ],
//           ),
//         );
//       }
//     );
//   }

//   // Confirm that the user would like to delete their list, and delete it if so
//   void showDeleteConfirmationDialog(BuildContext context, String listName) {
//     showDialog(
//       context: context, 
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Confirm Delete'),
//           content: const Text('Are you sure you want to delete this stock list?'),
//           actions: [
//             // cancel button
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the confirmation dialog
//               },
//               child: const Text('Cancel'),
//             ),

//             // delete button
//             TextButton(
//               onPressed: () async {
//                 Navigator.of(context).pop(); // Close the confirmation dialog
//                 await handleDeleteList(context, listName); // Handle the post deletion
//               },
//               child: const Text('Delete', style: TextStyle(color: Colors.red),),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Method to delete a given stock list
//   Future<void> handleDeleteList(BuildContext context, String listName) async {
//     try {
//       // Delete the stock list
//       await stockServices.deleteStockList(listName);

//       // Fetch the updated stock lists
//       await fetchUserStockLists();
//     } catch (e) {
//       // Log the error and provide user feedback
//       print('Error deleting stock list: $e');
//       displayMessageToUser('Error deleting stock list: $e', context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Search Stocks'), // Title of the search page
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(25.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // Index Prices Row
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: indexPrices.keys.map((ticker) {
//                   return GestureDetector(
//                     onTap: () => navigateToStockDetail(context, ticker),
//                     child: Column(
//                       children: [
//                         Text(
//                           ticker,
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           '\$${indexPrices[ticker]?.toStringAsFixed(2) ?? '--'}',
//                         ),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//               ),
//               const SizedBox(height: 16), // Add some space between the index prices and search input

//               // Row to hold the search text field and search button
//               Row(
//                 children: [
//                   // Use the MyTextField component
//                   Expanded(
//                     child: MyRoundedTextField(
//                       hintText: 'Search by ticker',
//                       controller: searchController,
//                       maxLength: 15,
//                       allowSpaces: false,
//                     ),
//                   ),
//                   const SizedBox(width: 8), // Add some space between the text field and button

//                   // Search button
//                   IconButton(
//                     icon: const Icon(Icons.search),
//                     onPressed: () {
//                       if (searchController.text.isNotEmpty) {
//                         searchStocksByTicker(searchController.text); // Call the search method when the button is pressed
//                       }
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16), // Add some space between the input row and the search results

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
//                       onTap: () => navigateToStockDetail(context, stock.symbol),
//                     );
//                   },
//                 ),

//               const SizedBox(height: 16), // Add space before the stock lists

//               // Display the user's stock lists
//               ListView(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 children: stockLists.keys.map((listName) {
//                   return ExpansionTile(
//                     title: Row(
//                       children: [
//                         // button to edit and delete the list
//                         IconButton(
//                           icon: const Icon(Icons.more_vert), // You can use any icon
//                           onPressed: () {
//                             // allow the user to edit or delete their given list
//                             showEditDeleteDialog(context, listName);
//                           },
//                         ),

//                         // stock list name
//                         Text(
//                           listName,
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     initiallyExpanded: expandedStockLists[listName]!,
//                     onExpansionChanged: (_) => toggleStockListExpansion(listName),
//                     children: stockLists[listName]!.map((ticker) {
//                       double? price = stockListPrices[listName]?[ticker];
//                       return StockTile(
//                         stock: StockModel(name: ticker, symbol: "", price: price ?? 0.0),
//                         onTap: () => navigateToStockDetail(context, ticker),
//                       );
//                     }).toList(),
//                   );
//                 }).toList(),
//               ),

//               const SizedBox(height: 16),

//               // Button to allow the user to create a new list
//               GestureDetector(
//                 onTap: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(builder: (context) => CreateStockListPage(
//                       stockLists: stockLists,
//                       currentUser: currentUser,
//                     )),
//                   );
//                 },
//                 child: Container(
//                   height: 60,
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade200,
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
//                   child: Center(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(Icons.add_box_sharp, size: 40,),

//                         const SizedBox(width: 10,),

//                         // Add a new stock list text
//                         Text(
//                           "Create a new list",
//                           style: TextStyle(
//                             fontSize: 20,
//                             color: Theme.of(context).colorScheme.secondary,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 16),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:personal_frontend/components/my_small_button.dart';
import 'package:personal_frontend/components/my_stock_tile.dart';
import 'package:personal_frontend/helper/helper_functions.dart';
import 'package:personal_frontend/models/stock_model.dart';
import 'package:personal_frontend/stock_pages/create_stock_list_page.dart';
import 'package:personal_frontend/stock_pages/edit_stock_list_page.dart';
import 'package:personal_frontend/stock_pages/stock_detail_page.dart';
import 'package:personal_frontend/services/user_interation_services.dart';
import 'package:personal_frontend/services/stock_services.dart';
import 'package:personal_frontend/models/user_model.dart';

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

  // Timer for debouncing
  Timer? _debounce;

  // the user model of the current user
  UserModel? currentUser;

  // Objects to use UserInteractionServices and StockServices methods
  final StockServices stockServices = StockServices();
  final UserInteractionServices userInteractionServices = UserInteractionServices();

  // Index prices
  Map<String, double> indexPrices = {
    'SPY': 0.0,
    'QQQ': 0.0,
    'DIA': 0.0,
    'IWM': 0.0,
  };

  // User's stock lists and their prices
  Map<String, List<String>> stockLists = {};
  Map<String, Map<String, double>> stockListPrices = {};

  // Tracks which stock list is expanded
  Map<String, bool> expandedStockLists = {};

  @override
  void initState() {
    super.initState();
    // Fetch index prices and user stock lists when the widget initializes
    fetchIndexPrices();
    fetchUserStockLists();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  // Method to fetch index prices
  Future<void> fetchIndexPrices() async {
    try {
      // Fetch the prices of the indexes
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

  // Method to fetch user's stock lists
  Future<void> fetchUserStockLists() async {
    try {
      // Fetch user data including stockLists
      UserModel user = await userInteractionServices.fetchCurrentUser();

      setState(() {
        currentUser = user;
        stockLists = currentUser!.stockLists!;
        if (stockLists.isNotEmpty) {
          stockLists.keys.forEach((listName) {
            expandedStockLists[listName] = false;
            fetchStockPricesForList(listName, stockLists[listName]!);
          });
        }
      });
    } catch (e) {
      // Log the error and provide user feedback
      print('Error fetching user stock lists: $e');
      displayMessageToUser('Error fetching user stock lists: $e', context);
    }
  }

  // Method to fetch stock prices for the selected stock list
  Future<void> fetchStockPricesForList(String listName, List<String> tickers) async {
    try {
      Map<String, double> prices = await stockServices.fetchStockPrices(tickers);
      setState(() {
        stockListPrices[listName] = prices;
      });
    } catch (e) {
      // Log the error and provide user feedback
      print('Error fetching stock prices: $e');
      displayMessageToUser('Error fetching stock prices: $e', context);
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

  // Method to navigate to the stock detail page
  void navigateToStockDetail(BuildContext context, String symbol) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StockDetailPage(symbol: symbol), // Pass the stock symbol to the detail page
      ),
    );
  }

  // Toggle the expansion of the stock list
  void toggleStockListExpansion(String listName) {
    setState(() {
      expandedStockLists[listName] = !expandedStockLists[listName]!;
    });
  }

  // Method to show the options for the user to edit or delete the stocks in their list
  void showEditDeleteDialog(BuildContext context, String listName) {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // edit button
              MySmallButton(
                text: 'Edit List', 
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EditStockListPage(
                      listName: listName, 
                      stockLists: stockLists,
                      currentUser: currentUser,
                    )),
                  );
                },
              ),

              // delete button
              MySmallButton(
                text: 'Delete List', 
                onTap: () {
                  Navigator.of(context).pop(); // Close the current dialog
                  showDeleteConfirmationDialog(context, listName); // Show confirmation dialog
                },
              ),
            ],
          ),
        );
      }
    );
  }

  // Confirm that the user would like to delete their list, and delete it if so
  void showDeleteConfirmationDialog(BuildContext context, String listName) {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this stock list?'),
          actions: [
            // cancel button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the confirmation dialog
              },
              child: const Text('Cancel'),
            ),

            // delete button
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the confirmation dialog
                await handleDeleteList(context, listName); // Handle the post deletion
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red),),
            ),
          ],
        );
      },
    );
  }

  // Method to delete a given stock list
  Future<void> handleDeleteList(BuildContext context, String listName) async {
    try {
      // Delete the stock list
      await stockServices.deleteStockList(listName);

      // Fetch the updated stock lists
      await fetchUserStockLists();
    } catch (e) {
      // Log the error and provide user feedback
      print('Error deleting stock list: $e');
      displayMessageToUser('Error deleting stock list: $e', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Stocks'), // Title of the search page
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Index Prices Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: indexPrices.keys.map((ticker) {
                  return GestureDetector(
                    onTap: () => navigateToStockDetail(context, ticker),
                    child: Column(
                      children: [
                        Text(
                          ticker,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          indexPrices[ticker]?.toStringAsFixed(2) ?? '-',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // Search input field
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search for a stock...',
                      ),
                      onChanged: onSearchChanged, // Call the onSearchChanged method when the text changes
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16), // Add some space between the input row and the search results

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
                      onTap: () => navigateToStockDetail(context, stock.symbol),
                    );
                  },
                ),

              const SizedBox(height: 16), // Add space before the stock lists

              // Display the user's stock lists
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: stockLists.keys.map((listName) {
                  return ExpansionTile(
                    title: Row(
                      children: [
                        // button to edit and delete the list
                        IconButton(
                          icon: const Icon(Icons.more_vert), // You can use any icon
                          onPressed: () {
                            // allow the user to edit or delete their given list
                            showEditDeleteDialog(context, listName);
                          },
                        ),

                        // stock list name
                        Text(
                          listName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    initiallyExpanded: expandedStockLists[listName]!,
                    onExpansionChanged: (_) => toggleStockListExpansion(listName),
                    children: stockLists[listName]!.map((ticker) {
                      double? price = stockListPrices[listName]?[ticker];
                      return StockTile(
                        stock: StockModel(name: ticker, symbol: "", price: price ?? 0.0),
                        onTap: () => navigateToStockDetail(context, ticker),
                      );
                    }).toList(),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // Button to allow the user to create a new list
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CreateStockListPage(
                      stockLists: stockLists,
                      currentUser: currentUser,
                    )),
                  );
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_box_sharp, size: 40,),

                        const SizedBox(width: 10,),

                        // Add a new stock list text
                        Text(
                          "Create a new list",
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
