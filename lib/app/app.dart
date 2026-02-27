import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../features/board/board_page.dart';
import 'theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ));

    return MaterialApp(
      title: 'Sudoku do Dia',
      debugShowCheckedModeBanner: false,
      theme: KuroTheme.theme,
      home: const BoardPage(),
    );
  }
}
