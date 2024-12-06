/**
 * @author Raining
 * @date 2024-12-06 09:30
 *
 * #I# dart异步
 */
class Demo1 {
  void run() {
    print("--------------- ${time()} - run start");
    //test1();
    //test2();
    //test3();
    //test4();
    //test5();
    test6();
    print("--------------- ${time()} - run end");
  }

  String time() {
    return DateTime.now().toString();
  }

  /**
   * 延迟2秒输出结果，在catchError中捕获错误
   *
   * error
   * finally
   */
  void test1() {
    Future.delayed(const Duration(seconds: 2), () {
      throw AssertionError("error");
      return "hi world";
    }).then((data) {
      print("success");
    }).catchError((e) {
      print("error");
    }).whenComplete(() {
      //无论成功或失败都会走到这里
      print("finally");
    });
  }

  /**
   * then方法还有一个可选参数onError，我们也可以用它来捕获异常
   *
   * error
   * finally
   */
  void test2() {
    Future.delayed(const Duration(seconds: 2), () {
      throw AssertionError("error");
      return "hi world";
    }).then((data) {
      print("success");
    }, onError: (e) {
      print("error");
    }).whenComplete(() {
      print("finally");
    });
  }

  /**
   * 卡UI等待4秒输出结果
   *
   * 2024-12-06 10:10:48.872269 - start test3
   * 2024-12-06 10:10:52.880830 - delay 2 | delay 4
   */
  void test3() {
    print("${time()} - start test3");
    Future.wait([
      // 2秒后返回结果
      Future.delayed(const Duration(seconds: 2), () {
        return "delay 2";
      }),
      Future.delayed(const Duration(seconds: 4), () {
        return "delay 4";
      })
    ]).then((results) {
      print("${time()} - ${results[0]} | ${results[1]}");
    }).catchError((e) {
      print(e);
    });
  }

  //先分别定义各个异步任务
  Future<String> login(String userName, String pwd) {
    //用户登录
    return Future.delayed(const Duration(seconds: 2), () {
      return "id-123";
    });
  }

  Future<String> getUserInfo(String id) {
    //获取用户信息
    return Future.delayed(const Duration(seconds: 2), () {
      return "userInfo-456";
    });
  }

  Future saveUserInfo(String userInfo) {
    // 保存用户信息
    return Future.delayed(const Duration(seconds: 2), () {
      return "saveUserInfo";
    });
  }

  /**
   * 消除回调地狱
   * 如果在then 中返回的是一个Future的话，该future会执行，执行结束后会触发后面的then回调
   *
   * --------------- 2024-12-06 11:24:20.279043 - run start
   * --------------- 2024-12-06 11:24:20.283765 - run end
   * login ok | id-123
   * getUserInfo | userInfo-456
   * saveUserInfo
   */
  void test4() {
    login("test", "******").then((id) {
      print("login ok | $id");
      return getUserInfo(id);
    }).then((userInfo) {
      print("getUserInfo | $userInfo");
      return saveUserInfo(userInfo);
    }).then((result) {
      print("saveUserInfo ok");
    }).catchError((e) {
      print("error");
    });
  }

  /**
   * 使用 async/await 消除 callback hell
   * async用来表示函数是异步的，定义的函数会返回一个`Future`对象，可以使用 then 方法添加回调函数。
   * await 后面是一个Future，表示等待该异步任务完成，异步完成后才会往下走；await必须出现在 async 函数内部。
   *
   * --------------- 2024-12-06 11:22:54.419161 - run start
   * --------------- 2024-12-06 11:22:54.425405 - run end
   * login ok | id-123
   * getUserInfo | userInfo-456
   * saveUserInfo ok
   */
  Future<void> test5() async {
    try {
      String id = await login("test", "******");
      print("login ok | $id");
      String userInfo = await getUserInfo(id);
      print("getUserInfo | $userInfo");
      await saveUserInfo(userInfo);
      print("saveUserInfo ok");
    } catch (e) {
      print("error");
    }
  }

  /**
   *
   * --------------- 2024-12-06 11:53:11.721574 - run start
   * 2024-12-06 11:53:11.725619 - start test6
   * --------------- 2024-12-06 11:53:11.731285 - run end
   * 2024-12-06 11:53:12.730857 | hello 1
   * 2024-12-06 11:53:13.731897 | error
   * 2024-12-06 11:53:14.731801 | hello 3
   * 2024-12-06 11:53:14.740673 | done
   */
  void test6() {
    print("${time()} - start test6");
    // 3个任务并行执行，最后汇总输出结果
    Stream.fromFutures([
      Future.delayed(const Duration(seconds: 1), () {
        return "${time()} | hello 1";
      }),
      Future.delayed(const Duration(seconds: 2), () {
        throw AssertionError("error");
        return "${time()} | hello 2";
      }),
      Future.delayed(const Duration(seconds: 3), () {
        return "${time()} | hello 3";
      })
    ]).listen((data) {
      print(data);
    }, onError: (e) {
      print("${time()} | error");
    }, onDone: () {
      print("${time()} | done");
    });
  }
}
