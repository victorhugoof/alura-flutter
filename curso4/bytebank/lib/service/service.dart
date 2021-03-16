import 'dart:convert';

import 'package:bytebank/exception/service_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

abstract class Service {
  @protected
  Future<Response> get(String url, {Map<String, String> headers}) async {
    final Response response = await _getClient().get(_getUri(url), headers: headers);

    if (_isError(response)) {
      _throwError(response);
    }

    return response;
  }

  @protected
  Future<Response> post(String url, {Map<String, String> headers, Object body, Encoding encoding}) async {
    final Response response = await _getClient().post(
      _getUri(url),
      headers: _getHeaders(headers),
      body: _getBody(body),
      encoding: encoding,
    );

    if (_isError(response)) {
      _throwError(response);
    }

    return response;
  }

  bool _isError(Response response) {
    return !_isSuccess(response);
  }

  bool _isSuccess(Response response) {
    return response.statusCode >= 200 && response.statusCode <= 299;
  }

  void _throwError(Response response) {
    final String message = _getErrorMessage(response);
    final String reason = _getReason(response);
    final int statusCode = response.statusCode;

    throw new ServiceException(message, statusCode, reason);
  }

  String _getReason(Response response) {
    try {
      final dynamic data = jsonDecode(response.body);
      if (data != null) {
        final Map<String, dynamic> map = data;
        if (map.containsKey('error')) {
          return map['error'];
        }
      }
    } catch (ignored) {}
    return response.reasonPhrase;
  }

  String _getErrorMessage(Response response) {
    try {
      final dynamic data = jsonDecode(response.body);
      if (data != null) {
        final Map<String, dynamic> map = data;
        if (map.containsKey('message')) {
          return map['message'];
        }
      }
    } catch (ignored) {}
    return null;
  }

  String _getBody(Object body) {
    return jsonEncode(body);
  }

  Map<String, String> _getHeaders(Map<String, String> headers) {
    if (headers == null) {
      headers = {};
    }

    if (!headers.containsKey('Content-Type')) {
      headers['Content-Type'] = 'application/json';
    }

    return headers;
  }

  Uri _getUri(String url) {
    return 'http://192.168.25.159:8080$url'.toUri();
  }

  Client _getClient() {
    return HttpClientWithInterceptor.build(interceptors: [_LoggingInterceptor()]);
  }
}

class _LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    print('+---------------------');
    print('| Request');
    print('| url: ${methodToString(data.method)} ${data.url}');
    print('| headers: ${data.headers}');
    print('| body: ${data.body}');
    print('+---------------------');
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    print('+---------------------');
    print('| Response');
    print('| status code: ${data.statusCode}');
    print('| headers: ${data.headers}');
    print('| body: ${data.body}');
    print('+---------------------');
    return data;
  }
}
