import 'package:flutter/material.dart';
import 'package:seeker_app/views/discovery/discovery_screen.dart';
import 'package:seeker_app/views/map/home_map_screen.dart';
import 'package:seeker_app/views/profile/profil_screen.dart';
import 'package:seeker_app/widgets/custom_bottom_navigation.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeMapScreen(),
    DiscoveryScreen(),
    ProfilScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomAppBar(
          selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
    );
  }
}
