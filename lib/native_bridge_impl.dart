///  Name: Native Bridge实现类
///  Created by Fitem on 2022/10/31
abstract class NativeBridgeImpl {
  NativeBridgeImpl({required this.name, required this.callMethodMap});

  /// javascript channel name
  final String name;
  /// call method map
  final Map<String, Function?> callMethodMap;

  /// 执行JS
  void runJavascript(String javaScriptString);

}
