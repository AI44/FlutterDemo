import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/**
 * @author Raining
 * @date 2024-12-06 14:27
 *
 * #I# Widget测试
 */
class Demo2 {
  /**
   * 在Dart中，你可以通过定义只包含final字段的类来创建不可变对象。一旦这些字段在构造函数中被初始化，它们就不能再被修改。
   * 此外，Dart的集合类（如List、Set和Map）也有不可变的变体（如List.unmodifiable、Set.unmodifiable和Map.unmodifiable），
   * 它们提供了不可变的集合视图。
   */
  /**
   * Flutter中的四棵树（Widget 树、Element 树、Render 树、Layer 树）
   * 根据 Widget 树生成一个 Element 树，Element 树中的节点都继承自 Element 类。
   * 根据 Element 树生成 Render 树（渲染树），渲染树中的节点都继承自RenderObject 类。
   * 根据渲染树生成 Layer 树，然后上屏显示，Layer 树中的节点都继承自 Layer 类。
   * 真正的布局和渲染逻辑在 Render 树中，Element 是 Widget 和 RenderObject 的粘合剂，可以理解为一个中间代理。
   *
   * https://book.flutterchina.club/chapter2/flutter_widget_intro.html#_2-2-3-flutter中的四棵树
   */
}

class Echo extends StatelessWidget {
  /**
   * 必需要传的参数要添加required关键字。
   * 在继承 widget 时，第一个参数通常应该是Key。
   * 另外，如果 widget 需要接收子 widget ，那么child或children参数通常应被放在参数列表的最后。
   * 同样是按照惯例， widget 的属性应尽可能的被声明为final，防止被意外改变。
   */
  const Echo({Key? myKey, required this.text, this.backgroundColor = const Color.fromARGB(0xff, 0xff, 0, 0)})
      : super(key: myKey);

  final String text;
  final Color backgroundColor;

  /**
   * build方法有一个context参数，它是BuildContext类的一个实例，表示当前 widget 在 widget 树中的上下文，
   * 每一个 widget 都会对应一个 context 对象（因为每一个 widget 都是 widget 树上的一个节点）。
   */
  @override
  Widget build(BuildContext context) {
    return Center(child: Container(color: backgroundColor, child: Text(text)));
  }
}

class ContextRoute extends StatelessWidget {
  const ContextRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Context测试")),
        body: Container(child: Builder(builder: (context) {
          Scaffold? scaffold = context.findAncestorWidgetOfExactType<Scaffold>();
          return (scaffold?.appBar as AppBar).title ?? const Text("");
        })));
  }
}

/**
 * createState() 用于创建和 StatefulWidget 相关的状态，它在StatefulWidget 的生命周期中可能会被多次调用。
 * 例如，当一个 StatefulWidget 同时插入到 widget 树的多个位置时，Flutter 框架就会调用该方法为每一个位置生成一个独立的State实例，
 * 其实，本质上就是一个StatefulElement对应一个State实例。
 */

/**
 * 一个 StatefulWidget 类会对应一个 State 类，State表示与其对应的 StatefulWidget 要维护的状态，State 中的保存的状态信息可以：
 *
 * 1. 在 widget 构建时可以被同步读取。
 *
 * 2. 在 widget 生命周期中可以被改变，当State被改变时，可以手动调用其setState()方法通知Flutter 框架状态发生改变，
 * Flutter 框架在收到消息后，会重新调用其build方法重新构建 widget 树，从而达到更新UI的目的。
 */

/**
 * State 中有两个常用属性：
 *
 * 1. widget，它表示与该 State 实例关联的 widget 实例，由Flutter 框架动态设置。
 * 注意，这种关联并非永久的，因为在应用生命周期中，UI树上的某一个节点的 widget 实例在重新构建时可能会变化，
 * 但State实例只会在第一次插入到树中时被创建，当在重新构建时，如果 widget 被修改了，
 * Flutter 框架会动态设置State. widget 为新的 widget 实例。
 *
 * 2. context。StatefulWidget对应的 BuildContext，作用同StatelessWidget 的BuildContext。
 */

