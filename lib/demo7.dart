import 'dart:async';

import 'package:flutter/material.dart';

import 'main.dart';

/**
 * @author Raining
 * @date 2024-12-10 11:56
 *
 * #I# 异常捕获
 */
class Demo7 {}

/**
 * 在事件循环中，当某个任务发生异常并没有被捕获时，程序并不会退出，而直接导致的结果是当前任务的后续代码就不会被执行了，
 * 也就是说一个任务中的异常是不会影响其他任务执行的。
 *
 * 自己上报异常：
 * void main() {
 *   FlutterError.onError = (FlutterErrorDetails details) {
 *     reportError(details);
 *   };
 *  ...
 * }
 *
 * 异常分两类：同步异常和异步异常，同步异常可以通过try/catch捕获
 *
 * Dart中有一个runZoned(...) 方法，可以给执行对象指定一个Zone。Zone表示一个代码执行的环境范围，为了方便理解，
 * 读者可以将Zone类比为一个代码执行沙箱，不同沙箱的之间是隔离的，沙箱可以捕获、拦截或修改一些代码行为，
 * 如Zone中可以捕获日志输出、Timer创建、微任务调度的行为，同时Zone也可以捕获所有未处理的异常。
 *
 * zoneSpecification：Zone的一些配置，可以自定义一些代码行为，比如拦截日志输出和错误等。
 * runZoned(
 *   () => runApp(MyApp()),
 *   zoneSpecification: ZoneSpecification(
 *     // 拦截print 蜀西湖
 *     print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
 *       parent.print(zone, "Interceptor: $line");
 *     },
 *     // 拦截未处理的异步错误
 *     handleUncaughtError: (Zone self, ZoneDelegate parent, Zone zone,
 *                           Object error, StackTrace stackTrace) {
 *       parent.print(zone, '${error.toString()} $stackTrace');
 *     },
 *   ),
 * );
 */

void collectLog(String line) {
  //收集日志
}

void reportErrorAndLog(FlutterErrorDetails details) {
  //上报错误和日志逻辑
}

FlutterErrorDetails makeDetails(Object obj, StackTrace stack) {
  // 构建错误信息
  throw AssertionError("完善代码");
}

void main() {
  var onError = FlutterError.onError; //先将 onError 保存起来
  FlutterError.onError = (FlutterErrorDetails details) {
    onError?.call(details); //调用默认的onError
    reportErrorAndLog(details); //上报
  };
  runZoned(
    () => runApp(MyApp()),
    zoneSpecification: ZoneSpecification(
      // 拦截print
      print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
        collectLog(line);
        parent.print(zone, "Interceptor: $line");
      },
      // 拦截未处理的异步错误
      handleUncaughtError: (Zone self, ZoneDelegate parent, Zone zone, Object error, StackTrace stackTrace) {
        // reportErrorAndLog(details);
        parent.print(zone, '${error.toString()} $stackTrace');
      },
    ),
  );
}
