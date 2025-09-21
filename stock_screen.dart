import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'portfolio_screen.dart';

class Stock {
  final int id;
  final String date;
  final String stockName;
  final String recommendedAction;
  final double price;
  final String source;
  final double predictedTarget;
  final double ltp;
  final double upside;

  Stock({
    required this.id,
    required this.date,
    required this.stockName,
    required this.recommendedAction,
    required this.price,
    required this.source,
    required this.predictedTarget,
    required this.ltp,
    required this.upside,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      id: json['id'],
      date: json['date'],
      stockName: json['stock_name'],
      recommendedAction: json['recommended_action'],
      price: double.parse(json['price'].toString()),
      source: json['source'],
      predictedTarget: double.parse(json['predicted_target'].toString()),
      ltp: double.parse(json['ltp'].toString()),
      upside: double.parse(json['upside'].toString()),
    );
  }
}

class StockService {
  static const String baseUrl = 'http://iunderstandit.in/api';
  
  static Future<List<Stock>> fetchStocks() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/stocks.php'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Stock.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load stocks');
      }
    } catch (e) {
      // For demo purposes, return mock data if API fails
      return [
        Stock(
          id: 1,
          date: '2024-09-17',
          stockName: 'Apple',
          recommendedAction: 'BUY',
          price: 234.72,
          source: 'Analyst Report',
          predictedTarget: 250.00,
          ltp: 234.72,
          upside: 6.52,
        ),
        Stock(
          id: 2,
          date: '2024-09-17',
          stockName: 'Google',
          recommendedAction: 'HOLD',
          price: 165.45,
          source: 'Market Research',
          predictedTarget: 175.00,
          ltp: 165.45,
          upside: 5.77,
        ),
        Stock(
          id: 3,
          date: '2024-09-15',
          stockName: 'Microsoft',
          recommendedAction: 'BUY',
          price: 412.30,
          source: 'Technical Analysis',
          predictedTarget: 450.00,
          ltp: 415.20,
          upside: 9.14,
        ),
        Stock(
          id: 4,
          date: '2024-09-14',
          stockName: 'Meta',
          recommendedAction: 'SELL',
          price: 298.50,
          source: 'Earnings Report',
          predictedTarget: 280.00,
          ltp: 295.80,
          upside: -6.22,
        ),
      ];
    }
  }
}

class StockScreen extends StatefulWidget {
  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  List<Stock> stocks = [];
  bool isLoading = true;
  String? error;
  Set<int> expandedRows = {};

  @override
  void initState() {
    super.initState();
    fetchStocksData();
  }

  Future<void> fetchStocksData() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final fetchedStocks = await StockService.fetchStocks();
      
