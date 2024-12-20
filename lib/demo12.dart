import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/**
 * @author Raining
 * @date 2024-12-17 14:27
 *
 * #I# GetX
 *
 * 1. test.obs 使任何变量成为可观察的；
 *    final name = ''.obs;
 *    final isLogged = false.obs;
 *    final count = 0.obs;
 *    final balance = 0.0.obs;
 *    final number = 0.obs;
 *    final items = <String>[].obs;
 *    final myMap = <String, int>{}.obs;
 *    // 自定义类 - 可以是任何类
 *    final user = User().obs;
 *
 * 2. 使用StatelessWidget节省一些内存，使用Get你可能不再需要使用StatefulWidget；
 * 3. Obx(() => Text(test.value))
 *    除了使用 Obx 实现界面数据自动刷新外，GetX 提供了多种手动方式对响应式变量进行数据变化监听：
 *    ///每次`count1`变化时调用。
 *    ever(count1, (_) => print("$_ has been changed"));
 *
 *    ///只有在变量$_第一次被改变时才会被调用。
 *    once(count1, (_) => print("$_ was changed once"));
 *
 *    ///防DDos - 每当用户停止输入1秒时调用，例如。
 *    debounce(count1, (_) => print("debounce$_"), time: Duration(seconds: 1));
 *
 *     ///忽略1秒内的所有变化。
 *     interval(count1, (_) => print("interval $_"), time: Duration(seconds: 1));
 *
 *     所有这些方法都会返回一个Worker实例，你可以用它来取消（通过dispose()）worker。
 *     ever 当数据发生改变时触发
 *     everAll 和 "ever "很像，只是监听的是多个响应式变量的变化，当其中一个发生变化就会触发回调
 *     once 只在变量第一次被改变时被调用
 *     debounce 防抖，即延迟一定时间调用，且在规定时间内只有最后一次改变会触发回调。如设置时间为 1 秒，发生了3次数据变化，每次间隔500毫秒，则只有最后一次变化会触发回调。
 *     interval 时间间隔内只有最后一次变化会触发回调。如设置时间间隔为1秒，则在1秒内无论点击多少次都只有最后一次会触发回调，然后进入下一次的时间间隔。
 *
 *
 */
class Demo12 {}

class CounterController extends GetxController {
  int counter = 0;

  void increment() {
    counter++;
    update(); // 通知更新，update()方法是结合GetBuilder使用的，如果你想只更新某个或者特定的widget控件，你可以给它们分配唯一的ID
  }
}

/**
 * 简单状态管理 (GetBuilder)
 * 适用于不需要频繁更新的场景
 */
class GetXDemo extends StatelessWidget {
  GetXDemo({super.key});

  final CounterController counterController = Get.put(CounterController());