class StateLifecycleTest extends StatelessWidget {
  const StateLifecycleTest({super.key});

  @override
  Widget build(BuildContext context) {
    return const CounterWidget();
  }
}

class CounterWidget extends StatefulWidget {
  const CounterWidget({Key? myKey, this.initValue = 0}) : super(key: myKey);
  final int initValue;

  @override
  State<StatefulWidget> createState() => _CounterWidgetState();
}

/**
 * 运行app，打开页面后输出：
 * initState
 * didChangeDependencies
 * build
 *
 * 无改变，热重载，输出：
 * reassemble
 * build
 *
 * 移除widget后，热重载，输出：
 * reassemble
 * deactivate
 * dispose
 *
 * 点击按钮，输出：
 * build
 */
class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;

  /**
   * 当 widget 第一次插入到 widget 树时会被调用，对于每一个State对象，Flutter 框架只会调用一次该回调，
   * 所以，通常在该回调中做一些一次性的操作，如状态初始化、订阅子树的事件通知等。
   * 不能在该回调中调用BuildContext.dependOnInheritedWidgetOfExactType（正确做法在build（）方法或didChangeDependencies()中调用）。
   */
  @override
  void initState() {
    super.initState();
    _counter = widget.initValue;
    print("initState");
  }

  /**
   * 用于构建 widget 子树的，会在如下场景被调用：
   * 1. 在调用initState()之后。
   * 2. 在调用didUpdateWidget()之后。
   * 3. 在调用setState()之后。
   * 4. 在调用didChangeDependencies()之后。
   * 5. 在State对象从树中一个位置移除后（会调用deactivate）又重新插入到树的其他位置之后。
   */
  @override
  Widget build(BuildContext context) {
    print('build');
    return Scaffold(
      body: Center(
        child: TextButton(onPressed: () => setState(() => ++_counter), child: Text("$_counter")),
      ),
    );
  }

  /**
   * 在 widget 重新构建时，Flutter 框架会调用widget.canUpdate来检测 widget 树中同一位置的新旧节点，
   * 然后决定是否需要更新，如果widget.canUpdate返回true则会调用此回调。
   *
   * didUpdateWidget 什么情况回被调用：
   * 1. 父 widget 触发了重建‌：当父 widget 调用 setState 方法导致其子 widget 需要重新构建时，
   * 如果子 widget 是一个 StatefulWidget，并且其配置（即构造函数中接收的参数）发生了变化，
   * 那么 didUpdateWidget 会被调用。
   * 2. widget 配置发生变化‌：如果 StatefulWidget 的配置（即其属性）在父 widget 中被更改，
   * 并且这些更改导致该 widget 需要被重新构建，那么 didUpdateWidget 会在新的 widget 配置被应用到状态时调用。
   * 3. 不是每次重建都会调用‌：重要的是要注意，didUpdateWidget 并不是在每次 widget 重建时都会被调用。
   * 它只会在 widget 的配置实际发生变化时被调用。如果父 widget 触发了重建，但子 widget 的配置没有变化，
   * 那么 didUpdateWidget 不会被调用。
   *
   * 在 didUpdateWidget 方法中，你通常会执行一些与新的 widget 配置相关的逻辑，比如：
   * 1. 更新状态对象中的字段以反映新的配置。
   * 2. 触发动画或过渡效果来响应配置的变化。
   * 3. 重新配置或替换子 widget。
   */
  @override
  void didUpdateWidget(covariant CounterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('didUpdateWidget');
  }

  /**
   * 当 State 对象从树中被移除时，会调用此回调。在一些场景下，Flutter 框架会将 State 对象重新插到树中，
   * 如包含此 State 对象的子树在树的一个位置移动到另一个位置时（可以通过GlobalKey 来实现）。
   * 如果移除后没有重新插入到树中则紧接着会调用dispose()方法。
   */
  @override
  void deactivate() {
    super.deactivate();
    print('deactivate');
  }

  /**
   * 当 State 对象从树中被永久移除时调用；通常在此回调中释放资源。
   */
  @override
  void dispose() {
    super.dispose();
    print('dispose');
  }

  /**
   * 此回调是专门为了开发调试而提供的，在热重载(hot reload)时会被调用，此回调在Release模式下永远不会被调用。
   */
  @override
  void reassemble() {
    super.reassemble();
    print('reassemble');
  }

  /**
   * 当State对象的依赖发生变化时会被调用
   */
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('didChangeDependencies');
  }
}

