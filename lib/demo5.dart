import 'package:flutter/material.dart';

/**
 * @author Raining
 * @date 2024-12-10 09:38
 *
 * #I# 资源加载
 */
class Demo5 {}

/**
 * 加载asset资源
 */
class ImageBgPage extends StatelessWidget {
  const ImageBgPage({super.key});

  /**
   * 加载依赖包中的图片：
   * AssetImage('icons/heart.png', package: 'my_icons')
   * 或
   * Image.asset('icons/heart.png', package: 'my_icons')
   *
   * 如果在pubspec.yaml文件中声明了期望的资源，它将会打包到相应的package中。特别是，包本身使用的资源必须在pubspec.yaml中指定。
   * 包也可以选择在其lib/文件夹中包含未在其pubspec.yaml文件中声明的资源。
   * 在这种情况下，对于要打包的图片，应用程序必须在pubspec.yaml中指定包含哪些图像。
   * 例如，一个名为“fancy_backgrounds”的包，可能包含以下文件：
   * …/lib/backgrounds/background1.png
   * …/lib/backgrounds/background2.png
   * …/lib/backgrounds/background3.png
   *
   * 要包含第一张图像，必须在pubspec.yaml的assets部分中声明它：
   * flutter:
   *   assets:
   *     - packages/fancy_backgrounds/backgrounds/background1.png
   *
   * lib/是隐含的，所以它不应该包含在资产路径中。
   *
   * 特定平台的资源：
   * android
   * .../android/app/src/main/res
   * ios
   * .../ios/Runner
   *
   * 启动页修改：
   * https://book.flutterchina.club/chapter2/flutter_assets_mgr.html#_2-6-3-加载-assets
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ImageBgPage"),
      ),
      body: Container(
          // width: 200, // 设置容器的宽度
          // height: 100, // 设置容器的高度
          decoration: const BoxDecoration(
              image: DecorationImage(fit: BoxFit.cover, image: AssetImage(("graphics/background.jpg"))))),
      // body: Image.asset('graphics/background.jpg'),
      // body: Image.asset('graphics/bg2.png'),
    );
  }
}
