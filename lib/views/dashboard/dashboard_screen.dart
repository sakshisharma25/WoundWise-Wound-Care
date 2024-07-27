import 'package:flutter/material.dart';
import 'package:woundwise/constants.dart';
import 'package:woundwise/views/dashboard/analysis_screen.dart';
import 'package:woundwise/views/dashboard/home_screen.dart';
import 'package:woundwise/views/dashboard/profile_screen.dart';
import 'package:woundwise/views/dashboard/setting_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({required this.accountType, super.key});
  final AccountType accountType;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> selectedIndex = ValueNotifier(0);
    final PageController pageController = PageController();
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        // leading: IconButton(
        //   icon: const Icon(Icons.notifications, color: Colors.black),
        //   onPressed: () {},
        // ),
        title: Center(
          child: Image.asset(
            'assets/logo.png',
            height: 80,
            width: 160,
          ),
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.more_vert, color: Colors.black),
        //     onPressed: () {},
        //   ),
        //   const SizedBox(width: 8),
        // ],
      ),
      body: PageView(
        controller: pageController,
        allowImplicitScrolling: true,
        children: [
          HomeScreen(accountType: accountType),
          const AnalysisScreen(),
          const SettingScreen(),
          const ProfileScreen(),
        ],
        onPageChanged: (int index) {
          selectedIndex.value = index;
        },
      ),
      bottomNavigationBar: ValueListenableBuilder(
          valueListenable: selectedIndex,
          builder: (context, index, _) {
            return BottomNavigationBar(
              backgroundColor: Colors.white,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.analytics),
                  label: 'Analysis',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
              currentIndex: index,
              selectedItemColor: const Color.fromRGBO(26, 35, 126, 1),
              unselectedItemColor: const Color.fromARGB(255, 139, 137, 137),
              onTap: (int newIndex) {
                pageController.jumpToPage(newIndex);
                selectedIndex.value = newIndex;
              },
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: const TextStyle(
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 12,
              ),
            );
          }),
    );
  }
}
