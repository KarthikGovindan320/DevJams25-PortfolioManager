import 'package:flutter/material.dart';
import 'dart:math';
import 'stock_screen.dart';
import 'source_screen.dart';

class Investment {
  final String name;
  final int percentage;
  final bool isPositive;
  final List<double> plotPoints;

  Investment({
    required this.name,
    required this.percentage,
    required this.isPositive,
    required this.plotPoints,
  });
}

class PortfolioScreen extends StatefulWidget {
  @override
  _PortfolioScreenState createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> with TickerProviderStateMixin {
  int? expandedIndex;
  List<Investment> investments = [];
  bool isLoading = true;
  String? error;
  Set<int> expandedRows = {};
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Investment> mockInvestments = [
    Investment(
      name: 'Chalet Hotels',
      percentage: 20,
      isPositive: true,
      plotPoints: [10, 15, 12, 18, 25, 22, 28, 32, 30, 35],
    ),
    Investment(
      name: 'Safari Industries',
      percentage: 18,
      isPositive: false,
      plotPoints: [40, 35, 38, 30, 25, 28, 20, 15, 18, 12],
    ),
    Investment(
      name: 'Dell Hiberi',
      percentage: 11,
      isPositive: false,
      plotPoints: [25, 22, 28, 20, 18, 15, 12, 10, 8, 14],
    ),
  ];

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
    
    fetchInvestments();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void fetchInvestments() {
    // Simulate fetch
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        investments = mockInvestments;
        isLoading = false;
      });
      _animationController.forward();
    });
  }

  Future<void> _refresh() async {
    setState(() {
      investments = mockInvestments;
      error = null;
    });
  }

  Color getProfitLossColor(bool isPositive) {
    return isPositive ? Colors.green[600]! : Colors.red[600]!;
  }

  IconData getProfitLossIcon(bool isPositive) {
    return isPositive ? Icons.trending_up : Icons.trending_down;
  }

  Widget buildPortfolio() {
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
              'Loading portfolio...',
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
                onPressed: fetchInvestments,
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

    if (investments.isEmpty) {
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
                'No investments yet',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Check back later for new investments',
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
                      'Recent Investments',
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
                      '${investments.length} investments',
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
            
            // Investment List
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                color: Colors.blue[600],
                child: ListView.separated(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: investments.length,
                  separatorBuilder: (context, index) => FractionallySizedBox(
                    widthFactor: 0.85,
                    alignment: Alignment.center,
                    child: Container(
                      height: 1,
                      color: Colors.grey[300],
                    ),
                  ),
                  itemBuilder: (context, index) {
                    Investment investment = investments[index];
                    bool isExpanded = expandedRows.contains(index);
                    
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
                                if (expandedRows.contains(index)) {
                                  expandedRows.remove(index);
                                } else {
                                  expandedRows.add(index);
                                }
                              });
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  // Top Row - Investment Name
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Investment Info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              investment.name,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[800],
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      
                                      // Percentage Badge
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: getProfitLossColor(investment.isPositive).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: getProfitLossColor(investment.isPositive),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              getProfitLossIcon(investment.isPositive),
                                              size: 14,
                                              color: getProfitLossColor(investment.isPositive),
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              '${investment.isPositive ? '+' : '-'}${investment.percentage}%',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: getProfitLossColor(investment.isPositive),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  SizedBox(height: 12),
                                  
                                  // Bottom Row - Expand
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Placeholder for more info if needed
                                      Expanded(
                                        child: Text(
                                          'Performance',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
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
                                        Container(
                                          height: 200,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: InvestmentGraph(investment: investment),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                                  'My Portfolio',
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
                                  'Investment overview',
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
                              Icons.pie_chart_outline,
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

            // Balance Section
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(24),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Balance Amount:',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '₹ 1,97,888',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      Text(
                        '+20%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.green[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Portfolio Table Section
            Expanded(
              child: buildPortfolio(),
            ),

            // Bottom Navigation
            Container(
              color: Color(0xFF2563EB), // blue-600
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => StockScreen()),
                      );
                    },
                    icon: Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                    padding: EdgeInsets.all(12),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      onPressed: () {
                        // Current screen
                      },
                      icon: Icon(
                        Icons.person,
                        color: Color(0xFF2563EB),
                        size: 24,
                      ),
                      padding: EdgeInsets.all(16),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SourceScreen()),
                      );
                    },
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

class InvestmentGraph extends StatelessWidget {
  final Investment investment;

  const InvestmentGraph({Key? key, required this.investment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: GraphPainter(investment),
    );
  }
}

class GraphPainter extends CustomPainter {
  final Investment investment;

  GraphPainter(this.investment);

  @override
  void paint(Canvas canvas, Size size) {
    final points = investment.plotPoints;
    if (points.isEmpty) return;

    double globalMax = points.fold<double>(double.negativeInfinity, (max, v) => v > max ? v : max);
    double globalMin = points.fold<double>(double.infinity, (min, v) => v < min ? v : min);
    final range = globalMax - globalMin == 0 ? 1 : globalMax - globalMin;

    final width = size.width;
    final height = size.height;
    final padding = 16.0;

    // Draw grid
    final gridPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1;

    // Horizontal grid lines
    for (int i = 1; i < 4; i++) {
      final y = padding + i * (height - 2 * padding) / 4;
      canvas.drawLine(
        Offset(padding, y),
        Offset(width - padding, y),
        gridPaint,
      );
    }

    // Draw line
    final lineColor = investment.isPositive ? Colors.green : Colors.red;

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final x = padding + i * (width - 2 * padding) / (points.length - 1);
      final y = height - padding - (points[i] - globalMin) / range * (height - 2 * padding);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, linePaint);

    // Draw points
    for (int i = 0; i < points.length; i++) {
      final x = padding + i * (width - 2 * padding) / (points.length - 1);
      final y = height - padding - (points[i] - globalMin) / range * (height - 2 * padding);
      canvas.drawCircle(Offset(x, y), 4, Paint()..color = lineColor);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}