import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:native_bridge/bean/message.dart';
import 'package:native_bridge/native_bridge_helper.dart';
import 'package:native_bridge_example/native_bridge_controller.dart';
import 'package:native_bridge_example/utils/app_util.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // 确定初始化
  SystemChrome.setPreferredOrientations(// 使设备竖屏显示
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
  late final WebViewController _controller;
  late final AppBridgeController _appBridgeController;

  @override
  void initState() {
    super.initState();
    // 初始化AppBridgeController
    _appBridgeController = AppBridgeController();
    // 初始化WebViewController
    _controller = WebViewController()
      ..enableZoom(true)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        _appBridgeController.name,
        onMessageReceived: _appBridgeController.onMessageReceived,
      )
      ..loadFlutterAsset('assets/test/index.html');
    // 设置WebViewController
    _appBridgeController.controller = _controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Native Bridge"),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
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
      body: WebViewWidget(controller: _controller),
    );
  }
}
