import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Row(
          children: [
            // 사이드바
            SizedBox(
              width: 220,
              child: Column(
                children: [
                  Container(
                    height: 64,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.centerLeft,
                    child: const Row(
                      children: [
                        Icon(Icons.apps),
                        SizedBox(width: 6),
                        Text('TaskTune'),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  const Expanded(
                    child: Center(child: Text('사이드바 만들 것')),
                  ),
                ],
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
