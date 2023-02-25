///  Name: Native Bridge实现类
///  Created by Fitem on 2022/10/31
mixin NativeBridgeImpl {

  /// javascript channel name
  get name;
  /// call method map
  Map<String, Function?> get callMethodMap;

  /// 执行JS
  void runJavascript(String javaScriptString);

}
