
import 'package:company_portal/service/dio_client.dart';
import 'package:flutter/foundation.dart';
import '../models/remote/user_info.dart';
import '../utils/app_notifier.dart';

class UserInfoProvider with ChangeNotifier{
  final DioClient dioClient;
  UserInfoProvider({required this.dioClient});

  UserInfo? _userInfo;
  bool _loading = false;
  String? _error;

  UserInfo? get userInfo => _userInfo;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchUserInfo() async{
    _loading = true;
    _error = null;
    notifyListeners();

    try{
      final response = await dioClient.get('/me');

      if(response.statusCode == 200){
        _userInfo = UserInfo.fromJson(response.data);
        AppNotifier.printFunction("User Info Fetching: ",_userInfo);
      }else{
        _error = 'Failed to load user data';
        AppNotifier.printFunction("User Info Error: ","$_error ${response.statusCode}");
      }
    }catch(e){
      _error = e.toString();
      AppNotifier.printFunction("User Info Exception: ",_error);
    }
    _loading = false;
    notifyListeners();
  }
}