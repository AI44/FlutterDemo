import 'package:flutter/material.dart';

/**
 * @author Raining
 * @date 2024-12-11 17:14
 *
 * #I# 容器类组件
 */
class Demo10 {}

class ContainerDemo extends StatelessWidget {
  const ContainerDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ContainerDemo"),
      ),
      body: Column(
        children: [
          /**
           * padding 设置边距
           *
           * 1. fromLTRB(double left, double top, double right, double bottom)：分别指定四个方向的填充。
           * 2. all(double value) : 所有方向均使用相同数值的填充。
           * 3. only({left, top, right ,bottom })：可以设置具体某个方向的填充(可以同时指定多个方向)。
           * 4. symmetric({ vertical, horizontal })：用于设置对称方向的填充，vertical指top和bottom，horizontal指left和right。
           */
          const Padding(
            //上下左右各添加16像素补白
            padding: EdgeInsets.all(16),
            child: Column(
              //显式指定对齐方式为左对齐，排除对齐干扰
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  //左边添加8像素补白
                  padding: EdgeInsets.only(left: 8),
                  child: Text("Hello world"),
                ),
                Padding(
                  //上下各添加8像素补白
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text("I am Jack"),
                ),
                Padding(
                  // 分别指定四个方向的补白
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Text("Your friend"),
                )
              ],
            ),
          ),
          /**
           * DecoratedBox可以在其子组件绘制前(或后)绘制一些装饰（Decoration），如背景、边框、渐变等。
           * decoration：代表将要绘制的装饰，它的类型为Decoration。Decoration是一个抽象类，它定义了一个接口 createBoxPainter()，子类的主要职责是需要通过实现它来创建一个画笔，该画笔用于绘制装饰。
           * position：此属性决定在哪里绘制Decoration，它接收DecorationPosition的枚举类型，该枚举类有两个值：
           *    background：在子组件之后绘制，即背景装饰。
           *    foreground：在子组件之上绘制，即前景。
           */
          DecoratedBox(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.red, Colors.orange.shade700]), //背景渐变
                  borderRadius: BorderRadius.circular(3.0), //3像素圆角
                  boxShadow: const [
                    //阴影
                    BoxShadow(color: Colors.black54, offset: Offset(2.0, 2.0), blurRadius: 4.0)
                  ]),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 18.0),
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              )),
          /**
           * Transform可以在其子组件绘制时对其应用一些矩阵变换来实现一些特效。
           *
           * Transform的变换是应用在绘制阶段，而并不是应用在布局(layout)阶段，所以无论对子组件应用何种变化，
           * 其占用空间的大小和在屏幕上的位置都是固定不变的，因为这些是在布局阶段就确定的。
           *
           * 由于矩阵变化只会作用在绘制阶段，所以在某些场景下，在UI需要变化时，可以直接通过矩阵变化来达到视觉上的UI改变，
           * 而不需要去重新触发build流程，这样会节省layout的开销，所以性能会比较好。如之前介绍的Flow组件，它内部就是用矩阵变换来更新UI，
           * 除此之外，Flutter的动画组件中也大量使用了Transform以提高性能。
           */
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 60),
            child: Container(
              color: Colors.black,
              child: Transform(
                alignment: Alignment.topRight, //相对于坐标系原点的对齐方式
                transform: Matrix4.skewY(0.3), //沿Y轴倾斜0.3弧度
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.deepOrange,
                  child: const Text('Apartment for rent!'),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DecoratedBox(
                  decoration: const BoxDecoration(color: Colors.red),
                  child: Transform.scale(scale: 1.5, child: const Text("Hello world"))),
              const Text("你好", style: TextStyle(color: Colors.green, fontSize: 18.0))
            ],
          ),
          /**
           * RotatedBox
           * RotatedBox和Transform.rotate功能相似，它们都可以对子组件进行旋转变换，
           * 但是有一点不同：RotatedBox的变换是在layout阶段，会影响在子组件的位置和大小。
           *
           * 由于RotatedBox是作用于layout阶段，所以子组件会旋转90度（而不只是绘制的内容），
           * decoration会作用到子组件所占用的实际空间上
           */
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(color: Colors.red),
                //将Transform.rotate换成RotatedBox
                child: RotatedBox(
                  quarterTurns: 1, //旋转90度(1/4圈)
                  child: Text("Hello world"),
                ),
              ),
              Text(
                "你好",
                style: TextStyle(color: Colors.green, fontSize: 18.0),
              )
            ],
          ),
          /**
           * Container
           * Container是一个组合类容器，它本身不对应具体的RenderObject，它是DecoratedBox、ConstrainedBox、Transform、
           * Padding、Align等组件组合的一个多功能容器，所以我们只需通过一个Container组件可以实现同时需要装饰、变换、限制的场景。
           *
           * Container({
           *   this.alignment,
           *   this.padding, //容器内补白，属于decoration的装饰范围
           *   Color color, // 背景色
           *   Decoration decoration, // 背景装饰，color和decoration是互斥的
           *   Decoration foregroundDecoration, //前景装饰
           *   double width,//容器的宽度
           *   double height, //容器的高度
           *   BoxConstraints constraints, //容器大小的限制条件
           *   this.margin,//容器外补白，不属于decoration的装饰范围
           *   this.transform, //变换
           *   this.child,
           *   ...
           * })
           */
          Container(
            // 容器内补白
            padding: const EdgeInsets.all(20.0),
            margin: const EdgeInsets.only(top: 50.0, left: 20.0),
            // 卡片大小
            constraints: const BoxConstraints.tightFor(width: 200.0, height: 150.0),
            decoration: const BoxDecoration(
              //背景装饰
              gradient: RadialGradient(
                //背景径向渐变
                colors: [Colors.red, Colors.orange],
                center: Alignment.topLeft,
                radius: .98,
              ),
              boxShadow: [
                //卡片阴影
                BoxShadow(
                  color: Colors.black54,
                  offset: Offset(2.0, 2.0),
                  blurRadius: 4.0,
                )
              ],
            ),
            // 卡片倾斜变换
            transform: Matrix4.rotationZ(.2),
            // 卡片内文字居中
            alignment: Alignment.center,
            child: const Text(
              //卡片文字
              "5.20", style: TextStyle(color: Colors.white, fontSize: 40.0),
            ),
          ),
        ],
      ),
    );
  }
}

