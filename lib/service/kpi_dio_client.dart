import 'package:company_portal/config/env_config.dart';
import 'package:company_portal/utils/app_notifier.dart';
import 'package:dio/dio.dart';


class KPIDioClient {
  late final Dio dio;
  String? _accessToken;
  DateTime? _tokenSavedAt;
  int _expiresIn = 3599;

  KPIDioClient() {
    dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
  }

  Future<String?> getToken() async {

    const url = "https://login.microsoftonline.com/3e2223b9-a7ca-4c74-9555-66e0cd43c412/oauth2/token";
    final response = await dio.post(
      url,
      data: {
        "grant_type": EnvConfig.kpiGrantType,
        "client_id": EnvConfig.kpiClientId,
        "client_secret": EnvConfig.kpiClientSecret,
        "resource": EnvConfig.kpiResource,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType, // important!
      ),
    );
    _accessToken = response.data["access_token"];
    _expiresIn = int.tryParse(response.data["expires_in"].toString()) ?? 3600;
    _tokenSavedAt = DateTime.now();
    AppNotifier.printFunction("AccessToken", _accessToken);
    return _accessToken;
  }

  bool get isTokenExpired {
    if (_accessToken == null || _tokenSavedAt == null) return true;
    final expiryTime = _tokenSavedAt!.add(Duration(seconds: _expiresIn - 60));
    return DateTime.now().isAfter(expiryTime);
  }

  Future<String?> ensureToken() async {
    if (isTokenExpired) {
      return await getToken();
    }
    return _accessToken;
  }

  Future<Response> getRequest(
    String url, ) async {
    await ensureToken();

    return await dio.get(
      url,
      //queryParameters: queryParameters,
      options: Options(headers: _buildHeaders()),
    );
  }

  Map<String, String> _buildHeaders() {
    if (_accessToken == null) {
      throw Exception("Access token is null");
    }
    return {
      "Authorization": _accessToken != null ? "Bearer $_accessToken" : "",
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
  }
}
