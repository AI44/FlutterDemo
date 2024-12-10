import 'package:flutter/material.dart';

/**
 * @author Raining
 * @date 2024-12-10 15:30
 *
 * #I# 基础组件
 */
class Demo8 {}

class BaseComponentDemo extends StatefulWidget {
  const BaseComponentDemo({super.key});

  @override
  State<StatefulWidget> createState() => BaseComponentDemoState();
}

class BaseComponentDemoState extends State<BaseComponentDemo> {
  bool _switchSelected = true; //维护单选开关状态
  bool _checkboxSelected = true; //维护复选框状态
  final TextEditingController _unameController = TextEditingController(text: "123");
  final TextEditingController _pwdController = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _unameController.addListener(() {
      print('TextEditingController : ${_unameController.text}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("TextDemo"),
        ),
        body: Column(children: [
          /**
           * 文字
           */
          const Text.rich(TextSpan(children: [
            TextSpan(text: "Home: "),
            TextSpan(
              text: "https://flutterchina.club",
              style: TextStyle(color: Colors.blue),
              recognizer: null, // 点击链接后的一个处理器
            ),
          ])),
          const DefaultTextStyle(
            //1.设置文本默认样式
            style: TextStyle(
              color: Colors.red,
              fontSize: 20.0,
            ),
            textAlign: TextAlign.start,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("hello world"),
                Text("I am Jack"),
                Text(
                  "I am Jack",
                  style: TextStyle(
                      inherit: false, //2.不继承默认样式
                      color: Colors.grey),
                ),
              ],
            ),
          ),
          /**
           * ElevatedButton、TextButton、OutlinedButton都有一个icon 构造函数，通过它可以轻松创建带图标的按钮
           */
          Row(
            children: [
              ElevatedButton(
                // "漂浮"按钮，它默认带有阴影和灰色背景
                child: const Text("normal"),
                onPressed: () {},
              ),
              TextButton(
                // 文本按钮，默认背景透明并不带阴影
                child: const Text("normal"),
                onPressed: () {},
              ),
              OutlinedButton(
                // 有一个边框，不带阴影且背景透明
                child: const Text("normal"),
                onPressed: () {},
              ),
              IconButton(
                // 可点击的Icon，不包括文字，默认没有背景，点击后会出现背景
                icon: const Icon(Icons.thumb_up),
                onPressed: () {},
              ),
            ],
          ),
          Row(
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text("发送"),
                onPressed: () {},
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("添加"),
                onPressed: () {},
              ),
              TextButton.icon(
                icon: const Icon(Icons.info),
                label: const Text("详情"),
                onPressed: () {},
              ),
            ],
          ),
          /**
           * 图片
           * https://book.flutterchina.club/chapter3/img_and_icon.html#_3-3-1-图片
           */
          Row(
            children: [
              const Image(
                image: AssetImage("graphics/background.jpg"),
                width: 60.0,
                height: 100.0,
                repeat: ImageRepeat.repeatY,
                color: Colors.red,
                colorBlendMode: BlendMode.difference,
              ),
              Image.asset("graphics/background.jpg", width: 60.0),
              const Image(
                // 从网络加载图片
                image: NetworkImage("http://www.baidu.com/img/PCtm_d9c8750bed0b3c7d089fa7d55720d6cf.png"),
                width: 60.0,
              ),
              Image.network(
                "http://www.baidu.com/img/PCtm_d9c8750bed0b3c7d089fa7d55720d6cf.png",
                width: 60.0,
              ),
              const Text(
                "\uE03e\uE237\uE287",
                style: TextStyle(
                  fontFamily: "MaterialIcons",
                  fontSize: 24.0,
                  color: Colors.green,
                ),
              ),
              const Icon(Icons.accessible, color: Colors.red),
              const Icon(Icons.error, color: Colors.red),
              const Icon(Icons.fingerprint, color: Colors.red),
            ],
          ),
          Row(
            children: [
              Switch(
                value: _switchSelected, //当前状态
                onChanged: (value) {
                  //重新构建页面
                  setState(() {
                    _switchSelected = value;
                  });
                },
              ),
              Checkbox(
                value: _checkboxSelected,
                activeColor: Colors.red, //选中时的颜色
                onChanged: (value) {
                  setState(() {
                    _checkboxSelected = value ?? false;
                  });
                },
              ),
            ],
          ),
          /**
           * 输入框
           *
           * 获取输入内容有两种方式：
           * 1. 定义两个变量，用于保存用户名和密码，然后在onChange触发时，各自保存一下输入内容。
           * 2. 通过controller直接获取。
           *
           * TextSelection 控制文字选中
           *
           * https://book.flutterchina.club/chapter3/input_and_form.html#_3-5-1-textfield
           */
          Theme(
            data: Theme.of(context).copyWith(
                hintColor: Colors.green, //定义下划线颜色
                inputDecorationTheme: const InputDecorationTheme(
                    labelStyle: TextStyle(color: Colors.blue), //定义label字体样式
                    hintStyle: TextStyle(color: Colors.pink, fontSize: 14.0) //定义提示文本样式
                    )),
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      // 下滑线浅灰色，宽度1像素
                      border: Border(bottom: BorderSide(color: Colors.grey, width: 1.0))),
                ),
                TextField(
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: "用户名",
                    hintText: "用户名或邮箱",
                    prefixIcon: Icon(Icons.person),
                  ),
                  controller: _unameController,
                  onChanged: (str) {
                    print('onChange: $str');
                  },
                ),
                const TextField(
                  decoration: InputDecoration(
                    labelText: "密码",
                    hintText: "您的登录密码",
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
              ],
            ),
          ),
          /**
           * Form的使用
           * https://book.flutterchina.club/chapter3/input_and_form.html#_3-5-2-表单form
           */
          Form(
            key: _formKey, //设置globalKey，用于后面获取FormState
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: <Widget>[
                TextFormField(
                  autofocus: true,
                  controller: _unameController,
                  decoration: const InputDecoration(
                    labelText: "用户名",
                    hintText: "用户名或邮箱",
                    icon: Icon(Icons.person),
                  ),
                  // 校验用户名
                  validator: (v) {
                    return v!.trim().isNotEmpty ? null : "用户名不能为空";
                  },
                ),
                TextFormField(
                  controller: _pwdController,
                  decoration: const InputDecoration(
                    labelText: "密码",
                    hintText: "您的登录密码",
                    icon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  //校验密码
                  validator: (v) {
                    return v!.trim().length > 5 ? null : "密码不能少于6位";
                  },
                ),
                // 登录按钮
                Padding(
                  padding: const EdgeInsets.only(top: 28.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          child: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text("登录"),
                          ),
                          onPressed: () {
                            // 通过_formKey.currentState 获取FormState后，
                            // 调用validate()方法校验用户名密码是否合法，校验
                            // 通过后再提交数据。
                            if ((_formKey.currentState as FormState).validate()) {
                              //验证通过提交数据
                            }
                            /**
                             * 不能通过Form.of(context)来获取FormState，原因是，此处的context为FormTestRoute的context，
                             * 而Form.of(context)是根据所指定context`向根`去查找，而FormState是在FormTestRoute的子树中，
                             * 所以不行。正确的做法是通过Builder来构建登录按钮，Builder会将widget节点的context作为回调参数：
                             * Expanded(
                             *  // 通过Builder来获取ElevatedButton所在widget树的真正context(Element)
                             *   child:Builder(builder: (context){
                             *     return ElevatedButton(
                             *       ...
                             *       onPressed: () {
                             *         //由于本widget也是Form的子代widget，所以可以通过下面方式获取FormState
                             *         if(Form.of(context).validate()){
                             *           //验证通过提交数据
                             *         }
                             *       },
                             *     );
                             *   })
                             * )
                             * 其实context正是操作Widget所对应的Element的一个接口，
                             * 由于Widget树对应的Element都是不同的，所以context也都是不同的
                             */
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ]));
  }
}

