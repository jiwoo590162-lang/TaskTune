import 'package:flutter/material.dart';
import 'package:tasktune/screens/home_page.dart';
import 'package:tasktune/screens/settings_page.dart';
import 'package:tasktune/screens/stats_page.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int selected = 0;

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
                  // 앱 로고
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
                  const Divider(height: 1, color: Colors.grey),
                  // 메뉴
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            MenuItem(
                              icon: Icons.home_rounded,
                              label: '홈',
                              selected: selected == 0,
                              onTap: () => setState(() => selected = 0),
                            ),
                            MenuItem(
                              icon: Icons.bar_chart_rounded,
                              label: '통계',
                              selected: selected == 1,
                              onTap: () => setState(() => selected = 1),
                            ),
                          ],
                        ),
                        // 설정
                        Column(
                          children: [
                            MenuItem(
                              icon: Icons.settings_rounded,
                              label: '설정',
                              selected: selected == 2,
                              onTap: () => setState(() => selected = 2),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              color: Colors.grey,
            ),
            // 메인 화면
            Expanded(
              child: IndexedStack(
                index: selected,
                children: [
                  const HomePage(),
                  const StatsPage(),
                  const SettingsPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const MenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? Colors.grey.shade200 : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        child: SizedBox(
          height: 50,
          child: Center(
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                Icon(icon),
                const SizedBox(
                  width: 20,
                ),
                Text(label),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
