import 'package:company_portal/core/data/remote_data/dio_share_point/share_point_dio_client.dart';
import 'package:company_portal/core/models/remote/new_user_request.dart';
import 'package:flutter/foundation.dart';

import '../../../../../core/data/remote_data/dio_share_point/share_api_config.dart';

abstract class BaseNewUserRepository {
  Future<List<NewUserItem>> getItems(int userId);
  Future<bool> createItem(NewUserItem item);
  Future<bool> updateItem(NewUserItem item, int itemId);
}

class NewUserRepo extends BaseNewUserRepository{
  final SharePointDioClient client;

  NewUserRepo(this.client);

  @override
  Future<List<NewUserItem>> getItems(int userId) async{
    final response = await client.get(ShareApiConfig.newUserItems);
    if (response.statusCode == 200) {
      final parsedResponse = response.data;
      return await compute(
          (final data) => (data['value'] as List)
          .map((e) => NewUserItem.fromJson(e as Map<String, dynamic>))
          .where((req) => req.directManagerId == userId)
          .toList(),
        parsedResponse,
      );
    } else {
     throw Exception('Failed to load New Users data');
    }
  }

  @override
  Future<bool> createItem(NewUserItem item) {
    // TODO: implement createItem
    throw UnimplementedError();
  }

  @override
  Future<bool> updateItem(NewUserItem item, int itemId) {
    // TODO: implement updateItem
    throw UnimplementedError();
  }

}