import 'package:company_portal/models/remote/ensure_user.dart';
import 'package:company_portal/service/shared_point_dio_client.dart';
import 'package:flutter/foundation.dart';

import '../utils/app_notifier.dart';

class SPEnsureUserProvider extends ChangeNotifier{
  final SharePointDioClient sharePointDioClient;
  SPEnsureUserProvider({required this.sharePointDioClient});
  
  EnsureUser? _ensureUser;
  bool _loading = false;
  String? _error;
  
  EnsureUser? get ensureUser => _ensureUser;
  bool get loading => _loading;
  String? get error => _error;
  
  Future<void> fetchEnsureUser(String email) async{
    _loading = true;
    _error = null;
    notifyListeners();
    
    try {
      final response = await sharePointDioClient.dio.post(
          "/sites/IT-Requests/_api/web/ensureuser",
          data: {
            "logonName": "i:0#.f|membership|$email"
          }
          );
      if(response.statusCode == 200){
        _ensureUser = EnsureUser.fromJson(response.data);
        AppNotifier.printFunction("Ensure User Fetching: ",_ensureUser?.id.toString());
      }else if(response.statusCode == 401){
        _error = response.statusCode.toString();
      }else{
        _error = 'Failed to load ensure user data';
      }
    }catch(e){
      _error = e.toString();
      AppNotifier.printFunction("Ensure User Exception: ",_error);
    }
    _loading = false;
    notifyListeners();

  }

}