class BaseComponentDemo2 extends StatefulWidget {
  const BaseComponentDemo2({super.key});

  @override
  State<StatefulWidget> createState() => BaseComponentDemo2State();
}

class BaseComponentDemo2State extends State<BaseComponentDemo2> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    //动画执行时间3秒
    _animationController = AnimationController(
      vsync: this, //注意State类需要混入SingleTickerProviderStateMixin（提供动画帧计时/触发器）
      duration: const Duration(seconds: 3),
    );
    _animationController.addListener(() => setState(() {
      print('anim');
    }));
    _animationController.repeat();
  }

  @override
  void dispose() {
    print('dispose');
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('_animationController: ${_animationController.value}');
    return Scaffold(
        appBar: AppBar(
          title: const Text("BaseComponentDemo2"),
        ),
        body: Column(
          children: [
            // 模糊进度条(会执行一个动画)
            LinearProgressIndicator(
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation(Colors.blue),
            ),
            //进度条显示50%
            LinearProgressIndicator(
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation(Colors.blue),
              value: .5,
            ),
            // 模糊进度条(会执行一个旋转动画)
            CircularProgressIndicator(
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation(Colors.blue),
            ),
            //进度条显示50%，会显示一个半圆
            CircularProgressIndicator(
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation(Colors.blue),
              value: .5,
            ),
            // 线性进度条高度指定为30
            SizedBox(
              height: 30,
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation(Colors.blue),
                value: .5,
              ),
            ),
            // 圆形进度条直径指定为100
            SizedBox(
              height: 60,
              width: 130,
              child: CircularProgressIndicator(
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation(Colors.blue),
                value: .7,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: LinearProgressIndicator(
                backgroundColor: Colors.green,
                valueColor: ColorTween(begin: Colors.grey, end: Colors.blue).animate(_animationController), // 从灰色变成蓝色
                value: _animationController.value,
              ),
            ),
          ],
        ));
  }
}

