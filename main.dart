import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PortfolioScreen(),
    );
  }
}

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

class _PortfolioScreenState extends State<PortfolioScreen> {
  int? expandedIndex;

  final List<Investment> investments = [
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

  void toggleExpansion(int index) {
    setState(() {
      expandedIndex = expandedIndex == index ? null : index;
    });
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, TOM',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '+91 9846143302',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFDFE7FF), // blue-100
                    ),
                  ),
                ],
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
                      color: Color(0xFF6B7280), // gray-600
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
                            color: Color(0xFF1F2937), // gray-800
                          ),
                        ),
                      ),
                      Text(
                        '+20%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF10B981), // green-500
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Recent Investments Section
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFEFF6FF), // blue-50
                      Colors.white,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Color(0xFFC7D2FE), // blue-200
                    width: 1,
                  ),
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
                      padding: EdgeInsets.all(16),
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
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFFC7D2FE), // blue-200
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Recent Investments',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937), // gray-800
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Investments List
                    Expanded(
                      child: ListView.builder(
                        itemCount: investments.length,
                        itemBuilder: (context, index) {
                          final investment = investments[index];
                          return Column(
                            children: [
                              // Investment Row
                              InkWell(
                                onTap: () => toggleExpansion(index),
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Color(0xFFEFF6FF), // blue-50
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          investment.name,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF1F2937), // gray-800
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${investment.isPositive ? '+' : '-'}${investment.percentage}%',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: investment.isPositive
                                              ? Color(0xFF10B981) // green-500
                                              : Color(0xFFEF4444), // red-500
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFDBEAFE).withOpacity(0.5), // blue-100
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Icon(
                                          expandedIndex == index
                                              ? Icons.keyboard_arrow_up
                                              : Icons.keyboard_arrow_down,
                                          color: Color(0xFF2563EB), // blue-600
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Expandable Graph Section
                              if (expandedIndex == index)
                                Container(
                                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
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
                                  child: Container(
                                    height: 96,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Color(0xFFDBEAFE), // blue-100
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 5,
                                          offset: Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.all(8),
                                    child: InvestmentGraph(investment: investment),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Navigation
            Container(
              color: Color(0xFF2563EB), // blue-600
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {},
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
                      onPressed: () {},
                      icon: Icon(
                        Icons.person_outlined,
                        color: Color(0xFF2563EB), // blue-600
                        size: 28,
                      ),
                      padding: EdgeInsets.all(16),
                    ),
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
    final maxValue = points.reduce(max);
    final minValue = points.reduce(min);
    final range = maxValue - minValue == 0 ? 1 : maxValue - minValue;

    final width = size.width;
    final height = size.height;
    final padding = 20.0;

    // Draw grid
    final gridPaint = Paint()
      ..color = Color(0xFF94A3B8).withOpacity(0.2) // slate-400
      ..strokeWidth = 0.5;

    // Vertical grid lines
    for (int i = 0; i < 8; i++) {
      final x = padding + (i * (width - 2 * padding)) / 7;
      canvas.drawLine(
        Offset(x, padding),
        Offset(x, height - padding),
        gridPaint,
      );
    }

    // Horizontal grid lines
    for (int i = 0; i < 5; i++) {
      final y = padding + (i * (height - 2 * padding)) / 4;
      canvas.drawLine(
        Offset(padding, y),
        Offset(width - padding, y),
        gridPaint,
      );
    }

    // Draw main line
    final lineColor = investment.isPositive 
        ? Color(0xFF10B981) // green-500
        : Color(0xFFEF4444); // red-500

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final x = padding + (i * (width - 2 * padding)) / (points.length - 1);
      final y = height - padding - ((points[i] - minValue) / range) * (height - 2 * padding);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, linePaint);

    // Draw data points
    final pointPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    final pointBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 0; i < points.length; i++) {
      final x = padding + (i * (width - 2 * padding)) / (points.length - 1);
      final y = height - padding - ((points[i] - minValue) / range) * (height - 2 * padding);
      
      canvas.drawCircle(Offset(x, y), 3, pointPaint);
      canvas.drawCircle(Offset(x, y), 3, pointBorderPaint);
    }

    // Draw arrow at the end
    final lastIndex = points.length - 1;
    final lastX = padding + (lastIndex * (width - 2 * padding)) / (points.length - 1);
    final lastY = height - padding - ((points[lastIndex] - minValue) / range) * (height - 2 * padding);

    final arrowPaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final arrowPath = Path();
    arrowPath.moveTo(lastX + 8, lastY - 4);
    arrowPath.lineTo(lastX + 15, lastY);
    arrowPath.lineTo(lastX + 8, lastY + 4);

    canvas.drawPath(arrowPath, arrowPaint);

    // Draw percentage label
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${investment.isPositive ? '+' : '-'}${investment.percentage}%',
        style: TextStyle(
          color: lineColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    textPainter.paint(canvas, Offset(16, height - 24));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}