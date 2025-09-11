import 'package:aad_oauth/model/config.dart';
import 'package:company_portal/config/env_config.dart';
import 'package:flutter/material.dart';

class AuthConfig {
  static Config createMicrosoftConfig(GlobalKey<NavigatorState> navigatorKey) {
    return Config(
        tenant: EnvConfig.msTenantId,
        clientId: EnvConfig.msClientId,
        scope: EnvConfig.msScope,
        redirectUri: EnvConfig.msRedirectUri,
        isB2C: false,
        domainHint: EnvConfig.msDomainHint,
        navigatorKey: navigatorKey,
    );
  }
}
