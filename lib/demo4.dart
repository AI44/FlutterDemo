import 'package:flutter/material.dart';

/**
 * @author Raining
 * @date 2024-12-09 16:26
 * #I# 页面路由管理
 */
class Demo4 {}

/**
 * 简单页面跳转
 */
class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Page1"),
      ),
      backgroundColor: Colors.pink,
      body: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: () async {
                /**
                 * Navigator.push(BuildContext context, Route route)等价于Navigator.of(context).push(Route route)
                 */
                var result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const Page2(text: "往page2传递参数");
                }));
                print('$result');
              },
              child: const Text(
                "This is Page1",
                style: TextStyle(color: Colors.white, fontSize: 40),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed("Page2", arguments: "hi");
              },
              child: const Text("scheme跳转方式", style: TextStyle(color: Colors.white, fontSize: 40)),
            ),
          ],
        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({Key? myKey, required this.text}) : super(key: myKey);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Page2"),
      ),
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          children: [
            Text(
              "This is Page2: $text",
              style: const TextStyle(color: Colors.white, fontSize: 40),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, "页面返回值");
                },
                child: const Text("返回"))
          ],
        ),
      ),
    );
  }
}
