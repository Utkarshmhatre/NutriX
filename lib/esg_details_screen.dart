import 'package:flutter/material.dart';

class ESGDetailsScreen extends StatelessWidget {
  const ESGDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ESG Details')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          Card(
            child: ListTile(
              leading: Icon(Icons.eco),
              title: Text('Environmental Initiatives'),
              subtitle: Text('Focus on carbon footprint reduction'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.people),
              title: Text('Community Engagement'),
              subtitle: Text('Social programs and impact'),
            ),
          ),
        ],
      ),
    );
  }
}