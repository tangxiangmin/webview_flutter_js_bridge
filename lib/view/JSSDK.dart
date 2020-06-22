import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// 约定JavaScript调用方法时的统一模板
class JSModel {
  String method; // 方法名
  Map params; // 参数
  String callback; // 回调名

  JSModel(this.method, this.params, this.callback);

  // jsonEncode方法中会调用实体类的这个方法。如果实体类中没有这个方法，会报错。
  Map toJson() {
    Map map = new Map();
    map["method"] = this.method;
    map["params"] = this.params;
    map["callback"] = this.callback;
    return map;
  }

  // jsonDecode(jsonStr)方法返回的是Map<String, dynamic>类型，需要这里将map转换成实体类
  static JSModel fromMap(Map<String, dynamic> map) {
    JSModel model =
        new JSModel(map['method'], map['params'], map['callback']);
    return model;
  }

  @override
  String toString() {
    return "JSModel: {method: $method, params: $params, callback: $callback}";
  }
}

class JsSDK {
  static WebViewController controller;

  // 格式化参数
  static JSModel parseJson(String jsonStr) {
    try {
      return JSModel.fromMap(jsonDecode(jsonStr));
    } catch (e) {
      print(e);
      return null;
    }
  }

  static String toast(context, JSModel jsBridge) {
    String msg = jsBridge.params['message'] ?? '';
    Scaffold.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
    return 'success'; // 接口返回值，会透传给JS注册的回调函数
  }

  /// 向H5暴露接口调用
  static void executeMethod(
      BuildContext context, WebViewController controller, String message) {
    var model = JsSDK.parseJson(message);

    var handlers = {
      // test toast
      'toast': () {
        return JsSDK.toast(context, model);
      },
      // 调用callJS上的方法
      'checkGoBack': (){
        return controller.evaluateJavascript('window.callJS.goBack()').then((value) {
          return value == '1' ? 'can go back' : 'cannot go back';
        }).catchError((e){
          print(e);
        });
      }
    };

    // 运行method对应方法实现
    var method = model.method;
    dynamic result;
    if (handlers.containsKey(method)) {
      try {
        result = handlers[method]();
      } catch (e) {
        print(e);
      }
    } else {
      print('无$method对应接口实现');
    }

    // 统一处理JS注册的回调函数
    if (model.callback != null) {
      var callback = model.callback;
      void runCallBack(res){
        var resultStr = jsonEncode(res?.toString() ?? '');
        controller.evaluateJavascript("$callback($resultStr);");
      }
      if(result is Future){
        result.then((value){
          print(value);
          runCallBack(value);
        });
      }else {
        runCallBack(result);
      }
    }
  }
}
