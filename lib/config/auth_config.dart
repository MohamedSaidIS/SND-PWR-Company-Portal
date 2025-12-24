import 'package:aad_oauth/model/config.dart';
import 'package:flutter/material.dart';
import '../utils/export_import.dart';

class AuthConfig {
  static Config createRefreshConfig(GlobalKey<NavigatorState> navigatorKey) {
    return Config(
      tenant: EnvConfig.msTenantId,
      clientId: EnvConfig.msClientId,
      scope: 'openid profile offline_access',
      redirectUri: EnvConfig.msalRedirectUri,
      isB2C: false,
      domainHint: EnvConfig.msDomainHint,
      navigatorKey: navigatorKey,
      prompt: "login",
    );
  }
  static Config createGraphConfig(GlobalKey<NavigatorState> navigatorKey) {
    return Config(
      tenant: EnvConfig.msTenantId,
      clientId: EnvConfig.msClientId,
      scope: 'https://graph.microsoft.com/.default',
      redirectUri: EnvConfig.msalRedirectUri,
      isB2C: false,
      domainHint: EnvConfig.msDomainHint,
      navigatorKey: navigatorKey,
      prompt: "login",
    );
  }

  static Config createSharePointConfig(GlobalKey<NavigatorState> navigatorKey) {
    return Config(
      tenant: EnvConfig.msTenantId,
      clientId: EnvConfig.msClientId,
      scope: 'https://alsanidi.sharepoint.com/.default',
      redirectUri: EnvConfig.msalRedirectUri,
      isB2C: false,
      //  domainHint: EnvConfig.msDomainHint,
      navigatorKey: navigatorKey,
      prompt: "login",
    );
  }

  static Config createMySharePointConfig(
      GlobalKey<NavigatorState> navigatorKey) {
    return Config(
      tenant: EnvConfig.msTenantId,
      clientId: EnvConfig.msClientId,
      scope: 'https://alsanidi-my.sharepoint.com/.default',
      redirectUri: EnvConfig.msalRedirectUri,
      isB2C: false,
      // domainHint: EnvConfig.msDomainHint,
      navigatorKey: navigatorKey,
      prompt: "login",
    );
  }

}
