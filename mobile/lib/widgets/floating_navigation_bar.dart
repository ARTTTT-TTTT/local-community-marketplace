import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_constants.dart';

class FloatingNavigationBar extends StatefulWidget {
  const FloatingNavigationBar({super.key});

  @override
  State<FloatingNavigationBar> createState() => _FloatingNavigationBarState();
}

class _FloatingNavigationBarState extends State<FloatingNavigationBar> {
  int _currentIndex = 0;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'หน้าหลัก',
      route: '/dashboard',
    ),
    NavigationItem(
      icon: Icons.paid_outlined,
      activeIcon: Icons.paid,
      label: 'ร้าน',
      route: '/shop',
    ),
    NavigationItem(
      icon: Icons.notifications_outlined,
      activeIcon: Icons.notifications,
      label: 'แจ้งเตือน',
      route: '/notifications',
    ),
    NavigationItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'ฉัน',
      route: '/profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                spreadRadius: 0,
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _navigationItems.asMap().entries.map((entry) {
              int index = entry.key;
              NavigationItem item = entry.value;
              bool isSelected = _currentIndex == index;

              return GestureDetector(
                onTap: () => _onItemTapped(index, item),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppConstants.primaryColor.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          isSelected ? item.activeIcon : item.icon,
                          key: ValueKey(isSelected),
                          color: isSelected
                              ? AppConstants.primaryColor
                              : Colors.grey[600],
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: isSelected
                              ? AppConstants.primaryColor
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index, NavigationItem item) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });

      // Add haptic feedback
      HapticFeedback.selectionClick();

      // Navigate to the selected route
      _navigateToRoute(item.route);
    }
  }

  void _navigateToRoute(String route) {
    switch (route) {
      case '/dashboard':
        // Already on dashboard, do nothing
        break;
      case '/shop':
        // TODO: Navigate to shop screen
        // print('Navigate to Shop');
        break;
      case '/notifications':
        // TODO: Navigate to notifications screen
        // print('Navigate to Notifications');
        break;
      case '/profile':
        // TODO: Navigate to profile screen
        // print('Navigate to Profile');
        break;
    }
  }
}

class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}
