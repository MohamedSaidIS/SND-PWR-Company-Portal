import 'package:dio/dio.dart';

class SharePointCookieHelper {
  final Dio _dio = Dio();

  /// يستقبل SharePoint access token
  /// ويرجع FedAuth و rtFa cookies
  Future<Map<String, String>> getSharePointCookies({
    required String tenant,
    required String accessToken,
  }) async {
    final url = "https://$tenant.sharepoint.com/_forms/default.aspx?wa=wsignin1.0";

    try {
      final response = await _dio.post(
        url,
        data: accessToken, // 👈 نص خام
        options: Options(
          headers: {
            "Content-Type": "text/plain", // 👈 مهم
          },
          followRedirects: false,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      print("🔹 Status: ${response.statusCode}");
      print("🔹 Headers: ${response.headers}");
      print("🔹 Body: ${response.data}");

      final rawCookies = response.headers['set-cookie'];
      print("🔎 Raw Set-Cookie headers: $rawCookies");

      final cookies = <String, String>{};
      if (rawCookies != null) {
        for (var c in rawCookies) {
          if (c.contains("FedAuth")) {
            cookies["FedAuth"] = c.split(";").first.split("=").last;
          }
          if (c.contains("rtFa")) {
            cookies["rtFa"] = c.split(";").first.split("=").last;
          }
        }
      }

      if (cookies.isEmpty) {
        throw Exception("❌ No FedAuth/rtFa cookies found. Maybe invalid token?");
      }

      print("✅ Extracted Cookies: $cookies");
      return cookies;
    } catch (e) {
      print("❌ Error getting SharePoint cookies: $e");
      rethrow;
    }
  }

}
