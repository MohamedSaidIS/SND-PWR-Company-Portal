import '../../local_data/constants.dart';

class MyShareApiConfig {
  static const String dynamics = '/_api/Web/ensureuser';
  static const String  dynamicsItems= "/_api/Web/Lists(guid'${Constants.dynamicsListId}')/items";
  static String dynamicsItemsByUser ({required int ensureUserId}) => "/_api/Web/Lists(guid'${Constants.dynamicsListId}')/items?\$filter=AuthorId eq $ensureUserId&\$top=999";
  static String dynamicsComments({required String ticketId}) => "https://alsanidi-my.sharepoint.com/personal/retail_alsanidi_onmicrosoft_com/_api/Web/Lists(guid'${Constants.dynamicsListId}')/items($ticketId)/comments";
  static String dynamicAttachments({required String ticketId}) => "https://alsanidi-my.sharepoint.com/personal/retail_alsanidi_onmicrosoft_com/_api/Web/Lists(guid'${Constants.dynamicsListId}')/items($ticketId)/AttachmentFiles";
  static String addDynamicsAttachments ({required String ticketId, required String fileName}) => "https://alsanidi-my.sharepoint.com/personal/retail_alsanidi_onmicrosoft_com/_api/Web/Lists(guid'${Constants.dynamicsListId}')/items($ticketId)/AttachmentFiles/add(FileName='$fileName')";
  static String dynamicAttachmentValue({required String ticketId, required String fileName}) => "https://alsanidi-my.sharepoint.com/personal/retail_alsanidi_onmicrosoft_com/_api/Web/Lists(guid'${Constants.dynamicsListId}')//items($ticketId)/AttachmentFiles('$fileName')/\$value";

}