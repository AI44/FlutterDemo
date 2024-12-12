import 'package:flutter/material.dart';

/**
 * @author Raining
 * @date 2024-12-10 21:03
 *
 * #I# 布局
 */
class Demo9 {}

/**
 * 布局流程如下：
 * 1. 上层组件向下层组件传递约束（constraints）条件。
 * 2. 下层组件确定自己的大小，然后告诉上层组件。注意下层组件的大小必须符合父组件的约束。
 * 3. 上层组件确定下层组件相对于自身的偏移和确定自身的大小（大多数情况下会根据子组件的大小来确定自身的大小）。
 *
 * 任何时候子组件都必须先遵守父组件的约束。
 *
 * 盒模型布局组件有两个特点：
 * 1. 组件对应的渲染对象都继承自 RenderBox 类。
 * 2. 在布局过程中父级传递给子级的约束信息由 BoxConstraints 描述。
 *
 * LeafRenderObjectWidget：非容器类组件基类，Widget树的叶子节点，用于没有子节点的widget，通常基础组件都属于这一类，如Image。
 * SingleChildRenderObjectWidget：单子组件基类，包含一个子Widget，如：ConstrainedBox、DecoratedBox等。
 * MultiChildRenderObjectWidget：多子组件基类，包含多个子Widget，一般都有一个children参数，接受一个Widget数组。如Row、Column、Stack等。
 *
 * 继承关系 Widget > RenderObjectWidget > (Leaf/SingleChild/MultiChild)RenderObjectWidget。
 *
 * BoxConstraints 是盒模型布局过程中父渲染对象传递给子渲染对象的`约束信息`。
 * ConstrainedBox 用于对子组件添加额外的约束。
 * SizedBox 用于给子元素指定固定的宽高。
 * AspectRatio 可以指定子组件的长宽比。
 * LimitedBox 用于指定最大宽高。
 * FractionallySizedBox 可以根据父容器宽高的百分比来设置子组件宽高。
 *
 * 线性布局（Row和Column）
 * mainAxisSize：表示Row在主轴(水平)方向占用的空间，默认是MainAxisSize.max，表示尽可能多的占用水平方向的空间。
 * mainAxisAlignment：表示子组件在Row所占用的水平空间内对齐方式，如果mainAxisSize值为MainAxisSize.min，则此属性无意义。
 * 如果Row里面嵌套Row，或者Column里面再嵌套Column，那么只有最外面的Row或Column会占用尽可能大的空间，里面Row或Column所占用的空间为实际大小。
 *
 * 让里面的Column占满外部Column，可以使用Expanded 组件
 *
 * Flex 弹性布局，Row和Column都继承自Flex，
 * required this.direction, //弹性布局的方向, Row默认为水平方向，Column默认为垂直方向。
 * Expanded 只能作为 Flex 的 children。
 *
 * Stack允许子组件堆叠，而Positioned用于根据Stack的四个角来确定子组件的位置。
 *
 * Align 对齐与相对定位
 * widthFactor和heightFactor是用于确定Align 组件本身宽高的属性；它们是两个缩放因子，
 * 会分别乘以子元素的宽、高，最终的结果就是Align 组件的宽高。如果值为null，则组件的宽高将会占用尽可能多的空间。
 */

class LayoutDemo extends StatelessWidget {
  const LayoutDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LayoutDemo"),
        // 因为AppBar中已经指定了actions按钮的约束条件，所以我们要自定义loading按钮大小，就必须通过UnconstrainedBox来 “去除” 父元素的限制
        actions: const <Widget>[
          UnconstrainedBox(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation(Colors.green),
              ),
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, // 控件本身位置
        crossAxisAlignment: CrossAxisAlignment.start, // 相当于内部gravity
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: double.infinity, //宽度尽可能大
              minHeight: 50.0, //最小高度为50像素
            ),
            child: const SizedBox(
              height: 5.0,
              child: DecoratedBox(decoration: BoxDecoration(color: Colors.red)),
            ),
          ),
          const SizedBox(
            width: 80.0,
            height: 80.0,
            child: DecoratedBox(decoration: BoxDecoration(color: Colors.red)),
          ),
          // 上面代码等价于下面
          ConstrainedBox(
            constraints: const BoxConstraints.tightFor(width: 80.0, height: 80.0),
            // 等价于：BoxConstraints(minHeight: 80.0,maxHeight: 80.0,minWidth: 80.0,maxWidth: 80.0)
            child: const DecoratedBox(decoration: BoxDecoration(color: Colors.red)),
          ),
          // 而实际上ConstrainedBox和SizedBox都是通过RenderConstrainedBox来渲染的。
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 60.0, minHeight: 60.0), //父
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 90.0, minHeight: 20.0), //子
              child: const DecoratedBox(decoration: BoxDecoration(color: Colors.red)),
            ),
          ),
          /**
           * 多重限制时，对于minWidth和minHeight来说，是取父子中相应数值较大的。
           * 对于maxWidth和maxHeight，是取父子中相应数值较小的。
           */
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 90.0, minHeight: 20.0), //父
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 60.0, minHeight: 60.0), //子
              child: const DecoratedBox(decoration: BoxDecoration(color: Colors.red)),
            ),
          ),
          ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 60.0, minHeight: 100.0), //父
              child: UnconstrainedBox(
                /**
                 * 如果没有中间的UnconstrainedBox，那么根据多重限制规则，那么最终将显示一个90×100的红色框。
                 * 但是由于UnconstrainedBox “去除”了父ConstrainedBox的限制，
                 * 则最终会按照子ConstrainedBox的限制来绘制redBox，即90×20。
                 *
                 * “去除”父级限制，但上方仍然有80的空白空间，也就是说父限制的minHeight(100.0)仍然是生效的，
                 * 只不过它不影响最终子元素redBox的大小，但仍然还是占有相应的空间。
                 * 任何时候子组件都必须遵守其父组件的约束。
                 * 需要注意，UnconstrainedBox 虽然在其子组件布局时可以取消约束（子组件可以为无限大），
                 * 但是 UnconstrainedBox 自身是受其父组件约束的，所以当 UnconstrainedBox 随着其子组件变大后，
                 * 如果UnconstrainedBox 的大小超过它父组件约束时，也会导致溢出报错。
                 */
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 90.0, minHeight: 20.0), //子
                  child: const DecoratedBox(decoration: BoxDecoration(color: Colors.red)),
                ),
              )),
        ],
      ),
    );
  }
}

