import 'package:flutter/material.dart';
import 'package:flutter_blog_sample/views/overlay_portal_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return ListTile(
              title: const Text('OverlayPortal'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OverlayPortalScreen()));
              });
        },
      ),
    );
  }
}
