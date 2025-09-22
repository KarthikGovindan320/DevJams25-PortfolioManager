// stock_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
          stockName: 'Apple Inc.',
          recommendedAction: 'BUY',
          price: 234.72,
          source: 'Kushal Kumar',
          predictedTarget: 250.00,
          ltp: 234.72,
          upside: 6.52,
        ),
        Stock(
          id: 2,
          date: '2024-09-17',
          stockName: 'Google LLC',
          recommendedAction: 'HOLD',
          price: 165.45,
          source: 'Ashok Abhimanue',
          predictedTarget: 175.00,
          ltp: 165.45,
          upside: 5.77,
        ),
        Stock(
          id: 3,
          date: '2024-09-15',
          stockName: 'Microsoft Corp',
          recommendedAction: 'BUY',
          price: 412.30,
          source: 'Terrance Tailwood',
          predictedTarget: 450.00,
          ltp: 415.20,
          upside: 9.14,
        ),
        Stock(
          id: 4,
          date: '2024-09-14',
          stockName: 'Meta Platforms',
          recommendedAction: 'SELL',
          price: 298.50,
          source: 'Ester Evans',
          predictedTarget: 280.00,
          ltp: 295.80,
          upside: -6.22,
        ),
        Stock(
          id: 5,
          date: '2024-09-13',
          stockName: 'Tesla Inc.',
          recommendedAction: 'BUY',
          price: 380.25,
          source: 'Tommy Thompson',
          predictedTarget: 420.00,
          ltp: 385.50,
          upside: 10.45,
        ),
      ];
    }
  }
}

class StockView extends StatefulWidget {
  @override
  _StockViewState createState() => _StockViewState();
}

class _StockViewState extends State<StockView> with TickerProviderStateMixin {
  List<Stock> stocks = [];
  bool isLoading = true;
  String? error;
  Set<int> expandedRows = {};
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    fetchStocksData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
      
      _animationController.forward();
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
        return Colors.green[600]!;
      case 'SELL':
        return Colors.red[600]!;
      case 'HOLD':
        return Colors.orange[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  IconData getActionIcon(String action) {
    switch (action.toUpperCase()) {
      case 'BUY':
        return Icons.trending_up;
      case 'SELL':
        return Icons.trending_down;
      case 'HOLD':
        return Icons.trending_flat;
      default:
        return Icons.help_outline;
    }
  }

  Widget buildStockTable() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
              strokeWidth: 3,
            ),
            SizedBox(height: 20),
            Text(
              'Loading recommendations...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Container(
          padding: EdgeInsets.all(24),
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  color: Colors.red[600],
                  size: 32,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Unable to load data',
                style: TextStyle(
                  color: Colors.red[700],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Please check your connection and try again',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: fetchStocksData,
                icon: Icon(Icons.refresh, size: 18),
                label: Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (stocks.isEmpty) {
      return Center(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inbox_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16),
              Text(
                'No recommendations yet',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Check back later for new stock recommendations',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Enhanced Header
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue[700]!,
                    Colors.blue[800]!,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Latest Recommendations',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${stocks.length} stocks',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Stock List
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                color: Colors.blue[600],
                child: ListView.separated(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: stocks.length,
                  separatorBuilder: (context, index) => FractionallySizedBox(
                    widthFactor: 0.85,
                    alignment: Alignment.center,
                    child: Container(
                      height: 1,
                      color: Colors.grey[300],
                    ),
                  ),
                  itemBuilder: (context, index) {
                    Stock stock = stocks[index];
                    bool isExpanded = expandedRows.contains(stock.id);
                    
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: isExpanded ? Colors.blue[50] : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: isExpanded 
                            ? Border.all(color: Colors.blue[200]!, width: 1)
                            : null,
                      ),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (expandedRows.contains(stock.id)) {
                                  expandedRows.remove(stock.id);
                                } else {
                                  expandedRows.add(stock.id);
                                }
                              });
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  // Top Row - Stock Info and Action
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Stock Info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              stock.stockName,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[800],
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              stock.date,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      
                                      // Action Badge
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: getActionColor(stock.recommendedAction).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: getActionColor(stock.recommendedAction),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              getActionIcon(stock.recommendedAction),
                                              size: 14,
                                              color: getActionColor(stock.recommendedAction),
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              stock.recommendedAction,
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: getActionColor(stock.recommendedAction),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  SizedBox(height: 12),
                                  
                                  // Bottom Row - Price Info and Expand
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Price Info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '₹${stock.price.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[800],
                                              ),
                                            ),
                                            Text(
                                              'Target: ₹${stock.predictedTarget.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      
                                      // Expand Icon
                                      AnimatedRotation(
                                        turns: isExpanded ? 0.5 : 0,
                                        duration: Duration(milliseconds: 300),
                                        child: Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          // Expanded Details
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            height: isExpanded ? null : 0,
                            child: isExpanded 
                                ? Container(
                                    padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
                                    child: Column(
                                      children: [
                                        Divider(color: Colors.grey[300]),
                                        SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: _buildDetailCard(
                                                'LTP',
                                                '₹${stock.ltp.toStringAsFixed(2)}',
                                                Icons.monetization_on_outlined,
                                                Colors.blue,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Expanded(
                                              child: _buildDetailCard(
                                                'Upside',
                                                '${stock.upside > 0 ? '+' : ''}${stock.upside.toStringAsFixed(2)}%',
                                                stock.upside > 0 ? Icons.trending_up : Icons.trending_down,
                                                stock.upside > 0 ? Colors.green : Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Source',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey[600],
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(height: 2),
                                              Text(
                                                stock.source,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[800],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : null,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 16),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue[100]!,
            Colors.blue[50]!,
            Colors.white,
          ],
        ),
      ),
      child: Column(
        children: [
          // Enhanced Header Section
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue[600]!,
                  Colors.blue[700]!,
                  Colors.blue[800]!,
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, 20, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Recommendations',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'AI-powered investment insights',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.trending_up,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Stock Table Section
          Expanded(
            child: buildStockTable(),
          ),
        ],
      ),
    );
  }
}