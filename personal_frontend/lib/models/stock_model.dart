/*
This is the basic model of stock, needed for displaying characteristics about its current price
*/
class StockModel {
  final String symbol;
  final String name;
  final double price;

  StockModel({required this.symbol, required this.name, required this.price});

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      symbol: json['symbol'],
      name: json['name'],
      price: json['price'].toDouble(),
    );
  }
}