  @override
  Widget build(BuildContext context) {
    print('GetXDemo:build'); // 只会第一次创建调用，后续点击不会调用，效率高
    return GetMaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('GetX Demo')),
        body: Center(
          child: GetBuilder<CounterController>(
            // 可以分配id，update时只更新特定控件
            builder: (controller) => Text('Counter: ${controller.counter}'),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: counterController.increment,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class TestModel {
  bool a = false;
  int b = 0;
  String c = "";

  @override
  int get hashCode {
    return a.hashCode ^ b.hashCode ^ c.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (other is TestModel) {
      return other.a == a && other.b == b && other.c == c;
    }
    return false;
  }
}

class CounterController2 extends GetxController {
  // 添加了.obs后缀，使这个变量可观察，当可观察变量值更新时，Obx包裹中的内容就会进行刷新，例如：Obx(() => Text(test.value))。
  var counter = 0.obs; // 声明为响应式变量
  final num2 = 2.obs;
  final num3 = 3.obs;

  var obj = TestModel();
  var model = TestModel().obs;

  void increment() => counter++;

  void test() {
    counter.value = 1;
    counter.value = 2;
  }

  void test2() {
    var o2 = TestModel();
    Random random = Random();
    o2.a = random.nextBool();
    o2.b = random.nextInt(100);
    model.value = o2;

    // model.update((value) {
    //   value?.a = true;
    // });
  }

  void test3() {
    Random random = Random();
    counter.value = random.nextInt(40);
    num2.value = random.nextInt(40);
    num3.value = random.nextInt(60);
  }

  int getComNum() {
    return counter.value + num2.value + num3.value;
  }
}

/**
 * 响应式状态管理 (Rx)
 * 适用于需要频繁更新的场景
 *
 * 测试发现：Obx值一样时不会重复触发监听，对象类型需要重写hasCode和==，否则对象内的变量改变不会触发更新。
 *
 */
class GetXDemo2 extends StatelessWidget {
  GetXDemo2({super.key});

  final CounterController2 counterController = Get.put(CounterController2());

  @override
  Widget build(BuildContext context) {
    print('GetXDemo2:build');
    final result = combineLatest([counterController.num2, counterController.num3, counterController.counter], (list) {
      return list[0].value + list[1].value + list[2].value;
    }, (clean) {});
    final result2 =
        combineLatest3(counterController.num2, counterController.num3, counterController.counter, (x, y, z) {
      return x.value + y.value + z.value;
    }, (clean) {});
    return GetMaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('GetX Demo2')),
        body: Center(
          child: Column(
            children: [
              Obx(() {
                print('obx ${counterController.counter}');
                return Text('Counter: ${counterController.counter}');
              }),
              Obx(() {
                print('obx2 ${counterController.model.value.b}');
                return Text('Counter: ${counterController.model.value.a}');
              }),
              Obx(() {
                print('obx3 ${result.value}');
                return Text('result: ${result.value}');
              }),
              Obx(() {
                // 即使嵌套也能监控到
                final temp = counterController.getComNum();
                print('obx4 $temp');
                return Text('result: $temp');
              }),
              Obx(() {
                print('obx4 ${result2.value}');
                return Text('result: ${result2.value}');
              }),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          // onPressed: counterController.increment,
          // onPressed: counterController.test2,
          onPressed: counterController.test3,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

/**
 * 路由管理
 *
 * Get.to(SecondPage()); // 跳转到 SecondPage
 * Get.back(); // 返回上一页
 * Get.off(SecondPage()); // 替换当前页
 *
 * 依赖注入
 * Get.put<S>(
 *  // 必备：你想得到保存的类，比如控制器或其他东西。
 *  // 注："S "意味着它可以是任何类型的类。
 *  S dependency
 *
 *  // 可选：当你想要多个相同类型的类时，可以用这个方法。
 *  // 因为你通常使用Get.find<Controller>()来获取一个类。
 *  // 你需要使用标签来告诉你需要哪个实例。
 *  // 必须是唯一的字符串
 *  String tag,
 *
 *  // 可选：默认情况下，get会在实例不再使用后进行销毁
 *  // （例如：一个已经销毁的视图的Controller)
 *  // 但你可能需要这个实例在整个应用生命周期中保留在那里，就像一个sharedPreferences的实例或其他东西。
 *  //所以你设置这个选项
 *  // 默认值为false
 *  bool permanent = false,
 *
 *  // 可选：允许你在测试中使用一个抽象类后，用另一个抽象类代替它，然后再进行测试。
 *  // 默认为false
 *  bool overrideAbstract = false,
 *
 *  // 可选：允许你使用函数而不是依赖（dependency）本身来创建依赖。
 *  // 这个不常用
 *  InstanceBuilderCallback<S> builder,
 * )
 *
 * Get.lazyPut 可以懒加载一个依赖，这样它只有在使用时才会被实例化。
 * ///只有当第一次使用Get.find<ApiMock>时，ApiMock才会被调用。
 * Get.lazyPut<ApiMock>(() => ApiMock());
 *
 * Get.lazyPut<S>(
 *  // 强制性：当你的类第一次被调用时，将被执行的方法。
 *  InstanceBuilderCallback builder,
 *
 *  // 可选：和Get.put()一样，当你想让同一个类有多个不同的实例时，就会用到它。
 *  // 必须是唯一的
 *  String tag,
 *
 *  // 可选：类似于 "永久"，
 *  // 不同的是，当不使用时，实例会被丢弃，但当再次需要使用时，Get会重新创建实例，
 *  // 就像 bindings api 中的 "SmartManagement.keepFactory "一样。
 *  // 默认值为false
 *  bool fenix = false
 * )
 *
 * Get.putAsync注册一个异步实例
 * Get.putAsync<S>(
 *  // 必备：一个将被执行的异步方法，用于实例化你的类。
 *  AsyncInstanceBuilderCallback<S> builder,
 *
 *  // 可选：和Get.put()一样，当你想让同一个类有多个不同的实例时，就会用到它。
 *  // 必须是唯一的
 *  String tag,
 *
 *  // 可选：与Get.put()相同，当你需要在整个应用程序中保持该实例的生命时使用。
 *  // 默认值为false
 *  bool permanent = false
 * )
 *
 * https://blog.csdn.net/hengsf123456/article/details/124727287
 */
Future<void> main() async {
  /**
   * 确保 Flutter 框架已初始化，在调用 runApp() 之前进行异步初始化操作（如插件初始化、数据加载等），避免引发错误，
   * 还有一些依赖（例如数据库、Firebase）需要在框架初始化后才能进行配置。
   */
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => MyService().init()); // 注册依赖

  runApp(GetMaterialApp(
    initialRoute: '/',
    getPages: [
      GetPage(name: '/', page: () => GetXDemo3()),
      GetPage(name: '/second', page: () => GetXDemoSecondPage()),
    ],
  ));
}

class GetXDemo3 extends StatelessWidget {
  const GetXDemo3({super.key});

  @override
  Widget build(BuildContext context) {
    print('GetXDemo2:build');
    return Scaffold(
      appBar: AppBar(title: Text('GetX Demo3 - 需要运行demo12的main')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                Get.to(GetXDemoSecondPage(), arguments: {'name': 'John', 'age': 25});
              },
              child: Text("Click")),
          ElevatedButton(
              onPressed: () {
                Get.toNamed("/second", arguments: {'name': 'Tom', 'age': 33});
              },
              child: Text("Click2"))
        ],
      ),
    );
  }
}

class GetXDemoSecondPage extends StatelessWidget {
  const GetXDemoSecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final MyService service = Get.find<MyService>(); // 使用依赖
    return Scaffold(
      appBar: AppBar(title: Text('GetXDemoSecondPage')),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
                "back: ${args['name']}, Age: ${args['age']}, ${service.hashCode}, ${service.test()}, ${service.test2()}")),
      ),
    );
  }
}