class ContainerDemo2 extends StatelessWidget {
  const ContainerDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    // 头像
    Widget avatar = Image.asset("graphics/background.jpg", width: 100.0);

    return Scaffold(
        appBar: AppBar(
          title: const Text("ContainerDemo2"),
        ),
        body: Column(children: [
          avatar, //不剪裁
          ClipOval(child: avatar), //剪裁为圆形
          ClipRRect(
            //剪裁为圆角矩形
            borderRadius: BorderRadius.circular(5.0),
            child: avatar,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                widthFactor: .5, //宽度设为原来宽度一半，另一半会溢出
                child: avatar,
              ),
              const Text(
                "你好世界",
                style: TextStyle(color: Colors.green),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ClipRect(
                //将溢出部分剪裁
                child: Align(
                  alignment: Alignment.topLeft,
                  widthFactor: .5, //宽度设为原来宽度一半
                  child: avatar,
                ),
              ),
              const Text("你好世界", style: TextStyle(color: Colors.green))
            ],
          ),
          DecoratedBox(
            decoration: const BoxDecoration(color: Colors.red),
            child: ClipRect(
                clipper: MyClipper(), //使用自定义的clipper
                child: avatar),
          ),
        ]));
  }
}

class MyClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) => const Rect.fromLTWH(10.0, 15.0, 40.0, 30.0);

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}

