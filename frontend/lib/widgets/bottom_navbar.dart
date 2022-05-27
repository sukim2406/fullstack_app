import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/global_controllers.dart';

class BottomNavBarWidget extends StatelessWidget {
  final int curIndex;
  final void Function(int) updatePage;
  const BottomNavBarWidget({
    Key? key,
    required this.curIndex,
    required this.updatePage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        indicatorColor: Colors.white.withOpacity(.5),
        labelTextStyle: MaterialStateProperty.all(
          GoogleFonts.zenLoop(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      child: NavigationBar(
        backgroundColor: Colors.lightBlue[300],
        animationDuration: const Duration(seconds: 1),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        height: GlobalControllers.instance.mediaHeight(context, .06),
        selectedIndex: curIndex,
        onDestinationSelected: (int newIndex) {
          updatePage(newIndex);
        },
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'HOME',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.message),
            icon: Icon(Icons.message_outlined),
            label: 'TWEET',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.category),
            icon: Icon(Icons.search),
            label: 'SEARCH',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'ACCOUNT',
          ),
        ],
      ),
    );
  }
}
