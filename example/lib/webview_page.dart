import 'dart:async';

import 'package:flutter/material.dart';
import 'package:native_bridge/bean/message.dart';
import 'package:native_bridge/native_bridge.dart';
import 'package:native_bridge/native_bridge_helper.dart';
import 'package:native_bridge_example/native_bridge_controller.dart';
import 'package:native_bridge_example/utils/app_util.dart';
import 'package:webview_flutter/webview_flutter.dart';

///  Name: WebViewPage
///  Created by Fitem on 2022/11/1
class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState<WebViewPage> extends State {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  late NativeBridgeController _nativeBridgeController;

  @override
  void initState() {
    super.initState();
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
            var isHome = await NativeBridgeHelper.sendMessage(
                        Message(api: "isHome"), _nativeBridgeController)
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
          NativeBridge(
            controller: _nativeBridgeController =
                NativeBridgeController(controller: _controller.future),
          )
        },
      ),
    );
  }

  /// 加载本地测试index.html
  Future<void> onLoadExample() async {
    await _controller.future
        .then((value) => value.loadFlutterAsset('assets/test/index.html'));
  }
}