class LayoutDemo2 extends StatelessWidget {
  const LayoutDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("LayoutDemo2"),
        ),
        body: Container(
          color: Colors.green,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max, //有效，外层Colum高度为整个屏幕
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Colors.red,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center, //垂直方向居中对齐
                      children: <Widget>[
                        Text("hello world "),
                        Text("I am Jack "),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class LayoutDemo3 extends StatelessWidget {
  const LayoutDemo3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("LayoutDemo3"),
        ),
        body: Column(
          children: <Widget>[
            //Flex的两个子widget按1：2来占据水平空间
            Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                /**
                 * flex参数为弹性系数，如果为 0 或null，则child是没有弹性的，即不会被扩伸占用的空间。
                 * 如果大于0，所有的Expanded按照其 flex 的比例来分割主轴的全部空闲空间。
                 * 类似android LinearLayout的weight
                 */
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 30.0,
                    color: Colors.red,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 30.0,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: SizedBox(
                height: 100.0,
                //Flex的三个子widget，在垂直方向按2：1：1来占用100像素的空间
                child: Flex(
                  direction: Axis.vertical,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        // height: 30.0, // 无效
                        color: Colors.red,
                      ),
                    ),
                    /**
                     * Spacer的功能是占用指定比例的空间，实际上它只是Expanded的一个包装类
                     */
                    const Spacer(flex: 1),
                    Expanded(
                      flex: 1,
                      child: Container(
                        // height: 30.0, // 无效
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

/**
 * wrap的使用
 *
 * flow 的使用查看
 * https://book.flutterchina.club/chapter4/wrap_and_flow.html#_4-5-1-wrap
 */
class LayoutDemo4 extends StatelessWidget {
  const LayoutDemo4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LayoutDemo4"),
      ),
      body: const Wrap(
        spacing: 8.0, // 主轴(水平)方向间距
        runSpacing: 4.0, // 纵轴（垂直）方向间距
        alignment: WrapAlignment.center, //沿主轴方向居中
        children: <Widget>[
          Chip(
            avatar: CircleAvatar(backgroundColor: Colors.blue, child: Text('A')),
            label: Text('Hamilton'),
          ),
          Chip(
            avatar: CircleAvatar(backgroundColor: Colors.blue, child: Text('M')),
            label: Text('Lafayette'),
          ),
          Chip(
            avatar: CircleAvatar(backgroundColor: Colors.blue, child: Text('H')),
            label: Text('Mulligan'),
          ),
          Chip(
            avatar: CircleAvatar(backgroundColor: Colors.blue, child: Text('J')),
            label: Text('Laurens'),
          ),
        ],
      ),
    );
  }
}

/**
 * Stack使用，可以堆叠，类似FrameLayout
 *
 * fit：StackFit.loose表示使用子组件的大小，StackFit.expand表示扩伸到Stack的大小。
 * clipBehavior：此属性决定对超出Stack显示空间的部分如何剪裁，Clip枚举类中定义了剪裁的方式，Clip.hardEdge 表示直接剪裁，不应用抗锯齿。
 */
class LayoutDemo5 extends StatelessWidget {
  const LayoutDemo5({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LayoutDemo5"),
      ),
      body: //通过ConstrainedBox来确保Stack占满屏幕
          ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Stack(
          alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
          // fit: StackFit.expand, //未定位widget占满Stack整个空间
          children: <Widget>[
            Container(
              color: Colors.red,
              child: const Text("Hello world", style: TextStyle(color: Colors.white)),
            ),
            const Positioned(
              left: 18.0,
              child: Text("I am Jack"),
            ),
            const Positioned(
              top: 18.0,
              child: Text("Your friend"),
            )
          ],
        ),
      ),
    );
  }
}

/**
 * Align 布局测试
 *
 * Alignment(-1.0, -1.0) 代表矩形的左侧顶点，而Alignment(1.0, 1.0)代表右侧底部终点，而Alignment(1.0, -1.0) 则正是右侧顶点
 * 实际偏移 = (Alignment.x * (parentWidth - childWidth) / 2 + (parentWidth - childWidth) / 2,
 *           Alignment.y * (parentHeight - childHeight) / 2 + (parentHeight - childHeight) / 2)
 *
 * Align和Stack/Positioned区别：
 * 1. 定位参考系统不同；Stack/Positioned定位的参考系可以是父容器矩形的四个顶点；而Align则需要先通过alignment 参数来确定坐标原点，
 *    不同的alignment会对应不同原点，最终的偏移是需要通过alignment的转换公式来计算出。
 * 2. Stack可以有多个子元素，并且子元素可以堆叠，而Align只能有一个子元素，不存在堆叠。
 *
 * Center继承自Align
 */
class LayoutDemo6 extends StatelessWidget {
  const LayoutDemo6({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LayoutDemo5"),
      ),
      body: Column(
        children: [
          Container(
            // height: 120.0,
            // width: 120.0,
            color: Colors.blue.shade50,
            child: const Align(
              widthFactor: 3, // 因为FlutterLogo的宽高为 60，则Align的最终宽高都为3*60=180
              heightFactor: 3,
              alignment: Alignment.topRight,
              child: FlutterLogo(
                size: 60,
              ),
            ),
          ),
          Container(
            color: Colors.blue.shade50,
            child: const Align(
              widthFactor: 2,
              heightFactor: 2,
              alignment: Alignment(2, 0.0),
              child: FlutterLogo(
                size: 60,
              ),
            ),
          ),
          Container(
            height: 120.0,
            width: 120.0,
            color: Colors.blue[50],
            child: const Align(
              /**
               * 实际偏移 = (FractionalOffset.x * (parentWidth - childWidth), FractionalOffset.y * (parentHeight - childHeight))
               */
              alignment: FractionalOffset(0.2, 0.6), // 实际偏移为（12，36）
              child: FlutterLogo(
                size: 60,
              ),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(color: Colors.red),
            child: Center(
              child: Text("xxx"),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(color: Colors.red),
            child: Center(
              widthFactor: 1,
              heightFactor: 1,
              child: Text("xxx"),
            ),
          ),
        ],
      ),
    );
  }
}

/**
 * LayoutBuilder
 * 可以在布局过程中拿到父组件传递的约束信息，然后我们可以根据约束信息动态的构建不同的布局。
 */
class LayoutDemo7 extends StatelessWidget {
  const LayoutDemo7({super.key});

  @override
  Widget build(BuildContext context) {
    var children = List.filled(6, const Text("A"));
    // Column在本示例中在水平方向的最大宽度为屏幕的宽度
    return Scaffold(
      appBar: AppBar(
        title: const Text("LayoutDemo7"),
      ),
      body: Column(
        children: [
          // 限制宽度为190，小于 200
          SizedBox(width: 190, child: ResponsiveColumn(children: children)),
          ResponsiveColumn(children: children),
          const LayoutLogPrint(child: Text("xx")) // 打印布局信息
        ],
      ),
    );
  }
}

class ResponsiveColumn extends StatelessWidget {
  const ResponsiveColumn({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    // 通过 LayoutBuilder 拿到父组件传递的约束，然后判断 maxWidth 是否小于200
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        print('width:${constraints.maxWidth}');
        if (constraints.maxWidth < 200) {
          // 父控件最大宽度小于200，显示单列
          return Column(mainAxisSize: MainAxisSize.min, children: children);
        } else {
          // 父控件宽度大于200，显示双列
          var widgets = <Widget>[];
          for (var i = 0; i < children.length; i += 2) {
            if (i + 1 < children.length) {
              widgets.add(Row(
                mainAxisSize: MainAxisSize.min,
                children: [children[i], children[i + 1]],
              ));
            } else {
              widgets.add(children[i]);
            }
          }
          return Column(mainAxisSize: MainAxisSize.min, children: widgets);
        }
      },
    );
  }
}

/**
 * 使用例子：
 * LayoutLogPrint(tag: 1, child: wRow(' 800 ')),
 * FittedBox(child: LayoutLogPrint(tag: 2, child: wRow(' 800 '))),
 */
class LayoutLogPrint<T> extends StatelessWidget {
  const LayoutLogPrint({
    super.key,
    this.tag,
    required this.child,
  });

  final Widget child;
  final T? tag; //指定日志tag

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      // assert在编译release版本时会被去除
      assert(() {
        print('${tag ?? key ?? child}: $constraints');
        return true;
      }());
      return child;
    });
  }
}
