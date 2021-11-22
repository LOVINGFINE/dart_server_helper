import 'package:dio/dio.dart';

class DioManager {
  BaseOptions baseOptions;

  DioManager(this.baseOptions);

  Future find<T>(path, {options}) async {
    try {
      Response response = await Dio(baseOptions).get(path, options: options);
      return hanleData<T>(response);
    } on DioError catch (e) {
      return createErrorEntity(e);
    }
  }

  Future post<T>(path, {Map? data, Options? options}) async {
    try {
      Response response =
          await Dio(baseOptions).post(path, data: data, options: options);
      return hanleData<T>(response);
    } on DioError catch (e) {
      createErrorEntity(e);
    }
  }

  Future patch<T>(path, {Map? data, Options? options}) async {
    try {
      Response response =
          await Dio(baseOptions).patch(path, data: data, options: options);
      hanleData<T>(response);
    } on DioError catch (e) {
      createErrorEntity(e);
    }
  }

  Future put<T>(path, {Map? data, Options? options}) async {
    try {
      Response response =
          await Dio(baseOptions).put(path, data: data, options: options);
      return hanleData<T>(response);
    } on DioError catch (e) {
      return createErrorEntity(e);
    }
  }

  Future delete<T>(path, {Options? options}) async {
    try {
      Response response = await Dio(baseOptions).delete(path, options: options);
      return hanleData<T>(response);
    } on DioError catch (e) {
      return createErrorEntity(e);
    }
  }

  // data:{}
  hanleData<T>(Response response) {
    if (response.data != null) {
      dynamic entity;
      if (response.data is List) {
        entity = BaseListEntity<List>.fromJson(response.data);
      } else {
        entity = BaseEntity<T>.fromJson(response.data);
      }
      if (entity.code == 200) {
        return entity.data;
      } else {
        return ErrorEntity(entity.code, entity.message);
      }
    } else {
      return ErrorEntity(-1, "未知错误");
    }
  }
}

// data:{} 转换
class BaseEntity<T> {
  int code;
  String message;
  T data;

  BaseEntity(this.code, this.message, this.data);

  static dynamic generateOBJ<T>(json) {
    if (json == null) {
      return null;
    } else {
      return json as T;
    }
  }

  factory BaseEntity.fromJson(json) {
    return BaseEntity(
      json["code"],
      json["message"],
      // data值需要经过工厂转换为我们传进来的类型
      generateOBJ<T>(json["data"]),
    );
  }
}

// data:[] 转换
class BaseListEntity<T> {
  int? code;
  String? message;
  List<T>? data;
  BaseListEntity(this.code, this.message, this.data);

  static dynamic generateOBJ<T>(json) {
    if (json == null) {
      return null;
    } else {
      return json as T;
    }
  }

  factory BaseListEntity.fromJson(json) {
    List<T> mData = [];
    if (json['data'] != null) {
      //遍历data并转换为我们传进来的类型
      for (var item in (json['data'] as List)) {
        mData.add(generateOBJ<T>(item));
      }
    }

    return BaseListEntity(
      json["code"],
      json["message"],
      mData,
    );
  }
}

class ErrorEntity {
  int? code;
  String message;
  ErrorEntity(this.code, this.message);
  factory ErrorEntity.fromJson(json) {
    return ErrorEntity(json["code"], json["message"]);
  }
}

// error metods
ErrorEntity createErrorEntity(DioError error) {
  switch (error.type) {
    case DioErrorType.cancel:
      {
        return ErrorEntity(-1, "请求取消");
      }
    case DioErrorType.connectTimeout:
      {
        return ErrorEntity(-1, "连接超时");
      }

    case DioErrorType.sendTimeout:
      {
        return ErrorEntity(-1, "请求超时");
      }

    case DioErrorType.receiveTimeout:
      {
        return ErrorEntity(-1, "响应超时");
      }

    case DioErrorType.response:
      {
        try {
          var errCode = error.response?.statusCode;
          switch (errCode) {
            case 400:
              return ErrorEntity(errCode, "请求语法错误");
            case 403:
              return ErrorEntity(errCode, "服务器拒绝执行");
            case 404:
              return ErrorEntity(errCode, "无法连接服务器");
            case 405:
              return ErrorEntity(errCode, "请求方法被禁止");
            case 500:
              return ErrorEntity(errCode, "服务器内部错误");
            case 502:
              return ErrorEntity(errCode, "无效的请求");
            case 503:
              return ErrorEntity(errCode, "服务器挂了");

            case 505:
              return ErrorEntity(errCode, "不支持HTTP协议请求");
            default:
              {
                return ErrorEntity(errCode, "未知错误");
              }
          }
        } on Exception catch (_) {
          return ErrorEntity(-1, "未知错误");
        }
      }

    default:
      {
        return ErrorEntity(-1, error.message);
      }
  }
}
