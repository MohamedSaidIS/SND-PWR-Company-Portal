
import 'package:company_portal/utils/app_notifier.dart';
import 'package:flutter/foundation.dart';
import '../models/remote/user_info.dart';
import '../service/dio_client.dart';

class ManagerInfoProvider with ChangeNotifier{
  final DioClient dioClient;
  ManagerInfoProvider({required this.dioClient});

  UserInfo? _managerInfo;
  bool _loading = false;
  String? _error;

  UserInfo? get managerInfo => _managerInfo;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchManagerInfo() async{
    _loading = true;
    _error = null;
    notifyListeners();

    try{
      final response = await dioClient.get('/me/manager');

      if(response.statusCode == 200){
        _managerInfo = UserInfo.fromJson(response.data);
        AppNotifier.printFunction("Manager Info Fetching Success: ",_managerInfo);
      }else{
        _error = 'Failed to load manager data';
        AppNotifier.printFunction("Manager Info Error: ","$_error ${response.statusCode}");
      }
    }catch(e){
      _error = e.toString();
      AppNotifier.printFunction("Manager Info Exception: ",_error);
    }
    _loading = false;
    notifyListeners();
  }
}