class MyService extends GetxService {
  Future<MyService> init() async {
    print("Service initialized");
    return this;
  }
}

extension on MyService {
  int test() {
    return 100;
  }
}

extension on MyService {
  int test2() {
    return 200;
  }
}

Rx<T> combineLatest<T>(
  List<Rx> list,
  T Function(List<Rx>) combiner,
  void Function(void Function()) clean,
) {
  final result = Rx<T>(combiner(list));
  final lst = list.map((item) {
    return item.listen((data) {
      result.value = combiner(list);
    });
  }).toList();
  clean(() {
    for (var item in lst) {
      item.cancel();
    }
  });
  return result;
}

Rx<T> combineLatest3<T, X, Y, Z>(
  Rx<X> x,
  Rx<Y> y,
  Rx<Z> z,
  T Function(Rx<X>, Rx<Y>, Rx<Z>) combiner,
  void Function(void Function()) clean,
) {
  final result = Rx<T>(combiner(x, y, z));
  final List<StreamSubscription> lst = [];
  lst.add(x.listen((data) {
    result.value = combiner(x, y, z);
  }));
  lst.add(y.listen((data) {
    result.value = combiner(x, y, z);
  }));
  lst.add(z.listen((data) {
    result.value = combiner(x, y, z);
  }));
  clean(() {
    for (var item in lst) {
      item.cancel();
    }
  });
  return result;
}
