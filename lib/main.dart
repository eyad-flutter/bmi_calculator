import 'package:flutter/material.dart';

import 'welcome_ui.dart';

void main() {
  runApp(Bmi());
}

class Bmi extends StatelessWidget {
  const Bmi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // To hide debug banner
        debugShowCheckedModeBanner: false,
        home: WelcomeUi());
  }
}
