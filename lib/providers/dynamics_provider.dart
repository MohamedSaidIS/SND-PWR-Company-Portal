import 'package:flutter/foundation.dart';
import '../utils/export_import.dart';

class DynamicsProvider extends ChangeNotifier {
  final MySharePointDioClient mySharePointDioClient;

  DynamicsProvider({required this.mySharePointDioClient});

  List<DynamicsItem> _dynamicsItemsList = [];
  bool _loading = false;
  String? _error;

  List<DynamicsItem> get dynamicsItemsList => _dynamicsItemsList;

  bool get loading => _loading;

  String? get error => _error;

  Future<void> getDynamicsItems(int ensureUserId) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await mySharePointDioClient.get(
        "/_api/Web/Lists(guid'3b2e2dd6-55a0-4ee4-b517-5ccd63b6a12a')/items?\$top=2999",
      );
      if (response.statusCode == 200) {
        final parsedResponse = response.data;
        _dynamicsItemsList = await compute(
          (final data) => (data['value'] as List)
              .map((e) => DynamicsItem.fromJson(e as Map<String, dynamic>))
              .where((item) => item.authorId == ensureUserId)
              .toList(),
          parsedResponse,
        );
      } else {
        _error = 'Failed to load Dynamics data';
        AppNotifier.logWithScreen("Dynamics Provider",
            "Dynamics Error: $_error ${response.statusCode}");
      }
      _dynamicsItemsList.isNotEmpty
          ? AppNotifier.logWithScreen("Dynamics Provider",
              "Dynamics Fetching: ${response.statusCode} ${_dynamicsItemsList[0].area}")
          : AppNotifier.logWithScreen("Dynamics Provider",
              "Dynamics Fetching: ${response.statusCode} ${_dynamicsItemsList.length}");
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen(
          "Dynamics Provider", "Dynamics Exception: $_error");
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> createDynamicsItem(DynamicsItem item) async {
    _loading = true;
    _error = null;
    notifyListeners();
    debugPrint("Dynamics Item ${item.toJson()}");

    try {
      final response = await mySharePointDioClient.post(
        "/_api/Web/Lists(guid'3b2e2dd6-55a0-4ee4-b517-5ccd63b6a12a')/items",
        data: item.toJson(),
      );
      if (response.statusCode == 201) {
        AppNotifier.logWithScreen("Dynamics Provider",
            "Dynamics Item Created: ${response.statusCode}");
        return true;
      } else {
        _error = 'Failed to load Dynamics data';
        AppNotifier.logWithScreen("Dynamics Provider",
            "Dynamics Item Error: $_error ${response.statusCode}");
        return false;
      }
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen(
          "Dynamics Provider", "Dynamics Item Exception: $_error");
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }


}
