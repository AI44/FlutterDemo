import 'package:flutter/material.dart';

import 'PageProvider.dart';
import 'demo1.dart';
import 'demo2.dart';
import 'demo4.dart';

void main() {
  print("--------------- start main");
  Demo1().run();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final List<ItemData> list = PageProvider.getData();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // 构建router
    Map<String, WidgetBuilder> router = {
      "Page2": (context) => Page2(text: ModalRoute.of(context)?.settings.arguments.toString() ?? ""),
    };
    for (var item in list) {
      router[item.key] = item.builder;
    }

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: router,
      /**
       * 可以通过onGenerateRoute做一些全局的路由跳转前置处理逻辑。
       *
       * MaterialApp有一个onGenerateRoute属性，它在打开命名路由时可能会被调用，之所以说可能，
       * 是因为当调用Navigator.pushNamed(...)打开命名路由时，如果指定的路由名在路由表中已注册，
       * 则会调用路由表中的builder函数来生成路由组件；如果路由表中没有注册，才会调用onGenerateRoute来生成路由。
       *
       * 要实现上面控制页面权限的功能就非常容易：我们放弃使用路由表，
       * 取而代之的是提供一个onGenerateRoute回调，然后在该回调中进行统一的权限控制
       */
      // onGenerateRoute: (settings) {
      //   return MaterialPageRoute(builder: (context) {
      //     String routeName = settings.name ?? "";
      //     // 如果访问的路由页需要登录，但当前未登录，则直接返回登录页路由，
      //     // 引导用户登录；其他情况则正常打开路由。
      //   });
      // },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/**
 * 对于StatefulWidget，将build方法放在 State 中，可以给开发带来很大的灵活性
 */
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    // 将状态更新逻辑封装在一个方法中，可以确保状态的更新是原子性的。当setState被调用时，Flutter框架会确保在状态更新和UI重建之间不会发生其他状态更改。
    // 如果有多个setState调用在短时间内发生，它们可能会被合并为一个UI更新。
    // setState的参数方法回调是在你调用setState时立即执行的，但UI的更新会在未来的某个时间点发生，这取决于Flutter框架的事件循环和渲染管道。
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('#################### main build');
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    // return const ContextRoute();
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("${widget.title}456"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // 如果没有声明const，那么重建时会调用TestRebuild#build
            const TestRebuild(),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const TestRebuild2(),
            Expanded(
                child: ListView.builder(
                    itemCount: PageProvider.getData().length,
                    itemExtent: 40.0,
                    itemBuilder: (context, index) {
                      var list = PageProvider.getData();
                      var item = list[index];
                      return ListTile(
                        title: Text(item.title),
                        onTap: () {
                          Navigator.of(context).pushNamed(item.key);
                        },
                      );
                    })),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.startFloat, // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class TestRebuild extends StatelessWidget {
  const TestRebuild({super.key});

  @override
  Widget build(BuildContext context) {
    print('#################### TestRebuild build');
    return const Text(
      'You have pushed the button this many times:',
    );
  }
}

class TestRebuild2 extends StatefulWidget {
  const TestRebuild2({super.key});

  @override
  State<StatefulWidget> createState() => TestRebuild2State();
}

class TestRebuild2State extends State<TestRebuild2> {
  @override
  Widget build(BuildContext context) {
    print('#################### TestRebuild2 build');
    return const Echo(text: "start12345678901234567890123456789012345678901234567890end");
  }
}