class GetStateObjectRoute extends StatefulWidget {
  const GetStateObjectRoute({super.key});

  @override
  State<StatefulWidget> createState() => _GetStateObjectRouteState();
}

class _GetStateObjectRouteState extends State<GetStateObjectRoute> {
  static final GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: const Text("子树中获取State对象"),
      ),
      body: Center(
        child: Column(
          children: [
            Builder(builder: (context) {
              return ElevatedButton(
                  onPressed: () {
                    /**
                     * 一般来说，如果 StatefulWidget 的状态是私有的（不应该向外部暴露），那么我们代码中就不应该去直接获取其 State 对象；
                     * 如果StatefulWidget的状态是希望暴露出的（通常还有一些组件的操作方法），我们则可以去直接获取其State对象。
                     * 但是通过 context.findAncestorStateOfType 获取 StatefulWidget 的状态的方法是通用的，
                     * 我们并不能在语法层面指定 StatefulWidget 的状态是否私有，所以在 Flutter 开发中便有了一个默认的约定：
                     * 如果 StatefulWidget 的状态是希望暴露出的，应当在 StatefulWidget 中提供一个of 静态方法来获取其 State 对象，
                     * 开发者便可直接通过该方法来获取；如果 State不希望暴露，则不提供of方法。
                     */
                    // 查找父级最近的Scaffold对应的ScaffoldState对象
                    ScaffoldState? state = context.findAncestorStateOfType<ScaffoldState>();
                    // 打开抽屉菜单
                    state?.openDrawer();
                  },
                  child: const Text("打开抽屉菜单1"));
            }),
            Builder(builder: (context) {
              return ElevatedButton(
                  onPressed: () {
                    ScaffoldState state = Scaffold.of(context);
                    state.openDrawer();
                  },
                  child: const Text("打开抽屉菜单2"));
            }),
            Builder(builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("我是SnackBar")),
                  );
                },
                child: const Text('显示SnackBar'),
              );
            }),
            Builder(builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  /**
                   * GlobalKey 是 Flutter 提供的一种在整个 App 中引用 element 的机制。如果一个 widget 设置了GlobalKey，
                   * 那么我们便可以通过globalKey.currentWidget获得该 widget 对象、globalKey.currentElement来获得 widget 对应的element对象，
                   * 如果当前 widget 是StatefulWidget，则可以通过globalKey.currentState来获得该 widget 对应的state对象。
                   *
                   * 注意：使用 GlobalKey 开销较大，如果有其他可选方案，应尽量避免使用它。
                   * 另外，同一个 GlobalKey 在整个 widget 树中必须是唯一的，不能重复。
                   */
                  _globalKey.currentState?.openDrawer();
                },
                child: const Text('打开抽屉菜单3'),
              );
            }),
          ],
        ),
      ),
      drawer: const Drawer(),
    );
  }
}

/**
 * Flutter 提供了一套丰富、强大的基础组件，在基础组件库之上 Flutter 又提供了一套 Material 风格（ Android 默认的视觉风格）
 * 和一套 Cupertino 风格（iOS视觉风格）的组件库。要使用基础组件库，需要先导入：
 * ```
 * import 'package:flutter/widgets.dart';
 * ```
 * https://book.flutterchina.club/chapter2/flutter_widget_intro.html#_2-2-9-flutter-sdk内置组件库介绍
 */

/**
 * ios风格UI
 */
class CupertinoTestRoute extends StatelessWidget {
  const CupertinoTestRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text("Cupertino Demo"),
        ),
        child: Center(
          child: CupertinoButton(color: CupertinoColors.activeBlue, child: const Text("Press"), onPressed: () {}),
        ));
  }
}
