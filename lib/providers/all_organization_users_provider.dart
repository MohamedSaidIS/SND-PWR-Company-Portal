import 'package:flutter/foundation.dart';
import '../utils/export_import.dart';

class AllOrganizationUsersProvider extends ChangeNotifier {
  GraphDioClient dioClient;

  AllOrganizationUsersProvider({required this.dioClient});

  bool _loading = false;
  String? _error;
  List<AllOrganizationUsers> _allUsers = [];

  bool get loading => _loading;

  String? get error => _error;

  List<AllOrganizationUsers> get allUsers => _allUsers;

  Future<void> getAllUsers() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await dioClient.get("/users?\$top=999");

      if (response.statusCode == 200) {
        final parsedResponse = response.data;
        _allUsers = await compute(
            (final data) => (data['value'] as List)
                .map((allUsersJson) =>  AllOrganizationUsers.fromJson(allUsersJson))
                .toList(),
          parsedResponse
        );

        AppNotifier.logWithScreen("All Users Provider: ", "All Users Fetching: ${allUsers.length}");
      } else {
        _error = 'Failed to load user data';
        AppNotifier.logWithScreen(
            "All Users Provider: ", "All Users Error: $_error ${response.statusCode}");
      }
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen("All Users Provider: ", "All Users Exception: $_error" );
    }
    _loading = false;
    notifyListeners();
  }
}
