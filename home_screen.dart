// home_screen.dart
import 'package:flutter/material.dart';
import 'stock_screen.dart'; // for StockView
import 'portfolio_screen.dart'; // for PortfolioView
import 'source_screen.dart'; // for SourceView

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0; // Start on StockView (index 0), or change to 1 for PortfolioView

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          StockView(),    // Index 0: Swipe right from Portfolio goes here
          PortfolioView(), // Index 1
          SourceView(),   // Index 2: Swipe left from Portfolio goes here
        ],
      ),
      bottomNavigationBar: Container(
        color: Color(0xFF2563EB), // blue-600
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(0, Icons.notifications, Icons.notifications_outlined),
            _buildNavItem(1, Icons.person, Icons.person_outlined),
            _buildNavItem(2, Icons.volume_up, Icons.volume_up_outlined),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData filledIcon, IconData outlinedIcon) {
    final bool isActive = _currentIndex == index;
    final IconData icon = isActive ? filledIcon : outlinedIcon;

    if (isActive) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: IconButton(
          onPressed: () {
            _controller.animateToPage(
              index,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          icon: Icon(
            icon,
            color: Color(0xFF2563EB),
            size: 24,
          ),
          padding: EdgeInsets.all(16),
        ),
      );
    } else {
      return IconButton(
        onPressed: () {
          _controller.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        icon: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
        padding: EdgeInsets.all(12),
      );
    }
  }
}