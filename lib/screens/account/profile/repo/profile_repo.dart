import 'package:company_portal/core/data/remote_data/dio_graph/graph_dio_client.dart';
import 'package:company_portal/core/models/remote/direct_report.dart';
import 'package:company_portal/core/models/remote/user_info.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/data/remote_data/dio_graph/graph_api_config.dart';

abstract class BaseProfileRepository{
  Future<UserInfo> getManager();
  Future<List<DirectReport>> getReports();
}
class ProfileRepo extends BaseProfileRepository{
  final GraphDioClient client;
  ProfileRepo(this.client);

  @override
  Future<UserInfo> getManager() async{
    final response = await client.get(GraphApiConfig.userManager);
    if (response.statusCode == 200) {
     return await compute(
            (Map<String, dynamic> data) => UserInfo.fromJson(data),
        Map<String, dynamic>.from(response.data),
      );
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Future<List<DirectReport>> getReports() async {
    final response = await client.get(GraphApiConfig.directReports);

    if (response.statusCode == 200) {
      final parsedResponse = response.data;
      return await compute(
            (final data) => (data['value'] as List)
            .map((redirectJson) => DirectReport.fromJson(redirectJson))
            .toList(),
        parsedResponse,
      );
   } else {
      throw Exception('Failed to load data');
    }
  }

}