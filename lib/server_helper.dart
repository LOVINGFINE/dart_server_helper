import 'dart:io';
import 'dart:convert';

class DartServerHelper {
  HttpRequest request;
  Map<String, dynamic> params = {};
  DartServerHelper(this.request, {params}) {
    params = params ?? {};
    response();
  }
  response() {
    switch (request.method) {
      case 'GET':
        get();
        break;
      case 'POST':
        post();
        break;
      case 'PUT':
        put();
        break;
      case 'DELETE':
        delete();
        break;
      case 'PATCH':
        patch();
        break;
      default:
        error(500, message: 'server error');
        break;
    }
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
    request.response
      ..statusCode = HttpStatus.methodNotAllowed
      ..write('Unsupported request: ${request.method}.')
      ..close();
  }

  paramNotFound(String key) {
    request.response
      ..statusCode = HttpStatus.notAcceptable
      ..write('Unsupported request param: $key.')
      ..close();
  }

  paramTypeNotAccess(String key) {
    request.response
      ..statusCode = HttpStatus.notAcceptable
      ..write('request param Type error: $key.')
      ..close();
  }

  void error(int code, {message}) {
    request.response
      ..statusCode = code
      ..write(
          jsonEncode({'code': code, 'message': message ?? '', 'data': null}))
      ..close();
  }

  void helper(data) {
    // 返回数据
    request.response
      ..write(jsonEncode({'code': 200, 'message': 'success', 'data': data}))
      ..close();
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

  Future<Map<String, dynamic>> getBody() async {
    // 获取body
    String maps = await utf8.decodeStream(request);
    var value = jsonDecode(maps);
    if (value != null) {
      return value;
    } else {
      return {};
    }
  }

  Map<String, String> getQuery() {
    // 获取 Query
    return request.uri.queryParameters;
  }

  dynamic getQueryByKey(String key) {
    // 获取 params
    return request.uri.queryParameters[key];
  }

  Map<String, dynamic> getParams() {
    // 获取 params
    return params;
  }

  dynamic getParamByKey(String key) {
    // 获取 params
    return params['key'];
  }

  File getFile() {
    // 获取文件
    var fileName = request.uri.pathSegments.last;
    return File(fileName);
  }
}
