import 'package:flutter/widgets.dart';

import 'demo10.dart';
import 'demo2.dart';
import 'demo3.dart';
import 'demo4.dart';
import 'demo5.dart';
import 'demo8.dart';
import 'demo9.dart';

/**
 * @author Raining
 * @date 2024-12-11 11:15
 *
 * 提供所有页面信息
 */
class ItemData {
  String key;
  WidgetBuilder builder;
  String title;

  ItemData(this.key, this.builder, this.title);
}

class PageProvider {
  static List<ItemData>? _data;

  static List<ItemData> getData() {
    if (_data != null) {
      return _data!;
    }
    var data = List.of({
      ItemData(
        "StateLifecycleTest",
        (context) => const StateLifecycleTest(),
        "state生命周期测试",
      ),
      ItemData(
        "GetStateObjectRoute",
        (context) => const GetStateObjectRoute(),
        "状态对象获取测试",
      ),
      ItemData(
        "CupertinoTestRoute",
        (context) => const CupertinoTestRoute(),
        "IOS风格测试",
      ),
      ItemData(
        "TapboxA",
        (context) => const TapboxA(),
        "管理自身状态",
      ),
      ItemData(
        "ParentWidget",
        (context) => const ParentWidget(),
        "父Widget管理子Widget的状态",
      ),
      ItemData(
        "ParentWidgetC",
        (context) => const ParentWidgetC(),
        "混合状态管理",
      ),
      ItemData(
        "Page1",
        (context) => const Page1(),
        "简单页面跳转",
      ),
      ItemData(
        "ImageBgPage",
        (context) => const ImageBgPage(),
        "加载asset资源",
      ),
      ItemData(
        "BaseComponentDemo",
        (context) => const BaseComponentDemo(),
        "基础组件测试",
      ),
      ItemData(
        "BaseComponentDemo2",
        (context) => const BaseComponentDemo2(),
        "基础组件测试2",
      ),
      ItemData(
        "LayoutDemo",
        (context) => const LayoutDemo(),
        "布局测试",
      ),
      ItemData(
        "LayoutDemo2",
        (context) => const LayoutDemo2(),
        "布局测试2",
      ),
      ItemData(
        "LayoutDemo3",
        (context) => const LayoutDemo3(),
        "布局测试3",
      ),
      ItemData(
        "LayoutDemo4",
        (context) => const LayoutDemo4(),
        "Wrap的使用",
      ),
      ItemData(
        "LayoutDemo5",
        (context) => const LayoutDemo5(),
        "Stack使用",
      ),
      ItemData(
        "LayoutDemo6",
        (context) => const LayoutDemo6(),
        "Align布局测试",
      ),
      ItemData(
        "LayoutDemo7",
        (context) => const LayoutDemo7(),
        "LayoutBuilder",
      ),
      ItemData(
        "ContainerDemo",
        (context) => const ContainerDemo(),
        "容器类测试",
      ),
      ItemData(
        "ContainerDemo2",
        (context) => const ContainerDemo2(),
        "容器类测试2",
      ),
      ItemData(
        "ContainerDemo3",
        (context) => const ContainerDemo3(),
        "容器类测试3",
      ),
      ItemData(
        "ContainerDemo4",
        (context) => const ContainerDemo4(),
        "单行缩放布局",
      ),
      ItemData(
        "ContainerDemo5",
        (context) => const ContainerDemo5(),
        "Scaffold",
      ),
    });

    // 增加编号
    for (int i = 0; i < data.length; i++) {
      var item = data[i];
      item.title = "${i + 1}. ${item.title}";
    }
    // 倒序
    _data = data.reversed.toList();
    return _data!;
  }
}
