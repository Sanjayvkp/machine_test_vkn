import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/custom_bottom_nav_item.dart';
import '../widgets/custom_text.dart';
import 'dashboard_tab.dart';
import 'profile_tab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const DashboardTab(),
      const Center(
        child: CustomText(text: 'Messages', type: TextType.body),
      ),
      const Center(
        child: CustomText(text: 'Notifications', type: TextType.body),
      ),
      const ProfileTab(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        color: AppColors.background,
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          backgroundColor: AppColors.background,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.textPrimary,
          unselectedItemColor: AppColors.textSecondary,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: CustomBottomNavItem(
                iconPath: 'assets/icons/icon_bottom_home.svg',
                isSelected: _currentIndex == 0,
                label: 'Home',
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: CustomBottomNavItem(
                iconPath: 'assets/icons/icon_bottom_messages.svg',
                isSelected: _currentIndex == 1,
                label: 'Messages',
              ),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: CustomBottomNavItem(
                iconPath: 'assets/icons/icon_bottom_notifications.svg',
                isSelected: _currentIndex == 2,
                label: 'Notifications',
              ),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: CustomBottomNavItem(
                iconPath: 'assets/icons/icon_bottom_profile.svg',
                isSelected: _currentIndex == 3,
                label: 'Profile',
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
