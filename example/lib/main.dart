import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'dart:async';

import 'package:native_bridge/bean/message.dart';
import 'package:native_bridge/native_bridge.dart';
import 'package:native_bridge/native_bridge_helper.dart';
import 'package:native_bridge_example/native_bridge_controller.dart';
import 'package:native_bridge_example/utils/app_util.dart';
import 'package:webview_flutter/webview_flutter.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized(); // 确定初始化
  SystemChrome.setPreferredOrientations( // 使设备竖屏显示
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Native Bridge",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WebViewPage(),
    );
  }
}

///  Name: WebViewPage
///  Created by Fitem on 2022/11/1
class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState<WebViewPage> extends State {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  late AppBridgeController _appBridgeController;

  @override
  void initState() {
    super.initState();
    _appBridgeController = AppBridgeController()
      ..controller = _controller.future;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onLoadExample();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Native Bridge"),
        actions: [
          PopupMenuButton(
            // add icon, by default "3 dot" icon
            // icon: Icon(Icons.book)
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text("Is web home?"),
                  )
                ];
              }, onSelected: (value) async {
            var isHome =
                await NativeBridgeHelper.sendMessage(Message(api: "isHome"), _appBridgeController)
                    .future ??
                    false;
            AppUtil.show("isHome:$isHome");
          })
        ],
      ),
      body: WebView(
        onWebViewCreated: (controller) {
          _controller.complete(controller);
        },
        zoomEnabled: true,
        gestureNavigationEnabled: true,
        initialUrl: "",
        //JS执行模式 是否允许JS执行
        javascriptMode: JavascriptMode.unrestricted,
        javascriptChannels: <JavascriptChannel>{
          NativeBridge(controller: _appBridgeController),
        },
      ),
    );
  }

  /// 加载本地测试index.html
  Future<void> onLoadExample() async {
    await _controller.future.then((value) => value.loadFlutterAsset('assets/test/index.html'));
  }
}
