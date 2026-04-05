import 'package:flutter/foundation.dart';
import 'package:company_portal/utils/export_import.dart';

abstract class BaseDynamicsRepository {
  Future<List<DynamicsItem>> getItems(int userId);
  Future<bool> createItem(DynamicsItem item, List<AttachedBytes> attachedFiles);
}

class DynamicsRepo implements BaseDynamicsRepository{
  final MySharePointDioClient client;

  DynamicsRepo(this.client);

  @override
  Future<List<DynamicsItem>> getItems(int userId) async {
    final response = await client.get(MyShareApiConfig.dynamicsItemsByUser(ensureUserId: userId));
    if (response.statusCode == 200) {
      final data = response.data;
      return await compute(
            (final data) => (data['value'] as List)
            .map((e) => DynamicsItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        data,
      );
    } else{
      throw Exception("Failed to load items");
    }
  }

  @override
  Future<bool> createItem(DynamicsItem item, List<AttachedBytes> attachedFiles) async{
    try{
      final response = await client.post(
        MyShareApiConfig.dynamicsItems,
        data: item.toJson(),
      );

      if (response.statusCode != 201) {
        throw Exception("Failed to create item");
      }
      final createdItem = await compute(
            (Map<String, dynamic> data) => DynamicsItem.fromJson(data),
        Map<String, dynamic>.from(response.data),
      );

      if (attachedFiles.isNotEmpty) {
        await _uploadAttachments(createdItem.id, attachedFiles);
      }

      return true;
    }catch(e){
      return false;
    }
  }

  Future<void> _uploadAttachments(int ticketId, List<AttachedBytes> attachedFiles) async {
    for (var file in attachedFiles) {
      await _uploadSingleFile(ticketId.toString(), file);
    }
  }

  Future<bool> _uploadSingleFile(
      String ticketId,
      AttachedBytes file,
      ) async {
    try {
      final response = await client.post(
        MyShareApiConfig.addDynamicsAttachments(
          ticketId: ticketId,
          fileName: file.fileName,
        ),
        data: file.fileBytes,
      );
      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Upload Attachment Error: ${e.toString()}");    }
  }

}