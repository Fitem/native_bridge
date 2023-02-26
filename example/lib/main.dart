import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:native_bridge/native_bridge.dart';
import 'package:native_bridge_example/native_bridge_controller.dart';
import 'package:native_bridge_example/utils/app_util.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // 确定初始化
  SystemChrome.setPreferredOrientations(// 使设备竖屏显示
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Native Bridge',
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
    // 初始化WebViewController
    _controller = WebViewController()
      ..enableZoom(true)
      ..loadFlutterAsset('assets/test/index.html');
    // 初始化AppBridgeController
    _appBridgeController = AppBridgeController(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Native Bridge'),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              const PopupMenuItem<int>(
                value: 0,
                child: Text('App获取H5数据'),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text('App获取H5数据(直接获取)'),
              )
            ];
          }, onSelected: (value) async {
            switch (value) {
              case 0:
                bool? isHome = await _appBridgeController.sendMessage(Message(api: 'isHome'));
                AppUtil.show('isHome:$isHome');
                break;
              case 1:
                var userAgent =
                    await _appBridgeController.runJavaScriptReturningResult('getUserAgent()');
                AppUtil.show('userAgent:$userAgent');
                break;
            }
          })
        ],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
