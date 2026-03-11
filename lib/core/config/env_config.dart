import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get baseUrl => dotenv.get("base_url");
  static String get spBaseUrl => dotenv.get("sp_base_url");
  static String get mySpBaseUrl => dotenv.get("my_sp_base_url");
  static String get msTenantId => dotenv.get('tenant_id');
  static String get msClientId => dotenv.get('client_id');
  static String get msScope => dotenv.get('scope');
  static String get msRedirectUri => dotenv.get('redirect_uri');
  static String get msDomainHint => dotenv.get('domain_hint');
  static String get msalRedirectUri => dotenv.get('redirect_uri_msal');


  static String get kpiGrantType => dotenv.get('kpi_grant_type');
  static String get kpiClientId => dotenv.get('kpi_client_id');
  static String get kpiClientSecret => dotenv.get('kpi_client_secret');
  static String get kpiUatResource => dotenv.get('kpi_uat_resource');
  static String get kpiProdResource => dotenv.get('kpi_prod_resource');

  static Future<void> load() async {
    await dotenv.load(fileName: 'env/.env_dev');
  }
}