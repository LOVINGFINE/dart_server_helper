import 'dart:io';
import 'package:shelf/shelf.dart';

class DartServerHelper {
  Request request;
  Response message = Response(404);
  DartServerHelper(this.request);

  Future<Response> response() async {
    switch (request.method) {
      case 'GET':
        await get();
        break;
      case 'POST':
        await post();
        break;
      case 'PUT':
        await put();
        break;
      case 'DELETE':
        await delete();
        break;
      case 'PATCH':
        await patch();
        break;
      default:
        Future(() => error(500, message: 'server error'));
        break;
    }
    return message;
  }

  get() {
    methodNotAllowed();
  }

  post() {
    methodNotAllowed();
  }

  put() {
    methodNotAllowed();
  }

  patch() {
    methodNotAllowed();
  }

  delete() {
    methodNotAllowed();
  }

  void methodNotAllowed() {
    message = Response(405, body: 'Unsupported request: ${request.method}.');
  }

  paramNotFound(String key) {
    message = Response(406, body: 'Unsupported request param: $key.');
  }

  paramTypeNotAccess(String key) {
    message = Response(406, body: 'request param Type error: $key.');
  }

  error(int code, {message}) {
    message = Response(code, body: message ?? '');
  }

  helper(data) {
    // 返回数据
    message = Response(200, body: data);
  }

  String getHeadersBykey(String name) {
    String target = '';
    request.headers.forEach((key, value) {
      if (name == key) {
        target = value.toString();
      }
    });
    return target;
  }

  Map<String, dynamic> getBody() {
    // 获取body
    return request.context;
  }

  Map<String, String> getQuery() {
    // 获取 Query
    return request.url.queryParameters;
  }

  dynamic getQueryByKey(String key) {
    // 获取 params
    return request.url.queryParameters[key];
  }

  File getFile() {
    // 获取文件
    var fileName = request.url.pathSegments.last;
    return File(fileName);
  }
}
