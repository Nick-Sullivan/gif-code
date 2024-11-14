import 'package:flutter/material.dart';
import 'package:qr_gif/screens/collection_list_screen.dart';
import 'package:qr_gif/screens/gif_selection_screen.dart';
import 'package:qr_gif/screens/qr_text_screen.dart';

class HomeScreen extends StatelessWidget {
  final TabController tabController;

  const HomeScreen({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.gif_box_rounded)]),
            ),
            Tab(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.qr_code_2)]),
            ),
            Tab(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.folder_copy)]),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          GifSelectionScreen(tabController: tabController),
          QrTextScreen(),
          CollectionListScreen(),
        ],
      ),
    );
  }
}
