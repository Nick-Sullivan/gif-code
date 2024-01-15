import 'package:flutter/material.dart';
import 'package:qr_gif/screens/collection_list_screen.dart';
import 'package:qr_gif/screens/maker_screen.dart';

class HomeScreen extends StatelessWidget {
  final int initialTab;
  const HomeScreen({super.key, required this.initialTab});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: initialTab,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              toolbarHeight: 0,
              bottom: const TabBar(tabs: [
                Tab(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Icon(Icons.qr_code_2), Text(" Make")]),
                ),
                Tab(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Icon(Icons.folder_copy), Text(" Collect")]),
                ),
              ])),
          body: TabBarView(children: [
            MakerScreen(),
            CollectionListScreen(),
          ]),
        ));
  }
}
