import 'package:flutter/material.dart';

/**
 * @author Raining
 * @date 2024-12-09 14:48
 *
 * #I# 状态管理
 */
class Demo3 {}

/**
 * 管理状态的最常见的方法：
 * 1. Widget 管理自己的状态。
 * 2. Widget 管理子 Widget 状态。
 * 3. 混合管理（父 Widget 和子 Widget 都管理状态）。
 *
 * 如何决定使用哪种管理方法？下面是官方给出的一些原则可以帮助你做决定：
 * 1. 如果状态是用户数据，如复选框的选中状态、滑块的位置，则该状态最好由父 Widget 管理。
 * 2. 如果状态是有关界面外观效果的，例如颜色、动画，那么状态最好由 Widget 本身来管理。
 * 3. 如果某一个状态是不同 Widget 共享的则最好由它们共同的父 Widget 管理。
 *
 * 在 Widget 内部管理状态封装性会好一些，而在父 Widget 中管理会比较灵活。有些时候，
 * 如果不确定到底该怎么管理状态，那么推荐的首选是在父 Widget 中管理（灵活会显得更重要一些）。
 */

/**
 * 管理自身状态
 */
class TapboxA extends StatefulWidget {
  const TapboxA({super.key});

  @override
  State<StatefulWidget> createState() => _TapboxAState();
}

class _TapboxAState extends State<TapboxA> {
  bool _active = false;

  void _handleTap() {
    setState(() {
      _active = !_active;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        width: 200.0,
        height: 200.0,
        decoration: BoxDecoration(
          color: _active ? Colors.lightGreen[700] : Colors.grey[600],
        ),
        child: Center(
          child: Text(
            _active ? 'Active' : 'Inactive',
            style: const TextStyle(fontSize: 32.0, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

/**
 * 父Widget管理子Widget的状态
 *
 * 点击后输出：
 * _ParentWidgetState#build
 * TapboxB#build
 */
class ParentWidget extends StatefulWidget {
  const ParentWidget({super.key});

  @override
  State<StatefulWidget> createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  bool _active = false;

  void _handleTapboxChanged(bool newValue) {
    setState(() {
      _active = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('_ParentWidgetState#build');
    return TapboxB(
      active: _active,
      onChanged: _handleTapboxChanged,
    );
  }
}

class TapboxB extends StatelessWidget {
  const TapboxB({super.key, this.active = false, required this.onChanged});

  final bool active;
  final ValueChanged<bool> onChanged;

  void _handleTap() {
    onChanged(!active);
  }

  @override
  Widget build(BuildContext context) {
    print('TapboxB#build');
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        width: 200.0,
        height: 200.0,
        decoration: BoxDecoration(
          color: active ? Colors.lightGreen[700] : Colors.grey[600],
        ),
        child: Center(
          child: Text(
            active ? 'Active' : 'Inactive',
            style: const TextStyle(fontSize: 32.0, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

/**
 * 混合状态管理
 */
class ParentWidgetC extends StatefulWidget {
  const ParentWidgetC({super.key});

  @override
  State<StatefulWidget> createState() => _ParentWidgetCState();
}

class _ParentWidgetCState extends State<ParentWidgetC> {
  bool _active = false;

  void _handleTapboxChanged(bool newValue) {
    setState(() {
      _active = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TapboxC(
      active: _active,
      onChanged: _handleTapboxChanged,
    );
  }
}

class TapboxC extends StatefulWidget {
  const TapboxC({super.key, this.active = false, required this.onChanged});

  final bool active;
  final ValueChanged<bool> onChanged;

  @override
  State<StatefulWidget> createState() => _TapboxCState();
}

class _TapboxCState extends State<TapboxC> {
  bool _highlight = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _highlight = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _highlight = false;
    });
  }

  void _handleTapCancel() {
    setState(() {
      _highlight = false;
    });
  }

  void _handleTap() {
    widget.onChanged(!widget.active);
  }

  @override
  Widget build(BuildContext context) {
    // 在按下时添加绿色边框，当抬起时，取消高亮
    return GestureDetector(
      onTapDown: _handleTapDown, // 处理按下事件
      onTapUp: _handleTapUp, // 处理抬起事件
      onTap: _handleTap,
      onTapCancel: _handleTapCancel,
      child: Container(
        width: 200.0,
        height: 200.0,
        decoration: BoxDecoration(
          color: widget.active ? Colors.lightGreen[700] : Colors.grey[600],
          border: _highlight
              ? Border.all(
                  color: Colors.teal[700]!,
                  width: 10.0,
                )
              : null,
        ),
        child: Center(
          child: Text(
            widget.active ? 'Active' : 'Inactive',
            style: const TextStyle(fontSize: 32.0, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

/**
 * 全局状态管理方案：
 *
 * 1. 实现一个全局的事件总线，将语言状态改变对应为一个事件，然后在APP中依赖应用语言的组件的initState 方法中订阅语言改变的事件。当用户在设置页切换语言后，我们发布语言改变事件，而订阅了此事件的组件就会收到通知，收到通知后调用setState(...)方法重新build一下自身即可。
 * 2. 使用一些专门用于状态管理的包，如 Provider、Redux，读者可以在 pub 上查看其详细信息。
 */