/**
 * 字体
 *
 * 先在pubspec.yaml中声明它
 * flutter:
 *   fonts:
 *     - family: Raleway
 *       fonts:
 *         - asset: assets/fonts/Raleway-Regular.ttf
 *         - asset: assets/fonts/Raleway-Medium.ttf
 *           weight: 500
 *         - asset: assets/fonts/Raleway-SemiBold.ttf
 *           weight: 600
 *     - family: AbrilFatface
 *       fonts:
 *         - asset: assets/fonts/abrilfatface/AbrilFatface-Regular.ttf
 *
 * 使用字体
 * // 声明文本样式
 * const textStyle = const TextStyle(
 *   fontFamily: 'Raleway',
 *   package: 'my_package', //指定包名
 * );
 *
 * // 使用文本样式
 * var buttonText = const Text(
 *   "Use the font for this text",
 *   style: textStyle,
 * );
 *
 * 一个包也可以只提供字体文件而不需要在 pubspec.yaml 中声明。 这些文件应该存放在包的lib/文件夹中。
 * 字体文件不会自动绑定到应用程序中，应用程序可以在声明字体时有选择地使用这些字体。假设一个名为my_package的包中有一个字体文件：
 * lib/fonts/Raleway-Medium.ttf
 * 然后，应用程序可以声明一个字体，如下面的示例所示：
 *  flutter:
 *    fonts:
 *      - family: Raleway
 *        fonts:
 *          - asset: assets/fonts/Raleway-Regular.ttf
 *          - asset: packages/my_package/fonts/Raleway-Medium.ttf
 *            weight: 500
 * lib/是隐含的，所以它不应该包含在 asset 路径中。
 * 在这种情况下，由于应用程序本地定义了字体，所以在创建TextStyle时可以不指定package参数：
 * const textStyle = const TextStyle(
 *   fontFamily: 'Raleway',
 * );
 */
