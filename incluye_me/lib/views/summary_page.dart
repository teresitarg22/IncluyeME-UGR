import 'package:flutter/material.dart';

class SummaryPage extends StatelessWidget {
  final Map<String, Map<String, int>> amount;

  SummaryPage({required this.amount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resumen'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: amount.entries.map((entry) {
                return Center(
                  child: ListTile(
                    title: Text(
                      entry.key,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24),
                    ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: entry.value.entries.map((innerEntry) {
                        return Text(
                          '${innerEntry.key}: ${innerEntry.value}',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        );
                      }).toList(),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
