import 'package:aad_oauth/aad_oauth.dart';
import 'package:flutter/material.dart';

import 'auth_config.dart' show AuthConfig;

class AuthConfigController {
  final AadOAuth refreshOAuth;
  final AadOAuth graphOAuth;
  final AadOAuth spOAuth;
  final AadOAuth mySpOAuth;

  AuthConfigController(GlobalKey<NavigatorState> navigatorKey)
      : refreshOAuth = AadOAuth(AuthConfig.createRefreshConfig(navigatorKey)),
        graphOAuth = AadOAuth(AuthConfig.createGraphConfig(navigatorKey)),
        spOAuth = AadOAuth(AuthConfig.createSharePointConfig(navigatorKey)),
        mySpOAuth = AadOAuth(AuthConfig.createMySharePointConfig(navigatorKey));
}
