import 'package:flutter/material.dart';
import 'dart:math';
import 'portfolio_screen.dart';
import 'stock_screen.dart';

class Source {
  final int id;
  final String name;
  final double confidence;
  final double profitLoss;
  final List<List<double>> plotPoints;

  Source({
    required this.id,
    required this.name,
    required this.confidence,
    required this.profitLoss,
    required this.plotPoints,
  });
}

class SourceService {
  static Future<List<Source>> fetchSources() async {
    // For demo purposes, return mock data
    return [
      Source(
        id: 1,
        name: 'Kushal Kumar',
        confidence: 85.0,
        profitLoss: 15.5,
        plotPoints: [
          [10, 15, 12, 18, 25, 22, 28, 32, 30, 35],
          [5, 8, 7, 10, 15, 13, 18, 20, 19, 25],
          [15, 20, 18, 22, 30, 28, 35, 40, 38, 45],
        ],
      ),
      Source(
        id: 2,
        name: 'Ashok Abhimanue',
        confidence: 72.0,
        profitLoss: -5.2,
        plotPoints: [
          [40, 35, 38, 30, 25, 28, 20, 15, 18, 12],
          [45, 40, 42, 35, 30, 32, 25, 20, 22, 18],
          [35, 30, 32, 28, 22, 25, 18, 15, 20, 10],
        ],
      ),
      Source(
        id: 3,
        name: 'Terrance Tailwood',
        confidence: 90.0,
        profitLoss: 20.0,
        plotPoints: [
          [25, 22, 28, 20, 18, 15, 12, 10, 8, 14],
          [20, 18, 25, 15, 13, 10, 8, 5, 3, 9],
          [30, 27, 33, 25, 23, 20, 17, 15, 13, 19],
        ],
      ),
      Source(
        id: 4,
        name: 'Ester Evans',
        confidence: 68.0,
        profitLoss: -8.7,
        plotPoints: [
          [30, 28, 32, 25, 22, 20, 18, 15, 12, 10],
          [25, 23, 27, 20, 18, 15, 13, 10, 8, 5],
          [35, 33, 37, 30, 27, 25, 23, 20, 17, 15],
        ],
      ),
    ];
  }
}

class SourceScreen extends StatefulWidget {
  @override
  _SourceScreenState createState() => _SourceScreenState();
}

class _SourceScreenState extends State<SourceScreen> with TickerProviderStateMixin {
  List<Source> sources = [];
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
    
    fetchSourcesData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchSourcesData() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final fetchedSources = await SourceService.fetchSources();
      
      setState(() {
        sources = fetchedSources;
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
      final fetchedSources = await SourceService.fetchSources();
      
      setState(() {
        sources = fetchedSources;
        error = null;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
  }

  Color getProfitLossColor(double profitLoss) {
    return profitLoss > 0 ? Colors.green[600]! : Colors.red[600]!;
  }

  IconData getProfitLossIcon(double profitLoss) {
    return profitLoss > 0 ? Icons.trending_up : Icons.trending_down;
  }

  Widget buildSourceTable() {
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
              'Loading sources...',
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
                onPressed: fetchSourcesData,
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

    if (sources.isEmpty) {
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
                'No sources yet',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Check back later for new sources',
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
                      'Source Performance',
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
                      '${sources.length} sources',
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
            
            // Source List
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                color: Colors.blue[600],
                child: ListView.separated(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: sources.length,
                  separatorBuilder: (context, index) => FractionallySizedBox(
                    widthFactor: 0.85,
                    alignment: Alignment.center,
                    child: Container(
                      height: 1,
                      color: Colors.grey[300],
                    ),
                  ),
                  itemBuilder: (context, index) {
                    Source source = sources[index];
                    bool isExpanded = expandedRows.contains(source.id);
                    
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
                                if (expandedRows.contains(source.id)) {
                                  expandedRows.remove(source.id);
                                } else {
                                  expandedRows.add(source.id);
                                }
                              });
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  // Top Row - Source Info and Confidence
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Source Info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              source.name,
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
                                      
                                      // Confidence Badge
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[600]!.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: Colors.blue[600]!,
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.security,
                                              size: 14,
                                              color: Colors.blue[600],
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              '${source.confidence.toStringAsFixed(0)}%',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  SizedBox(height: 12),
                                  
                                  // Bottom Row - Profit/Loss and Expand
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Profit/Loss Info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${source.profitLoss > 0 ? '+' : ''}${source.profitLoss.toStringAsFixed(2)}%',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: getProfitLossColor(source.profitLoss),
                                              ),
                                            ),
                                            Text(
                                              source.profitLoss > 0 ? 'Profit' : 'Loss',
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
                                        Container(
                                          height: 200,  // Increased height for better visibility
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: SourceGraph(source: source),
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
                                  'Source Analytics',
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
                                  'Performance insights',
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
                              Icons.analytics_outlined,
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

            // Source Table Section
            Expanded(
              child: buildSourceTable(),
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
                        Icons.volume_up,
                        color: Color(0xFF2563EB),
                        size: 24,
                      ),
                      padding: EdgeInsets.all(16),
                    ),
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

class SourceGraph extends StatelessWidget {
  final Source source;

  const SourceGraph({Key? key, required this.source}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: SourceGraphPainter(source),
    );
  }
}

class SourceGraphPainter extends CustomPainter {
  final Source source;

  SourceGraphPainter(this.source);

  @override
  void paint(Canvas canvas, Size size) {
    final lines = source.plotPoints;
    if (lines.isEmpty || lines.every((line) => line.isEmpty)) return;

    // Find global min and max across all lines
    double globalMax = lines.fold<double>(double.negativeInfinity, (max, line) => line.fold(max, (m, v) => v > m ? v : m));
    double globalMin = lines.fold<double>(double.infinity, (min, line) => line.fold(min, (m, v) => v < m ? v : m));
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

    // Define colors for different lines
    final List<Color> lineColors = [
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.green,
      Colors.red,
      Colors.cyan,
    ];

    // Draw each line
    for (int lineIndex = 0; lineIndex < lines.length; lineIndex++) {
      final points = lines[lineIndex];
      if (points.isEmpty) continue;

      final linePaint = Paint()
        ..color = lineColors[lineIndex % lineColors.length]
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
        canvas.drawCircle(Offset(x, y), 4, Paint()..color = lineColors[lineIndex % lineColors.length]);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}