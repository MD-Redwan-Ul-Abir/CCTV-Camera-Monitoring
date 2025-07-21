import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:skt_sikring/infrastructure/utils/secure_storage_helper.dart';

import 'api_content.dart';

class ApiClient extends GetxService {
  static final _client = http.Client();
  static const _timeout = Duration(seconds: 30);
  static String _bearerToken = "";
  static const _noInternet = "Can't connect to the internet!";

  Future<Response> _makeRequest(
      String url,
      String method,
      Map<String, dynamic>? body, {
        Map<String, String>? headers,
        List<MultipartBody>? files,
      }) async {
    try {
      // Always get fresh token for each request
      _bearerToken = await SecureStorageHelper.getString("accessToken");

      // Build default headers
      final defaultHeaders = <String, String>{
        'Content-Type': 'application/json',
      };

      // Add authorization if token exists
      if (_bearerToken.isNotEmpty) {
        defaultHeaders['Authorization'] = 'Bearer $_bearerToken';
      }

      // Merge with provided headers, giving priority to provided headers
      final finalHeaders = <String, String>{
        ...defaultHeaders,
        ...?headers,
      };

      debugPrint('--> $method: $url\nHeaders: $finalHeaders\nBody: $body');
      http.Response response;

      switch (method) {
        case 'GET':
          response = await _client
              .get(Uri.parse(url), headers: finalHeaders)
              .timeout(_timeout);
          break;
        case 'POST':
          if (files != null && files.isNotEmpty) {
            response = await _postMultipart(
              url,
              body,
              files,
              finalHeaders,
            );
          } else {
            response = await _client
                .post(
              Uri.parse(url),
              headers: finalHeaders,
              body: _encodeBody(body, finalHeaders['Content-Type']),
            )
                .timeout(_timeout);
          }
          break;
        case 'PUT':
          response = await _client
              .put(
            Uri.parse(url),
            headers: finalHeaders,
            body: _encodeBody(body, finalHeaders['Content-Type']),
          )
              .timeout(_timeout);
          break;
        case 'PATCH':
          if (files != null && files.isNotEmpty) {
            response = await _patchMultipart(
              url,
              body,
              files,
              finalHeaders,
            );
          } else {
            response = await _client
                .patch(
              Uri.parse(url),
              headers: finalHeaders,
              body: _encodeBody(body, finalHeaders['Content-Type']),
            )
                .timeout(_timeout);
          }
          break;
        case 'DELETE':
          response = await _client
              .delete(
            Uri.parse(url),
            headers: finalHeaders,
            body: _encodeBody(body, finalHeaders['Content-Type']),
          )
              .timeout(_timeout);
          break;
        default:
          return Response(statusCode: 500, statusText: 'Invalid method');
      }
      return _handleResponse(response, url);
    } catch (e) {
      debugPrint('Error: $e');
      return const Response(statusCode: 0, statusText: _noInternet);
    }
  }

  /// Properly encode body based on content type
  String? _encodeBody(Map<String, dynamic>? body, String? contentType) {
    if (body == null) return null;

    debugPrint('Encoding body with content type: $contentType');
    debugPrint('Body data: $body');

    if (contentType?.contains('application/json') == true) {
      final encodedBody = jsonEncode(body);
      debugPrint('Encoded JSON body: $encodedBody');
      return encodedBody;
    } else if (contentType?.contains('application/x-www-form-urlencoded') == true) {
      final encodedBody = _encodeFormData(body);
      debugPrint('Encoded form body: $encodedBody');
      return encodedBody;
    } else {
      // Default to JSON
      final encodedBody = jsonEncode(body);
      debugPrint('Default encoded JSON body: $encodedBody');
      return encodedBody;
    }
  }

  /// Encode data as form URL encoded string with proper numeric support
  String _encodeFormData(Map<String, dynamic> data) {
    return data.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');
  }

  /// Convert dynamic map to string map while preserving numeric values
  Map<String, String> _convertToStringMap(Map<String, dynamic>? data) {
    if (data == null) return {};

    return data.map((key, value) => MapEntry(key, value.toString()));
  }

