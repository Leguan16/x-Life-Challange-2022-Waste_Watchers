import 'package:camera/camera.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:frontend/pages/cameraPage.dart';
import 'package:frontend/pages/mapPage.dart';

import '../domain/pageIcon.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String route = "/home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPageIndex = 0;
  late CameraDescription cameraDescription;
  static final pageIcons = [
    PageIcon(const Icon(Icons.explore_outlined), "Map"),
    PageIcon(const Icon(Icons.camera_alt_outlined), "Kamera"),
  ];

  @override
  Widget build(BuildContext context) {
    final pageController = PageController(initialPage: 0);
    GlobalKey<ConvexAppBarState> _appBarKey = GlobalKey<ConvexAppBarState>();
    return Scaffold(
      body: PageView(
        controller: pageController,
        allowImplicitScrolling: pageIcons[_currentPageIndex].text == "Map",
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          MapPage(),
          CameraPage(),
        ],
      ),
      bottomNavigationBar: ConvexAppBar(
        key: _appBarKey,
        style: TabStyle.react,
        initialActiveIndex: _currentPageIndex,
        onTap: (index) => _showPage(index, pageController, _appBarKey),
        backgroundColor: Colors.white,
        activeColor: Colors.green,
        items: generateIcons(pageIcons, pageController),
        color: Colors.black,
      ),
    );
  }

  void _showPage(int index, PageController pageController,
      GlobalKey<ConvexAppBarState> appBarKey) {
    setState(() {
      _currentPageIndex = index;
      appBarKey.currentState?.animateTo(index);
      pageController.animateToPage(_currentPageIndex,
          duration: const Duration(microseconds: 500), curve: Curves.ease);
    });
  }

  generateIcons(List<PageIcon> pageIcons, PageController pageController) {
    List<TabItem> icons = [];
    for (int i = 0; i < pageIcons.length; i++) {
      icons.add(TabItem(
          icon: pageIcons[i].icon,
          title: pageIcons[i].text,
          isIconBlend: true));
    }
    return icons;
  }
}
