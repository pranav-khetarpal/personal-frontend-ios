import 'package:http/http.dart' as http;
import 'package:personal_frontend/ip_address_and_routes.dart';
import 'dart:convert';
import 'dart:async';
import 'package:personal_frontend/models/stock_model.dart';
import 'package:personal_frontend/services/authorization_services.dart';

class StockServices {
  // object to use AuthServices methods
  final AuthServices authServices = AuthServices();

  // Method to search for stocks
  Future<List<StockModel>> searchStocks(String query) async {
    try {
      // Get the full route for the search ticker including IP address and query prefix
      String baseUrl = IPAddressAndRoutes.getRoute('searchTicker');
      // Construct the full URL by appending the query
      String url = '$baseUrl$query';

      final response = await http.get(
        Uri.parse(url),
      ); // Add a timeout

      if (response.statusCode == 200) {
        // If a successful response is given, decode the returned value to a list of stocks
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => StockModel.fromJson(json)).toList();
      } else {
        // Log the response for debugging purposes
        print('Failed to load stocks: ${response.statusCode} ${response.body}');
        throw Exception('Failed to load stocks: ${response.statusCode}');
      }
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  // Method designed to fetch stock information for a given ticker
  Future<Map<String, dynamic>> fetchStockInfo(String ticker) async {
    try {
      // Construct the full URL by appending the ticker to the end of the route
      String baseUrl = IPAddressAndRoutes.getRoute('stockInfo');
      String url = '$baseUrl$ticker';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Attempt to decode the response body
        try {
          return jsonDecode(response.body);
        } catch (e) {
          throw Exception('Failed to parse stock info');
        }
      } else {
        // Log the response for debugging purposes
        print('Failed to load stock info: ${response.statusCode} ${response.body}');
        throw Exception('Failed to load stock info: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle any other types of errors
      print('Unexpected error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  // Method to fetch the stock prices for a list of given tickers
  Future<Map<String, double>> fetchStockPrices(List<String> tickers) async {
    try {
      // Construct the URL with query parameters
      String baseUrl = IPAddressAndRoutes.getRoute('stockPrices');
      String tickersParam = tickers.map((ticker) => 'tickers=$ticker').join('&');
      String url = '$baseUrl$tickersParam';

      // Make a GET request
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Parse and return the response body
        return Map<String, double>.from(jsonDecode(response.body));
      } else {
        // Handle error response
        throw Exception('Failed to fetch stock prices: ${response.statusCode}');
      }
    } catch (e) {
      // Handle other errors
      throw Exception('Failed to fetch stock prices: $e');
    }
  }



  // Method to delete a stock list
  Future<void> deleteStockList(String listName) async {
    try {
      String token = await authServices.getIdToken();

      // build the url to delete the stock list
      String baseUrl = IPAddressAndRoutes.getRoute('deleteStockList');
      String url = '$baseUrl$listName';
      
      // send the HTTP DELETE request
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        }
      );
      
      if (response.statusCode != 204) {
        throw Exception('Failed to delete stock list: ${response.reasonPhrase}');
    }
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }




  // Method to update stock list in Firestore
  Future<void> updateStockList(
    String oldListName,
    String newListName,
    List<String> tickers,
  ) async {
    try {
      String token = await authServices.getIdToken();

      // Construct URL for API endpoint
      String baseUrl = IPAddressAndRoutes.getRoute('updateStockList');
      String url = '$baseUrl$oldListName';

      // Create JSON payload for the request body
      Map<String, dynamic> requestBody = {
        'name': newListName,
        'tickers': tickers,
      };

      // Send HTTP PUT request to update stock list
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update stock list: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }




  // Method to create a new stock list in Firestore
  Future<void> createStockList(String listName, List<String> tickers) async {
    try {
      String token = await authServices.getIdToken();

      // Construct URL for API endpoint
      String url = IPAddressAndRoutes.getRoute('createStockList');

      // Create JSON payload for the request body
      Map<String, dynamic> requestBody = {
        'name': listName,
        'tickers': tickers,
      };

      // Send HTTP POST request to create stock list
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to create stock list: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }




}
