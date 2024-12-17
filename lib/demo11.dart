import 'package:flutter/material.dart';

/**
 * @author Raining
 * @date 2024-12-13 13:47
 *
 * #I# 多语言
 */
class Demo11 {}

class LocalizationsDemo extends StatefulWidget {
  const LocalizationsDemo({super.key});

  @override
  State<StatefulWidget> createState() {
    return LocalizationsDemoState();
  }
}

class LocalizationsDemoState extends State<LocalizationsDemo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    print("locale : $myLocale");

    return Scaffold(
      appBar: AppBar(
        title: const Text("LocalizationsDemoState"),
      ),
    );
  }
}