      setState(() {
        stocks = fetchedStocks;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _refresh() async {
    try {
      final fetchedStocks = await StockService.fetchStocks();
      
      setState(() {
        stocks = fetchedStocks;
        error = null;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
  }

  Color getActionColor(String action) {
    switch (action.toUpperCase()) {
      case 'BUY':
        return Color(0xFF10B981); // green-500
      case 'SELL':
        return Color(0xFFEF4444); // red-500
      case 'HOLD':
        return Color(0xFFF59E0B); // amber-500
      default:
        return Colors.grey;
    }
  }

  Widget buildStockTable() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Color(0xFF3B82F6), // blue-500
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error loading data',
              style: TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: fetchStocksData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3B82F6), // blue-500
              ),
              child: Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    if (stocks.isEmpty) {
      return Center(
        child: Text(
          'No data yet',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFDBEAFE), // blue-100
                    Color(0xFFEFF6FF), // blue-50
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  _buildHeaderCell('Date', 90),
                  _buildHeaderCell('Stock', 110),
                  _buildHeaderCell('Action', 80),
                  _buildHeaderCell('Price', 80),
                  _buildHeaderCell('Source', 110),
                  _buildHeaderCell('Target', 80),
                  _buildHeaderCell('Status', 90),
                ],
              ),
            ),
            // Data Rows
            Container(
              height: 400,
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: stocks.asMap().entries.map((entry) {
                      int index = entry.key;
                      Stock stock = entry.value;
                      bool isExpanded = expandedRows.contains(stock.id);
                      
                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: index % 2 == 0 ? Colors.white : Color(0xFFF9FAFB), // gray-50
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(0xFFEFF6FF), // blue-50
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                _buildDataCell(stock.date, 90),
                                _buildDataCell(stock.stockName, 110),
                                _buildActionCell(stock.recommendedAction, 80),
                                _buildDataCell('₹${stock.price.toStringAsFixed(2)}', 80),
                                _buildDataCell(stock.source, 110),
                                _buildDataCell('₹${stock.predictedTarget.toStringAsFixed(2)}', 80),
                                _buildStatusCell(stock, 90),
                              ],
                            ),
                          ),
                          if (isExpanded)
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFEFF6FF), // blue-50
                                    Colors.white,
                                  ],
                                ),
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color(0xFFDBEAFE), // blue-100
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        '  LTP  ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Color(0xFF6B7280), // gray-500
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '₹${stock.ltp.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1F2937), // gray-800
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        '  Upside  ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Color(0xFF6B7280), // gray-500
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '${stock.upside > 0 ? '+' : ''}${stock.upside.toStringAsFixed(2)}%',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: stock.upside > 0 
                                              ? Color(0xFF10B981) // green-500
                                              : Color(0xFFEF4444), // red-500
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text, double width) {
    return Container(
      width: width,
      padding: EdgeInsets.all(12),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: Color(0xFF1F2937), // gray-800
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDataCell(String text, double width) {
    return Container(
      width: width,
      padding: EdgeInsets.all(12),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: Color(0xFF374151), // gray-700
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildActionCell(String action, double width) {
    return Container(
      width: width,
      padding: EdgeInsets.all(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: getActionColor(action).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: getActionColor(action)),
        ),
        child: Text(
          action,
          style: TextStyle(
            fontSize: 10,
            color: getActionColor(action),
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildStatusCell(Stock stock, double width) {
    return Container(
      width: width,
      padding: EdgeInsets.all(12),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (expandedRows.contains(stock.id)) {
              expandedRows.remove(stock.id);
            } else {
              expandedRows.add(stock.id);
            }
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFDBEAFE), // blue-100
                Color(0xFFC7D2FE), // blue-200
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFF3B82F6)), // blue-500
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Details',
                style: TextStyle(
                  fontSize: 9,
                  color: Color(0xFF1D4ED8), // blue-700
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                expandedRows.contains(stock.id) 
                    ? Icons.keyboard_arrow_up 
                    : Icons.keyboard_arrow_down,
                size: 14,
                color: Color(0xFF1D4ED8), // blue-700
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF93C5FD), // blue-300
              Color(0xFFDBEAFE), // blue-100
            ],
          ),
        ),
        child: Column(
          children: [
            // Header Section
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF60A5FA), // blue-400
                    Color(0xFF3B82F6), // blue-500
                    Color(0xFF2563EB), // blue-600
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              padding: EdgeInsets.fromLTRB(24, 48, 24, 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Stock Recommendation',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Stock Table Section
            Expanded(
              child: Container(
                margin: EdgeInsets.all(16),
                child: buildStockTable(),
              ),
            ),

            // Bottom Navigation
            Container(
              color: Color(0xFF2563EB), // blue-600
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      onPressed: () {
                        // Current screen - highlight it
                      },
                      icon: Icon(
                        Icons.notifications,
                        color: Color(0xFF2563EB), // blue-600
                        size: 28,
                      ),
                      padding: EdgeInsets.all(16),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => PortfolioScreen()),
                      );
                    },
                    icon: Icon(
                      Icons.person_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                    padding: EdgeInsets.all(12),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.volume_up_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                    padding: EdgeInsets.all(12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}