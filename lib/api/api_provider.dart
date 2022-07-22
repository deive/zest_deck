import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:zest/api/api_request_response.dart';

class APIProvider {
  final http.Client _client = http.Client();

  final Map<String, String> _defaultHeaders = {
    "Accept": "application/json",
    "Content-Type": "application/json",
  };

  post(String url, ZestAPIRequestResponse? session, ZestCall call) => _post(
      url, session, call, (body) => ZestAPIRequestResponse.fromJson(body));

  get(String url, ZestAPIRequestResponse? session, ZestGetCall call) =>
      _get(url, session, call, (body) => ZestAPIRequestResponse.fromJson(body));

  bool allowAutomaticRefresh(DateTime? lastRefresh) =>
      lastRefresh == null ||
      DateTime.now().toUtc().difference(lastRefresh) >
          const Duration(minutes: 10);

  bool allowManualRefresh(DateTime? lastRefresh) =>
      lastRefresh == null ||
      DateTime.now().toUtc().difference(lastRefresh) >
          const Duration(seconds: 1);

  _post<REQUEST extends APIRequest, RESPONSE extends APIResponse>(
      String url,
      ZestAPIRequestResponse? session,
      APICall<REQUEST, RESPONSE> call,
      RESPONSE Function(dynamic body) decode) async {
    await _call(
        url,
        call,
        decode,
        (uri) async => await _client.post(uri,
            headers: _headers(session),
            body: json.encode(call.request.toJson())));
  }

  _get<RESPONSE extends APIResponse>(
      String url,
      ZestAPIRequestResponse? session,
      APIGetCall<RESPONSE> call,
      RESPONSE Function(dynamic body) decode) async {
    await _call(url, call, decode,
        (uri) async => await _client.get(uri, headers: _headers(session)));
  }

  _call<REQUEST extends APIRequest, RESPONSE extends APIResponse>(
      String url,
      APICall<REQUEST, RESPONSE> call,
      RESPONSE Function(dynamic body) decode,
      Future<http.Response> Function(Uri url) makeCall) async {
    call.onStarted();
    APIException? responseException;
    try {
      final rawResponse = await makeCall(Uri.parse(url));
      if (rawResponse.statusCode >= 200 && rawResponse.statusCode < 300) {
        _decode(rawResponse.body, call, decode);
      } else {
        if (!kReleaseMode) {
          log("API Status Exception (${rawResponse.statusCode}): ${rawResponse.body}");
        }
        responseException = APIException(rawResponse);
      }
    } on Exception catch (error) {
      if (!kReleaseMode) log("API Exception: $error");
      call.onError(error);
    } catch (error) {
      if (!kReleaseMode) log("API Error: $error");
      call.onError(Exception(error));
    }

    if (responseException != null) throw responseException;
  }

  _decode<REQUEST extends APIRequest, RESPONSE extends APIResponse>(String body,
      APICall<REQUEST, RESPONSE> call, RESPONSE Function(dynamic body) decode) {
    try {
      final jsonResponse = json.decode(body);
      final response = decode(jsonResponse);
      call.onComplete(response);
    } on Exception catch (error) {
      if (!kReleaseMode) log("Decode Exception: $error\n$body");
      call.onError(error);
    } catch (error) {
      if (!kReleaseMode) log("Decode Error: $error\n$body");
      call.onError(Exception(error));
    }
  }

  _headers(ZestAPIRequestResponse? session) => {
        ..._defaultHeaders,
        if (session?.authToken != null) "AuthToken": session!.authToken!,
      };

  String apiPath(String path) => "https://dev.zestdeck.com/api/$path";
}

class APICall<REQUEST extends APIRequest, RESPONSE extends APIResponse>
    with ChangeNotifier {
  APICall(this.request);
  REQUEST request;
  RESPONSE? response;
  bool started = false;
  bool completed = false;
  bool get running => started && !completed;
  Exception? error;

  onStarted() {
    started = true;
    completed = false;
    notifyListeners();
  }

  onComplete(RESPONSE response) {
    this.response = response;
    _onComplete();
  }

  onError(Exception error) {
    this.error = error;
    _onComplete();
  }

  _onComplete() {
    completed = true;
    notifyListeners();
  }
}

class APIException implements Exception {
  APIException(this.response);
  http.Response response;
}

abstract class APIRequest {
  Map<String, dynamic> toJson();
}

abstract class APIResponse {
  APIResponse.fromJson(Map<String, dynamic> json);
}

class APIGetRequest extends APIRequest {
  @override
  Map<String, dynamic> toJson() => {};
}

class APIGetCall<RESPONSE extends APIResponse>
    extends APICall<APIGetRequest, RESPONSE> {
  APIGetCall() : super(APIGetRequest());
}