  Future<http.Response> _postMultipart(
      String url,
      Map<String, dynamic>? fields,
      List<MultipartBody> files,
      Map<String, String> headers,
      ) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Convert all field values to strings while preserving their original values
    if (fields != null) {
      request.fields.addAll(_convertToStringMap(fields));
    }

    // Remove content-type from headers for multipart (http package handles it)
    final multipartHeaders = Map<String, String>.from(headers);
    multipartHeaders.remove('Content-Type');
    request.headers.addAll(multipartHeaders);

    for (var file in files) {
      String? mimeType = mime(file.file.path);
      request.files.add(
        http.MultipartFile(
          file.key,
          file.file.readAsBytes().asStream(),
          file.file.lengthSync(),
          filename: file.file.path.split('/').last,
          contentType: mimeType != null ? MediaType.parse(mimeType) : null,
        ),
      );
    }
    http.StreamedResponse response = await request.send();
    return await http.Response.fromStream(response);
  }

  Future<http.Response> _patchMultipart(
      String url,
      Map<String, dynamic>? fields,
      List<MultipartBody> files,
      Map<String, String> headers,
      ) async {
    var request = http.MultipartRequest('PATCH', Uri.parse(url));

    // Convert all field values to strings while preserving their original values
    if (fields != null) {
      request.fields.addAll(_convertToStringMap(fields));
    }

    // Remove content-type from headers for multipart (http package handles it)
    final multipartHeaders = Map<String, String>.from(headers);
    multipartHeaders.remove('Content-Type');
    request.headers.addAll(multipartHeaders);

    for (var file in files) {
      String? mimeType = mime(file.file.path);
      request.files.add(
        http.MultipartFile(
          file.key,
          file.file.readAsBytes().asStream(),
          file.file.lengthSync(),
          filename: file.file.path.split('/').last,
          contentType: mimeType != null ? MediaType.parse(mimeType) : null,
        ),
      );
    }
    http.StreamedResponse response = await request.send();
    return await http.Response.fromStream(response);
  }

  Response _handleResponse(http.Response response, String url) {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (e) {
      debugPrint('JSON Decode Error: $e');
    }

    debugPrint('<-- [${response.statusCode}] $url\nBody: ${response.body}');

    return Response(
      statusCode: response.statusCode,
      body: body ?? response.body,
      statusText: response.reasonPhrase,
    );
  }

  // GET
  Future<Response> getData(String uri, {Map<String, String>? headers}) =>
      _makeRequest(ApiConstants.baseUrl + uri, 'GET', null, headers: headers);

  // POST with JSON (default)
  Future<Response> postData(
      String uri,
      dynamic body, {
        Map<String, String>? headers,
        List<MultipartBody>? files,
      }) => _makeRequest(
    '${ApiConstants.baseUrl}/$uri',
    'POST',
    body,
    headers: headers,
    files: files,
  );

  // POST with form data (if your API specifically needs form-encoded data)
  Future<Response> postFormData(
      String uri,
      Map<String, dynamic> body, {
        Map<String, String>? headers,
      }) {
    final formHeaders = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
      ...?headers,
    };
    return _makeRequest(
      '${ApiConstants.baseUrl}/$uri',
      'POST',
      body,
      headers: formHeaders,
    );
  }

  // PUT
  Future<Response> putData(
      String uri,
      dynamic body, {
        Map<String, String>? headers,
        List<MultipartBody>? files,
      }) => _makeRequest(
    ApiConstants.baseUrl + uri,
    'PUT',
    body,
    headers: headers,
    files: files,
  );

  //PATCH
  Future<Response> patchData(
      String uri,
      dynamic body, {
        Map<String, String>? headers,
        List<MultipartBody>? files,
      }) => _makeRequest(
    ApiConstants.baseUrl + uri,
    'PATCH',
    body,
    headers: headers,
    files: files,
  );

  // DELETE
  Future<Response> deleteData(
      String uri, {
        Map<String, String>? headers,
        dynamic body,
      }) => _makeRequest(
    ApiConstants.baseUrl + uri,
    'DELETE',
    body,
    headers: headers,
  );
}

class MultipartBody {
  String key;
  File file;

  MultipartBody(this.key, this.file);
}