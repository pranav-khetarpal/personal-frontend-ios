// frontend/lib/pages/stock_detail_page.dart
import 'package:flutter/material.dart';
import 'package:personal_frontend/services/stock_services.dart';

class StockDetailPage extends StatefulWidget {
  final String symbol;

  StockDetailPage({required this.symbol});

  @override
  _StockDetailPageState createState() => _StockDetailPageState();
}

class _StockDetailPageState extends State<StockDetailPage> {
  final StockServices stockServices = StockServices();
  Map<String, dynamic>? stockInfo;
  bool isLoading = true;
  bool showFullDescription = false;

  @override
  void initState() {
    super.initState();
    fetchStockInfo();
  }

  Future<void> fetchStockInfo() async {
    try {
      final info = await stockServices.fetchStockInfo(widget.symbol);
      setState(() {
        stockInfo = info;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load stock info: $e')),
      );
    }
  }

  String formatNumber(num? value) {
    if (value == null) return '--';
    return value.toStringAsFixed(2);
  }

  String formatLargeNumber(num? value) {
    if (value == null) return '--';
    if (value >= 1e12) {
      return '${(value / 1e12).toStringAsFixed(2)} T';
    } else if (value >= 1e9) {
      return '${(value / 1e9).toStringAsFixed(2)} B';
    } else if (value >= 1e6) {
      return '${(value / 1e6).toStringAsFixed(2)} M';
    } else {
      return value.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Details: ${widget.symbol}'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : stockInfo != null
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Price',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20,
                          )
                        ),
                        Text(
                          '\$${formatNumber(stockInfo!["current_price"])}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 30,
                          )
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildStockInfoItem('Open Price', formatNumber(stockInfo!["open_price"])),
                                  buildStockInfoItem('Today\'s High', formatNumber(stockInfo!["high"])),
                                  buildStockInfoItem('Today\'s Low', formatNumber(stockInfo!["low"])),
                                  buildStockInfoItem('Market Cap', formatLargeNumber(stockInfo!["market_cap"])),
                                  buildStockInfoItem('P/E Ratio', formatNumber(stockInfo!["pe_ratio"])),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildStockInfoItem('Volume', formatLargeNumber(stockInfo!["volume"])),
                                  buildStockInfoItem('Overnight Volume', formatLargeNumber(stockInfo!["overnight_volume"])),
                                  buildStockInfoItem('Average Volume', formatLargeNumber(stockInfo!["average_volume"])),
                                  buildStockInfoItem('52 Week High', formatNumber(stockInfo!["52_week_high"])),
                                  buildStockInfoItem('52 Week Low', formatNumber(stockInfo!["52_week_low"])),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          'About',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 30,
                          )
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          _getDescription(),
                          textAlign: TextAlign.justify,
                        ),
                        if (_isDescriptionTruncated())
                          TextButton(
                            onPressed: () {
                              setState(() {
                                showFullDescription = !showFullDescription;
                              });
                            },
                            child: Text(showFullDescription ? 'Show less' : 'Show more'),
                          ),
                      ],
                    ),
                  ),
                )
              : const Center(child: Text('No data available')),
    );
  }

  String _getDescription() {
    const int maxLength = 100; // Set a max length for the truncated description
    String description = stockInfo!["description"] ?? '--';
    if (description.length > maxLength && !showFullDescription) {
      return '${description.substring(0, maxLength)}...';
    } else {
      return description;
    }
  }

  bool _isDescriptionTruncated() {
    const int maxLength = 100;
    String description = stockInfo!["description"] ?? '--';
    return description.length > maxLength;
  }

  Widget buildStockInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 20,
            )
          ),
          Text(
            value,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 30,
            )
          ),
          const SizedBox(height: 5)
        ],
      ),
    );
  }
}
