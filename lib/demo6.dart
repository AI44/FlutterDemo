/**
 * @author Raining
 * @date 2024-12-10 11:24
 *
 * #I# flutter 调试
 */
class Demo6 {}

/**
 * debugger(when: offset > 30.0);
 *
 * print
 * debugPrint（它封装了 print，将一次输出的内容长度限制在一个级别（内容过多时会分批输出），避免被Android内核丢弃）
 * flutter logs（基本上是一个包装adb logcat）
 *
 * debugDumpApp() 转储Widgets树的状态（我们编写自己的widget，则可以通过覆盖debugFillProperties()来添加信息）
 *
 * toStringDeepwidget
 *
 * debugDumpRenderTree() 转储渲染树
 *
 * debugDumpLayerTree() 转储Layer树
 *
 * debugDumpSemanticsTree() 转储语义树
 *
 * 要找出相对于帧的开始/结束事件发生的位置，可以切换debugPrintBeginFrameBanner
 * 和 debugPrintEndFrameBanner 布尔值以将帧的开始和结束打印到控制台。
 *
 * debugPaintSizeEnabled为true以可视方式调试布局问题。设置它的最简单方法是在void main()的顶部设置。
 *
 * debugPaintBaselinesEnabled 做了类似的事情，但对于具有基线的对象，
 * 文字基线以绿色显示，表意(ideographic)基线以橙色显示。
 *
 * debugPaintPointersEnabled 标志打开一个特殊模式，任何正在点击的对象都会以深青色突出显示。
 * 这可以帮助我们确定某个对象是否以某种不正确的方式进行hit测试（Flutter检测点击的位置是否有能响应用户操作的widget）
 *
 * 如果我们尝试调试合成图层，例如以确定是否以及在何处添加RepaintBoundary widget，则可以使用debugPaintLayerBordersEnabled 标志，
 * 该标志用橙色或轮廓线标出每个层的边界，或者使用debugRepaintRainbowEnabled 标志， 只要他们重绘时，这会使该层被一组旋转色所覆盖。
 *
 * 动画调试
 * 调试动画最简单的方法是减慢它们的速度。为此，请将timeDilation 变量（在scheduler库中）设置为大于1.0的数字，例如50.0。
 * 最好在应用程序启动时只设置一次。如果我们在运行中更改它，尤其是在动画运行时将其值改小，则在观察时可能会出现倒退，
 * 这可能会导致断言命中，并且这通常会干扰我们的开发工作。
 *
 * 性能调试
 * 要了解我们的应用程序导致重新布局或重新绘制的原因，我们可以分别设置debugPrintMarkNeedsLayoutStacks
 * 和 debugPrintMarkNeedsPaintStacks 标志。 每当渲染盒被要求重新布局和重新绘制时，这些都会将堆栈跟踪记录到控制台。
 * 如果这种方法对我们有用，我们可以使用services库中的debugPrintStack()方法按需打印堆栈痕迹。
 *
 * 统计应用启动时间
 * flutter run --trace-startup --profile
 * 跟踪输出保存为start_up_info.json，在Flutter工程目录在build目录下。
 * 输出列出了从应用程序启动到这些跟踪事件（以微秒捕获）所用的时间：
 * 1. 进入Flutter引擎时.
 * 2. 展示应用第一帧时.
 * 3. 初始化Flutter框架时.
 * 4. 完成Flutter框架初始化时.
 *
 * 测量Dart任意代码段的wall/CPU时间：
 * Timeline.startSync('interesting function');
 * // iWonderHowLongThisTakes();
 * Timeline.finishSync();
 * 请确保运行flutter run时带有--profile标志，以确保运行时性能特征与我们的最终产品差异最小。
 *
 * Flutter DevTools 是 Flutter 可视化调试工具
 */
