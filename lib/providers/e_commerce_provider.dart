import 'package:company_portal/models/remote/e_commerce_item.dart';
import 'package:company_portal/utils/app_notifier.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../service/share_point_dio_client.dart';

class EcommerceProvider extends ChangeNotifier {
  final SharePointDioClient sharePointDioClient;

  EcommerceProvider({required this.sharePointDioClient});

  List<EcommerceItem> _ecommerceItemsList = [];
  bool _loading = false;
  String? _error;

  List<EcommerceItem> get ecommerceItemsList => _ecommerceItemsList;

  bool get loading => _loading;

  String? get error => _error;

  Future<void> getEcommerceItems(int ensureUserId) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await sharePointDioClient.get(
        "/sites/AbdulrahmanHamadAlsanidi/_api/Web/Lists(guid'c09e3694-3b81-43b5-b39c-49a26155612e')/items?\$top=999",
      );
      if (response.statusCode == 200) {
        final parsedResponse = response.data;
        _ecommerceItemsList = await compute(
          (final data) => (data['value'] as List)
              .map((e) => EcommerceItem.fromJson(e as Map<String, dynamic>))
              .where((item) => item.authorId == ensureUserId)
              .toList(),
          parsedResponse,
        );
      } else {
        _error = 'Failed to load Ecommerce data';
        AppNotifier.logWithScreen("Ecommerce Provider",
            "Ecommerce Error: $_error ${response.statusCode}");
      }
      _ecommerceItemsList.isNotEmpty
          ? AppNotifier.logWithScreen("Ecommerce Provider",
              "Ecommerce Fetching: ${response.statusCode} ${_ecommerceItemsList[0].app[0]}")
          : AppNotifier.logWithScreen("Ecommerce Provider",
              "Ecommerce Fetching: ${response.statusCode} ${_ecommerceItemsList.length}");
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen(
          "Ecommerce Provider", "Ecommerce Exception: $_error");
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> createEcommerceItem(EcommerceItem item) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await sharePointDioClient.post(
        "/sites/AbdulrahmanHamadAlsanidi/_api/Web/Lists(guid'c09e3694-3b81-43b5-b39c-49a26155612e')/items",
        data: item.toJson(),
      );
      if (response.statusCode == 201) {
        AppNotifier.logWithScreen("Ecommerce Provider",
            "Ecommerce Item Created: ${response.statusCode}");
        return true;
      } else {
        _error = 'Failed to load Ecommerce data';
        AppNotifier.logWithScreen("Ecommerce Provider",
            "Ecommerce Item Error: $_error ${response.statusCode}");
        return false;
      }
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen(
          "Ecommerce Provider", "Ecommerce Item Exception: $_error");
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> updateEcommerceItem(EcommerceItem item, int itemId) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await sharePointDioClient.dio.post(
        "/sites/AbdulrahmanHamadAlsanidi/_api/Web/Lists(guid'c09e3694-3b81-43b5-b39c-49a26155612e')/items",
        data: item.toJson(),

        options: Options(
          headers: {
            "X-HTTP-Method": "MERGE",
            "If-Match": "*",
          },
        ),
      );
      if (response.statusCode == 204) {
        AppNotifier.logWithScreen("Ecommerce Provider",
            "Ecommerce Item updated: ${response.statusCode}");
        return true;
      } else {
        _error = 'Failed to load Ecommerce data';
        AppNotifier.logWithScreen("Ecommerce Provider",
            "Ecommerce Item updated Error: $_error ${response.statusCode}");
        return false;
      }
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen(
          "Ecommerce Provider", "Ecommerce Item updated Exception: $_error");
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
