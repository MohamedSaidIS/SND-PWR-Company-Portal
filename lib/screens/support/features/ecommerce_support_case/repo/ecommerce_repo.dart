import 'package:flutter/foundation.dart';

import 'package:company_portal/utils/export_import.dart';

abstract class BaseEcommerceRepository {
  Future<List<EcommerceItem>> getItems(int userId);
  Future<bool> createItem(EcommerceItem item, List<AttachedBytes> attachedFiles);
}

class EcommerceRepo implements BaseEcommerceRepository{
  final SharePointDioClient client;

  EcommerceRepo(this.client);

  @override
  Future<List<EcommerceItem>> getItems(int ensureUserId) async {
      final response = await client.get(ShareApiConfig.ecommerceItemsByUser(ensureUserId: ensureUserId));
      if (response.statusCode == 200) {
        final data = response.data;
        return await compute(
              (final data) => (data['value'] as List)
                  .map((e) => EcommerceItem.fromJson(e as Map<String, dynamic>))
                  .toList(),
          data,
        );
      } else {
        throw Exception("Failed to load items");
      }
    }

  @override
  Future<bool> createItem(EcommerceItem item, List<AttachedBytes> attachedFiles,) async{
    try {
      final response = await client.post(
        ShareApiConfig.ecommerceItems,
        data: item.toJson(),
      );

      if (response.statusCode != 201) {
        throw Exception("Failed to create item");
      }
      final createdItem = await compute(
            (data) => EcommerceItem.fromJson(data),
        Map<String, dynamic>.from(response.data),
      );

      if (attachedFiles.isNotEmpty) {
        await _uploadAttachments(createdItem.id, attachedFiles);
      }

      return true;
    }catch(e) {
      return false;
    }

  }

  Future<void> _uploadAttachments(
      int ticketId,
      List<AttachedBytes> files,
      ) async {
    for (var file in files) {
      await _uploadSingleFile(ticketId.toString(), file);
    }
  }

  Future<bool> _uploadSingleFile(
      String ticketId,
      AttachedBytes file,
      ) async {
    try {
      final response = await client.post(
        ShareApiConfig.addEcommerceAttachments(
          ticketId: ticketId,
          fileName: file.fileName,
        ),
        data: file.fileBytes,
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Upload Attachment Error: ${e.toString()}");
    }
  }
}