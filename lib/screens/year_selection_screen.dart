import 'package:flutter/material.dart';

class YearSelectionScreen extends StatelessWidget {
  final String sectionTitle;

  const YearSelectionScreen({super.key, required this.sectionTitle});

  @override
  Widget build(BuildContext context) {
    final List<String> years = ['Year 1', 'Year 2', 'Year 3', 'Year 4'];

    return Scaffold(
      appBar: AppBar(
        title: Text('$sectionTitle - Select Year'),
        backgroundColor: const Color(0xFF594FB6),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: years.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(years[index]),
              onTap: () {
                // TODO: Navigate to exam list or subject screen for that year
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${years[index]} clicked')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
