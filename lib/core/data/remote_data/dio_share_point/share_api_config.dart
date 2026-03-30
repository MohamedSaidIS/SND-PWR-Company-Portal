import '../../local_data/constants.dart';

class ShareApiConfig {
  /// EndPoints
  static const String itEnsureUser= '/sites/IT-Requests/_api/web/ensureuser';
  static const String alsanidiEnsureUser = '/sites/AbdulrahmanHamadAlsanidi/_api/web/ensureuser';
  static const String newUserItems= "/sites/IT-Requests/_api/Web/Lists(guid'${Constants.newUserListId}')/items";
  static const String ecommerceItems= "/sites/AbdulrahmanHamadAlsanidi/_api/Web/Lists(guid'${Constants.alSanidiListId}')/items";
  static const String itRequestItems= "/sites/IT-Requests/_api/Web/Lists(guid'${Constants.itListId}')/items";
  static String updateNewUserItem ({required int requestId}) => "/sites/IT-Requests/_api/Web/Lists(guid'${Constants.newUserListId}')/items($requestId)";
  static String ecommerceItemsByUser ({required int ensureUserId}) => "/sites/AbdulrahmanHamadAlsanidi/_api/Web/Lists(guid'${Constants.alSanidiListId}')/items?\$filter=AuthorId eq $ensureUserId&\$top=999";
  static String complaintItemsByUser ({required int ensureUserId}) => "/sites/IT-Requests/_api/Web/Lists(guid'${Constants.itListId}')/items?\$filter=AuthorId eq $ensureUserId&\$top=999";
  static String addEcommerceAttachments ({required String ticketId, required String fileName}) => "/sites/AbdulrahmanHamadAlsanidi/_api/Web/Lists(guid'${Constants.alSanidiListId}')/items($ticketId)/AttachmentFiles/add(FileName='$fileName')";
  static String addComplaintAttachments ({required String ticketId, required String fileName}) => "/sites/IT-Requests/_api/Web/Lists(guid'${Constants.itListId}')/items($ticketId)/AttachmentFiles/add(FileName='$fileName')";
  static String complaintComments({required String ticketId}) => "/sites/IT-Requests/_api/web/lists(guid'${Constants.itListId}')/items($ticketId)/comments";
  static String ecommerceComments({required String ticketId}) => "/sites/AbdulrahmanHamadAlsanidi/_api/Web/Lists(guid'${Constants.alSanidiListId}')/items($ticketId)/comments";
  static String complaintAttachments({required String ticketId}) => "/sites/IT-Requests/_api/web/lists(guid'${Constants.itListId}')/items($ticketId)/AttachmentFiles";
  static String ecommerceAttachments({required String ticketId}) => "/sites/AbdulrahmanHamadAlsanidi/_api/Web/Lists(guid'${Constants.alSanidiListId}')/items($ticketId)/AttachmentFiles";
  static String complaintAttachmentValue({required String ticketId, required String fileName}) => "/sites/IT-Requests/_api/web/lists(guid'${Constants.itListId}')//items($ticketId)/AttachmentFiles('$fileName')/\$value";
  static String ecommerceAttachmentValue({required String ticketId, required String fileName}) => "/sites/AbdulrahmanHamadAlsanidi/_api/Web/Lists(guid'${Constants.alSanidiListId}')//items($ticketId)/AttachmentFiles('$fileName')/\$value";
}