import 'package:company_portal/core/models/remote/ensure_user_result.dart';
import 'package:flutter/foundation.dart';

import 'package:company_portal/utils/export_import.dart';


abstract class BaseSupportRepository {
  Future<EnsureUserResult> fetchAllEnsureUser(String email);
}

class SupportRepo implements BaseSupportRepository{
  final SharePointDioClient client;
  final MySharePointDioClient myClient;

  SupportRepo({required this.client, required this.myClient});

  Future<EnsureUser> _fetchEnsureUser({
    required dynamic client,
    required String endpoint,
    required String email,
}) async {
    final response = await client.post(
      endpoint,
      data: {
        "logonName": "i:0#.f|membership|$email",
      },
    );

    if (response.statusCode == 200) {
      return compute(
            (Map<String, dynamic> data) => EnsureUser.fromJson(data),
        Map<String, dynamic>.from(response.data),
      );
    } else {
      throw Exception(
        'Failed to load ensure user ${response.statusCode}',
      );
    }
  }

  @override
  Future<EnsureUserResult> fetchAllEnsureUser(String email) async{
    try{
      final results = await Future.wait([
        _safeCall(() => _fetchEnsureUser(
          client: client,
          endpoint: ShareApiConfig.itEnsureUser,
          email: email,
        )),
        _safeCall(() => _fetchEnsureUser(
          client: client,
          endpoint: ShareApiConfig.alsanidiEnsureUser,
          email: email,
        )),
        _safeCall(() => _fetchEnsureUser(
          client: myClient,
          endpoint: MyShareApiConfig.dynamicsEnsureUser,
          email: email,
        )),
      ]);
      return EnsureUserResult(
        itUser: results[0],
        alsanidiUser: results[1],
        dynamicsUser: results[2]
      );
    }catch(e){
      throw Exception("SupportRepositoryImpl Error: $e");
    }


  }

  Future<EnsureUser?> _safeCall(
      Future<EnsureUser> Function() call) async {
    try {
      return await call();
    } catch (_) {
      return null;
    }
  }

}