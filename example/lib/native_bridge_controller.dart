import 'package:native_bridge/bean/message.dart';
import 'package:native_bridge/native_bridge_controller.dart';
import 'package:native_bridge/native_bridge_helper.dart';
import 'package:native_bridge_example/utils/app_util.dart';

///  Name: NativeBridge控制器
///  Created by Fitem on 2022/11/1
class AppBridgeController extends NativeBridgeController {

  /// 指定JSChannel名称
  @override
  get name => "nativeBridge";

  @override
  Map<String, Function?> get callMethodMap => <String, Function?>{
    // 版本号
    "getVersionCode": (data) async {
      return await AppUtil.getVersion();
    },
    // 版本名称
    "getVersionName": (data) async {
      return await AppUtil.getVersion();
    },
    //是否是App
    "isApp": (data) {
      return true;
    },
    //测试获取Web的值
    "getWebValue": (data) async {
      var isHome = await NativeBridgeHelper.sendMessage(
          Message(api: "isHome"), this)
          .future ??
          false;
      AppUtil.show("isHome:$isHome");
      return isHome;
    }
  };
}
