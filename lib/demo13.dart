import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutterdemo/dartExt.dart';
import 'package:get/get.dart';
import 'package:vector_math/vector_math_64.dart';

/**
 * @author Raining
 * @date 2024-12-25 14:51
 *
 * #I# 绘图 & 事件
 */
class CustomWidget extends StatelessWidget {
  CustomWidget({super.key});

  final manager = RenderManager().obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CustomWidget")),
      body: Expanded(
        child: LayoutBuilder(builder: (context, constraints) {
          return Listener(
            child: ObxValue((value) {
              return CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: MatrixPainter(manager.value.renderList), // 必须要使用value，否则Obx报错
              );
            }, manager),
            onPointerDown: (event) {
              print('down ${event.pointer}, x = ${event.position.dx}, y = ${event.position.dy}');
              manager.value.onPointerDown(event.toTouchPoint());
              invalidate();
            },
            onPointerMove: (event) {
              print('move ${event.pointer}, x = ${event.position.dx}, y = ${event.position.dy}');
              manager.value.onPointerMove(event.toTouchPoint());
              invalidate();
            },
            onPointerUp: (event) {
              print('up ${event.pointer}, x = ${event.position.dx}, y = ${event.position.dy}');
              manager.value.onPointerUp(event.toTouchPoint());
              invalidate();
            },
            onPointerCancel: (event) {
              manager.value.onPointerUp(event.toTouchPoint());
              invalidate();
            },
          );
        }),
      ),
    );
  }

  void invalidate() {
    manager.refresh();
  }
}

class RenderManager {
  final List<RenderNode> renderList = [CircleNode(), RectNode()];

  final List<TouchPoint> _downPoints = [];
  final List<TouchPoint> _movePoints = [];

  RenderNode? _selNode;
  Matrix4 _orgMatrix = Matrix4.identity();
  double _touchX = 0.0;
  double _touchY = 0.0;
  double _touchDist = 0.0;
  double _touchDegree = 0.0;

  void onPointerDown(TouchPoint point) {
    _downPoints.add(point);
    _movePoints.add(point);
    trySelect();
  }

  void onPointerMove(TouchPoint point) {
    if (_selNode == null) {
      return;
    }
    final index = _movePoints.indexWhere((item) {
      return item.id == point.id;
    });
    _movePoints[index] = point;

    if (_downPoints.length == 1) {
      final p = _movePoints[0];
      final tX = p.x - _touchX;
      final tY = p.y - _touchY;
      final m = Matrix4.identity();
      m.translate(tX, tY);
      _selNode?.matrix = m * _orgMatrix;
      return;
    }
    if (index < 2) {
      applyMoveScaleRotate(_movePoints[0], _movePoints[1]);
    }
  }

  void onPointerUp(TouchPoint point) {
    removeFun(TouchPoint item) {
      return item.id == point.id;
    }

    _downPoints.removeFirstExt(removeFun);
    _movePoints.removeFirstExt(removeFun);
    trySelect();
  }

  void applyMoveScaleRotate(TouchPoint p1, TouchPoint p2) {
    final touchPoint = getCenterPoint(p1, p2);
    final distance = calculateDistance(p1, p2);
    final degree = calculateDegreeByPoint(p1, p2);
    final scale = distance / _touchDist;
    final tX = touchPoint.x - _touchX;
    final tY = touchPoint.y - _touchY;
    final m = Matrix4.identity();
    m.translate(touchPoint.x, touchPoint.y);
    m.rotateZ(degree - _touchDegree);
    m.scale(scale, scale);
    m.translate(-touchPoint.x, -touchPoint.y);
    m.translate(tX, tY);
    _selNode?.matrix = m * _orgMatrix;
  }

  void saveTouchInfo() {
    final point = getTouchPoint();
    if (point == null) {
      return;
    }
    _touchX = point.x;
    _touchY = point.y;
    _orgMatrix = _selNode?.matrix ?? _orgMatrix;
    if (_downPoints.length < 2) {
      return;
    }
    _touchDist = calculateDistance(_downPoints[0], _downPoints[1]);
    _touchDegree = calculateDegreeByPoint(_downPoints[0], _downPoints[1]);
  }

  double calculateDistance(TouchPoint point1, TouchPoint point2) {
    final d = point1.point.distanceTo(point2.point);
    return d < 1.0 ? 1.0 : d;
  }

  double calculateDegreeByPoint(TouchPoint point1, TouchPoint point2) {
    return calculateDegree(point1.x, point1.y, point2.x, point2.y);
  }

  double calculateDegree(double x1, double y1, double x2, double y2) {
    return atan2(y2 - y1, x2 - x1);
  }

  Point<double>? getTouchPoint() {
    if (_downPoints.isEmpty) {
      return null;
    }
    if (_downPoints.length == 1) {
      final point = _downPoints[0];
      return Point(point.x, point.y);
    }
    final point1 = _downPoints[0];
    final point2 = _downPoints[1];
    return getCenterPoint(point1, point2);
  }

