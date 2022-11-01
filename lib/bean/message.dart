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
  });

  String api;
  String? data;
  String? callbackId;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        api: json["api"],
        data: json["data"],
        callbackId: json["callbackId"],
      );

  Map<String, dynamic> toJson() => {
        "api": api,
        "data": data,
        "callbackId": callbackId,
      };
}