/**
 * FittedBox
 *
 * const FittedBox({
 *   Key? key,
 *   this.fit = BoxFit.contain, // 适配方式
 *   this.alignment = Alignment.center, //对齐方式
 *   this.clipBehavior = Clip.none, //是否剪裁
 *   Widget? child,
 * })
 *
 * 适配原理
 * 1. FittedBox 在布局子组件时会忽略其父组件传递的约束，可以允许子组件无限大，
 *    即FittedBox 传递给子组件的约束为（0<=width<=double.infinity, 0<= height <=double.infinity）。
 * 2. FittedBox 对子组件布局结束后就可以获得子组件真实的大小。
 * 3. FittedBox 知道子组件的真实大小也知道他父组件的约束，那么FittedBox 就可以通过指定的适配方式（BoxFit 枚举中指定），
 *    让起子组件在 FittedBox 父组件的约束范围内按照指定的方式显示。
 *
 *
 */
class ContainerDemo3 extends StatelessWidget {
  const ContainerDemo3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("ContainerDemo3"),
        ),
        body: Column(children: [
          /**
           * 因为父Container要比子Container 小，所以当没有指定任何适配方式时，
           * 子组件会按照其真实大小进行绘制，所以第一个蓝色区域会超出父组件的空间，因而看不到红色区域。
           *
           * 要注意一点，在未指定适配方式时，虽然 FittedBox 子组件的大小超过了 FittedBox 父 Container 的空间，
           * 但FittedBox 自身还是要遵守其父组件传递的约束，所以最终 FittedBox 的本身的大小是 50×50，
           * 这也是为什么蓝色会和下面文本重叠的原因，因为在布局空间内，父Container只占50×50的大小，
           * 接下来文本会紧挨着Container进行布局，而此时Container 中有子组件的大小超过了自己，
           * 所以最终的效果就是绘制范围超出了Container，但布局位置是正常的，所以就重叠了。
           */
          wContainer(BoxFit.none), // wContainer2 会把超出部分裁剪掉
          const Text('Wendux'),
          /**
           * BoxFit.contain，含义是按照子组件的比例缩放，尽可能多的占据父组件空间，
           * 因为子组件的长宽并不相同，所以按照比例缩放适配父组件后，父组件能显示一部分。
           */
          wContainer(BoxFit.contain),
          const Text('Flutter中国'),
        ]));
  }
}

Widget wContainer(BoxFit boxFit) {
  return Container(
    width: 50,
    height: 50,
    color: Colors.red,
    child: FittedBox(
      fit: boxFit,
      // 子容器超过父容器大小
      child: Container(width: 60, height: 100, color: Colors.blue),
    ),
  );
}

Widget wContainer2(BoxFit boxFit) {
  return ClipRect(
      child: Container(
    width: 50,
    height: 50,
    color: Colors.red,
    child: FittedBox(
      fit: boxFit,
      // 子容器超过父容器大小
      child: Container(width: 60, height: 100, color: Colors.blue),
    ),
  ));
}

/**
 * 单行缩放布局
 */
class ContainerDemo4 extends StatelessWidget {
  const ContainerDemo4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("ContainerDemo3"),
        ),
        body: Center(
          child: Column(
            children: [
              wRow(' 90000000000000000 '),
              SingleLineFittedBox(child: wRow(' 90000000000000000 ')),
              wRow(' 800 '),
              SingleLineFittedBox(child: wRow(' 800 ')),
            ].map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: e,
                    )).toList(),
          ),
        ));
  }

  Widget wRow(String text) {
    Widget child = Text(text);
    child = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [child, child, child],
    );
    return child;
  }
}

class SingleLineFittedBox extends StatelessWidget {
  const SingleLineFittedBox({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return FittedBox(
          child: ConstrainedBox(
            constraints: constraints.copyWith(
              minWidth: constraints.maxWidth,
              maxWidth: double.infinity,
              //让 maxWidth 使用屏幕宽度
              // maxWidth: constraints.maxWidth,
            ),
            child: child,
          ),
        );
      },
    );
  }
}