  Point<double> getCenterPoint(TouchPoint p1, TouchPoint p2) {
    return Point((p1.x + p2.x) / 2, (p1.y + p2.y) / 2);
  }

  void trySelect() {
    final point = getTouchPoint();
    if (point == null) {
      setSelect(null);
      return;
    }
    trySelectByPoint(point.x, point.y);
  }

  void trySelectByPoint(double x, double y) {
    final sel = renderList.lastOrNullExt((item) {
      return item.isHit(x, y);
    });
    setSelect(sel);
    saveTouchInfo();
  }

  void setSelect(RenderNode? node) {
    for (var item in renderList) {
      item.selected = item == node;
    }
    _selNode = node;
    if (node != null) {
      renderList.remove(node);
      renderList.add(node);
    }
  }
}

class TouchPoint {
  TouchPoint(this.id, this.x, this.y);

  final int id;
  final double x;
  final double y;

  Point<double> get point => Point(x, y);
}

class MatrixPainter extends CustomPainter {
  MatrixPainter(this.list);

  final List<RenderNode> list;

  @override
  void paint(Canvas canvas, Size size) {
    print('paint size = $size');
    for (var item in list) {
      item.onDraw(canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

abstract class RenderNode {
  Matrix4 matrix = Matrix4.identity();
  bool selected = false;

  void onDraw(Canvas canvas, Size size);

  bool isHit(double x, double y);
}

class CircleNode extends RenderNode {
  static const double _radius = 30.0;
  static const Color _color = Color(0xffff0000);
  static const Color _selColor = Color(0xffff8000);
  final Paint _paint = Paint();

  CircleNode() {
    _paint.isAntiAlias = true;
    _paint.color = _color;
    _paint.blendMode = BlendMode.src;
    _paint.style = PaintingStyle.fill;
    _paint.strokeWidth = 4.0;
  }

  @override
  void onDraw(Canvas canvas, Size size) {
    canvas.save(); // 存储现场
    canvas.transform(matrix.storage);
    _paint.style = PaintingStyle.fill;
    _paint.color = _color;
    canvas.drawCircle(Offset(0, 0), _radius, _paint);
    if (selected) {
      _paint.style = PaintingStyle.stroke;
      _paint.color = _selColor;
      canvas.drawCircle(Offset(0, 0), _radius, _paint);
    }
    canvas.restore(); // 还原现场
  }

  @override
  bool isHit(double x, double y) {
    final m = matrix.clone();
    m.invert();
    final point = m.transform3(Vector3(x, y, 0.0));
    final distance = point.distanceTo(Vector3(0.0, 0.0, 0.0));
    return distance <= _radius;
  }
}

class RectNode extends RenderNode {
  static const double _w = 30.0;
  static const double _h = 50.0;
  static const Color _color = Color(0xff0000ff);
  static const Color _selColor = Color(0xffff8000);
  final Paint _paint = Paint();

  RectNode() {
    _paint.isAntiAlias = true;
    _paint.color = _color;
    _paint.blendMode = BlendMode.src;
    _paint.style = PaintingStyle.fill;
    _paint.strokeWidth = 4.0;
  }

  @override
  void onDraw(Canvas canvas, Size size) {
    canvas.save(); // 存储现场
    canvas.transform(matrix.storage);
    _paint.style = PaintingStyle.fill;
    _paint.color = _color;
    final rect = Rect.fromLTWH(-_w / 2.0, -_h / 2.0, _w, _h);
    canvas.drawRect(rect, _paint);
    if (selected) {
      _paint.style = PaintingStyle.stroke;
      _paint.color = _selColor;
      canvas.drawRect(rect, _paint);
    }
    canvas.restore(); // 还原现场
  }

  @override
  bool isHit(double x, double y) {
    final m = matrix.clone();
    m.invert();
    final point = m.transform3(Vector3(x, y, 0.0));
    final l = -_w / 2.0;
    final t = -_h / 2.0;
    final r = _w / 2.0;
    final b = _h / 2.0;
    return point.x >= l && point.x <= r && point.y >= t && point.y <= b;
  }
}

extension on PointerDownEvent {
  TouchPoint toTouchPoint() {
    return TouchPoint(pointer, localPosition.dx, localPosition.dy);
  }
}

extension on PointerMoveEvent {
  TouchPoint toTouchPoint() {
    return TouchPoint(pointer, localPosition.dx, localPosition.dy);
  }
}

extension on PointerUpEvent {
  TouchPoint toTouchPoint() {
    return TouchPoint(pointer, localPosition.dx, localPosition.dy);
  }
}

extension on PointerCancelEvent {
  TouchPoint toTouchPoint() {
    return TouchPoint(pointer, localPosition.dx, localPosition.dy);
  }
}
