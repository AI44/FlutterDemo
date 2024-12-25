import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'dartExt.dart';

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
    print('obj1 ${MyLocalizations.of(context).hashCode}');
    print('obj2 ${MyLocalizations.of(context).hashCode}');

    return Scaffold(
      appBar: AppBar(
        title: Text(MyLocalizations.of(context).getString("title")),
      ),
      body: Column(
        children: [
          Text(MyLocalizations.of(context).getString("hello")),
          Text(MyLocalizations.of(context).getString("welcome")),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: "使用原生实现多语言",
    // 1. 设置支持的语言
    supportedLocales: const [
      Locale('en', 'US'), // English
      Locale('zh', 'CN'), // 中文
    ],
    // 2. 设置语言代理
    localizationsDelegates: const [
      // 组件库提供的本地化的字符串
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      // 3. 注册我们的Delegate
      MyLocalizationsDelegate(),
    ],
    // 4. 设置语言选择规则
    localeListResolutionCallback: (List<Locale>? locales, Iterable<Locale> supportedLocales) {
      // locales为什么是一个list，现在很多手机语言选择都是一个列表，在第一位的语言优先显示
      if (locales == null || locales.isEmpty) {
        return supportedLocales.first;
      }
      // 遍历设备支持的语言列表，选择第一个匹配的
      final result = locales.firstOrNullExt((locale) {
        return supportedLocales.firstOrNullExt((item) {
              return locale.languageCode == item.languageCode;
            }) !=
            null;
      });
      if (result != null) {
        return result;
      }
      // 如果没有找到匹配的，返回默认语言环境
      return supportedLocales.first;
    },
    home: LocalizationsDemo(),
  ));
}

enum LanguageCode {
  none,
  en,
  zh,
}

extension on String {
  LanguageCode toLanguageCode() {
    return LanguageCode.values.firstWhere((item) => toLowerCase().startsWith(item.toString().split('.').last),
        orElse: () => LanguageCode.none);
  }
}

class MyLocalizations {
  Map<String, String> stringMap = {};

  MyLocalizations(LanguageCode lang) {
    print('init $lang');
    if (lang == LanguageCode.none) {
      lang = LanguageCode.en;
    }
    // 模拟加载语言数据
    Map<LanguageCode, Map<String, String>> map = {};
    Map<String, String> en = {};
    en["title"] = "Flutter App";
    en["hello"] = "Hello";
    en["welcome"] = "Welcome to Flutter";
    map[LanguageCode.en] = en;

    Map<String, String> zh = {};
    zh["title"] = "Flutter应用";
    zh["hello"] = "你好";
    zh["welcome"] = "欢迎使用 Flutter";
    map[LanguageCode.zh] = zh;

    // 选择语言数据
    stringMap = map[lang] ?? {};
  }

  //为了使用方便，我们定义一个静态方法
  static MyLocalizations of(BuildContext context) {
    return Localizations.of<MyLocalizations>(context, MyLocalizations) ?? MyLocalizations(LanguageCode.en); // 不会每次都生成对象
  }

  String getString(String key) => stringMap[key] ?? "";
}

class MyLocalizationsDelegate extends LocalizationsDelegate<MyLocalizations> {
  const MyLocalizationsDelegate();

  //是否支持某个Local
  @override
  bool isSupported(Locale locale) => locale.languageCode.toLanguageCode() != LanguageCode.none;

  // Flutter会调用此类加载相应的Locale资源类
  @override
  Future<MyLocalizations> load(Locale locale) {
    print("load : $locale");
    return SynchronousFuture<MyLocalizations>(MyLocalizations(locale.languageCode.toLanguageCode()));
  }

  @override
  bool shouldReload(MyLocalizationsDelegate old) => false;
}
