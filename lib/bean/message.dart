import 'dart:convert';

Message messageFromJson(String str) => Message.fromJson(json.decode(str));

String messageToJson(Message data) => json.encode(data.toJson());

///  Name: MessageElement
///  Created by Fitem on 2022/10/31
class Message {
  Message({
    required this.api,
    this.data,
    this.callbackId,
    this.isResponseFlag = false,
  });

  String api; // 调用方法api
  dynamic data; // 数据
  String? callbackId; // 对应id
  bool? isResponseFlag; // 是否是返回消息标记

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        api: json["api"],
        data: json["data"],
        callbackId: json["callbackId"],
        isResponseFlag: json["isResponseFlag"],
      );

  Map<String, dynamic> toJson() => {
        "api": api,
        "data": data,
        "callbackId": callbackId,
        "isResponseFlag": isResponseFlag,
      };
}
