import 'package:company_portal/core/data/remote_data/dio_share_point/share_point_dio_client.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/data/remote_data/dio_share_point/share_api_config.dart';
import '../../../../core/models/local/attached_file_info.dart';
import '../../../../core/models/remote/complaint_suggestion_item.dart';

abstract class BaseComplaintRepository{
  Future<List<ComplaintSuggestionItem>> getItems(int userId);
  Future<bool> createItem(ComplaintSuggestionItem item, List<AttachedBytes> attachedFiles);
}

class ComplaintRepo extends BaseComplaintRepository{
  final SharePointDioClient client;
  ComplaintRepo(this.client);

  @override
  Future<List<ComplaintSuggestionItem>> getItems(int userId) async{
      final response = await client.get(ShareApiConfig.complaintItemsByUser(ensureUserId: userId));

      if (response.statusCode == 200) {
        final data = response.data;
        return await compute(
                (final data) => (data['value'] as List)
                .map((e) => ComplaintSuggestionItem.fromJson(e as Map<String, dynamic>))
                .toList(),
            data
        );
      } else {
        throw Exception("Failed to load items");
      }
  }

  @override
  Future<bool> createItem(ComplaintSuggestionItem item, List<AttachedBytes> attachedFiles) async{
    try {
      final response = await client.post(
        ShareApiConfig.itRequestItems,
        data: item.toJson(),
      );

      if (response.statusCode != 201) {
        throw Exception("Failed to create item");
      }

        final createdItem = await compute(
              (Map<String, dynamic> data) => ComplaintSuggestionItem.fromJson(data),
          Map<String, dynamic>.from(response.data),
        );
        await _uploadAttachments(createdItem.id, attachedFiles);
        return true;
    } catch (e) {
       return false;
    }
  }
  Future<void> _uploadAttachments( int ticketId, List<AttachedBytes> attachedFiles,) async {
    for(var attachedFile in attachedFiles){
       await uploadSingleFile(ticketId.toString(), attachedFile);
    }
  }
  Future<bool> uploadSingleFile(String ticketId, AttachedBytes attachedFile) async {
    try {
      final response = await client.post(
        ShareApiConfig.addComplaintAttachments(
            ticketId: ticketId,
            fileName: attachedFile.fileName,
        ),
        data: attachedFile.fileBytes,
      );

     return response.statusCode == 200;
    } catch (e) {
    throw Exception("Upload Attachment Error: ${e.toString()}");
    }

  }

}