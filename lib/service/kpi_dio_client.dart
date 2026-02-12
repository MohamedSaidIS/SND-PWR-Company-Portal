import 'package:dio/dio.dart';

import '../../../../utils/export_import.dart';

class KPIDioClient {
  late final Dio dio;
  String? _uatAccessToken;
  DateTime? _uatTokenSavedAt;
  int _uatExpiresIn = 3599;
  String? _prodAccessToken;
  DateTime? _prodTokenSavedAt;
  int _prodExpiresIn = 3599;

  KPIDioClient() {
    dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 200),
      ),
    );
  }

  Future<String?> getToken(bool isUAT) async {
    AppLogger.info("Kpi DioClient", "KpiUAT: $isUAT");
    const url =
        "https://login.microsoftonline.com/3e2223b9-a7ca-4c74-9555-66e0cd43c412/oauth2/token";
    final response = await dio.post(
      url,
      data: {
        "grant_type": EnvConfig.kpiGrantType,
        "client_id": EnvConfig.kpiClientId,
        "client_secret": EnvConfig.kpiClientSecret,
        "resource":
            isUAT ? EnvConfig.kpiUatResource : EnvConfig.kpiProdResource,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType, // important!
      ),
    );
    isUAT
        ? _uatAccessToken = response.data["access_token"]
        : _prodAccessToken = response.data["access_token"];

    isUAT
        ? _uatExpiresIn =
            int.tryParse(response.data["expires_in"].toString()) ?? 3600
        : _prodExpiresIn =
            int.tryParse(response.data["expires_in"].toString()) ?? 3600;

    isUAT
        ? _uatTokenSavedAt = DateTime.now()
        : _prodTokenSavedAt = DateTime.now();

    // AppLogger.info("KPI DioClient: ", "KpiAccessToken ${_uatAccessToken ?? _prodAccessToken}");
    return isUAT ? _uatAccessToken : _prodAccessToken;
  }

  bool get isUatTokenExpired {
    if (_uatAccessToken == null || _uatTokenSavedAt == null) return true;
    final expiryTime =
        _uatTokenSavedAt!.add(Duration(seconds: _uatExpiresIn - 60));
    return DateTime.now().isAfter(expiryTime);
  }

  bool get isProdTokenExpired {
    if (_prodAccessToken == null || _prodTokenSavedAt == null) return true;
    final expiryTime =
        _prodTokenSavedAt!.add(Duration(seconds: _prodExpiresIn - 60));
    return DateTime.now().isAfter(expiryTime);
  }

  Future<String?> ensureToken(bool isUAT) async {
    if (isUAT && isUatTokenExpired) {
      return await getToken(isUAT);
    } else if (!isUAT && isProdTokenExpired) {
      return await getToken(isUAT);
    } else {
      return isUAT ? _uatAccessToken : _prodAccessToken;
    }
  }

  Future<Response> getRequest(
    String url,
    bool isUAT,
  ) async {
    await ensureToken(isUAT);

    return await dio.get(
      url,
      options: Options(headers: _buildHeaders(isUAT)),
    );
  }

  Map<String, String> _buildHeaders(bool isUAT) {
    if (isUAT && _uatAccessToken == null) {
      throw Exception("UAT Access token is null");
    } else if (!isUAT && _prodAccessToken == null) {
      throw Exception("Prod Access token is null");
    }
    return {
      "Authorization":
          isUAT ? "Bearer $_uatAccessToken" : "Bearer $_prodAccessToken",
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
  }

  Future postRequest(String endPoint, bool isUAT,
      {required Map<String, Map<String, dynamic>> data}) async {
    return await dio.post(
      endPoint,
      data: data,
      options: Options(
        headers: _buildHeaders(isUAT),
      ),
    );
  }
}
